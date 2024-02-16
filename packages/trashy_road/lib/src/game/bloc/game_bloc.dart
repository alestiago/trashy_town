import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required String identifier,
    required TiledMap map,
  }) : super(GameState.initial(identifier: identifier, map: map)) {
    on<GameReadyEvent>(_onGameReady);
    on<GameInteractedEvent>(_onGameInteraction);
    on<GameCollectedTrashEvent>(_onCollectedTrash);
    on<GameDepositedTrashEvent>(_onDepositedTrash);
    on<GameResetEvent>(_onGameReset);
    on<GamePausedEvent>(_onGamePaused);
    on<GameResumedEvent>(_onGameResumed);
  }

  void _onGameReady(
    GameReadyEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(status: GameStatus.ready));
  }

  void _onGameInteraction(
    GameInteractedEvent event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        status: GameStatus.playing,
        startedAt: () => state.startedAt ?? clock.now(),
      ),
    );
  }

  void _onCollectedTrash(
    GameCollectedTrashEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.playing) {
      return;
    }

    final items = List<TrashType>.from(state.inventory.items)..add(event.item);
    final inventory = state.inventory.copyWith(items: items);

    emit(state.copyWith(inventory: inventory));
  }

  void _onDepositedTrash(
    GameDepositedTrashEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.playing) {
      return;
    }

    final hasItem = state.inventory.items.contains(event.item);
    if (!hasItem) {
      return;
    }

    final items = List<TrashType>.from(state.inventory.items)
      ..remove(event.item);
    final inventory = state.inventory.copyWith(items: items);

    final collectedTrash = state.collectedTrash + 1;
    final hasWon = collectedTrash == state._initialTrash;

    emit(
      state.copyWith(
        inventory: inventory,
        collectedTrash: collectedTrash,
        status: hasWon ? GameStatus.completed : GameStatus.playing,
      ),
    );
  }

  void _onGameReset(
    GameResetEvent event,
    Emitter<GameState> emit,
  ) {
    emit(
      GameState.initial(
        identifier: state.identifier,
        map: state.map,
      ).copyWith(
        status: GameStatus.resetting,
      ),
    );
  }

  void _onGamePaused(
    GamePausedEvent event,
    Emitter<GameState> emit,
  ) {
    emit(
      state.copyWith(
        status: GameStatus.paused,
        pausedAt: () => clock.now(),
      ),
    );
  }

  void _onGameResumed(
    GameResumedEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.paused) {
      return;
    }

    final pausedDuration =
        state.pausedDuration + clock.now().difference(state.pausedAt!);

    emit(
      state.copyWith(
        status: GameStatus.playing,
        pausedDuration: pausedDuration,
        pausedAt: () => null,
      ),
    );
  }

  @override
  void onTransition(Transition<GameEvent, GameState> transition) {
    super.onTransition(transition);
  }
}
