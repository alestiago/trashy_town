import 'dart:async';
import 'dart:math' hide Rectangle;

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/audio/audio.dart';
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
    required this.audioBloc,
    required this.random,
    required this.resolution,
    required Images images,
  })  : _gameBloc = gameBloc,
        super(
          camera: CameraComponent(
            viewfinder: Viewfinder(),
          ),
        ) {
    this.images = images;
  }

  final Size resolution;

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  /// {@macro AudioCubit}
  final AudioCubit audioBloc;

  final Random random;

  late final Player _player;

  MapBounds? bounds;

  @override
  Color backgroundColor() {
    return Colors.transparent;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateBounds();
    _updateZoom();
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final tiledMap = _gameBloc.state.map;
    bounds = MapBounds.fromLTWH(
      0,
      0,
      tiledMap.width.toDouble() * GameSettings.gridDimensions.x,
      tiledMap.height.toDouble() * GameSettings.gridDimensions.y,
    );

    final trashyRoadWorld = TrashyRoadWorld(tileMap: tiledMap);
    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [
        ZCanvasComponent(
          children: [trashyRoadWorld],
        ),
      ],
    );

    await world.add(blocProvider);

    // TODO(alestiago): Refactor this and properly await loading.
    unawaited(
      trashyRoadWorld.loaded.then((_) {
        _player = trashyRoadWorld.children.whereType<Player>().first;
        camera.follow(_player);
        _updateBounds();
      }),
    );
  }

  void _updateBounds() {
    final worldBounds = bounds;
    if (worldBounds == null) return;

    final viewportHalf = camera.viewport.size / 2;

    final cameraBounds = Rectangle.fromPoints(
      worldBounds.topLeft + viewportHalf,
      worldBounds.bottomRight - viewportHalf,
    );
    camera.setBounds(cameraBounds);
  }

  void _updateZoom() {
    final size = camera.viewport.size;
    camera.viewfinder.zoom = (size.x / resolution.width) + 0.2;

    final isPortrait = size.y > size.x;
    if (isPortrait) {
      // Increase the zoom on those mobile devices with a portrait aspect ratio
      // to make the game look better, rather than too zoomed out.
      camera.viewfinder.zoom += 0.4;
    }
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
