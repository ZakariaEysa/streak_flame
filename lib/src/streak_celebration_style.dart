import 'package:flutter/material.dart';
import 'streak_card_style.dart';
import 'streak_header_style.dart';
import 'streak_close_style.dart';
import 'streak_text_style.dart';
import 'streak_action_style.dart';

/// Optional styling for the surrounding celebration only.
/// Flame and badge styling belong to StreakPalette/StreakFlameStyle/StreakBadgeStyle.
@immutable
class StreakCelebrationStyle {
  /// Creates optional frame, header, typography and action overrides.
  const StreakCelebrationStyle({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(
      Radius.circular(28),
    ),
    ShapeBorder? shape,
    List<BoxShadow> shadows = const [],
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    EdgeInsets dialogInsetPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 24,
    ),
    bool showHeader = true,
    bool showCloseButton = true,
    bool showAction = true,
    Color? headerBackgroundColor,
    Gradient? headerGradient,
    ShapeBorder? headerShape,
    Color? headerForegroundColor,
    Color? headerBorderColor,
    double headerBorderWidth = 0,
    BorderRadiusGeometry headerBorderRadius = const BorderRadius.all(
      Radius.circular(20),
    ),
    EdgeInsetsGeometry headerPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    TextStyle? headerTextStyle,
    Color? closeColor,
    Color? closeBackgroundColor,
    Color? closeBorderColor,
    double closeBorderWidth = 0,
    OutlinedBorder closeShape = const CircleBorder(),
    ButtonStyle? closeButtonStyle,
    double closeIconSize = 24,
    Color? titleColor,
    Color? subtitleColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextAlign textAlign = TextAlign.center,
    double titleSubtitleSpacing = 8,
    double actionSpacing = 20,
    Color? buttonBackgroundColor,
    Color? buttonForegroundColor,
    Color? buttonDisabledBackgroundColor,
    Color? buttonDisabledForegroundColor,
    Color? buttonOverlayColor,
    Color? buttonBorderColor,
    double buttonBorderWidth = 0,
    OutlinedBorder? buttonShape,
    TextStyle? buttonTextStyle,
    EdgeInsetsGeometry buttonPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    Size buttonMinimumSize = const Size(48, 48),
    ButtonStyle? buttonStyle,
    this.card,
    this.header,
    this.closeButton,
    this.text,
    this.action,
  }) : _backgroundColor = backgroundColor,
       _backgroundGradient = backgroundGradient,
       _borderColor = borderColor,
       _borderWidth = borderWidth,
       _borderRadius = borderRadius,
       _shape = shape,
       _shadows = shadows,
       _padding = padding,
       _margin = margin,
       _dialogInsetPadding = dialogInsetPadding,
       _showHeader = showHeader,
       _showCloseButton = showCloseButton,
       _showAction = showAction,
       _headerBackgroundColor = headerBackgroundColor,
       _headerGradient = headerGradient,
       _headerShape = headerShape,
       _headerForegroundColor = headerForegroundColor,
       _headerBorderColor = headerBorderColor,
       _headerBorderWidth = headerBorderWidth,
       _headerBorderRadius = headerBorderRadius,
       _headerPadding = headerPadding,
       _headerTextStyle = headerTextStyle,
       _closeColor = closeColor,
       _closeBackgroundColor = closeBackgroundColor,
       _closeBorderColor = closeBorderColor,
       _closeBorderWidth = closeBorderWidth,
       _closeShape = closeShape,
       _closeButtonStyle = closeButtonStyle,
       _closeIconSize = closeIconSize,
       _titleColor = titleColor,
       _subtitleColor = subtitleColor,
       _titleStyle = titleStyle,
       _subtitleStyle = subtitleStyle,
       _textAlign = textAlign,
       _titleSubtitleSpacing = titleSubtitleSpacing,
       _actionSpacing = actionSpacing,
       _buttonBackgroundColor = buttonBackgroundColor,
       _buttonForegroundColor = buttonForegroundColor,
       _buttonDisabledBackgroundColor = buttonDisabledBackgroundColor,
       _buttonDisabledForegroundColor = buttonDisabledForegroundColor,
       _buttonOverlayColor = buttonOverlayColor,
       _buttonBorderColor = buttonBorderColor,
       _buttonBorderWidth = buttonBorderWidth,
       _buttonShape = buttonShape,
       _buttonTextStyle = buttonTextStyle,
       _buttonPadding = buttonPadding,
       _buttonMinimumSize = buttonMinimumSize,
       _buttonStyle = buttonStyle;

  /// Card fill; defaults to palette.surface.
  Color? get backgroundColor => card?.backgroundColor ?? _backgroundColor;
  final Color? _backgroundColor;

  /// Card gradient overrides backgroundColor.
  Gradient? get backgroundGradient =>
      card?.backgroundGradient ?? _backgroundGradient;
  final Gradient? _backgroundGradient;

  /// Default card outline; defaults to accent at 35% opacity.
  Color? get borderColor => card?.borderColor ?? _borderColor;
  final Color? _borderColor;

  /// Default card outline width; zero removes it.
  double get borderWidth => card?.borderWidth ?? _borderWidth;
  final double _borderWidth;

  /// Default card corners.
  BorderRadiusGeometry get borderRadius => card?.borderRadius ?? _borderRadius;
  final BorderRadiusGeometry _borderRadius;

  /// Card shape and border; overrides borderRadius/borderColor/borderWidth.
  ShapeBorder? get shape => card?.shape ?? _shape;
  final ShapeBorder? _shape;

  /// Card shadows. Keep this list immutable.
  List<BoxShadow> get shadows => card?.shadows ?? _shadows;
  final List<BoxShadow> _shadows;

  /// Card content padding.
  EdgeInsetsGeometry get padding => card?.padding ?? _padding;
  final EdgeInsetsGeometry _padding;

  /// Space outside the card.
  EdgeInsetsGeometry get margin => card?.margin ?? _margin;
  final EdgeInsetsGeometry _margin;

  /// Popup distance from viewport edges.
  EdgeInsets get dialogInsetPadding =>
      card?.dialogInsetPadding ?? _dialogInsetPadding;
  final EdgeInsets _dialogInsetPadding;

  /// Show the supplied or default header.
  bool get showHeader => header?.show ?? _showHeader;
  final bool _showHeader;

  /// Show close when onClose is supplied.
  bool get showCloseButton => closeButton?.show ?? _showCloseButton;
  final bool _showCloseButton;

  /// Show supplied footer or default action.
  bool get showAction => action?.show ?? _showAction;
  final bool _showAction;

  /// Header pill fill; defaults to accent at 15% opacity.
  Color? get headerBackgroundColor =>
      header?.backgroundColor ?? _headerBackgroundColor;
  final Color? _headerBackgroundColor;

  /// Header pill gradient overrides its fill.
  Gradient? get headerGradient => header?.gradient ?? _headerGradient;
  final Gradient? _headerGradient;

  /// Custom header pill shape and border override radius and border options.
  ShapeBorder? get headerShape => header?.shape ?? _headerShape;
  final ShapeBorder? _headerShape;

  /// Header pill text; defaults to secondaryForeground.
  Color? get headerForegroundColor =>
      header?.foregroundColor ?? _headerForegroundColor;
  final Color? _headerForegroundColor;

  /// Header pill border; defaults to transparent.
  Color? get headerBorderColor => header?.borderColor ?? _headerBorderColor;
  final Color? _headerBorderColor;

  /// Header pill outline width.
  double get headerBorderWidth => header?.borderWidth ?? _headerBorderWidth;
  final double _headerBorderWidth;

  /// Header pill corners.
  BorderRadiusGeometry get headerBorderRadius =>
      header?.borderRadius ?? _headerBorderRadius;
  final BorderRadiusGeometry _headerBorderRadius;

  /// Header pill insets.
  EdgeInsetsGeometry get headerPadding => header?.padding ?? _headerPadding;
  final EdgeInsetsGeometry _headerPadding;

  /// Header typography; explicit color wins.
  TextStyle? get headerTextStyle => header?.textStyle ?? _headerTextStyle;
  final TextStyle? _headerTextStyle;

  /// Close icon; defaults to foreground.
  Color? get closeColor => closeButton?.foregroundColor ?? _closeColor;
  final Color? _closeColor;

  /// Close control background.
  Color? get closeBackgroundColor =>
      closeButton?.backgroundColor ?? _closeBackgroundColor;
  final Color? _closeBackgroundColor;

  /// Close control outline.
  Color? get closeBorderColor => closeButton?.borderColor ?? _closeBorderColor;
  final Color? _closeBorderColor;

  /// Close control outline width.
  double get closeBorderWidth => closeButton?.borderWidth ?? _closeBorderWidth;
  final double _closeBorderWidth;

  /// Close control shape.
  OutlinedBorder get closeShape => closeButton?.shape ?? _closeShape;
  final OutlinedBorder _closeShape;

  /// Advanced close control states; overrides non-null close style properties.
  ButtonStyle? get closeButtonStyle =>
      closeButton?.buttonStyle ?? _closeButtonStyle;
  final ButtonStyle? _closeButtonStyle;

  /// Close icon size; touch target stays at least 48.
  double get closeIconSize => closeButton?.iconSize ?? _closeIconSize;
  final double _closeIconSize;

  /// Title color; defaults to foreground.
  Color? get titleColor => text?.titleColor ?? _titleColor;
  final Color? _titleColor;

  /// Subtitle color; defaults to secondaryForeground.
  Color? get subtitleColor => text?.subtitleColor ?? _subtitleColor;
  final Color? _subtitleColor;

  /// Title typography; explicit color wins.
  TextStyle? get titleStyle => text?.titleStyle ?? _titleStyle;
  final TextStyle? _titleStyle;

  /// Subtitle typography; explicit color wins.
  TextStyle? get subtitleStyle => text?.subtitleStyle ?? _subtitleStyle;
  final TextStyle? _subtitleStyle;

  /// Title, subtitle and button text alignment.
  TextAlign get textAlign => text?.align ?? _textAlign;
  final TextAlign _textAlign;

  /// Gap between title and subtitle.
  double get titleSubtitleSpacing => text?.spacing ?? _titleSubtitleSpacing;
  final double _titleSubtitleSpacing;

  /// Gap before the action/footer.
  double get actionSpacing => action?.spacing ?? _actionSpacing;
  final double _actionSpacing;

  /// Action fill; defaults to accent.
  Color? get buttonBackgroundColor =>
      action?.backgroundColor ?? _buttonBackgroundColor;
  final Color? _buttonBackgroundColor;

  /// Action text; defaults to surface.
  Color? get buttonForegroundColor =>
      action?.foregroundColor ?? _buttonForegroundColor;
  final Color? _buttonForegroundColor;

  /// Disabled action fill; otherwise Flutter theme.
  Color? get buttonDisabledBackgroundColor =>
      action?.disabledBackgroundColor ?? _buttonDisabledBackgroundColor;
  final Color? _buttonDisabledBackgroundColor;

  /// Disabled action text; otherwise Flutter theme.
  Color? get buttonDisabledForegroundColor =>
      action?.disabledForegroundColor ?? _buttonDisabledForegroundColor;
  final Color? _buttonDisabledForegroundColor;

  /// Action hover/focus/pressed overlay.
  Color? get buttonOverlayColor => action?.overlayColor ?? _buttonOverlayColor;
  final Color? _buttonOverlayColor;

  /// Action outline; defaults to transparent.
  Color? get buttonBorderColor => action?.borderColor ?? _buttonBorderColor;
  final Color? _buttonBorderColor;

  /// Action outline width.
  double get buttonBorderWidth => action?.borderWidth ?? _buttonBorderWidth;
  final double _buttonBorderWidth;

  /// Action shape; its side is controlled by buttonBorderColor/Width.
  OutlinedBorder? get buttonShape => action?.shape ?? _buttonShape;
  final OutlinedBorder? _buttonShape;

  /// Action typography.
  TextStyle? get buttonTextStyle => action?.textStyle ?? _buttonTextStyle;
  final TextStyle? _buttonTextStyle;

  /// Action insets.
  EdgeInsetsGeometry get buttonPadding => action?.padding ?? _buttonPadding;
  final EdgeInsetsGeometry _buttonPadding;

  /// Preferred minimum action size.
  Size get buttonMinimumSize => action?.minimumSize ?? _buttonMinimumSize;
  final Size _buttonMinimumSize;

  /// Advanced state styling. Non-null properties override other button options.
  ButtonStyle? get buttonStyle => action?.buttonStyle ?? _buttonStyle;
  final ButtonStyle? _buttonStyle;

  /// Optional partial card overrides. Supplied values take precedence over flat options.
  final StreakCardStyle? card;

  /// Optional partial header overrides. Supplied values take precedence over flat options.
  final StreakHeaderStyle? header;

  /// Optional partial closeButton overrides. Supplied values take precedence over flat options.
  final StreakCloseStyle? closeButton;

  /// Optional partial text overrides. Supplied values take precedence over flat options.
  final StreakTextStyle? text;

  /// Optional partial action overrides. Supplied values take precedence over flat options.
  final StreakActionStyle? action;

  /// Rejects invalid dimensions before layout.
  void validate() {
    for (final entry in {
      'borderWidth': borderWidth,
      'headerBorderWidth': headerBorderWidth,
      'closeBorderWidth': closeBorderWidth,
      'closeIconSize': closeIconSize,
      'titleSubtitleSpacing': titleSubtitleSpacing,
      'actionSpacing': actionSpacing,
      'buttonBorderWidth': buttonBorderWidth,
      'buttonMinimumSize.width': buttonMinimumSize.width,
      'buttonMinimumSize.height': buttonMinimumSize.height,
    }.entries) {
      if (!entry.value.isFinite || entry.value < 0)
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Must be finite and nonnegative',
        );
    }
    if (!padding.isNonNegative ||
        !margin.isNonNegative ||
        !headerPadding.isNonNegative ||
        !buttonPadding.isNonNegative ||
        !dialogInsetPadding.isNonNegative) {
      throw ArgumentError(
        'Celebration padding and margins must be nonnegative',
      );
    }
  }
}
