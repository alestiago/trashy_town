import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trashy_road/src/game/game.dart';

class _MockTiledMap extends Mock implements TiledMap {}

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
          Player.test(
            behaviors: [behavior],
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$PlayerMovingBehavior', () {
    late _TestGame game;
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = GameBloc(
        map: _MockTiledMap(),
      );
      game = _TestGame(gameBloc: gameBloc);
    });

    tearDown(() {
      gameBloc.close();
    });

    group('moves', () {
      testWithGame<_TestGame>(
        'upward with $Direction.up',
        () => game,
        (game) async {
          const direction = Direction.up;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.y;
          behavior.move(direction);
          game.update(0);

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
        'downwards with $Direction.down',
        () => game,
        (game) async {
          const direction = Direction.down;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.y;
          behavior.move(direction);
          game.update(0);

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
        'rightward with $Direction.right',
        () => game,
        (game) async {
          const direction = Direction.right;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.x;
          behavior.move(direction);
          game.update(0);

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
        'leftward with $Direction.left',
        () => game,
        (game) async {
          const direction = Direction.left;
          final behavior = PlayerMovingBehavior();
          await game.pump(behavior);

          final previousVerticalPosition = behavior.parent.position.x;
          behavior.move(direction);
          game.update(0);

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
