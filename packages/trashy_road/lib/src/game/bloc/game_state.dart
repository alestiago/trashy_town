part of 'game_bloc.dart';

/// {@template GameStatus}
/// The status of the game.
/// {@endtemplate}
enum GameStatus {
  /// The user is currently playing the game.
  playing,
}

/// {@template GameState}
/// Represents the state of a game.
///
/// A game is a single level, where the user is trying to collect and recycle
/// trash whilsts avoiding obstacles.
/// {@endtemplate}
@immutable
class GameState extends Equatable {
  /// {@macro GameState}
  const GameState({
    required this.status,
    required this.inventory,
  });

  /// The initial state of the game.
  const GameState.initial()
      : this(
          status: GameStatus.playing,
          inventory: const Inventory.empty(),
        );

  /// {@macro GameStatus}
  final GameStatus status;

  /// {@macro Inventory}
  final Inventory inventory;

  GameState copyWith({
    GameStatus? status,
    Inventory? inventory,
  }) {
    return GameState(
      status: status ?? this.status,
      inventory: inventory ?? this.inventory,
    );
  }

  @override
  List<Object?> get props => [status];
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
