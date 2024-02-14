import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/maps/maps.dart';

class MapsMenuPage extends StatelessWidget {
  const MapsMenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MapsMenuPage());
  }

  @override
  Widget build(BuildContext context) {
    return const _MapsMenuView();
  }
}

class _MapsMenuView extends StatelessWidget {
  const _MapsMenuView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: BlocSelector<GameMapsBloc, GameMapsState, GameMapsCollection>(
        selector: (state) => state.maps,
        builder: (context, maps) {
          final mapsValues = maps.values.toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: maps.length,
            itemBuilder: (context, index) {
              final map = mapsValues[index];

              return Padding(
                padding: const EdgeInsets.all(8),
                child: GameMapTile.fromGameMap(map),
              );
            },
          );
        },
      ),
    );
  }
}
