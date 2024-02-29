import 'package:basura/basura.dart';
import 'package:flutter/widgets.dart';

/// {@template HoverableTextButton}
/// A text button that changes color when hovered.
/// {@endtemplate}
class HoverableTextButton extends StatefulWidget {
  /// {@macro HoverableTextButton}
  const HoverableTextButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  /// The text to display on the button.
  final String text;

  /// A callback that is called when the button is pressed.
  final void Function(BuildContext context) onPressed;

  @override
  State<HoverableTextButton> createState() => _HoverableTextButtonState();
}

class _HoverableTextButtonState extends State<HoverableTextButton>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final _colorTween = ColorTween(
    begin: BasuraColors.black,
    end: BasuraColors.deepGreen,
  ).animate(
    _animationController,
  );

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.cardSubheading,
      child: Hoverable(
        onHoverStart: (_) => _animationController.forward(),
        onHoverExit: (_) => _animationController.reverse(),
        child: GestureDetector(
          onTap: () => widget.onPressed(context),
          child: AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) {
              return AutoSizeText(
                widget.text,
                style: theme.textTheme.cardSubheading.copyWith(
                  color: _colorTween.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
