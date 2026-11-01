# Performance notes

## Changes that reduce unnecessary work

The copied widget originally rebuilt its full animated stack on every idle
controller tick. This package passes animation notifications directly to a
CustomPainter. Only the badge listens through AnimatedBuilder, and it listens
only to the finite count transition.

Gradients are cached for a painter configuration. A paint reuses its Paint object.
Particle work is bounded to 64 particles. Delayed starts are cancellable. Idle
work stops when disabled, hidden through TickerMode, paused by the external
controller, or the application leaves the resumed lifecycle state. Reduced
motion schedules no animation frames. Background blur is optional.

A targeted widget test verifies that ten idle frames do not invoke count
formatting again. This is evidence about widget rebuild behavior, not a
production frame-time or battery benchmark. No measured speedup is claimed.

## Remaining costs

Flame paths are rebuilt each painted frame so their tips can move. Enabled glow,
particles, and text transitions have rendering costs. A mounted flame scrolled
offscreen needs a host-controlled TickerMode or idleAnimationEnabled setting.
Text fitting may reduce the displayed size in extremely tight bounds.

## Measure before publishing performance claims

1. Use a representative device and profile mode (not widget-test timings).
2. Compare the original copy with this package under the same scenario:
   one 220-wide flame idling for 10 seconds, then 20 replayed celebrations.
   Also compare a list of 20 flames with visible and hidden items.
3. Capture DevTools frame timings, UI/raster durations, missed frames,
   and retained memory after repeatedly opening and closing dialogs.
4. Keep viewport, device refresh rate, text scale, colors, particles, and
   build mode equal. Repeat runs after warm-up and report medians and tails.
5. Re-measure with idle disabled, glow disabled, and particle counts 0/28/64.
6. Record device, SDK, build, scenario, and results alongside any claims.

## Visual preview

test/visual_preview_test.dart writes build/streak_preview.png. Flutter widget
tests use a block-like test font by default. For readable visual inspection,
set STREAK_PREVIEW_FONT to a local TrueType font path before running that test.
The font is loaded only during the test and is not bundled with the package.
The checked-in PNG was rendered with a locally available system font.
## Compatibility refactor checks — 2026-10-10

The refactor extracts stateless celebration content/action and shares the legacy
dialog's properties/state with StreakWidget. New grouped-style compatibility
getters read stored values directly without resolving/allocating a style object
on every build. The painter, badge rendering and external controller source are
unchanged; the motion state machine and shader notification path are retained.

Command: flutter test --no-pub test/streak_refactor_test.dart

The targeted test drives 30 idle frames, 30 frames containing replay/transition,
and 30 subsequent idle frames. The custom header and footer each build once
across that scenario. Idle frames do not call number formatting again.
Pause/removal leaves no scheduled animation callbacks. Other existing renderer
tests cover lifecycle/TickerMode suspension, cancellation, reduced motion and
removal during transitions.

Four default/custom flame/celebration PNGs match their pre-refactor SHA-256 hashes
exactly under the same local font setup. A separate raw-pixel comparison verifies
that equivalent flat and grouped styles produce identical output.

These are functional/rebuild/visual regression checks in the Flutter test
environment, not a profile-mode measurement of UI/raster durations, FPS, jank,
memory, battery use or production speed. No measured performance improvement is
claimed. Use the profiling procedure above on representative target devices
before publishing device-performance claims.
