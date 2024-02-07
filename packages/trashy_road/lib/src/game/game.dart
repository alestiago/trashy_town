import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

export 'bloc/game_bloc.dart';
export 'components/components.dart';
export 'entities/entities.dart';
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

    final tiled =
        await TiledComponent.load('map.tmx', GameSettings.gridDimensions);
    final trashyRoadWorld = TrashyRoadWorld.create(tiled: tiled);

    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [trashyRoadWorld],
    );

    world.add(blocProvider);

    final player = trashyRoadWorld.tiled.children.whereType<Player>().first;
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
