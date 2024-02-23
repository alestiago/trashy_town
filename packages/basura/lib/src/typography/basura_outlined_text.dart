import 'package:flutter/widgets.dart';

class BasuraOutlinedText extends StatelessWidget {
  const BasuraOutlinedText({
    super.key,
    required this.child,
    required this.outlineColor,
    this.strokeWidth = 1,
  });

  final Text child;

  final Color outlineColor;

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
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
