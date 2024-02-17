import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/score/widgets/animated_star_rating.dart';

/// {@template MapsMenuPage}
/// Shows the available maps to play.
///
/// Some maps are locked and can only be played after the player has unlocked
/// them by playing other maps.
/// {@endtemplate}
class MapsMenuPage extends StatelessWidget {
  /// {@macro MapsMenuPage}
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
      body: AnimatedStarRating(
        rating: 2,
      ),
    );

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
                child: GameMapTile(map: map),
              );
            },
          );
        },
      ),
    );
  }
}
