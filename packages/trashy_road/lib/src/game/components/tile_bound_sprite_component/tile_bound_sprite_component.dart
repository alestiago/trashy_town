import 'dart:async';

import 'package:flame/components.dart';
import 'package:trashy_road/config.dart';

abstract class TileBoundSpriteComponent extends SpriteComponent {
  @override
  set position(Vector2 position) {
    // ensure that the sprite is locked to the grid
    final delta = position % GameSettings.gridDimensions;
    super.position = position - delta;
  }

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topLeft;
    return super.onLoad();
  }
}
