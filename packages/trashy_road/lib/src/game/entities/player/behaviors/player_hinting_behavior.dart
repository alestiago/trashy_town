import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template PlayerHintingBehavior}
/// Shows a hint to the player to guide them to the closest [Trash].
///
/// The hint is shown when the closest [Trash] is not visible for a while
/// ([_hintDelay]) and a certain amount of time ([_hintInterval]) has passed
/// since the last hint was shown.
/// {@endtemplate}
class PlayerHintingBehavior extends Behavior<Player> with HasGameReference {
  /// The minimum time between hints.
  static const _hintInterval = 5.0;

  /// The amount of time that has to elapse without the closest [Trash] being
  /// visible to show a hint.
  static const _hintDelay = 4.0;

  /// The [Trash] entities in the game.
  ///
  /// Initialy determined during the [onLoad] method. [Trash] entities are
  /// removed from this set when they are removed from the game.
  ///
  /// If new [Trash] entities are added to the game, they are not accounted for.
  ///
  /// When empty, the behavior is removed from the [Player], since there is no
  /// need to show hints when there is no trash.
  late Set<Trash> _trash;

  /// The closest [Trash] to the [Player].
  ///
  /// Initialy determined during the [onLoad] method.
  ///
  /// `null` if there are no [Trash] entities in the game. When so, the behavior
  /// is removed from the [Player], since there is no need to show hints when
  /// there is no trash.
  late Trash? _closestTrash;

  /// Whether the closest [Trash] is visible.
  ///
  /// Initialy determined during the [onLoad] method.
  late bool _isTrashVisible;

  /// The time since the last hint was shown.
  var _lastHint = 0.0;

  /// The time since the last trash was visible.
  var _lastVisibleTrash = 0.0;

  final _distanceACache = Vector2.zero();
  final _distanceBCache = Vector2.zero();
  final _playerPositionCache = Vector2.zero();
  final _snappedPlayerPositionCache = Vector2.zero();
  final _snappedTrashPositionCache = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _playerPositionCache.setFrom(parent.position);

    final world = ancestors().whereType<TrashyRoadWorld>().first;
    _trash = world.descendants().whereType<Trash>().toSet();
    for (final trash in _trash) {
      unawaited(trash.removed.then((_) => _trash.remove(trash)));
    }
    _findClosestTrash();
  }

  void _findClosestTrash() {
    // TODO(alestiago): Consinder ordering to improve performance.
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

    _isTrashVisible = game.camera.viewfinder
        // ignore: invalid_use_of_protected_member
        .computeVisibleRect()
        .containsPoint(_closestTrash!.position);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_trash.isEmpty || _closestTrash == null) {
      // If there is no trash, no hint is needed and thus, the behavior can be
      // removed.
      removeFromParent();
      return;
    }

    _lastVisibleTrash = _isTrashVisible ? 0 : _lastVisibleTrash + dt;
    _lastHint += dt;

    final hasMoved = _playerPositionCache.distanceTo(parent.position) > 1;
    if (hasMoved) {
      // Heuristic to avoid searching for the closest trash every frame.
      _findClosestTrash();
      _playerPositionCache.setFrom(parent.position);
    }

    final shouldHint =
        _lastHint > _hintInterval && _lastVisibleTrash > _hintDelay;
    if (shouldHint) {
      _lastHint = 0;

      _snappedPlayerPositionCache
        ..setFrom(parent.position)
        ..snap();
      _snappedTrashPositionCache
        ..setFrom(_closestTrash!.position)
        ..snap();

      final direction = _HintArrowDirection.fromVector2(
        _snappedPlayerPositionCache,
        _snappedTrashPositionCache,
      );
      parent.add(_HintArrowSpriteComponent.fromDirection(direction));
    }
  }
}

/// The directions the [_HintArrowSpriteComponent] can point to.
enum _HintArrowDirection {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest;

