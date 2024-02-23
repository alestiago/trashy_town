import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/src/game/game.dart';

/// The different layers in the Tiled map.
enum _TiledLayer {
  trashLayer._('TrashLayer'),
  coreItemsLayer._('CoreItemsLayer'),
  obstacles._('Obstacles'),
  roadLayer._('RoadLayer'),
  borderLayer._('Border');

  const _TiledLayer._(this.name);

  /// The [name] of the layer in the Tiled map.
  final String name;
}

class TrashyRoadWorld extends Component {
  TrashyRoadWorld.create({
    required this.tiled,
    required Random random,
  }) {
    final trashLayer =
        tiled.tileMap.getObjectGroup(_TiledLayer.trashLayer.name);
    tiled.addAll(
      trashLayer.objects
          .map((object) => Trash.fromTiledObject(object, random: random)),
    );

    final coreItemsLayer =
        tiled.tileMap.getObjectGroup(_TiledLayer.coreItemsLayer.name);
    final playerObjects =
        coreItemsLayer.objects.where((object) => object.type == 'player');
    tiled.addAll(playerObjects.map(Player.fromTiledObject));
    final trashCanObjects =
        coreItemsLayer.objects.where((object) => object.type == 'trash_can');
    tiled.addAll(trashCanObjects.map(TrashCan.fromTiledObject));

    final roadLaneLayer =
        tiled.tileMap.getObjectGroup(_TiledLayer.roadLayer.name);
    tiled.addAll(roadLaneLayer.objects.map(RoadLane.fromTiledObject));

    final obstaclesLayer =
        tiled.tileMap.getObjectGroup(_TiledLayer.obstacles.name);
    tiled.addAll(obstaclesLayer.objects.map(Obstacle.fromTiledObject));

    final borderLayer =
        tiled.tileMap.getObjectGroup(_TiledLayer.borderLayer.name);
    tiled.addAll(borderLayer.objects.map(MapEdge.fromTiledObject));

    bounds = MapBounds.fromLTWH(
      tiled.topLeftPosition.x,
      tiled.topLeftPosition.y,
      tiled.width,
      tiled.height,
    );
  }

  final TiledComponent tiled;

  late MapBounds bounds;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(tiled);
  }
}

extension on RenderableTiledMap {
  ObjectGroup getObjectGroup(String name) {
    final objectGroup = getLayer<ObjectGroup>(name);
    if (objectGroup == null) {
      throw ArgumentError.value(
        name,
        'layer',
        '''The Tiled map must have a layer named "$name".''',
      );
    }
    return objectGroup;
  }
}
