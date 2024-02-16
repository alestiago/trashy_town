import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';

class _MockTiledMap extends Mock implements TiledMap {}

class _MockObjectGroup extends Mock implements ObjectGroup {}

class _MockTiledObject extends Mock implements TiledObject {}

void main() {
  group('$GameBloc', () {
    late TiledMap map;
    late _MockObjectGroup trashLayer;

    setUp(() {
      map = _MockTiledMap();
      trashLayer = _MockObjectGroup();
      when(() => trashLayer.objects).thenReturn([]);
      when(() => map.layerByName('TrashLayer')).thenReturn(trashLayer);
    });

    test('can be instantiated', () {
      expect(() => GameBloc(map: map), returnsNormally);
    });

    group('$GameInteractedEvent', () {
      blocTest<GameBloc, GameState>(
        'playing status after the user interacts with the game',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc.add(const GameInteractedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
        ],
      );
    });

    group('$GameCollectedTrashEvent', () {
      blocTest<GameBloc, GameState>(
        'does not fill the inventory with trash when the user collects trash '
        'and the game is not playing',
        build: () => GameBloc(map: map),
        act: (bloc) =>
            bloc.add(const GameCollectedTrashEvent(item: TrashType.plastic)),
        expect: () => <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'fills the inventory with trash when the user collects trash '
        'and the game is playing',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic)),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'increments the correct type of trash when the user collects trash '
        'and the game is playing',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameCollectedTrashEvent(item: TrashType.glass)),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory:
                Inventory(items: const [TrashType.plastic, TrashType.glass]),
            startedAt: DateTime(0),
          ),
        ],
      );
    });

    group('$GameDepositedTrashEvent', () {
      blocTest<GameBloc, GameState>(
        'does nothing when the game is not playing',
        build: () => GameBloc(map: map),
        act: (bloc) =>
            bloc.add(const GameDepositedTrashEvent(item: TrashType.plastic)),
        expect: () => <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'empties the inventory with trash when the user deposits trash '
        'and the game is playing',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        setUp: () => when(() => trashLayer.objects)
            .thenReturn([_MockTiledObject(), _MockTiledObject()]),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameDepositedTrashEvent(item: TrashType.plastic)),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            collectedTrash: 1,
            startedAt: DateTime(0),
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'empties the correct type of trash when the user deposits trash '
        'and the game is playing',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        setUp: () => when(() => trashLayer.objects)
            .thenReturn([_MockTiledObject(), _MockTiledObject()]),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameCollectedTrashEvent(item: TrashType.glass))
          ..add(const GameDepositedTrashEvent(item: TrashType.plastic)),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory:
                Inventory(items: const [TrashType.plastic, TrashType.glass]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.glass]),
            collectedTrash: 1,
            startedAt: DateTime(0),
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'completes the game when all the trash is deposited ',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        setUp: () => when(() => trashLayer.objects)
            .thenReturn([_MockTiledObject(), _MockTiledObject()]),
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameDepositedTrashEvent(item: TrashType.plastic))
          ..add(const GameDepositedTrashEvent(item: TrashType.plastic)),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory:
                Inventory(items: const [TrashType.plastic, TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            collectedTrash: 1,
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.completed,
            inventory: Inventory.empty(),
            collectedTrash: 2,
            startedAt: DateTime(0),
          ),
        ],
      );
    });

    group('$GamePausedEvent', () {
      blocTest<GameBloc, GameState>(
        'pauses the game when the user was previously playing the game',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GamePausedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.paused,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
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
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GamePausedEvent())
          ..add(const GameResumedEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.paused,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
        ],
      );
    });

    group('$GameResetEvent', () {
      blocTest<GameBloc, GameState>(
        'resets the game',
        build: () {
          return withClock<GameBloc>(
            Clock.fixed(DateTime(0)),
            () => GameBloc(map: map),
          );
        },
        act: (bloc) => bloc
          ..add(const GameInteractedEvent())
          ..add(const GameCollectedTrashEvent(item: TrashType.plastic))
          ..add(const GameResetEvent()),
        expect: () => [
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory.empty(),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.playing,
            inventory: Inventory(items: const [TrashType.plastic]),
            startedAt: DateTime(0),
          ),
          GameState(
            map: map,
            status: GameStatus.resetting,
            inventory: Inventory.empty(),
          ),
        ],
      );
    });
  });
}
