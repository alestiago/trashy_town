part of 'game_maps_bloc.dart';

/// Represents a collection of [GameMap]s.
///
/// Where the key is the identifier of the map and the value is the
/// [GameMap] itself.
typedef GameMapsCollection = UnmodifiableMapView<String, GameMap>;

class GameMapsState extends Equatable {
  GameMapsState({
    required Map<String, GameMap> maps,
  }) : maps = GameMapsCollection(maps);

  GameMapsState.initial()
      : maps = UnmodifiableMapView(
          {
            'map1': GameMap._(
              identifier: 'map1',
              path: Assets.tiles.map1,
              score: 0,
              locked: false,
            ),
            'map2': GameMap._(
              identifier: 'map2',
              path: Assets.tiles.map2,
              score: 0,
              locked: true,
            ),
          },
        );

  final GameMapsCollection maps;

  /// Returns the next map in the collection.
  ///
  /// If there are no more maps, it will return `null`.
  GameMap? next(String identifier) {
    final mapsList = maps.keys.toList();
    final currentIndex = mapsList.indexOf(identifier);
    final nextIndex = currentIndex + 1;

    final isLastMap = nextIndex == mapsList.length;
    if (isLastMap) return null;

    return maps[mapsList[nextIndex]];
  }

  GameMapsState copyWith({
    Map<String, GameMap>? maps,
  }) {
    return GameMapsState(maps: maps ?? this.maps);
  }

  @override
  List<Object> get props => [maps];
}

/// {@template GameMapMetadata}
/// Stores the metadata of a map game.
///
/// Not to be confused with `TiledMap` which is the actual map file. To retrieve
/// the actual map file, use the [path] and load it from the `TiledCache`
/// provided by the `PreloadCubit`.
/// {@endtemplate}
class GameMap extends Equatable {
  const GameMap._({
    required this.identifier,
    required this.score,
    required this.locked,
    required this.path,
  });

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
    String? path,
  }) {
    return GameMap._(
      identifier: identifier ?? this.identifier,
      score: score ?? this.score,
      locked: locked ?? this.locked,
      path: path ?? this.path,
    );
  }

  @override
  List<Object?> get props => [identifier, score, locked, path];
}
