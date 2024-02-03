import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerMovingBehavior extends Component
    with ParentIsA<Player>, KeyboardHandler {
  Map<LogicalKeyboardKey, bool> alreadyDownMap = {};

  static const _moveDistance = 128;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (alreadyDownMap.containsKey(event
              .logicalKey) && // key is already down this is a repeat event exit early
          alreadyDownMap[event.logicalKey]!) {
        return super.onKeyEvent(event, keysPressed);
      }
      alreadyDownMap[event.logicalKey] = true;

      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        parent.targetPosition.x -= _moveDistance;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        parent.targetPosition.x += _moveDistance;
      }
    }

    if (event is RawKeyUpEvent) {
      alreadyDownMap[event.logicalKey] = false;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
