import 'package:basura/basura.dart';
import 'package:flutter/widgets.dart';

class HudLevelIndicator extends StatelessWidget {
  const HudLevelIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    final textStyle = theme.textTheme.button.copyWith(fontSize: 32);

    return DefaultTextStyle(
      style: textStyle,
      child: BasuraOutlinedText(
        outlineColor: BasuraColors.brown,
        child: AutoSizeText('2', style: textStyle),
      ),
    );
  }
}
