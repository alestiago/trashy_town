import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/maps/maps.dart';

/// {@template MapsMenuPage}
/// Shows the available maps to play.
///
/// Some maps are locked and can only be played after the player has unlocked
/// them by playing other maps.
/// {@endtemplate}
class MapsMenuPage extends StatelessWidget {
  /// {@macro MapsMenuPage}
  const MapsMenuPage({super.key});

  /// The identifier for the route.
  static String identifier = 'maps_menu';

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: identifier),
      builder: (_) => const MapsMenuPage(),
    );
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
          final screenSize = MediaQuery.sizeOf(context);

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.1,
              vertical: screenSize.height * 0.1,
            ),
            child: GridView.count(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: EdgeInsets.zero,
              children: [
                for (final map in mapsValues) GameMapTile(map: map),
              ],
            ),
          );
        },
      ),
    );
  }
}
