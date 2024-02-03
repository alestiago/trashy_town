import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/components/tile_bound_sprite_component/tile_bound_sprite_component.dart';
import 'package:trashy_road/src/game/game.dart';

class Trash extends TileBoundSpriteComponent
    with CollisionCallbacks, FlameBlocReader<GameBloc, GameState> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('trash.png');
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
