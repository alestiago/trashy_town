import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  Player()
      : super(
          children: [
            CircleComponent(
              anchor: Anchor.center,
              radius: 10,
              paint: Paint()..color = const Color(0xFFFF0000),
            ),
          ],
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
