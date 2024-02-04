import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/components/components.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

class TrashyRoadWorld extends Component {
  TrashyRoadWorld._create({
    required this.mapComponent,
  }) {
    final trashGroup = mapComponent.tileMap.getLayer<ObjectGroup>('TrashLayer');

    for (final trash in trashGroup!.objects) {
      mapComponent.add(
        Trash()
          ..position = Vector2(
            trash.x,
            trash.y,
          ),
      );
    }

    for (final object in mapComponent.tileMap
        .getLayer<ObjectGroup>('CoreItemsLayer')!
        .objects) {
      switch (object.type) {
        case 'spawn':
          spawnPosition = Vector2(object.x, object.y);
        case 'finish':
          finishPosition = Vector2(object.x, object.y);
        default:
      }
    }
    mapComponent.add(
      TrashCan(position: finishPosition),
    );

    final bottomRightPosition = mapComponent.topLeftPosition +
        Vector2(mapComponent.width, mapComponent.height);
    bounds = MapBounds(mapComponent.topLeftPosition, bottomRightPosition);
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

  static Future<TrashyRoadWorld> create(String path) async {
    final mapComponent =
        await TiledComponent.load(path, GameSettings.gridDimensions);
    return TrashyRoadWorld._create(mapComponent: mapComponent);
  }
}
