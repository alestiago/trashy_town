import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

/// Allows controlling the [Player] using the keyboard.
///
/// The player can move horizontally and vertically using the appropriate keys.
///
/// Maintaining the keys pressed will not make the player move continuously.
/// Instead, it will only move once. Continuos movement can be achieved by
/// pressing the keys multiple times.
///
/// See also:
///
/// * [PlayerKeyboardMovingBehavior.arrows], a behavior that uses the arrow keys
/// to move the player around.
/// * [PlayerKeyboardMovingBehavior.wasd], a behavior that uses the WASD keys
/// to move the player around.
class PlayerKeyboardMovingBehavior extends Behavior<Player>
    with KeyboardHandler, FlameBlocReader<GameBloc, GameState> {
  @visibleForTesting
  PlayerKeyboardMovingBehavior({
    required LogicalKeyboardKey upKey,
    required LogicalKeyboardKey downKey,
    required LogicalKeyboardKey leftKey,
    required LogicalKeyboardKey rightKey,
  })  : _upKey = upKey,
        _downKey = downKey,
        _leftKey = leftKey,
        _rightKey = rightKey;

  /// A [PlayerKeyboardMovingBehavior] that uses the arrow keys
  /// to move the player around.
  PlayerKeyboardMovingBehavior.arrows()
      : this(
          upKey: LogicalKeyboardKey.arrowUp,
          downKey: LogicalKeyboardKey.arrowDown,
          leftKey: LogicalKeyboardKey.arrowLeft,
          rightKey: LogicalKeyboardKey.arrowRight,
        );

  /// A [PlayerKeyboardMovingBehavior] that uses the WASD keys
  /// to move the player around.
  PlayerKeyboardMovingBehavior.wasd()
      : this(
          upKey: LogicalKeyboardKey.keyW,
          downKey: LogicalKeyboardKey.keyS,
          leftKey: LogicalKeyboardKey.keyA,
          rightKey: LogicalKeyboardKey.keyD,
        );

  /// The key to move the player up.
  final LogicalKeyboardKey _upKey;

  /// The key to move the player down.
  final LogicalKeyboardKey _downKey;

  /// The key to move the player left.
  final LogicalKeyboardKey _leftKey;

  /// The key to move the player right.
  final LogicalKeyboardKey _rightKey;

  /// A set containg the keys that were previously down.
  final _previouslyDownKeys = <LogicalKeyboardKey>{};

  /// The position the player is trying to move to.
  ///
  /// When its values are different than the current [Player.position]
  /// it will be lerped until [_targetPosition] is reached by the [Player].
  final Vector2 _targetPosition = Vector2.zero();

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

    if (parent.position.distanceTo(_targetPosition) != 0) {
      parent.position.lerp(_targetPosition, 0.1);
      parent.priority = parent.position.y.floor();
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isMovementKey = event.logicalKey == _leftKey ||
        event.logicalKey == _rightKey ||
        event.logicalKey == _downKey ||
        event.logicalKey == _upKey;
    if (!isMovementKey) {
      return super.onKeyEvent(event, keysPressed);
    }

    final isFirstInteraction = bloc.state.status == GameStatus.ready;
    if (isFirstInteraction) {
      bloc.add(const GameInteractedEvent());
    }

    if (event is RawKeyDownEvent) {
      final now = DateTime.now();
      if (_previouslyDownKeys.contains(event.logicalKey) ||
          now.isBefore(_nextMoveTime)) {
        // The user has to release the key before it can be pressed again.
        // or the next move time has not been reached yet.
        return super.onKeyEvent(event, keysPressed);
      }

      _previouslyDownKeys.add(event.logicalKey);

      if (event.logicalKey == _leftKey) {
        _targetPosition.x -= GameSettings.gridDimensions.x;
      } else if (event.logicalKey == _rightKey) {
        _targetPosition.x += GameSettings.gridDimensions.x;
      } else if (event.logicalKey == _downKey) {
        _targetPosition.y += GameSettings.gridDimensions.y;
      } else if (event.logicalKey == _upKey) {
        _targetPosition.y -= GameSettings.gridDimensions.y;
      }

      _nextMoveTime = now.add(GameSettings.moveDelay);
    }

    if (event is RawKeyUpEvent) {
      _previouslyDownKeys.remove(event.logicalKey);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
