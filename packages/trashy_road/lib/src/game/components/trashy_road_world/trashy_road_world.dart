import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/components/components.dart';

class TrashyRoadWorld extends Component {
  TrashyRoadWorld._create({
    required this.mapComponent,
    required this.spawnPosition,
    required this.finishPosition,
  }) : super();

  @override
  FutureOr<void> onLoad() {
    add(mapComponent);
    return super.onLoad();
  }

  static Future<TrashyRoadWorld> create(String path) async {
    final mapComponent =
        await TiledComponent.load(path, GameSettings.gridDimensions);
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
    late Vector2 spawn;
    late Vector2 finish;

    for (final object in mapComponent.tileMap
        .getLayer<ObjectGroup>('CoreItemsLayer')!
        .objects) {
      switch (object.type) {
        case 'spawn':
          spawn = Vector2(object.x, object.y);
        case 'finish':
          finish = Vector2(object.x, object.y);

        default:
      }
    }
    mapComponent.add(
      TrashCan(position: finish),
    );

    return TrashyRoadWorld._create(
      mapComponent: mapComponent,
      spawnPosition: spawn,
      finishPosition: finish,
    );
  }

  late TiledComponent mapComponent;
  late Vector2 spawnPosition;
  late Vector2 finishPosition;
}