  /// Derives the [_HintArrowDirection] from two [Vector2] points.
  static _HintArrowDirection fromVector2(Vector2 a, Vector2 b) {
    final angle = math.atan2(a.y - b.y, a.x - b.x);
    var degrees = angle * (180 / math.pi);

    // Adjust degrees to be within 0 to 360 range
    if (degrees < 0) {
      degrees += 360;
    }

    // Determine direction based on degrees
    if (degrees >= 22.5 && degrees < 67.5) {
      return _HintArrowDirection.northWest;
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return _HintArrowDirection.north;
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return _HintArrowDirection.northEast;
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return _HintArrowDirection.east;
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return _HintArrowDirection.southEast;
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return _HintArrowDirection.south;
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return _HintArrowDirection.southWest;
    } else {
      return _HintArrowDirection.west;
    }
  }

  String get spritePath {
    final spritePath = switch (this) {
      _HintArrowDirection.north => Assets.images.sprites.arrowNorth.path,
      _HintArrowDirection.northEast =>
        Assets.images.sprites.arrowNorthEast.path,
      _HintArrowDirection.east => Assets.images.sprites.arrowEast.path,
      _HintArrowDirection.southEast =>
        Assets.images.sprites.arrowSouthEast.path,
      _HintArrowDirection.south => Assets.images.sprites.arrowSouth.path,
      _HintArrowDirection.southWest =>
        Assets.images.sprites.arrowSouthWest.path,
      _HintArrowDirection.west => Assets.images.sprites.arrowWest.path,
      _HintArrowDirection.northWest =>
        Assets.images.sprites.arrowNorthWest.path,
    };
    return spritePath;
  }

  /// The destination of the direction.
  Vector2 destination() {
    return switch (this) {
      _HintArrowDirection.north => Vector2(0, -1),
      _HintArrowDirection.northEast => Vector2(1, -1),
      _HintArrowDirection.east => Vector2(1, 0),
      _HintArrowDirection.southEast => Vector2(1, 1),
      _HintArrowDirection.south => Vector2(0, 1),
      _HintArrowDirection.southWest => Vector2(-1, 1),
      _HintArrowDirection.west => Vector2(-1, 0),
      _HintArrowDirection.northWest => Vector2(-1, -1),
    };
  }
}

class _HintArrowSpriteComponent extends GameSpriteComponent
    with HasGameReference {
  _HintArrowSpriteComponent._({
    required this.direction,
    required super.spritePath,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall aesthetic.
          scale: Vector2.all(0.5),
        );

  /// Derives the [_HintArrowSpriteComponent] from a [Direction].
  factory _HintArrowSpriteComponent.fromDirection(
    _HintArrowDirection direction,
  ) {
    final position = _spritePathPositionMap[direction]!;
    return _HintArrowSpriteComponent._(
      direction: direction,
      spritePath: direction.spritePath,
    )..position = position;
  }

  /// Eye-balled map of the sprite path associated with the
  /// [_HintArrowDirection] to their position.
  static final Map<_HintArrowDirection, Vector2> _spritePathPositionMap = {
    _HintArrowDirection.north: Vector2(-0.58, -2)..toGameSize(),
    _HintArrowDirection.south: Vector2(-0.58, -0.24)..toGameSize(),
    _HintArrowDirection.east: Vector2(0, -1.1)..toGameSize(),
    _HintArrowDirection.west: Vector2(-1.16, -1.1)..toGameSize(),
    _HintArrowDirection.northEast: Vector2(0, -2)..toGameSize(),
    _HintArrowDirection.northWest: Vector2(-1.16, -2)..toGameSize(),
    _HintArrowDirection.southWest: Vector2(-1.16, -0.24)..toGameSize(),
    _HintArrowDirection.southEast: Vector2(0, -0.24)..toGameSize(),
  };

  _HintArrowDirection direction;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final effectController = EffectController(
      duration: 1,
    );

    await addAll([
      MoveEffect.by(
        direction.destination()..scale(4),
        effectController,
      ),
      RemoveEffect(
        delay: effectController.duration!,
      ),
      OpacityEffect.fadeOut(effectController),
    ]);
  }
}
