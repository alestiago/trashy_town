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

  /// The game has been completed.
  ///
  /// The game is completed when the user has collected all the trash on the
  /// map.
  completed,
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
    required this.status,
    required this.map,
    required this.inventory,
    this.collectedTrash = 0,
  }) :
        // TODO(alestiago): Remove magic string.
        _initialTrash =
            (map.layerByName('TrashLayer') as ObjectGroup).objects.length;

  /// The initial state of the game.
  GameState.initial({required TiledMap map})
      : this(
          status: GameStatus.ready,
          map: map,
          inventory: const Inventory.empty(),
          collectedTrash: 0,
        );

  /// {@macro GameStatus}
  final GameStatus status;

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

  GameState copyWith({
    GameStatus? status,
    Inventory? inventory,
    int? collectedTrash,
  }) {
    return GameState(
      status: status ?? this.status,
      map: map,
      inventory: inventory ?? this.inventory,
      collectedTrash: collectedTrash ?? this.collectedTrash,
    );
  }

  @override
  List<Object?> get props => [
        status,
        inventory,
        map,
        collectedTrash,
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
  const Inventory({required this.plasticTrash, required this.glassTrash});

  /// A completely empty inventory.
  const Inventory.empty() : this(plasticTrash: 0, glassTrash: 0);

  /// The amount of trash that the player has collected.
  final int plasticTrash;
  final int glassTrash;

  /// Returns the amount of trash of a given [type].
  int getTrash(TrashType type) {
    switch (type) {
      case TrashType.plastic:
        return plasticTrash;
      case TrashType.glass:
        return glassTrash;
    }
  }

  /// Returns the total amount of trash in the inventory.
  int getTotalTrash() => plasticTrash + glassTrash;

  /// Returns a new [Inventory] with the trash of a given [type] increased by
  /// [amount].
  Inventory copyWithModifiedTrash(TrashType type, int amount) {
    switch (type) {
      case TrashType.plastic:
        return copyWith(plasticTrash: plasticTrash + amount);
      case TrashType.glass:
        return copyWith(glassTrash: glassTrash + amount);
    }
  }

  Inventory copyWith({int? plasticTrash, int? glassTrash}) {
    return Inventory(
      plasticTrash: plasticTrash ?? this.plasticTrash,
      glassTrash: glassTrash ?? this.glassTrash,
    );
  }

  @override
  List<Object?> get props => [plasticTrash, glassTrash];
}
