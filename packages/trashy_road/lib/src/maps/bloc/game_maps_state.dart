part of 'game_maps_bloc.dart';

class GameMapsState extends Equatable {
  GameMapsState({
    required Map<String, GameMap> maps,
  }) : maps = UnmodifiableMapView<String, GameMap>(maps);

  GameMapsState.initial()
      : maps = UnmodifiableMapView(
          {
            'map1':
                const GameMap._(identifier: 'map1', score: 0, locked: false),
            'map2': const GameMap._(identifier: 'map2', score: 0, locked: true),
          },
        );

  final UnmodifiableMapView<String, GameMap> maps;

  GameMapsState copyWith({
    Map<String, GameMap>? maps,
  }) {
    return GameMapsState(maps: maps ?? this.maps);
  }

  @override
  List<Object> get props => [maps];
}

class GameMap extends Equatable {
  const GameMap._({
    required this.identifier,
    required this.score,
    required this.locked,
  }) : path =
            // TODO(alestiago): Consider using the path package.
            'assets/maps/$identifier.tmx';

  /// The identifier of the map.
  final String identifier;

  /// The score the player has achieved on this map.
  ///
  /// A score of 0 means the map has not been played yet.
  final int score;

  /// Whether the map is locked and cannot be played.
  ///
  /// A locked map is usually a map that is not yet available to the player.
  final bool locked;

  /// The path to the map file.
  final String path;

  GameMap copyWith({
    String? identifier,
    int? score,
    bool? locked,
  }) {
    return GameMap._(
      identifier: identifier ?? this.identifier,
      score: score ?? this.score,
      locked: locked ?? this.locked,
    );
  }

  @override
  List<Object?> get props => [identifier, score, locked, path];
}
