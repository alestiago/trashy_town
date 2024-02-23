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
    super.key,
    this.style,
  });

  /// {@macro BasuraGlossyButtonStyle}
  final BasuraGlossyButtonStyle? style;

  /// The child widget of the button.
  ///
  /// Usually a [Text] showing the button's label.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO(alestiago): Implement BasuraGlossyButton.

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment(0, -1.2),
          colors: [
            Color(0xFF2F965E),
            Color(0xFFFFFBF3),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
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

class BasuraGlossyTextButton extends StatelessWidget {
  const BasuraGlossyTextButton({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return BasuraGlossyButton(
      child: BasuraOutlinedText(
        outlineColor: const Color(0xFF000000),
        child: Text(label, style: BasuraTheme.of(context).textTheme.button),
      ),
    );
  }
}
