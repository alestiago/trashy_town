import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';

class _MockTiledMap extends Mock implements TiledMap {}

void main() {
  group('$GameBloc', () {
    late TiledMap map;

    setUp(() {
      map = _MockTiledMap();
    });

    test('can be instantiated', () {
      expect(() => GameBloc(map: map), returnsNormally);
    });

    group('$GameInteractedEvent', () {
      blocTest<GameBloc, GameState>(
        'playing status after the user interacts with the game',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc.add(const GameInteractedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
        ],
      );
    });

    group('$GameCollectedTrashEvent', () {
      blocTest<GameBloc, GameState>(
        'does not fill the inventory with trash when the user collects trash '
        'and the game is not playing',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc.add(const GameCollectedTrashEvent()),
        expect: () => <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'fills the inventory with trash when the user collects trash '
        'and the game is playing',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory(trash: 1),
          ),
        ],
      );
    });

    group('$GamePausedEvent', () {
      blocTest<GameBloc, GameState>(
        '''does not pause the game when the user was not previously playing the game''',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc.add(const GamePausedEvent()),
        expect: () => <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'pauses the game when the user was previously playing the game',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GamePausedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
          GameState(
            map: map,
            status: GameStatus.paused,
            inventory: const Inventory.empty(),
          ),
        ],
      );
    });

    group('$GameResumedEvent', () {
      blocTest<GameBloc, GameState>(
        '''does not resume the game when the user was not previously paused''',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc.add(const GameResumedEvent()),
        expect: () => <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'resumes the game when the user was previously paused',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GamePausedEvent())
          ..add(const GameResumedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
          GameState(
            map: map,
            status: GameStatus.paused,
            inventory: const Inventory.empty(),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
        ],
      );
    });

    group('$GameResetEvent', () {
      blocTest<GameBloc, GameState>(
        'resets the game',
        build: () => GameBloc(map: map),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent())
          ..add(const GameResetEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory.empty(),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: const Inventory(trash: 1),
          ),
          GameState(
            map: map,
            status: GameStatus.resetting,
            inventory: const Inventory.empty(),
          ),
        ],
      );
    });
  });
}
