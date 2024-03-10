part of 'game_maps_bloc.dart';

/// Represents a collection of [GameMap]s.
///
/// Where the key is the identifier of the map and the value is the
/// [GameMap] itself.
typedef GameMapsCollection = UnmodifiableMapView<String, GameMap>;

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

class GameMapsState extends Equatable {
  GameMapsState({
    required Map<String, GameMap> maps,
  }) : maps = GameMapsCollection(maps);

  GameMapsState.initial()
      : maps = UnmodifiableMapView(
          {
            tutorialIdentifier: GameMap._(
              identifier: tutorialIdentifier,
              displayName: '1',
              path: Assets.tiles.map1,
              score: null,
              ratingSteps: (15, 20, 30),
              locked: false,
            ),
            'map2': GameMap._(
              identifier: 'map2',
              displayName: '2',
              path: Assets.tiles.map2,
              score: null,
              ratingSteps: (25, 50, 100),
              locked: true,
            ),
          },
        );

  /// The identifier of the tutorial map.
  static String tutorialIdentifier = 'map1';

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
  final String identifier;

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
    String? identifier,
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
