import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
class TrashCan extends Obstacle with FlameBlocReader<GameBloc, GameState> {
  TrashCan._({
    required Vector2 position,
  }) : super(
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          priority: position.y.floor(),
          behaviors: [
            TrashCanFocusingBehavior(),
          ],
          children: [
            _TrashCanSpriteComponent(),
            TextComponent(
              anchor: Anchor.center,
            ),
          ],
        );

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    return TrashCan._(
      position: Vector2(tiledObject.x, tiledObject.y),
    );
  }

  /// Whether the trash can is focused.
  bool focused = false;
  final int _capacity = 3;
  int _currentTrash = 0;

  /// Deposits [Trash] into the [TrashCan].
  ///
  /// Returns `true` if the [Trash] was deposited, `false` otherwise.
  bool depositTrash() {
    if (bloc.state.inventory.trash > 0 && _currentTrash < _capacity) {
      _currentTrash++;
      children.whereType<TextComponent>().first.text =
          '$_currentTrash/$_capacity';
      return true;
    }

    return false;
  }

  @override
  Future<void> onLoad() {
    children.whereType<TextComponent>().first
      ..text = '$_currentTrash/$_capacity'
      ..position = (size / 2)
      ..y = 0;
    return super.onLoad();
  }
}

class _TrashCanSpriteComponent extends SpriteComponent with HasGameReference {
  _TrashCanSpriteComponent() : super();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite =
        await Sprite.load(Assets.images.trashCan.path, images: game.images);
  }
}
