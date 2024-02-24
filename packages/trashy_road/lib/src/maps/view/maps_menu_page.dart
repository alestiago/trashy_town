import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            // TODO(alestiago): Use background render when available.
            Assets.images.grass.path,
            repeat: ImageRepeat.repeat,
          ),
        ),
        BlocSelector<GameMapsBloc, GameMapsState, GameMapsCollection>(
          selector: (state) => state.maps,
          builder: (context, maps) {
            final mapsValues = maps.values.toList();
            final screenSize = MediaQuery.sizeOf(context);

            const mainCrossAxisExtent = 150.0;
            const mainAxisSpacing = 20.0;

            final padding = EdgeInsets.symmetric(
              vertical: mainAxisSpacing * 3,
              horizontal: screenSize.width * 0.1,
            );

            return Center(
              child: SizedBox(
                width: mainCrossAxisExtent * 5 + padding.horizontal,
                child: GridView.builder(
                  padding: padding,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: mainCrossAxisExtent,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  itemCount: mapsValues.length,
                  itemBuilder: (context, index) {
                    return GameMapTile(map: mapsValues[index]);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
