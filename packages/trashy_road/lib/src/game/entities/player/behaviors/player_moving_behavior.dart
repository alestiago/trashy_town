import 'package:clock/clock.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

enum Direction { up, down, left, right }

/// A behavior that allows the player to move around the game.
final class PlayerMovingBehavior extends Behavior<Player>
    with FlameBlocReader<GameBloc, GameState> {
  /// The position the player is trying to move to.
  ///
  /// When its values are different than the current [Player.position]
  /// it will be lerped until [_targetPosition] is reached by the [Player].
  final Vector2 _targetPosition = Vector2.zero();

  /// The delay between player moves.
  static const moveDelay = Duration(milliseconds: 100);

  /// The lerp time for player movement.
  static const playerMoveAnimationSpeed = 15;

  /// A int that contains the time when the next move can be made.
  DateTime _nextMoveTime = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _targetPosition.setFrom(parent.position);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (parent.position.distanceTo(_targetPosition) > 0.01) {
      parent.position.lerp(_targetPosition, playerMoveAnimationSpeed * dt);
      parent.priority = parent.position.y.floor();
    }
  }

  void move(Direction direction) {
    final isFirstInteraction = bloc.state.status == GameStatus.ready;
    if (isFirstInteraction) {
      bloc.add(const GameInteractedEvent());
    }

    final now = clock.now();

    if (now.isBefore(_nextMoveTime)) {
      return;
    }

    if (direction == Direction.left) {
      _targetPosition.x -= GameSettings.gridDimensions.x;
    } else if (direction == Direction.right) {
      _targetPosition.x += GameSettings.gridDimensions.x;
    } else if (direction == Direction.down) {
      _targetPosition.y += GameSettings.gridDimensions.y;
    } else if (direction == Direction.up) {
      _targetPosition.y -= GameSettings.gridDimensions.y;
    }
    _nextMoveTime = now.add(moveDelay);
  }

  void bounceBack() {
    _targetPosition.setFrom(Player.snapToGrid(parent.position));
  }
}
