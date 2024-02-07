import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:path/path.dart' as path;
import 'package:trashy_road/gen/gen.dart';

class Bus extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path.basename(Assets.images.bus.path));
    add(
      RectangleHitbox(),
    );
    return super.onLoad();
  }
}
