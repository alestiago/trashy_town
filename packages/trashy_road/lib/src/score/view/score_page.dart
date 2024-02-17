import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    required String identifier,
    super.key,
  }) : _identifier = identifier;

  final String _identifier;

  static Route<void> route({
    required String identifier,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ScorePage(identifier: identifier),
    );
  }

  void _onNextMap(BuildContext context, {required GameMap nextMap}) {
    if (nextMap.locked) return;

    final preloadCubit = context.read<PreloadCubit>();
    final tiledMap = preloadCubit.tiled.fromCache(nextMap.path);

    Navigator.of(context).pushReplacement(
      GamePage.route(
        identifier: nextMap.identifier,
        tiledMap: tiledMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameMapsBloc = context.read<GameMapsBloc>();

    final map = gameMapsBloc.state.maps[_identifier]!;

    final score = map.score;
    final nextMap = gameMapsBloc.state.next(_identifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: Center(
        child: Text('Score: $score'),
      ),
      floatingActionButton: nextMap != null
          ? FloatingActionButton(
              onPressed: () => _onNextMap(context, nextMap: nextMap),
              child: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
