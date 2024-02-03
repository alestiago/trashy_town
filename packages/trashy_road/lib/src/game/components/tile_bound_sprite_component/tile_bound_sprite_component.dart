import 'dart:async';

import 'package:flame/components.dart';
import 'package:trashy_road/config.dart';

abstract class TileBoundSpriteComponent extends SpriteComponent {
  TileBoundSpriteComponent({super.position}) : super(anchor: Anchor.bottomLeft);

  static Vector2 snapToGrid(Vector2 vector, {bool center = false}) {
    var snapped = vector - (vector % GameSettings.gridDimensions);
    if (center) snapped += GameSettings.gridDimensions / 2;

    return snapped;
  }

  @override
  set position(Vector2 position) {
    // ensure that the sprite is locked to the grid
    super.position = snapToGrid(position);
  }

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.bottomLeft;
    return super.onLoad();
  }
}
