import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

/// The different layers in the Tiled map.
enum _TiledLayer {
  trashLayer._('TrashLayer'),
  coreItemsLayer._('CoreItemsLayer'),
  obstacles._('Obstacles');

  const _TiledLayer._(this.name);

  /// The [name] of the layer in the Tiled map.
  final String name;
}

class TrashyRoadWorld extends Component {
  TrashyRoadWorld._create({required this.tiled}) {
    final trashGroup = tiled.tileMap.getLayer<ObjectGroup>(
      _TiledLayer.trashLayer.name,
    );
    for (final tiledObject in trashGroup!.objects) {
      tiled.add(Trash.fromTiledObject(tiledObject));
    }

    for (final object in tiled.tileMap
        .getLayer<ObjectGroup>(_TiledLayer.coreItemsLayer.name)!
        .objects) {
      switch (object.type) {
        // TODO(OlliePugh): rename 'spawn' to 'player' in the Tiled map, and
        // consider having a different layer for it.
        case 'spawn':
          tiled.add(Player.fromTiledObject(object));
        // TODO(OlliePugh): rename 'finish' to 'trash_can' in the Tiled map, and
        // consider having a different layer for it.
        case 'finish':
          finishPosition = Vector2(object.x, object.y);
        default:
      }
    }

    for (final object in tiled.tileMap
        .getLayer<ObjectGroup>(_TiledLayer.obstacles.name)!
        .objects) {
      tiled.add(
        TileBoundSpriteComponent.generate(object.class_)
          ..position = Vector2(object.x, object.y)
          ..priority = object.y.toInt(),
        // ordering priority by y
      );
    }

    tiled.add(
      TrashCan(position: finishPosition),
    );

    final bottomRightPosition =
        tiled.topLeftPosition + Vector2(tiled.width, tiled.height);
    bounds = MapBounds(tiled.topLeftPosition, bottomRightPosition);
  }

  static Future<TrashyRoadWorld> create(String path) async {
    final mapComponent =
        await TiledComponent.load(path, GameSettings.gridDimensions);
    return TrashyRoadWorld._create(tiled: mapComponent);
  }

  final TiledComponent tiled;

  late Vector2 finishPosition;

  late MapBounds bounds;

  @override
  FutureOr<void> onLoad() {
    add(tiled);
    return super.onLoad();
  }
}
