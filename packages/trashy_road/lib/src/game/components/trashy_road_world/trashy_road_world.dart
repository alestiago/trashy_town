import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/maps/maps.dart';

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

class TrashyRoadWorld extends PositionComponent {
  TrashyRoadWorld({
    required this.tileMap,
  });

  final TiledMap tileMap;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final borderLayer = tileMap.getObjectGroup(_TiledLayer.borderLayer.name);
    await addAll(borderLayer.objects.map(MapEdge.fromTiledObject));

    final trashLayer = tileMap.getObjectGroup(_TiledLayer.trashLayer.name);
    await addAll(trashLayer.objects.map(Trash.fromTiledObject));

    final coreItemsLayer =
        tileMap.getObjectGroup(_TiledLayer.coreItemsLayer.name);

    final playerObjects =
        coreItemsLayer.objects.where((object) => object.type == 'player');

    await addAll(playerObjects.map(Player.fromTiledObject));
    final trashCanObjects =
        coreItemsLayer.objects.where((object) => object.type == 'trash_can');
    await addAll(trashCanObjects.map(TrashCan.fromTiledObject));

    final roadLaneLayer = tileMap.getObjectGroup(_TiledLayer.roadLayer.name);
    await addAll(roadLaneLayer.objects.map(RoadLane.fromTiledObject));

    final obstaclesLayer = tileMap.getObjectGroup(_TiledLayer.obstacles.name);
    await addAll(obstaclesLayer.objects.map(Obstacle.fromTiledObject));

    await addAll(Bird.randomAmount());

    await add(_TiledFloor());

    size = Vector2(tileMap.width.toDouble(), tileMap.height.toDouble());
  }
}

class _TiledFloor extends Component
    with
        HasGameReference<TrashyRoadGame>,
        FlameBlocReader<GameBloc, GameState> {
  late final Sprite _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final mapIdentifier = bloc.state.identifier;
    _sprite = await Sprite.load(
      mapIdentifier.floorAssetPath,
      images: game.images,
    );
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas);
  }
}

extension on TiledMap {
  ObjectGroup getObjectGroup(String name) {
    final objectGroup = layerByName(name) as ObjectGroup?;
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

extension on GameMapIdentifier {
  String get floorAssetPath => switch (this) {
        GameMapIdentifier.tutorial => Assets.images.maps.map1.path,
        GameMapIdentifier.map2 => Assets.images.maps.map2.path,
        GameMapIdentifier.map3 => Assets.images.maps.map3.path,
        GameMapIdentifier.map4 => Assets.images.maps.map4.path,
        GameMapIdentifier.map5 => Assets.images.maps.map5.path,
        GameMapIdentifier.map6 => Assets.images.maps.map6.path,
        GameMapIdentifier.map7 => Assets.images.maps.map7.path,
        GameMapIdentifier.map8 => Assets.images.maps.map8.path,
        GameMapIdentifier.map9 => Assets.images.maps.map9.path,
        GameMapIdentifier.map10 => Assets.images.maps.map10.path,
        GameMapIdentifier.map11 => Assets.images.maps.map11.path,
      };
}
