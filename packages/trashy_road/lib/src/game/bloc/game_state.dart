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

  /// The game is resetting.
  resetting,

  /// The game is paused.
  ///
  /// Pausing the game means that all user input is disabled and moving objects
  /// are paused.
  paused,

  /// The player has completed the level
  completed
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
  const GameState({
    required this.status,
    required this.map,
    required this.inventory,
    required this.trashRemaining,
  });

  /// The initial state of the game.
  const GameState.initial({required TiledMap map})
      : this(
          status: GameStatus.ready,
          map: map,
          inventory: const Inventory.empty(),
          trashRemaining: -1,
        );

  /// {@macro GameStatus}
  final GameStatus status;

  /// The map that the game is being played on.
  final TiledMap map;

  /// {@macro Inventory}
  final Inventory inventory;

  final int trashRemaining;

  GameState copyWith({
    GameStatus? status,
    Inventory? inventory,
    int? trashRemaining,
  }) {
    return GameState(
      status: status ?? this.status,
      map: map,
      inventory: inventory ?? this.inventory,
      trashRemaining: trashRemaining ?? this.trashRemaining,
    );
  }

  @override
  List<Object?> get props => [status, inventory, map, trashRemaining];
}

/// {@template Inventory}
/// The player's inventory.
///
/// The inventory is used to keep track of the amount of [trash] that the player
/// has collected.
/// {@endtemplate}
@immutable
class Inventory extends Equatable {
  /// {@macro Inventory}
  const Inventory({required this.trash});

  /// A completely empty inventory.
  const Inventory.empty() : this(trash: 0);

  /// The amount of trash that the player has collected.
  final int trash;

  Inventory copyWith({int? trash}) {
    return Inventory(trash: trash ?? this.trash);
  }

  @override
  List<Object?> get props => [trash];
}
