import 'dart:async';

import 'package:flame/components.dart';
import 'package:trashy_road/src/game/game.dart';

class GameSpriteComponent extends SpriteComponent
    with HasGameReference<TrashyRoadGame> {
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
