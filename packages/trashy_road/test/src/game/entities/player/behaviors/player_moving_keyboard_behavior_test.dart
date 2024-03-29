import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/maps/maps.dart';

class _MockTiledMap extends Mock implements TiledMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _MockTiledObject extends Mock implements TiledObject {}

class _MockKeyDownEvent extends Mock implements KeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class _TestPlayer extends Player {
  _TestPlayer() : super.empty();

  @override
  FutureOr<void> onLoad() {}
}

class _TestGame extends FlameGame {
  _TestGame({
    required GameBloc gameBloc,
  }) : _gameBloc = gameBloc;

  final GameBloc _gameBloc;

  Future<void> pump(
    PlayerKeyboardMovingBehavior behavior,
  ) async {
    final player = _TestPlayer();

    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>(
        create: () => _gameBloc,
        children: [player],
      ),
    );

    await player.ensureAdd(PlayerMovingBehavior());
    await player.ensureAdd(behavior);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // TODO(OlliePugh): Fix tests
  /// These are broken since we added the animations to the player
  /// as the test tries to play the animation and can't find the asset.
  group('$PlayerKeyboardMovingBehavior.arrows', skip: true, () {
    late _TestGame game;
    late GameBloc gameBloc;

    setUp(() {
      final objectGroup = _MockObjectGroup();
      when(() => objectGroup.objects).thenReturn([_MockTiledObject()]);

      final map = _MockTiledMap();
      when(() => map.layerByName('TrashLayer')).thenReturn(objectGroup);

      gameBloc = GameBloc(
        identifier: GameMapIdentifier.tutorial,
        map: map,
      );
      game = _TestGame(gameBloc: gameBloc);
    });

    tearDown(() {
      gameBloc.close();
    });

    group('moves', () {
      late KeyEvent keyDownEvent;

      setUp(() {
        keyDownEvent = _MockKeyDownEvent();
      });

      testWithGame<_TestGame>(
        'upward with the up key',
        () => game,
        (game) async {
          const upKey = LogicalKeyboardKey.arrowUp;
          final behavior = PlayerKeyboardMovingBehavior.arrows();
          await game.pump(behavior);

          when(() => keyDownEvent.logicalKey).thenReturn(upKey);

          final previousVerticalPosition = behavior.parent.position.y;

          behavior.onKeyEvent(keyDownEvent, {upKey});

          game.update(1);

          final player = behavior.parent;
          final currentVerticalPosition = player.position.y;
          expect(
            previousVerticalPosition,
            greaterThan(currentVerticalPosition),
            reason:
                '''The player position should have moved upwards (negative y direction)''',
          );
        },
      );

      testWithGame<_TestGame>(
        'downward with the down key',
        () => game,
        (game) async {
          const downKey = LogicalKeyboardKey.arrowDown;
          final behavior = PlayerKeyboardMovingBehavior.arrows();
          await game.pump(behavior);

          when(() => keyDownEvent.logicalKey).thenReturn(downKey);

          final previousVerticalPosition = behavior.parent.position.y;

          behavior.onKeyEvent(keyDownEvent, {downKey});

          game.update(1);

          final player = behavior.parent;
          final currentVerticalPosition = player.position.y;
          expect(
            previousVerticalPosition,
            lessThan(currentVerticalPosition),
            reason:
                '''The player position should have moved downwards (positive y direction)''',
          );
        },
      );

      testWithGame<_TestGame>(
        'leftward with the left key',
        () => game,
        (game) async {
          const leftKey = LogicalKeyboardKey.arrowLeft;
          final behavior = PlayerKeyboardMovingBehavior.arrows();
          await game.pump(behavior);

          when(() => keyDownEvent.logicalKey).thenReturn(leftKey);

          final previousHorizontalPosition = behavior.parent.position.x;

          behavior.onKeyEvent(keyDownEvent, {leftKey});

          game.update(1);

          final player = behavior.parent;
          final currentHorizontalPosition = player.position.x;
          expect(
            previousHorizontalPosition,
            greaterThan(currentHorizontalPosition),
            reason:
                '''The player position should have moved leftwards (negative x direction)''',
          );
        },
      );

      testWithGame<_TestGame>(
        'rightward with the right key',
        () => game,
        (game) async {
          const rightKey = LogicalKeyboardKey.arrowRight;
          final behavior = PlayerKeyboardMovingBehavior.arrows();
          await game.pump(behavior);

          when(() => keyDownEvent.logicalKey).thenReturn(rightKey);

          final previousHorizontalPosition = behavior.parent.position.x;

          behavior.onKeyEvent(keyDownEvent, {rightKey});

          game.update(1);

          final player = behavior.parent;
          final currentHorizontalPosition = player.position.x;
          expect(
            previousHorizontalPosition,
            lessThan(currentHorizontalPosition),
            reason:
                '''The player position should have moved rightwards (positive x direction)''',
          );
        },
      );
    });
  });
}
