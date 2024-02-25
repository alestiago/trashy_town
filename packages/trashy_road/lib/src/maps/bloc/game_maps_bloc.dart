import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/gen/assets.gen.dart';

part 'game_maps_event.dart';
part 'game_maps_state.dart';

class GameMapsBloc extends Bloc<GameMapsEvent, GameMapsState> {
  GameMapsBloc() : super(GameMapsState.initial()) {
    on<GameMapCompletedEvent>(_onGameCompleted);
  }

  void _onGameCompleted(
    GameMapCompletedEvent event,
    Emitter<GameMapsState> emit,
  ) {
    assert(
      state.maps.containsKey(event.identifier),
      'The map with identifier `${event.identifier}` does not exist.',
    );

    Map<String, GameMap>? newMaps;
    final currentMap = state.maps[event.identifier]!;

    final firstTimeCompleted = currentMap.score == -1;
    if (firstTimeCompleted) {
      final nextMap = state.next(currentMap.identifier);

      final isLastMap = nextMap == null;
      if (!isLastMap) {
        newMaps ??= Map.from(state.maps);
        final updatedNextMap = nextMap.copyWith(locked: false);
        newMaps[nextMap.identifier] = updatedNextMap;
      }
    }

    if (currentMap.score < event.score) {
      newMaps ??= Map.from(state.maps);
      final updatedMap = currentMap.copyWith(score: event.score);
      newMaps[event.identifier] = updatedMap;
    }

    if (newMaps != null) {
      emit(state.copyWith(maps: newMaps));
    }
  }
}
