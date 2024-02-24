import 'dart:async';

import 'package:basura/basura.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template DebugTrashyRoadGame}
/// A [TrashyRoadGame] that is used for debugging purposes.
/// {@endtemplate}
class DebugTrashyRoadGame extends TrashyRoadGame {
  /// {@macro DebugTrashyRoadGame}
  DebugTrashyRoadGame({
    required super.gameBloc,
    required super.effectPlayer,
    required super.random,
    required super.resolution,
    super.images,
  }) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      FpsTextComponent()
        ..position = Vector2(10, 55)
        ..textRenderer = TextPaint(
          style: const TextStyle(
            color: BasuraColors.black,
            fontSize: 24,
          ),
        ),
    );
  }
}
