import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerCollectingTrashBehavior
    extends CollisionBehavior<Trash, PlayerEntity>
    with FlameBlocReader<GameBloc, GameState> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, Trash other) {
    super.onCollision(intersectionPoints, other);

    bloc.add(const GameCollectedTrashEvent());
    other.removeFromParent();
  }
}
