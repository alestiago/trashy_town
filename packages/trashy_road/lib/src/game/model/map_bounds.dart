import 'package:flame/components.dart';

class MapBounds {
  MapBounds(this.topLeft, this.bottomRight);

  Vector2 topLeft;
  Vector2 bottomRight;

  bool isPointInside(Vector2 position) =>
      position.x >= topLeft.x &&
      position.x <= bottomRight.x &&
      position.y <= bottomRight.y &&
      position.y >= topLeft.y;
}
