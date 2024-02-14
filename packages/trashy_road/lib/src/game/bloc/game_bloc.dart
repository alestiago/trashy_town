import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required TiledMap map}) : super(GameState.initial(map: map)) {
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
    emit(state.copyWith(status: GameStatus.playing));
  }

  void _onCollectedTrash(
    GameCollectedTrashEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.playing) {
      return;
    }

    final inventory = state.inventory.copyWithModifiedTrash(event.type, 1);

    emit(state.copyWith(inventory: inventory));
  }

  void _onDepositedTrash(
    GameDepositedTrashEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.playing) {
      return;
    }
    if (state.inventory.getTrash(event.type) == 0) {
      return;
    }

    final inventory = state.inventory.copyWithModifiedTrash(event.type, -1);
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
      state.copyWith(
        status: GameStatus.resetting,
        inventory: const Inventory.empty(),
      ),
    );
  }

  void _onGamePaused(
    GamePausedEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(status: GameStatus.paused));
  }

  void _onGameResumed(
    GameResumedEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.status != GameStatus.paused) {
      return;
    }

    emit(state.copyWith(status: GameStatus.playing));
  }

  @override
  void onTransition(Transition<GameEvent, GameState> transition) {
    super.onTransition(transition);
  }
}
