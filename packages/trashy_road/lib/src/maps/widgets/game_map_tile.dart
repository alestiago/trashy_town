import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/view/view.dart';
import 'package:trashy_road/src/loading/loading.dart';
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
    required String title,
    required bool locked,
    required String path,
    super.key,
  })  : _title = title,
        _locked = locked,
        _path = path;

  factory GameMapTile.fromGameMap(GameMap gameMap) {
    return GameMapTile(
      title: gameMap.identifier,
      locked: gameMap.locked,
      path: gameMap.path,
    );
  }

  /// The title to display on the tile.
  ///
  /// This is usually the map's identifier.
  final String _title;

  /// Whether the map is locked or not.
  final bool _locked;

  /// The path to the map file.
  final String _path;

  void _onTap(BuildContext context) {
    if (_locked) return;

    final preloadCubit = context.read<PreloadCubit>();
    final tiledMap = preloadCubit.tiled.fromCache(_path);

    Navigator.of(context).push(GamePage.route(tiledMap: tiledMap));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _locked
              ? CupertinoColors.systemGrey
              : CupertinoColors.systemGreen,
          border: Border.all(),
        ),
        child: Center(child: Text(_title)),
      ),
    );
  }
}
