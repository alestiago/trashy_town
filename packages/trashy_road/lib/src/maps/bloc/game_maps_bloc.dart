import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

    final firstTimeCompleted = currentMap.score == 0;
    if (firstTimeCompleted) {
      final mapsList = state.maps.keys.toList();
      final currentIndex = mapsList.indexOf(event.identifier);
      final nextIndex = currentIndex + 1;

      final isLastMap = nextIndex == mapsList.length;
      if (!isLastMap) {
        final nextMap = state.maps[mapsList[nextIndex]]!;

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
