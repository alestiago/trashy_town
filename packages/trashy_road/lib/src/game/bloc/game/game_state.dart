part of 'game_bloc.dart';

/// {@template GameStatus}
/// The status of the game.
/// {@endtemplate}
enum GameStatus {
  /// The game is ready to be played.
  ///
  /// As soon, as the user has interacted with the game, the game will
  /// transition to [playing].
  ready,

  /// The user is currently playing the game.
  playing,

  /// The game has been lost.
  lost,

  /// The game is resetting.
  resetting,

  /// The game is paused.
  ///
  /// Pausing the game means that all user input is disabled and moving objects
  /// are paused.
  paused,

  /// The game has been completed.
  ///
  /// The game is completed when the user has collected all the trash on the
  /// map.
  completed,
}

/// {@template GameResetReason}
/// The reason why the game was reset.
/// {@endtemplate}
enum GameLostReason {
  /// The game was reset because the time ran out.
  timeIsUp,

  /// The game was reset because the player hit a vehicle.
  vehicleRunningOver,
}

/// {@template GameState}
/// Represents the state of a game.
///
/// A game is a single level, where the user is trying to collect and recycle
/// trash whilst avoiding obstacles.
/// {@endtemplate}
@immutable
class GameState extends Equatable {
  /// {@macro GameState}
  GameState({
    required this.identifier,
    required this.status,
    required this.map,
    required this.inventory,
    this.collectedTrash = 0,
    this.pausedDuration = Duration.zero,
    this.startedAt,
    this.pausedAt,
    this.score,
    this.lostReason,
  }) :
        // TODO(alestiago): Remove magic string.
        _initialTrash =
            (map.layerByName('TrashLayer') as ObjectGroup).objects.length;

  /// The initial state of the game.
  GameState.initial({
    required GameMapIdentifier identifier,
    required TiledMap map,
  }) : this(
          identifier: identifier,
          status: GameStatus.ready,
          map: map,
          inventory: Inventory.empty(),
          pausedDuration: Duration.zero,
          collectedTrash: 0,
          score: null,
        );

  /// {@macro GameStatus}
  final GameStatus status;

  /// The identifier of the level being played.
  final GameMapIdentifier identifier;

  /// The map that the game is being played on.
  final TiledMap map;

  /// The initial amount of trash on the map.
  final int _initialTrash;

  /// The amount of trash that the player has collected.
  ///
  /// Can't be greater than [_initialTrash].
  final int collectedTrash;

  /// {@macro Inventory}
  final Inventory inventory;

  /// The time at which the game was started.
  ///
  /// Is `null` if the game has not been started yet. A game is considered to
  /// have started as soon as the user interacts with the game.
  final DateTime? startedAt;

  /// The time at which the game was paused.
  ///
  /// Is `null` if the game is not paused.
  final DateTime? pausedAt;

  /// The total amount of time that the game has been paused for.
  final Duration pausedDuration;

  /// The final score of the game.
  ///
  /// If the game has not been completed, the score is `null`.
  ///
  /// The larger the score, the worse the player did. The score is calculated
  /// based on the amount of time that the player took to complete the game.
  final int? score;

  /// The reason why the game was loas.
  ///
  /// Is `null` if the game has not been lost.
  ///
  /// The reset reason is persisted until the game is lost again. For example,
  /// if the game was lost because the time ran out, the reset reason will be
  /// [GameLostReason.timeIsUp] until the game is lost again.
  final GameLostReason? lostReason;

  GameState copyWith({
    GameStatus? status,
    Inventory? inventory,
    int? collectedTrash,
    DateTime? Function()? startedAt,
    DateTime? Function()? pausedAt,
    Duration? pausedDuration,
    int? score,
    GameLostReason? lostReason,
  }) {
    return GameState(
      identifier: identifier,
      status: status ?? this.status,
      map: map,
      inventory: inventory ?? this.inventory,
      collectedTrash: collectedTrash ?? this.collectedTrash,
      startedAt: startedAt != null ? startedAt() : this.startedAt,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      pausedAt: pausedAt != null ? pausedAt() : this.pausedAt,
      score: score ?? this.score,
      lostReason: lostReason ?? this.lostReason,
    );
  }

  @override
  List<Object?> get props => [
        status,
        inventory,
        map,
        collectedTrash,
        startedAt,
        pausedDuration,
        pausedAt,
        score,
        lostReason,
      ];
}

/// {@template Inventory}
/// The player's inventory.
///
/// The inventory is used to keep track of the amount of [Trash] that the player
/// has collected.
/// {@endtemplate}
@immutable
class Inventory extends Equatable {
  /// {@macro Inventory}
  Inventory({
    required List<TrashType> items,
  })  : assert(
          items.length <= size,
          'The inventory can only hold up to $size items.',
        ),
        items = UnmodifiableListView(items);

  /// A completely empty inventory.
  Inventory.empty() : this(items: const []);

  /// The maximum amount of items that the inventory can hold.
  static const size = 5;

  final UnmodifiableListView<TrashType> items;

  /// Whether the inventory is full.
  bool get isFull => items.length >= size;

  Inventory copyWith({
    List<TrashType>? items,
  }) {
    return Inventory(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
