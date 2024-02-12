import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/cache.dart';
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
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        TapCallbacks,
        DragCallbacks {
  TrashyRoadGame({
    required GameBloc gameBloc,
    required this.random,
    Images? images,
  })  : _gameBloc = gameBloc,
        super(
          camera: CameraComponent.withFixedResolution(
            width: 720,
            height: 1280,
            viewfinder: Viewfinder()
              ..anchor = const Anchor(.5, .8)
              ..zoom = 1.2,
          ),
        ) {
    if (images != null) this.images = images;
  }

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  final Random random;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final renderableTiledMap = await RenderableTiledMap.fromTiledMap(
      _gameBloc.state.map,
      GameSettings.gridDimensions,
    );
    final tiled = TiledComponent(renderableTiledMap);
    final trashyRoadWorld = TrashyRoadWorld.create(tiled: tiled);
    children.register<TrashyRoadWorld>();

    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [trashyRoadWorld],
    );

    world.add(blocProvider);

    final player = trashyRoadWorld.tiled.children.whereType<Player>().first;

    camera.follow(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final player = descendants().whereType<Player>().first;
    player.findBehavior<PlayerDragMovingBehavior>().onTapDown(event);
    super.onTapDown(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final player = descendants().whereType<Player>().first;
    player.findBehavior<PlayerDragMovingBehavior>().onDragUpdate(event);
    super.onDragUpdate(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    final player = descendants().whereType<Player>().first;
    player.findBehavior<PlayerDragMovingBehavior>().onDragStart(event);
    super.onDragStart(event);
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
