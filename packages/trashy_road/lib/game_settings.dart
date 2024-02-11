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
}

extension TrashyRoadVector on Vector2 {
  /// Snaps this to the grid.
  ///
  /// Modifications are made to the object.
  void snap({required Vector2 size}) {
    sub(this % GameSettings.gridDimensions);
    y -= GameSettings.gridDimensions.y *
        (size.y / GameSettings.gridDimensions.y);
  }

  /// Scales this from tile size to game size.
  ///
  /// Modifications are made to the object.
  void convertToGameSize() => multiply(GameSettings.gridDimensions);
}
