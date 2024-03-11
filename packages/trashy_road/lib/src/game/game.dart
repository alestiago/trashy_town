import 'dart:async';
import 'dart:math' hide Rectangle;

import 'package:flame/cache.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
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

  TrashyRoadWorld? _trashyRoadWorld;

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

    final tiledMap = _gameBloc.state.map..transformTileImagePaths();
    final renderableTiledMap = await RenderableTiledMap.fromTiledMap(
      tiledMap,
      GameSettings.gridDimensions,
      images: images,
    );
    final tiled = TiledComponent(renderableTiledMap);
    final trashyRoadWorld =
        _trashyRoadWorld = TrashyRoadWorld.create(tiled: tiled);
    children.register<TrashyRoadWorld>();

    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () => _gameBloc,
      children: [
        ZCanvasComponent(
          children: [
            trashyRoadWorld,
          ],
        ),
      ],
    );

    world.add(blocProvider);

    _player = trashyRoadWorld.tiled.children.whereType<Player>().first;
    camera.follow(_player);
    _updateBounds();
  }

  void _updateBounds() {
    final worldBounds = _trashyRoadWorld?.bounds;
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

extension on TiledMap {
  void transformTileImagePaths() {
    for (final tileset in tilesets) {
      for (final tile in tileset.tiles) {
        final tileImage = tile.image;
        if (tileImage == null) continue;
        final newTileImage = tileImage.copyWith(
          source: tileImage.source?.replaceFirst('..', 'assets'),
        );
        tile.image = newTileImage;
      }
    }
  }
}

extension on TiledImage {
  TiledImage copyWith({
    String? source,
    String? format,
    int? width,
    int? height,
    String? trans,
  }) {
    return TiledImage(
      source: source ?? this.source,
      format: format ?? this.format,
      width: width ?? this.width,
      height: height ?? this.height,
      trans: trans ?? this.trans,
    );
  }
}
