part of 'game_bloc.dart';

enum GameStatus { playing }

@immutable
class GameState extends Equatable {
  const GameState({
    required this.status,
  });

  final GameStatus status;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
