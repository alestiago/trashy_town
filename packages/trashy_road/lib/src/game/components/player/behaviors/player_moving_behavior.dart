import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

class PlayerMovingBehavior extends Component
    with ParentIsA<Player>, KeyboardHandler {
  PlayerMovingBehavior({required this.mapBounds});

  Map<LogicalKeyboardKey, bool> alreadyDownMap = {};
  MapBounds mapBounds;
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final newPosition =
        Vector2(parent.targetPosition.x, parent.targetPosition.y);
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
          newPosition.x -= GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowRight:
          newPosition.x += GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowDown:
          newPosition.y += GameSettings.gridDimensions.y;
        case LogicalKeyboardKey.arrowUp:
          newPosition.y -= GameSettings.gridDimensions.y;
        default:
          break;
      }

      if (mapBounds.isPointInside(newPosition)) {
        parent.targetPosition = newPosition;
      }
    }

    if (event is RawKeyUpEvent) {
      alreadyDownMap[event.logicalKey] = false;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
