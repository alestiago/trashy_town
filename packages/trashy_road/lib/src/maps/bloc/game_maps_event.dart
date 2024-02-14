part of 'game_maps_bloc.dart';

@immutable
sealed class GameMapsEvent extends Equatable {
  const GameMapsEvent();
}

/// {@template game_map_completed_event}
/// Indicates that a [GameMap] has been completed.
/// {@endtemplate}
class GameMapCompletedEvent extends GameMapsEvent {
  /// {@macro game_map_completed_event}
  const GameMapCompletedEvent({
    required this.identifier,
    required this.score,
  });

  /// The identifier of the map that was completed.
  final String identifier;

  /// The score achieved on the map.
  final int score;

  @override
  List<Object?> get props => [identifier, score];
}
