import 'dart:async';

import 'package:flame/components.dart';

class GameSpriteComponent extends SpriteComponent with HasGameRef {
  GameSpriteComponent.fromPath({
    super.anchor,
    String? spritePath,
  }) : _spritePath = spritePath;

  final String? _spritePath;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    if (_spritePath != null) {
      sprite = await Sprite.load(_spritePath, images: game.images);
    }
  }
}
