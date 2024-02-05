import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

class PlayerMovingBehavior extends Component
    with ParentIsA<Player>, KeyboardHandler {
  PlayerMovingBehavior({
    required MapBounds mapBounds,
  }) : _mapBounds = mapBounds;

  final MapBounds _mapBounds;

  /// A set containg the keys that were previously down.
  final _previouslyDownKeys = <LogicalKeyboardKey>{};

  /// The new position the player is trying to move to.
  ///
  /// It may not be the final position the player will move to, since it has
  /// to be checked against the map bounds.
  final Vector2 _newPosition = Vector2.zero();

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _newPosition.setFrom(parent.targetPosition);

    if (event is RawKeyDownEvent) {
      if (_previouslyDownKeys.contains(event.logicalKey)) {
        // The user has to release the key before it can be pressed again.
        return super.onKeyEvent(event, keysPressed);
      }

      _previouslyDownKeys.add(event.logicalKey);

      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          _newPosition.x -= GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowRight:
          _newPosition.x += GameSettings.gridDimensions.x;
        case LogicalKeyboardKey.arrowDown:
          _newPosition.y += GameSettings.gridDimensions.y;
        case LogicalKeyboardKey.arrowUp:
          _newPosition.y -= GameSettings.gridDimensions.y;
        default:
          break;
      }

      if (_mapBounds.isPointInside(_newPosition)) {
        parent.targetPosition.setFrom(_newPosition);
      }
    }

    if (event is RawKeyUpEvent) {
      _previouslyDownKeys.remove(event.logicalKey);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
