import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/src/game/components/components.dart';

export 'view/view.dart';
export 'components/components.dart';

class TrashyRoadGame extends FlameGame with HasKeyboardHandlerComponents {
  late TiledComponent mapComponent;

  TrashyRoadGame()
      : super(camera: CameraComponent()..viewfinder.anchor = Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    world.add(await TiledComponent.load('map.tmx', Vector2.all(128)));

    var player = Player();
    world.add(player);
    camera.follow(player);
  }

  @override
  void update(double dt) {
    camera.update(dt);
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return const Color(0xFFFFFFFF);
  }
}
