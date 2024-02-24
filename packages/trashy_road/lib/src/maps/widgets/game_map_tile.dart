import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/gen/gen.dart';
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
    final theme = BasuraTheme.of(context);

    final label = _map.locked ? '.' : _map.displayName;

    return DefaultTextStyle(
      style: theme.textTheme.button,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BasuraGlossyTextButton(
            onPressed: () => _onTap(context),
            label: label,
            style: theme.glossyButtonTheme.secondary,
            textStyle: theme.textTheme.button.copyWith(
              height: 0.6,
              color: BasuraColors.lightCadmiumYellow,
            ),
          ),
          if (!_map.locked)
            Positioned(
              left: 0,
              right: 0,
              bottom: -10,
              child: _Stars(value: _map.scoreRating.value),
            ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final starWidth = maxWidth / 2.8;
        final middle = maxWidth / 2;

        SvgGenImage star({required bool filled}) =>
            filled ? Assets.images.starFilled : Assets.images.starEmpty;

        return SizedBox(
          height: starWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: middle - starWidth,
                child: star(filled: value >= 1).svg(width: starWidth),
              ),
              Positioned(
                top: -2,
                left: middle - (starWidth / 2),
                child: star(filled: value >= 2).svg(width: starWidth),
              ),
              Positioned(
                left: middle,
                child: star(filled: value >= 3).svg(width: starWidth),
              ),
            ],
          ),
        );
      },
    );
  }
}
