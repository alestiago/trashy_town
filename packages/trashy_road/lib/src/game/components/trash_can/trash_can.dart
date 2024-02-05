import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCan extends TileBoundSpriteComponent
    with FlameBlocReader<GameBloc, GameState> {
  TrashCan({super.position});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('trash_can.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      print('player hit end game');
    }

    super.onCollision(intersectionPoints, other);
  }
}
