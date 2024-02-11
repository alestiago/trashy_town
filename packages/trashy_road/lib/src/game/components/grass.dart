import 'dart:async';

import 'package:flame/components.dart';
import 'package:trashy_road/gen/assets.gen.dart';

class Grass extends SpriteComponent with HasGameReference {
  Grass();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(Assets.images.grass.path, images: game.images);
  }
}
