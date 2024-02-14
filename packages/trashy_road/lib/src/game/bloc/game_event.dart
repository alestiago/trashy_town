part of 'game_bloc.dart';

@immutable
sealed class GameEvent extends Equatable {
  const GameEvent();
}

/// {@template GameReadyEvent}
/// The game is ready to be played.
///
/// Fired when everything has been loaded and the game is ready to receive user
/// input.
/// {@endtemplate}
class GameReadyEvent extends GameEvent {
  /// {@macro GameReadyEvent}
  const GameReadyEvent() : super();

  @override
  List<Object?> get props => [];
}

/// {@template GameInteractedEvent}
/// The user has interacted with the game.
///
/// Fired during the first user interaction with the game.
/// {@endtemplate}
class GameInteractedEvent extends GameEvent {
  /// {@macro GameInteractedEvent}
  const GameInteractedEvent() : super();

  @override
  List<Object?> get props => [];
}

/// {@template GameCollectedTrashEvent}
/// The user has collected trash.
///
/// Fired when the user has collected a piece of trash. Trash is usually sparsed
/// across the map and the user has to collect it.
/// {@endtemplate}
class GameCollectedTrashEvent extends GameEvent {
  /// {@macro GameCollectedTrashEvent}
  const GameCollectedTrashEvent({required this.type}) : super();

  final TrashType type;

  @override
  List<Object?> get props => [type];
}

/// {@template GameDepositedTrashEvent}
/// The user has deposited trash.
///
/// Fired when the user has deposited a piece of trash into a trash can.
/// {@endtemplate}
class GameDepositedTrashEvent extends GameEvent {
  /// {@macro GameDepositedTrashEvent}
  const GameDepositedTrashEvent({required this.type}) : super();

  final TrashType type;

  @override
  List<Object?> get props => [];
}

/// The game has been reset.
class GameResetEvent extends GameEvent {
  const GameResetEvent() : super();

  @override
  List<Object?> get props => [];
}

/// {@template GamePausedEvent}
/// The game has been paused.
///
/// Pausing the game means that all user input is disabled and moving objects
/// are stopped.
///
/// Fired when the user pauses the game using the pause button.
/// {@endtemplate}
class GamePausedEvent extends GameEvent {
  /// {@macro GamePausedEvent}
  const GamePausedEvent() : super();

  @override
  List<Object?> get props => [];
}

/// {@template GameResumedEvent}
/// The game has been resumed.
///
/// A game can only be resumed if it has been previously paused. Resuming a game
/// means that all user input is enabled and moving objects are started again.
///
/// Fired when the user resumes the game using the pause button.
/// {@endtemplate}
class GameResumedEvent extends GameEvent {
  /// {@macro GameResumedEvent}
  const GameResumedEvent() : super();

  @override
  List<Object?> get props => [];
}
