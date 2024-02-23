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
    // TODO(alestiago): Get colors from style and theme.

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFFECC0).withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            gradient: const RadialGradient(
              radius: 2,
              colors: [
                Color(0xFF009042),
                Color(0xFFFFECC0),
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
                  color: const Color(0xFF096F00),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment(0, -1.1),
                  stops: [0, 1.1],
                  colors: [
                    Color(0xFF2F965E),
                    Color(0xFFFFECC0),
                  ],
                ),
              ),
              child: child,
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
  @override
  List<Object?> get props => [];
}

/// {@template BasuraGlossyTextButton}
/// A [BasuraGlossyButton] with a [Text] child.
/// {@endtemplate}
class BasuraGlossyTextButton extends StatelessWidget {
  /// {@macro BasuraGlossyTextButton}
  const BasuraGlossyTextButton({
    required this.label,
    this.onPressed,
    super.key,
  });

  /// The button's label.
  final String label;

  /// {@macro BasuraGlossyButton.onPressed}
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BasuraGlossyButton(
      onPressed: onPressed,
      child: BasuraOutlinedText(
        outlineColor: const Color(0xFF096F00),
        strokeWidth: 6,
        child: Text(
          label.toUpperCase(),
          style: BasuraTheme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
