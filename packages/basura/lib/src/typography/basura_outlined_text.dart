import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';

/// {@template BasuraOutlinedText}
/// Outlines the given [Text] with a color and stroke width.
/// {@endtemplate}
class BasuraOutlinedText extends StatelessWidget {
  /// {@macro BasuraOutlinedText}
  const BasuraOutlinedText({
    required this.child,
    required this.outlineColor,
    super.key,
    this.strokeWidth = 1,
  });

  /// The [Text] to outline.
  final AutoSizeText child;

  /// The color of the outline.
  final Color outlineColor;

  /// The width of the outline.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        AutoSizeText(
          child.data!,
          style: child.style?.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = outlineColor,
          ),
        ),
        child,
      ],
    );
  }
}
