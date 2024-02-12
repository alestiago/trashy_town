import 'dart:typed_data';

import 'package:flame/components.dart';

abstract class GameSettings {
  /// The dimensions of the grid.
  static final Vector2 gridDimensions = _ImmutableVector2(128, 64);

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
  /// If this is being used to determine the position of a [Component],
  /// the size of the [Component] should be declared and it
  /// should have a bottom left anchor.
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

class _ImmutableVector2 extends Vector2 {
  _ImmutableVector2(double x, double y)
      : super.fromFloat64List(Float64List.fromList([x, y]));

  @override
  set x(double value) => throw UnsupportedError('This object is immutable');

  @override
  set y(double value) => throw UnsupportedError('This object is immutable');
}
