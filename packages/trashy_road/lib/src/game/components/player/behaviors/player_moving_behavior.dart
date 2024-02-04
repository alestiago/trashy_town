import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerMovingBehavior extends Component
    with ParentIsA<Player>, KeyboardHandler {
  Map<LogicalKeyboardKey, bool> alreadyDownMap = {};

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (alreadyDownMap.containsKey(
            event.logicalKey,
          ) && // key is already down this is a repeat event exit early
          alreadyDownMap[event.logicalKey]!) {
        return super.onKeyEvent(event, keysPressed);
      }
      alreadyDownMap[event.logicalKey] = true;

      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          parent.targetPosition.x -= Player.moveDistance;
          break;
        case LogicalKeyboardKey.arrowRight:
          parent.targetPosition.x += Player.moveDistance;
          break;
        case LogicalKeyboardKey.arrowDown:
          parent.targetPosition.y += Player.moveDistance;
          break;
        case LogicalKeyboardKey.arrowUp:
          parent.targetPosition.y -= Player.moveDistance;
          break;
        default:
          break;
      }
    }

    if (event is RawKeyUpEvent) {
      alreadyDownMap[event.logicalKey] = false;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
