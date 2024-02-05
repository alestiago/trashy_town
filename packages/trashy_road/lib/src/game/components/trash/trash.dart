import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:path/path.dart' as path;
import 'package:trashy_road/config.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class Trash extends TileBoundSpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path.basename(Assets.images.trash.path));
    add(
      RectangleHitbox(
        size: GameSettings.gridDimensions,
        position: Vector2(0, GameSettings.gridDimensions.y),
      ),
    );
    return super.onLoad();
  }
}