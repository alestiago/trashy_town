import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/view/view.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/bloc/game_maps_bloc.dart';
import 'package:trashy_road/src/maps/maps.dart';

/// {@template GameMapTile}
/// Represents a [GameMap] as a tile in the map menu.
///
/// When tapped, it will start the game with its map.
///
/// See also:
///
/// * [GameMap], which represents a map in the game.
/// {@endtemplate}
class GameMapTile extends StatelessWidget {
  /// {@macro GameMapTile}
  const GameMapTile({
    required GameMap map,
    super.key,
  }) : _map = map;

  /// The title to display on the tile.
  ///
  /// This is usually the map's identifier.
  final GameMap _map;

  void _onTap(BuildContext context) {
    if (_map.locked) return;

    final preloadCubit = context.read<PreloadCubit>();
    final tiledMap = preloadCubit.tiled.fromCache(_map.path);

    Navigator.of(context).push(
      GamePage.route(
        identifier: _map.identifier,
        tiledMap: tiledMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _map.locked
              ? CupertinoColors.systemGrey
              : CupertinoColors.systemGreen,
          border: Border.all(),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_map.identifier),
              if (!_map.locked) Text(_starText(_map.scoreRating.value)),
            ],
          ),
        ),
      ),
    );
  }
}

String _starText(int stars) {
  final buffer = StringBuffer();

  const emptyStar = '☆';
  const fullStar = '★';

  for (var i = 0; i < stars; i++) {
    buffer.write(fullStar);
  }
  for (var i = stars; i < 3; i++) {
    buffer.write(emptyStar);
  }
  return buffer.toString();
}
