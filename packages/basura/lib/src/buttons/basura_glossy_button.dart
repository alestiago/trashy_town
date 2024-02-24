import 'package:auto_size_text/auto_size_text.dart';
import 'package:basura/basura.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// {@template BasuraGlossyButton}
/// A glossy button that follows the Basura design system.
/// {@endtemplate}
class BasuraGlossyButton extends StatelessWidget {
  /// {@macro BasuraGlossyButton}
  const BasuraGlossyButton({
    required this.child,
    this.onPressed,
    this.style,
    super.key,
  });

  /// {@macro BasuraGlossyButtonStyle}
  final BasuraGlossyButtonStyle? style;

  /// The child widget of the button.
  ///
  /// Usually a [Text] showing the button's label.
  final Widget child;

  /// {@template BasuraGlossyButton.onPressed}
  /// A callback that is called when the button is pressed.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO(alestiago): Add semantic tree.
    // TODO(alestiago): Add gesture detector.
    // TODO(alestiago): Add hover effect.

    final style =
        this.style ?? BasuraTheme.of(context).glossyButtonTheme.fallback;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: BasuraColors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            gradient: RadialGradient(
              radius: 2,
              colors: [
                style.innerBackgroundColor,
                style.outterHighlightColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: style.outlineColor,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: const Alignment(0, -1.1),
                  stops: const [0, 1.1],
                  colors: [
                    style.innerBackgroundColor,
                    style.innerHighlightColor,
                  ],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template BasuraGlossyButtonStyle}
/// The style for a [BasuraGlossyButton].
/// {@endtemplate}
class BasuraGlossyButtonStyle extends Equatable {
  /// {@macro BasuraGlossyButtonStyle}
  const BasuraGlossyButtonStyle({
    required this.outterHighlightColor,
    required this.innerHighlightColor,
    required this.outterBackgroundColor,
    required this.innerBackgroundColor,
    required this.outlineColor,
  });

  /// Represents those lighter areas, where the light is reflected within the
  /// outter area of the button.
  final Color outterHighlightColor;

  /// Represents those lighter areas, where the light is reflected within the
  /// inner area of the button.
  final Color innerHighlightColor;

  /// The color of the outter background of the button.
  final Color outterBackgroundColor;

  /// The color of the inner background of the button.
  final Color innerBackgroundColor;

  /// Used as the border of shapes.
  final Color outlineColor;

  @override
  List<Object?> get props => [
        outterHighlightColor,
        innerHighlightColor,
        outterBackgroundColor,
        innerBackgroundColor,
        outlineColor,
      ];
}

/// {@template BasuraGlossyButtonTheme}
/// Collection of [BasuraGlossyButtonStyle]s.
/// {@endtemplate}
class BasuraGlossyButtonTheme extends Equatable {
  /// {@macro BasuraGlossyButtonTheme}
  const BasuraGlossyButtonTheme({
    required this.primary,
    required this.secondary,
    required this.disabled,
  });

  /// Derives a [BasuraGlossyButtonTheme] from a [BasuraThemeData].
  // ignore: avoid_unused_constructor_parameters
  factory BasuraGlossyButtonTheme.light() {
    return BasuraGlossyButtonTheme(
      primary: const BasuraGlossyButtonStyle(
        outterHighlightColor: BasuraColors.white,
        innerHighlightColor: BasuraColors.lightCadmiumYellow,
        outterBackgroundColor: BasuraColors.deepCadmiumYellow,
        innerBackgroundColor: BasuraColors.deepCadmiumYellow,
        outlineColor: BasuraColors.brown,
      ),
      secondary: const BasuraGlossyButtonStyle(
        outterHighlightColor: BasuraColors.lightCadmiumYellow,
        innerHighlightColor: BasuraColors.lightCadmiumYellow,
        outterBackgroundColor: BasuraColors.mediumGreen,
        innerBackgroundColor: BasuraColors.mediumGreen,
        outlineColor: BasuraColors.deepGreen,
      ),
      disabled: BasuraGlossyButtonStyle(
        outterHighlightColor: BasuraColors.lightCadmiumYellow.withOpacity(0.5),
        innerHighlightColor: BasuraColors.lightCadmiumYellow.withOpacity(0.5),
        outterBackgroundColor: BasuraColors.mediumGreen.withOpacity(0.5),
        innerBackgroundColor: BasuraColors.lightCadmiumYellow.withOpacity(0.5),
        outlineColor: BasuraColors.deepGreen.withOpacity(0.5),
      ),
    );
  }

  // ignore: public_member_api_docs
  final BasuraGlossyButtonStyle primary;

  // ignore: public_member_api_docs
  final BasuraGlossyButtonStyle secondary;

  // ignore: public_member_api_docs
  final BasuraGlossyButtonStyle disabled;

  /// The style to use when a [BasuraGlossyButtonStyle] is not specified.
  BasuraGlossyButtonStyle get fallback => primary;

  @override
  List<Object?> get props => [
        primary,
        secondary,
        disabled,
      ];
}

/// {@template BasuraGlossyTextButton}
/// A [BasuraGlossyButton] with a [Text] child.
/// {@endtemplate}
class BasuraGlossyTextButton extends StatelessWidget {
  /// {@macro BasuraGlossyTextButton}
  const BasuraGlossyTextButton({
    required this.label,
    this.onPressed,
    this.style,
    super.key,
  });

  /// {@macro BasuraGlossyButtonStyle}
  final BasuraGlossyButtonStyle? style;

  /// The button's label.
  final String label;

  /// {@macro BasuraGlossyButton.onPressed}
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style =
        this.style ?? BasuraTheme.of(context).glossyButtonTheme.fallback;

    return BasuraGlossyButton(
      onPressed: onPressed,
      style: style,
      child: Center(
        child: BasuraOutlinedText(
          outlineColor: style.outlineColor,
          strokeWidth: 6,
          child: AutoSizeText(
            label.toUpperCase(),
            style: BasuraTheme.of(context).textTheme.button.copyWith(
              shadows: [
                Shadow(
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  color: style.outlineColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
