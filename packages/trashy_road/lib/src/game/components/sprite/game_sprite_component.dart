import 'dart:async';

import 'package:flame/components.dart';

class GameSpriteComponent extends SpriteComponent with HasGameRef {
  GameSpriteComponent.fromPath({
    required String spritePath,
    super.position,
    super.scale,
    super.anchor,
  }) : _spritePath = spritePath;

  final String _spritePath;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(_spritePath, images: game.images);
  }
}
