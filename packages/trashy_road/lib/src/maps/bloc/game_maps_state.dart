part of 'game_maps_bloc.dart';

/// Represents a collection of [GameMap]s.
///
/// Where the key is the identifier of the map and the value is the
/// [GameMap] itself.
typedef GameMapsCollection = UnmodifiableMapView<GameMapIdentifier, GameMap>;

/// {@template RatingSteps}
/// The steps that dictate the rating of the map score.
///
/// It expects three integers, where the first index is the minimum score
/// (inclusive) required to achieve a [ScoreRating.gold], the second index is
/// the minimum score (inclusive) required to achieve a [ScoreRating.silver]
/// rating, and the third index is the minimum score (inclusive) required to
/// achieve a [ScoreRating.bronze]. Any score below the third index will achieve
/// a rating of none.
///
/// For example, if the player completes the map in 75 seconds, and the rating
/// steps are [25, 50, 100], then the player will achieve a bronze score.
/// Whereas if the player completes the map in 25 seconds, then the player will
/// achieve a gold score.
/// {@endtemplate}
typedef RatingSteps = (int, int, int);

enum GameMapIdentifier {
  tutorial,
  map2,
  map3,
  map4,
  map5,
  map6,
  map7,
  map8,
  map9,
  map10,
  map11;
}

class GameMapsState extends Equatable {
  GameMapsState({
    required GameMapsCollection maps,
  }) : maps = GameMapsCollection(maps);

  GameMapsState.initial()
      : maps = UnmodifiableMapView(
          {
            GameMapIdentifier.tutorial: GameMap._(
              identifier: GameMapIdentifier.tutorial,
              displayName: '1',
              path: Assets.tiles.map1,
              score: null,
              ratingSteps: (15, 20, 30),
              locked: false,
            ),
            GameMapIdentifier.map2: GameMap._(
              identifier: GameMapIdentifier.map2,
              displayName: '2',
              path: Assets.tiles.map2,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map3: GameMap._(
              identifier: GameMapIdentifier.map3,
              displayName: '3',
              path: Assets.tiles.map3,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map4: GameMap._(
              identifier: GameMapIdentifier.map4,
              displayName: '4',
              path: Assets.tiles.map4,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map5: GameMap._(
              identifier: GameMapIdentifier.map5,
              displayName: '5',
              path: Assets.tiles.map5,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map6: GameMap._(
              identifier: GameMapIdentifier.map6,
              displayName: '6',
              path: Assets.tiles.map6,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map7: GameMap._(
              identifier: GameMapIdentifier.map7,
              displayName: '7',
              path: Assets.tiles.map7,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map8: GameMap._(
              identifier: GameMapIdentifier.map8,
              displayName: '8',
              path: Assets.tiles.map8,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map9: GameMap._(
              identifier: GameMapIdentifier.map9,
              displayName: '9',
              path: Assets.tiles.map9,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map10: GameMap._(
              identifier: GameMapIdentifier.map10,
              displayName: '10',
              path: Assets.tiles.map10,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
            GameMapIdentifier.map11: GameMap._(
              identifier: GameMapIdentifier.map11,
              displayName: '11',
              path: Assets.tiles.map11,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
          },
        );

  final GameMapsCollection maps;

  /// Returns the next map in the collection.
  ///
  /// If there are no more maps, it will return `null`.
  GameMap? next(GameMapIdentifier identifier) {
    final mapsList = maps.keys.toList();
    final currentIndex = mapsList.indexOf(identifier);
    final nextIndex = currentIndex + 1;

    final isLastMap = nextIndex == mapsList.length;
    if (isLastMap) return null;

    return maps[mapsList[nextIndex]];
  }

  GameMapsState copyWith({
    Map<GameMapIdentifier, GameMap>? maps,
  }) {
    return GameMapsState(maps: UnmodifiableMapView(maps ?? this.maps));
  }

  @override
  List<Object> get props => [maps];
}

/// {@template ScoreRating}
/// The rating of a score.
///
/// See also:
///
/// * [RatingSteps] for the steps that dictate the rating of the map score.
/// {@endtemplate}
enum ScoreRating {
  none._(value: 0),
  bronze._(value: 1),
  silver._(value: 2),
  gold._(value: 3);

  const ScoreRating._({required this.value});

  /// Creates a [ScoreRating] from the given [RatingSteps] and [score].
  factory ScoreRating.fromSteps({
    required int? score,
    required RatingSteps steps,
  }) {
    if (score == null) return none;
    if (score < 0) return none;
    if (score <= steps.$1) return gold;
    if (score <= steps.$2) return silver;
    if (score <= steps.$3) return bronze;
    return none;
  }

  /// The value of the score.
  ///
  /// The higher the value, the better the rating.
  final int value;
}

/// {@template GameMapMetadata}
/// Stores the metadata of a map game.
///
/// Not to be confused with `TiledMap` which is the actual map file. To retrieve
/// the actual map file, use the [path] and load it from the `TiledCache`
/// provided by the `PreloadCubit`.
/// {@endtemplate}
class GameMap extends Equatable {
  GameMap._({
    required this.identifier,
    required this.displayName,
    required this.score,
    required this.ratingSteps,
    required bool locked,
    required this.path,
  })  : scoreRating = ScoreRating.fromSteps(
          score: score,
          steps: ratingSteps,
        ),
        _locked = locked;

  /// The identifier of the map.
  final GameMapIdentifier identifier;

  /// The display name of the map.
  final String displayName;

  /// The score the player has achieved on this map.
  ///
  /// A score of `null` means the map has not been played yet.
  final int? score;

  /// {@macro RatingSteps}
  final RatingSteps ratingSteps;

  /// {@macro ScoreRating}
  final ScoreRating scoreRating;

  final bool _locked;

  /// Whether the map is locked and cannot be played.
  ///
  /// A locked map is usually a map that is not yet available to the player.
  bool get locked {
    return !(Uri.base.queryParameters['admin'] == 'true') && _locked;
  }

  /// The path to the map file.
  final String path;

  /// The maximum amount of time the player has to complete the map.
  int get completionSeconds => ratingSteps.$3 + 15;

  GameMap copyWith({
    GameMapIdentifier? identifier,
    String? displayName,
    int? score,
    RatingSteps? ratingSteps,
    bool? locked,
    String? path,
  }) {
    return GameMap._(
      identifier: identifier ?? this.identifier,
      displayName: displayName ?? this.displayName,
      score: score ?? this.score,
      ratingSteps: ratingSteps ?? this.ratingSteps,
      locked: locked ?? this.locked,
      path: path ?? this.path,
    );
  }

  @override
  List<Object?> get props => [
        identifier,
        displayName,
        score,
        ratingSteps,
        scoreRating,
        locked,
        path,
      ];
}
