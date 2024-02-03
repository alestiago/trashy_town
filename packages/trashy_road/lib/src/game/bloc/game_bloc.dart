import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameCollectedTrashEvent>(_onCollectedTrash);
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
}
