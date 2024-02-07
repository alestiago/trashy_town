import 'package:flame/components.dart';
import 'package:tuple/tuple.dart';

abstract class GameSettings {
  /// The dimensions of the grid.
  static const _gridDimensionsTuple = Tuple2<double, double>(128, 64);
  static Vector2 get gridDimensions =>
      Vector2(_gridDimensionsTuple.item1, _gridDimensionsTuple.item2);

  /// The delay between player moves.
  static const moveDelay = Duration(milliseconds: 150);
}
