import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

abstract class TileBoundSpriteComponent extends SpriteComponent
    with CollisionCallbacks {
  TileBoundSpriteComponent({
    super.position,
    super.sprite,
    this.collidesWithPlayer = false,
  }) : super(anchor: Anchor.bottomLeft);

  factory TileBoundSpriteComponent.generate(String class_) {
    switch (class_) {
      // TODO(OlliePugh): these are in template tiles, how do we want to enum
      // them.
      case 'barrel':
        return Barrel();
      default:
        throw Exception('$class_ respective class could not be found');
    }
  }

  final bool collidesWithPlayer;

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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!collidesWithPlayer) return;

    super.onCollision(intersectionPoints, other);
  }
}
