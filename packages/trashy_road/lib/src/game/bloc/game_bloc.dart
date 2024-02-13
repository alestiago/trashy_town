import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required TiledMap map}) : super(GameState.initial(map: map)) {
    on<GameReadyEvent>(_onGameReady);
    on<GameTrashAddedEvent>(_onGameTrashAdded);
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

  void _onGameTrashAdded(
    GameTrashAddedEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(trashRemaining: event.amountOfTrash));
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

    final inventory = state.inventory.copyWith(
      trash: state.inventory.trash + 1,
    );
    emit(state.copyWith(inventory: inventory));
  }

  void _onDepositedTrash(
    GameDepositedTrashEvent event,
    Emitter<GameState> emit,
  ) {
    if (state.inventory.trash > 0) {
      final inventory = state.inventory.copyWith(
        trash: state.inventory.trash - 1,
      );
      final trashRemaining = state.trashRemaining - 1;
      if (trashRemaining == 0) {
        emit(state.copyWith(status: GameStatus.completed));
      } else {
        emit(
          state.copyWith(
            inventory: inventory,
            trashRemaining: trashRemaining,
          ),
        );
      }
    }
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
