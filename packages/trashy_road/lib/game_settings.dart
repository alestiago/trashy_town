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
}

extension TrashyRoadVector on Vector2 {
  /// Snaps this to the grid.
  ///
  /// Modifications are made to the object.
  void snap() => sub(this % GameSettings.gridDimensions);

  /// Scales this from tile size to game size.
  ///
  /// For example, if an object is 1x1 in the tilemap, you may use
  /// `Vector2(1, 1)..toGameSize()` to scale it into the game size.
  ///
  /// Modifications are made to the object.
  void toGameSize() => multiply(GameSettings.gridDimensions);
}
