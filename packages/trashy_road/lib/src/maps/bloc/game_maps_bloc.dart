// ignore_for_file: type=lint

import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/gen/assets.gen.dart';

part 'game_maps_event.dart';
part 'game_maps_state.dart';

class GameMapsBloc extends HydratedBloc<GameMapsEvent, GameMapsState> {
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

    Map<GameMapIdentifier, GameMap>? newMaps;
    final currentMap = state.maps[event.identifier]!;

    final firstTimeCompleted = currentMap.score == null;
    if (firstTimeCompleted) {
      final nextMap = state.next(currentMap.identifier);

      final isLastMap = nextMap == null;
      if (!isLastMap) {
        newMaps ??= Map.from(state.maps);
        final updatedNextMap = nextMap.copyWith(locked: false);
        newMaps[nextMap.identifier] = updatedNextMap;
      }
    }

    if (firstTimeCompleted || (currentMap.score! > event.score)) {
      newMaps ??= Map.from(state.maps);
      final updatedMap = currentMap.copyWith(score: event.score);
      newMaps[event.identifier] = updatedMap;
    }

    if (newMaps != null) {
      emit(state.copyWith(maps: newMaps));
    }
  }

  @override
  GameMapsState? fromJson(Map<String, dynamic> json) {
    final maps = json['maps'] as Map<String, dynamic>;
    final newMaps = maps.map(
      (key, value) {
        value as Map<String, dynamic>;

        final identifier =
            GameMapIdentifier.values.firstWhere((e) => e.toString() == key);
        final ratingSteps = value['ratingSteps'] as List<int>;
        final map = GameMap._(
          identifier: identifier,
          displayName: value['displayName'] as String,
          path: value['path'] as String,
          score: value['score'] as int?,
          ratingSteps: (ratingSteps[0], ratingSteps[1], ratingSteps[2]),
          locked: value['locked'] as bool,
        );
        return MapEntry(identifier, map);
      },
    );
    return GameMapsState(maps: UnmodifiableMapView(newMaps));
  }

  @override
  Map<String, dynamic>? toJson(GameMapsState state) {
    return {
      'maps': {
        for (final map in state.maps.entries)
          map.key.toString(): {
            'identifier': map.value.identifier.toString(),
            'displayName': map.value.displayName,
            'path': map.value.path,
            'score': map.value.score,
            'ratingSteps': [
              map.value.ratingSteps.$1,
              map.value.ratingSteps.$2,
              map.value.ratingSteps.$3,
            ],
            'locked': map.value.locked,
          },
      },
    };
  }
}
