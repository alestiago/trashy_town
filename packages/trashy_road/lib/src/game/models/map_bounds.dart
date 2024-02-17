import 'package:flame/components.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/src/game/models/models.dart';

@immutable
class MapBounds {
  const MapBounds._(this.topLeft, this.bottomRight);

  /// Creates a [MapBounds] from the left, top, width and height.
  ///
  /// Similar to `Rect.fromLTWH` from `dart:ui`.
  factory MapBounds.fromLTWH(double x, double y, double width, double height) {
    final topLeft = UnmodifiableVector2View(x, y);
    final bottomRight = UnmodifiableVector2View(x + width, y + height);
    return MapBounds._(topLeft, bottomRight);
  }

  final UnmodifiableVector2View topLeft;
  final UnmodifiableVector2View bottomRight;

  bool isPointInside(Vector2 position) =>
      position.x >= topLeft.x &&
      position.x <= bottomRight.x &&
      position.y <= bottomRight.y &&
      position.y >= topLeft.y;
}
