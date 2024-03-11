import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/maps/maps.dart';

class _MockTiledMap extends Mock implements TiledMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _MockTiledObject extends Mock implements TiledObject {}

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
    PlayerMovingBehavior behavior,
  ) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>(
        create: () => _gameBloc,
        children: [
          _TestPlayer()..add(behavior),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // TODO(OlliePugh): Fix tests
  /// These are broken since we added the animations to the player
  /// as the test tries to play the animation and can't find the asset.
  group('$PlayerMovingBehavior', skip: true, () {
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

    group('move', () {
      testWithGame<_TestGame>(
        'moves upward with $Direction.up',
        () => game,
        (game) async {
          const direction = Direction.up;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final player = behavior.parent;
          final previousVerticalPosition = player.position.y;

          behavior.move(direction);
          game.update(1);

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
        'moves downwards with $Direction.down',
        () => game,
        (game) async {
          const direction = Direction.down;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.y;
          behavior.move(direction);
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
        'moves rightward with $Direction.right',
        () => game,
        (game) async {
          const direction = Direction.right;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.x;
          behavior.move(direction);
          game.update(1);

          final player = behavior.parent;
          final currentVerticalPosition = player.position.x;
          expect(
            previousVerticalPosition,
            lessThan(currentVerticalPosition),
            reason:
                '''The player position should have moved rightward (positive x direction)''',
          );
        },
      );
      testWithGame<_TestGame>(
        'moves leftward with $Direction.left',
        () => game,
        (game) async {
          const direction = Direction.left;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.x;
          behavior.move(direction);
          game.update(1);

          final player = behavior.parent;
          final currentVerticalPosition = player.position.x;
          expect(
            previousVerticalPosition,
            greaterThan(currentVerticalPosition),
            reason:
                '''The player position should have moved leftward (negative x direction)''',
          );
        },
      );
    });
  });
}
