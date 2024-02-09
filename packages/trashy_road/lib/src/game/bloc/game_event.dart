part of 'game_bloc.dart';

@immutable
sealed class GameEvent extends Equatable {
  const GameEvent();
}

/// The game is ready to be played.
class GameReadyEvent extends GameEvent {
  const GameReadyEvent() : super();

  @override
  List<Object?> get props => [];
}

/// The user has interacted with the game.
///
/// This is fired during the first interaction with the game.
class GameInteractedEvent extends GameEvent {
  const GameInteractedEvent() : super();

  @override
  List<Object?> get props => [];
}

/// The user has collected trash.
class GameCollectedTrashEvent extends GameEvent {
  const GameCollectedTrashEvent() : super();

  @override
  List<Object?> get props => [];
}

/// The game has been reset.
class GameResetEvent extends GameEvent {
  const GameResetEvent() : super();

  @override
  List<Object?> get props => [];
}
