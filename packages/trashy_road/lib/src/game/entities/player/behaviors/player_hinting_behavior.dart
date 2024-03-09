import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerHintingBehavior extends Behavior<Player> with HasGameReference {
  /// The [Trash] entities in the game.
  ///
  /// These are cached during the [onLoad] method.
  late Set<Trash> _trash;

  /// The closest [Trash] to the [Player].
  ///
  /// `null` if there are no [Trash] entities in the game.
  late Trash? _closestTrash;

  final _distanceACache = Vector2.zero();
  final _distanceBCache = Vector2.zero();
  final _playerPositionCache = Vector2.zero();
  final _snappedPlayerPositionCache = Vector2.zero();
  final _snappedTrashPositionCache = Vector2.zero();
  final _directionOriginCache = Vector2(0, -1);

  final _arrow = _ArrowSpriteComponent.fromDirection(
    _ArrowDirection.northWest,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _trash = game.descendants().whereType<Trash>().toSet();
    for (final trash in _trash) {
      unawaited(trash.removed.then((_) => _trash.remove(trash)));
    }

    for (final direction in _ArrowDirection.values) {
      add(_ArrowSpriteComponent.fromDirection(direction));
    }

    _playerPositionCache.setFrom(parent.position);
    parent.add(_arrow);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final hasMoved = _playerPositionCache.distanceTo(parent.position) > 1;
    if (!hasMoved) {
      return;
    }
    _playerPositionCache.setFrom(parent.position);

    _closestTrash = _trash.reduce((trash, anotherTrash) {
      _distanceACache
        ..setFrom(trash.position)
        ..sub(_playerPositionCache);
      _distanceBCache
        ..setFrom(anotherTrash.position)
        ..sub(_playerPositionCache);

      return _distanceACache.length < _distanceBCache.length
          ? trash
          : anotherTrash;
    });

    _snappedPlayerPositionCache
      ..setFrom(parent.position)
      ..snap();
    _snappedTrashPositionCache
      ..setFrom(_closestTrash!.position)
      ..snap();

    final direction = _ArrowDirection.getDirection(
      _snappedPlayerPositionCache,
      _snappedTrashPositionCache,
    );
    _arrow.updateDirection(direction);
  }
}

enum _ArrowDirection {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest;

  String get spritePath {
    final spritePath = switch (this) {
      _ArrowDirection.north => Assets.images.sprites.arrowNorth.path,
      _ArrowDirection.northEast => Assets.images.sprites.arrowNorthEast.path,
      _ArrowDirection.east => Assets.images.sprites.arrowEast.path,
      _ArrowDirection.southEast => Assets.images.sprites.arrowSouthEast.path,
      _ArrowDirection.south => Assets.images.sprites.arrowSouth.path,
      _ArrowDirection.southWest => Assets.images.sprites.arrowSouthWest.path,
      _ArrowDirection.west => Assets.images.sprites.arrowWest.path,
      _ArrowDirection.northWest => Assets.images.sprites.arrowNorthWest.path,
    };
    return spritePath;
  }

  static _ArrowDirection getDirection(Vector2 a, Vector2 b) {
    final angle = math.atan2(a.y - b.y, a.x - b.x);
    var degrees = angle * (180 / math.pi);

    // Adjust degrees to be within 0 to 360 range
    if (degrees < 0) {
      degrees += 360;
    }

    // Determine direction based on degrees
    if (degrees >= 22.5 && degrees < 67.5) {
      return _ArrowDirection.northWest;
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return _ArrowDirection.north;
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return _ArrowDirection.northEast;
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return _ArrowDirection.east;
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return _ArrowDirection.southEast;
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return _ArrowDirection.south;
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return _ArrowDirection.southWest;
    } else {
      return _ArrowDirection.west;
    }
  }
}

class _ArrowSpriteComponent extends GameSpriteComponent with HasGameReference {
  _ArrowSpriteComponent._({
    required this.direction,
    required super.spritePath,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall aesthetic.
          scale: Vector2.all(0.5),
        );

  /// Derives the [_ArrowSpriteComponent] from a [Direction].
  factory _ArrowSpriteComponent.fromDirection(_ArrowDirection direction) {
    final position = _spritePathPositionMap[direction]!;
    return _ArrowSpriteComponent._(
      direction: direction,
      spritePath: direction.spritePath,
    )..position = position;
  }

  /// Eye-balled map of the sprite path associated with the [_ArrowDirection] to
  /// their position.
  static final Map<_ArrowDirection, Vector2> _spritePathPositionMap = {
    _ArrowDirection.north: Vector2(-0.58, -2)..toGameSize(),
    _ArrowDirection.south: Vector2(-0.58, -0.24)..toGameSize(),
    _ArrowDirection.east: Vector2(0, -1.1)..toGameSize(),
    _ArrowDirection.west: Vector2(-1.16, -1.1)..toGameSize(),
    _ArrowDirection.northEast: Vector2(0, -2)..toGameSize(),
    _ArrowDirection.northWest: Vector2(-1.16, -2)..toGameSize(),
    _ArrowDirection.southWest: Vector2(-1.16, -0.24)..toGameSize(),
    _ArrowDirection.southEast: Vector2(0, -0.24)..toGameSize(),
  };

  _ArrowDirection direction;

  Future<void> updateDirection(_ArrowDirection newDirection) async {
    if (newDirection == direction) {
      return;
    }
    direction = newDirection;

    final newSpritePath = newDirection.spritePath;
    sprite = await Sprite.load(newSpritePath, images: game.images);
  }
}
