import 'package:flame/components.dart';

abstract class GameSettings {
  /// The dimensions of the grid.
  static const _gridDimensionsTuple = (x: 128, y: 64);
  static Vector2 get gridDimensions => Vector2(
        _gridDimensionsTuple.x.toDouble(),
        _gridDimensionsTuple.y.toDouble(),
      );

  /// The delay between player moves.
  static const moveDelay = Duration(milliseconds: 150);

  /// The speed multiplier for cars.
  static const carSpeedMultiplier = 1.5;

  /// The lerp time for player movement.
  static const playerMoveAnimationSpeed = 0.2;

  static const minTrafficVariation = 0.8;
}
