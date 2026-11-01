[CmdletBinding()]
param(
    [ValidateSet('run', 'setup', 'check', 'pack')]
    [string]$Action = 'run',
    [string]$Device = 'chrome',
    [switch]$Offline,
    [switch]$BuildWeb
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$packageRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$exampleRoot = Join-Path $packageRoot 'example'

function Invoke-Flutter {
    param([string]$Directory, [string[]]$FlutterArguments)
    Push-Location -LiteralPath $Directory
    try {
        & flutter @FlutterArguments
        if ($LASTEXITCODE -ne 0) {
            throw "Flutter failed ($LASTEXITCODE): $($FlutterArguments -join ' ')"
        }
    } finally {
        Pop-Location
    }
}

if ($Action -eq 'pack') {
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archiveRoot = Join-Path $packageRoot 'build/portable'
    [IO.Directory]::CreateDirectory($archiveRoot) | Out-Null
    $archivePath = Join-Path $archiveRoot 'streak_flame.zip'
    $excludedDirectories = @('.git', '.dart_tool', 'build', '.gradle', '.idea',
        'Pods', 'ephemeral', '.symlinks', 'coverage', 'node_modules')
    $excludedFiles = @('pubspec.lock', 'local.properties', 'key.properties',
        '.flutter-plugins', '.flutter-plugins-dependencies', '.DS_Store',
        'Generated.xcconfig', 'flutter_export_environment.sh')
    $stream = [IO.File]::Open($archivePath, [IO.FileMode]::Create)
    $archive = [IO.Compression.ZipArchive]::new(
        $stream, [IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        function Add-PortableFolder {
            param([string]$Directory, [string]$Relative)
            foreach ($item in Get-ChildItem -LiteralPath $Directory -Force) {
                $entryPath = "$Relative/$($item.Name)"
                if ($item.PSIsContainer) {
                    if ($item.Name -notin $excludedDirectories) {
                        Add-PortableFolder -Directory $item.FullName -Relative $entryPath
                    }
                } elseif ($item.Name -notin $excludedFiles -and
                    $item.Name -notlike 'flutter_*.log' -and
                    $item.Extension -notin @('.jks', '.keystore')) {
                    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                        $archive, $item.FullName, $entryPath,
                        [IO.Compression.CompressionLevel]::Optimal) | Out-Null
                }
            }
        }
        Add-PortableFolder -Directory $packageRoot -Relative 'streak_flame'
    } finally {
        $archive.Dispose()
        $stream.Dispose()
    }
    Write-Host "Portable source archive: $archivePath"
    exit 0
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter is not on PATH. Install Flutter, then reopen the terminal.'
}
$pubArguments = @('pub', 'get')
if ($Offline) { $pubArguments += '--offline' }
Invoke-Flutter -Directory $packageRoot -FlutterArguments $pubArguments
Invoke-Flutter -Directory $exampleRoot -FlutterArguments $pubArguments

switch ($Action) {
    'run' {
        Invoke-Flutter -Directory $exampleRoot -FlutterArguments @('run', '--no-pub', '-d', $Device)
    }
    'check' {
        Invoke-Flutter -Directory $packageRoot -FlutterArguments @('analyze', '--no-pub')
        $tests = @(Get-ChildItem -LiteralPath (Join-Path $packageRoot 'test') -File -Filter '*_test.dart' |
            Sort-Object Name | ForEach-Object { "test/$($_.Name)" })
        if ($tests.Count -eq 0) { throw 'No package tests found.' }
        Invoke-Flutter -Directory $packageRoot -FlutterArguments (@('test', '--no-pub') + $tests)
        if ($BuildWeb) {
            Invoke-Flutter -Directory $exampleRoot -FlutterArguments @('build', 'web', '--no-pub')
        }
    }
}