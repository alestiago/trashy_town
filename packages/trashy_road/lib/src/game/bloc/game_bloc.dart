import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required TiledMap map}) : super(GameState.initial(map: map)) {
    on<GameReadyEvent>(_onGameReady);
    on<GameInteractedEvent>(_onGameInteraction);
    on<GameCollectedTrashEvent>(_onCollectedTrash);
    on<GameResetEvent>(_onGameReset);
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
    final inventory = state.inventory.copyWith(
      trash: state.inventory.trash + 1,
    );
    emit(state.copyWith(inventory: inventory));
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
}
