import 'dart:async';

import 'package:flame/components.dart';
import 'package:trashy_road/gen/assets.gen.dart';

class Road extends SpriteComponent with HasGameReference {
  Road();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(Assets.images.road.path, images: game.images);
  }
}
