import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/components/components.dart';
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
  TrashyRoadWorld._create({
    required this.mapComponent,
  }) {
    final trashGroup = mapComponent.tileMap.getLayer<ObjectGroup>(
      _TiledLayer.trashLayer.name,
    );
    for (final tiledObject in trashGroup!.objects) {
      mapComponent.add(Trash.fromTiledObject(tiledObject));
    }

    for (final object in mapComponent.tileMap
        .getLayer<ObjectGroup>(_TiledLayer.coreItemsLayer.name)!
        .objects) {
      switch (object.type) {
        case 'spawn':
          spawnPosition = Vector2(object.x, object.y);
        case 'finish':
          finishPosition = Vector2(object.x, object.y);
        default:
      }
    }

    for (final object in mapComponent.tileMap
        .getLayer<ObjectGroup>(_TiledLayer.obstacles.name)!
        .objects) {
      mapComponent.add(
        TileBoundSpriteComponent.generate(object.class_)
          ..position = Vector2(object.x, object.y)
          ..priority = object.y.toInt(),
        // ordering priority by y
      );
    }

    mapComponent.add(
      TrashCan(position: finishPosition),
    );

    final bottomRightPosition = mapComponent.topLeftPosition +
        Vector2(mapComponent.width, mapComponent.height);
    bounds = MapBounds(mapComponent.topLeftPosition, bottomRightPosition);
  }

  static Future<TrashyRoadWorld> create(String path) async {
    final mapComponent =
        await TiledComponent.load(path, GameSettings.gridDimensions);
    return TrashyRoadWorld._create(mapComponent: mapComponent);
  }

  final TiledComponent mapComponent;

  late Vector2 spawnPosition;

  late Vector2 finishPosition;

  late MapBounds bounds;

  @override
  FutureOr<void> onLoad() {
    add(mapComponent);
    return super.onLoad();
  }
}
