import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class Trash extends SpriteComponent
    with CollisionCallbacks, FlameBlocReader<GameBloc, GameState> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('trash.png');
    anchor = Anchor.center;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      bloc.add(const GameCollectedTrashEvent());
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
