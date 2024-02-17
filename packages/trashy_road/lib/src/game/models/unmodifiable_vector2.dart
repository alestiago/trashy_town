import 'dart:typed_data';

import 'package:flame/components.dart' show Vector2;

class UnmodifiableVector2View extends Vector2 {
  UnmodifiableVector2View(double x, double y)
      : super.fromFloat64List(
          UnmodifiableFloat64ListView(Float64List.fromList([x, y])),
        );
}
