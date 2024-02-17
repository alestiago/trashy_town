import 'package:flame/components.dart';
import 'package:trashy_road/src/game/game.dart';

abstract class GameSettings {
  /// The dimensions of the grid.
  static final Vector2 gridDimensions = UnmodifiableVector2View(128, 64);
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
