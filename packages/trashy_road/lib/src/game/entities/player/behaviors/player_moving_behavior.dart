import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerKeyboardMovingBehavior extends Behavior<PlayerEntity>
    with KeyboardHandler {
  PlayerKeyboardMovingBehavior._({
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
      : this._(
          upKey: LogicalKeyboardKey.arrowUp,
          downKey: LogicalKeyboardKey.arrowDown,
          leftKey: LogicalKeyboardKey.arrowLeft,
          rightKey: LogicalKeyboardKey.arrowRight,
        );

  /// A [PlayerKeyboardMovingBehavior] that uses the WASD keys
  /// to move the player around.
  PlayerKeyboardMovingBehavior.wasd()
      : this._(
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

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _targetPosition.setFrom(parent.position);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (parent.position.distanceTo(_targetPosition) != 0) {
      parent.position.lerp(_targetPosition, 0.1);
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _targetPosition.setFrom(parent.position);

    if (event is RawKeyDownEvent) {
      if (_previouslyDownKeys.contains(event.logicalKey)) {
        // The user has to release the key before it can be pressed again.
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
    }

    if (event is RawKeyUpEvent) {
      _previouslyDownKeys.remove(event.logicalKey);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
