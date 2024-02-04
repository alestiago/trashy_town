import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/bloc/game_bloc.dart';
import 'package:trashy_road/src/game/components/components.dart';
import 'package:trashy_road/src/game/components/trashy_road_world/trashy_road_world.dart';

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

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final mapComponent = await TrashyRoadWorld.create('map.tmx');

    final player = Player(
      position: TileBoundSpriteComponent.snapToGrid(
        mapComponent.spawnPosition,
        center: true,
      ),
      mapBounds: mapComponent.bounds,
    );

    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [mapComponent, player],
    );

    world.add(blocProvider);
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
