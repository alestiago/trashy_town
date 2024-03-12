import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/gestures.dart';
import 'package:trashy_road/src/game/game.dart';

/// A behavior that allows the [Player] to move using mobile gestures.
///
/// Forward movement can be achieved through tapping the screen.
///
/// Directional movement can be achieved through swiping in the desired
/// direction.
///
/// This behavior is meant to be used in conjunction with
/// [PlayerMovingBehavior].
class PlayerDragMovingBehavior extends Behavior<Player> {
  static const _swipeThreshold = 50;

  late final PlayerMovingBehavior _playerMovingBehavior;

  Offset _startPosition = Offset.zero;
  Offset _lastPosition = Offset.zero;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _playerMovingBehavior = parent.findBehavior<PlayerMovingBehavior>();
  }

  void onTapUp(TapUpEvent event) {
    _playerMovingBehavior.move(Direction.up);
  }

  void onPanStart(DragStartDetails details) {
    _startPosition = details.globalPosition;
  }

  void onPanUpdate(DragUpdateDetails details) {
    _lastPosition = details.globalPosition;
  }

  void onPanEnd(DragEndDetails details) {
    final horizontalDelta = _lastPosition.dx - _startPosition.dx;
    final verticalDelta = _lastPosition.dy - _startPosition.dy;

    final isVertical = verticalDelta.abs() > horizontalDelta.abs();

    if (isVertical) {
      final isUpwardsSwipe = verticalDelta < -_swipeThreshold;

      if (isUpwardsSwipe) {
        _playerMovingBehavior.move(Direction.up);
      } else {
        _playerMovingBehavior.move(Direction.down);
      }
    } else {
      final isRightSwipe = horizontalDelta > _swipeThreshold;

      if (isRightSwipe) {
        _playerMovingBehavior.move(Direction.right);
      } else {
        _playerMovingBehavior.move(Direction.left);
      }
    }
  }
}
