import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
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
///
/// This behavior is meant to be used in conjunction with [PlayerMovingBehavior]
class PlayerKeyboardMovingBehavior extends Behavior<Player>
    with KeyboardHandler {
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

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isMovementKey = event.logicalKey == _leftKey ||
        event.logicalKey == _rightKey ||
        event.logicalKey == _downKey ||
        event.logicalKey == _upKey;
    if (!isMovementKey) {
      return super.onKeyEvent(event, keysPressed);
    }

    if (event is RawKeyDownEvent) {
      if (_previouslyDownKeys.contains(event.logicalKey)) {
        // The user has to release the key before it can be pressed again.
        // or the next move time has not been reached yet.
        return super.onKeyEvent(event, keysPressed);
      }

      _previouslyDownKeys.add(event.logicalKey);

      final playerMovingBehavior = parent.findBehavior<PlayerMovingBehavior>();

      if (event.logicalKey == _leftKey) {
        playerMovingBehavior.move(Direction.left);
      } else if (event.logicalKey == _rightKey) {
        playerMovingBehavior.move(Direction.right);
      } else if (event.logicalKey == _downKey) {
        playerMovingBehavior.move(Direction.down);
      } else if (event.logicalKey == _upKey) {
        playerMovingBehavior.move(Direction.up);
      }
    }

    if (event is RawKeyUpEvent) {
      _previouslyDownKeys.remove(event.logicalKey);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
