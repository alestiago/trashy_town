import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/gen.dart';
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
    return BasuraBlackEaseInOut<void>(
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
    final size = MediaQuery.sizeOf(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff5F97C4),
            Color(0xff64A5CC),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            top: null,
            child: Transform.translate(
              offset: Offset(
                0,
                size.width > size.height
                    ? (size.width - size.height) / ((1920 / 732) * 2)
                    : 0,
              ),
              child: Image.asset(
                Assets.images.display.playBackgroundHouses.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const _MapsGrid(),
        ],
      ),
    );
  }
}

class _MapsGrid extends StatelessWidget {
  const _MapsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameMapsBloc, GameMapsState, GameMapsCollection>(
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
                crossAxisSpacing: 50,
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
    );
  }
}
