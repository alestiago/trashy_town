import 'package:flame/components.dart';

abstract class GameSettings {
  /// The dimensions of the grid.
  static final gridDimensions = Vector2(128, 64);

  /// The delay between player moves.
  static const moveDelay = Duration(milliseconds: 150);
}
