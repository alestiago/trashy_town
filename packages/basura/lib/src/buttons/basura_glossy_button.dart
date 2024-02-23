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
    return child;
  }
}

/// {@template BasuraGlossyButtonStyle}
/// The style for a [BasuraGlossyButton].
/// {@endtemplate}
class BasuraGlossyButtonStyle extends Equatable {
  @override
  List<Object?> get props => [];
}
