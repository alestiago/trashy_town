import 'package:flutter/widgets.dart';

class BasuraOutlinedText extends StatelessWidget {
  const BasuraOutlinedText({
    super.key,
    required this.child,
    required this.outlineColor,
  });

  final Text child;

  final Color outlineColor;

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
              ..strokeWidth = 6
              ..color = outlineColor,
          ),
        ),
        child,
      ],
    );
  }
}
