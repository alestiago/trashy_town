import 'package:flutter/widgets.dart';
import 'package:trashy_road/gen/assets.gen.dart';

/// {@template StopwatchIcon}
/// A stopwatch icon.
/// {@endtemplate}
class StopwatchIcon extends StatelessWidget {
  const StopwatchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Assets.images.display.stopwatch.image(),
    );
  }
}
