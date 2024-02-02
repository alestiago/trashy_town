import 'dart:async';

import 'package:flame/game.dart';
import 'package:trashy_road/src/game/components/components.dart';

export 'view/view.dart';

class TrashyRoadGame extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(Player());
  }
}
