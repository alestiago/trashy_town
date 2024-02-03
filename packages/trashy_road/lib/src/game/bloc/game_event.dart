part of 'game_bloc.dart';

@immutable
sealed class GameEvent extends Equatable {
  const GameEvent();
}

/// The user has collected trash.
class GameCollectedTrashEvent extends GameEvent {
  const GameCollectedTrashEvent() : super();

  @override
  List<Object?> get props => [];
}
