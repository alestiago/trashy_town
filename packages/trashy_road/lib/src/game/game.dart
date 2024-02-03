import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:trashy_road/src/game/components/components.dart';

export 'view/view.dart';
export 'components/components.dart';

class TrashyRoadGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(Player());
  }

  @override
  Color backgroundColor() {
    return Color(0xFFFFFFFF);
  }
}
