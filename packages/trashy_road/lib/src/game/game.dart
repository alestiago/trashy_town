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
    Images? images,
  })  : _gameBloc = gameBloc,
        super(
          camera: CameraComponent(
            viewfinder: Viewfinder(),
          ),
        ) {
    if (images != null) this.images = images;
  }

  final Size resolution;

  /// {@macro GameBloc}
  final GameBloc _gameBloc;

  /// {@macro AudioCubit}
  final AudioCubit audioBloc;

  final Random random;

  late final Player _player;

  @override
  Color backgroundColor() {
    return Colors.transparent;
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
          children: [
            trashyRoadWorld,
          ],
        ),
      ],
    );

    world.add(blocProvider);

    _player = trashyRoadWorld.tiled.children.whereType<Player>().first;

    // [camera.follow] centers the target, whereas our [CameraFollowBehavior]
    // will keep the player slightly off-center towards the bottom of the
    // screen.
    await camera.viewfinder.add(
      CameraFollowBehavior(target: _player, viewport: camera.viewport),
    );

    // TODO(OlliePugh/alestiago): Need to figure out how to set the bounds
    // so that is works on all screen sizes.
    //
    // There are multiple things we can look into:
    // - [camera.setBounds]
    // - [ViewportAwareBoundsBehavior]
    // - [BoundedPositionBehavior]
    //
    // See also:
    // * [Flame Docs](https://docs.flame-engine.org/latest/flame/camera_component.html#camera-controls)
    // * [Flame Dart API Docs](https://pub.dev/documentation/flame/latest/camera/CameraComponent/setBounds.html)
    // * [Slack Conversation](https://stackoverflow.com/a/77167193)
    // * [Example](https://github.com/flame-engine/flame/blob/faf2df4b8c68015a1bfbdd96f93c950cb14963ef/examples/lib/stories/camera_and_viewport/follow_component_example.dart#L41)
    //
    // Notes:
    // - camera.viewport.size may change when the game is resized, depending on
    // the type of viewport used.
    // - the default camera viewport is [MaxViewport]
    final bounds = Rectangle.fromPoints(
      // [trashyRoadWorld.bounds] is correctly computed.
      trashyRoadWorld.bounds.topLeft,
      trashyRoadWorld.bounds.bottomRight,
    );

    camera.setBounds(
      bounds,
      considerViewport: true,
    );

    // NOTE: camera.viewport.size changes when the game is resized.

    // Random attempts:
    // camera.setBounds(
    //   Rectangle.fromCenter(
    //     center: Vector2.zero(),
    //     size: (trashyRoadWorld.bounds.bottomRight / 2) -
    //         (camera.viewport.size / 2),
    //   ),
    // );
    // await camera.viewfinder.add(
    //   BoundedPositionBehavior(
    //     bounds: bounds,
    //     target: _player,
    //   ),
    // );
    // camera.setBounds(
    //   bounds,
    //   // considerViewport: true,
    // );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

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
