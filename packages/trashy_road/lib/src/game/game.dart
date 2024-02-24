import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:basura/basura.dart';
import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

export 'bloc/bloc.dart';
export 'components/components.dart';
export 'debug_game.dart';
export 'entities/entities.dart';
export 'models/models.dart';
export 'view/view.dart';
export 'widgets/widgets.dart';

class TrashyRoadGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        TapCallbacks,
        DragCallbacks {
  TrashyRoadGame({
    required GameBloc gameBloc,
    required this.effectPlayer,
    required this.random,
    required Size resolution,
    Images? images,
  })  : _gameBloc = gameBloc,
        super(
          camera: CameraComponent.withFixedResolution(
            width: resolution.width,
            height: resolution.height,
            viewfinder: Viewfinder()
              ..anchor = const Anchor(.5, .8)
              ..zoom = 1.2,
          ),
        ) {
    if (images != null) this.images = images;
  }

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  /// Can play one audio at a time.
  ///
  /// Usually used to play very short sound effects.
  final AudioPlayer effectPlayer;

  final Random random;

  late final Player _player;

  @override
  Color backgroundColor() {
    return BasuraColors.white;
  }

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
      children: [
        ZCanvasComponent(
          children: [trashyRoadWorld],
        ),
      ],
    );

    world.add(blocProvider);

    _player = trashyRoadWorld.tiled.children.whereType<Player>().first;
    _player.children.register<PlayerDragMovingBehavior>();

    camera.follow(_player);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _player.children.query<PlayerDragMovingBehavior>().first.onTapUp(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _player.children
        .query<PlayerDragMovingBehavior>()
        .first
        .onDragUpdate(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _player.children.query<PlayerDragMovingBehavior>().first.onDragStart(event);
  }

  @override
  void update(double dt) {
    super.update(dt);
    camera.update(dt);
  }
}
