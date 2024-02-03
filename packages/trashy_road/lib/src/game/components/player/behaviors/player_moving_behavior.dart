import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerMovingBehavior extends Component
    with ParentIsA<Player>, KeyboardHandler {
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        parent.x -= 10;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        parent.x += 10;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
