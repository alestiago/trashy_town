import 'dart:math';

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
    if (_map.locked) {
      return const _CrumbledPaper();
    }
    final theme = BasuraTheme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.cardHeading,
      child: AnimatedHoverBrightness(
        child: GestureDetector(
          onTap: () => _onTap(context),
          behavior: HitTestBehavior.opaque,
          child: _PaperBackground(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: AutoSizeText(
                          _map.displayName,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _Stars(value: _map.scoreRating.value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    SvgGenImage star({required bool filled}) =>
        filled ? Assets.images.starFilled : Assets.images.starEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final starWidth = maxWidth / 4;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            star(filled: value >= 1).svg(width: starWidth),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: star(filled: value >= 2).svg(width: starWidth),
            ),
            star(filled: value >= 3).svg(width: starWidth),
          ],
        );
      },
    );
  }
}

class _PaperBackground extends StatelessWidget {
  const _PaperBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.paperBackgroundSquare.provider(),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}

class _CrumbledPaper extends StatelessWidget {
  const _CrumbledPaper();

  static final _images = [
    Assets.images.crumpledPaper1,
    Assets.images.crumbledPaper2,
    Assets.images.crumbledPaper3,
  ];

  static final _random = Random();

  @override
  Widget build(BuildContext context) {
    final image = _images[_random.nextInt(_images.length)];
    return AspectRatio(
      aspectRatio: 1,
      child: image.image(),
    );
  }
}
