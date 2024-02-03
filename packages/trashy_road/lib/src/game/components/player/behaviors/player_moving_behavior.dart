import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/config.dart';
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
          parent.targetPosition.x -= GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowRight:
          parent.targetPosition.x += GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowDown:
          parent.targetPosition.y += GameSettings.gridDimensions.y;
        case LogicalKeyboardKey.arrowUp:
          parent.targetPosition.y -= GameSettings.gridDimensions.y;
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
