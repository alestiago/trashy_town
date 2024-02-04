import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/bloc/game_bloc.dart';
import 'package:trashy_road/src/game/components/components.dart';

export 'bloc/game_bloc.dart';
export 'components/components.dart';
export 'view/view.dart';

class TrashyRoadGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  TrashyRoadGame({
    required GameBloc gameBloc,
  })  : _gameBloc = gameBloc,
        super(
          camera: CameraComponent.withFixedResolution(
            width: 720,
            height: 1280,
            viewfinder: Viewfinder()
              ..anchor = const Anchor(.5, .8)
              ..zoom = 1.2,
          ),
        );

  late TiledComponent mapComponent;

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    mapComponent =
        await TiledComponent.load('map.tmx', GameSettings.gridDimensions);
    final trashGroup = mapComponent.tileMap.getLayer<ObjectGroup>('TrashLayer');

    final trash = trashGroup!.objects
        .map((object) => Trash()..position = Vector2(object.x, object.y));

    final coreItems = <String, TiledObject>{};

    for (final object in mapComponent.tileMap
        .getLayer<ObjectGroup>('CoreItemsLayer')!
        .objects) {
      coreItems[object.name] = object;
    }

    final player = Player(
      position: TileBoundSpriteComponent.snapToGrid(
        Vector2(coreItems['spawn']!.x, coreItems['spawn']!.y),
        center: true,
      ),
    );

    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [
        player,
        ...trash,
        TrashCan(
          position: Vector2(
            coreItems['finish']!.x,
            coreItems['finish']!.y,
          ),
        ),
      ],
    );

    world
      ..add(mapComponent)
      ..add(blocProvider);

    camera.follow(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    camera.update(dt);
  }

  @override
  Color backgroundColor() {
    return const Color(0xFFFFFFFF);
  }
}
