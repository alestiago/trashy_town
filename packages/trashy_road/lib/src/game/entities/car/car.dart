import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// A car that moves on the road.
///
/// See also:
///
/// * [Vehicle], the base class for all vehicles.
class Car extends Vehicle {
  Car({required super.roadLane})
      : super(
          children: [_CarSpriteGroup.fromDirection(roadLane.direction)],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(1.3, 1)..toGameSize(),
          ),
        );
}

class _CarSpriteGroup extends Component {
  _CarSpriteGroup.fromDirection(RoadLaneDirection direction)
      : super(
          children: [
            _CarShadowComponent._fromDirection(direction),
            _CarSpriteComponent._fromDirection(direction: direction),
          ],
        );
}

class _CarSpriteComponent extends GameSpriteAnimationComponent {
  _CarSpriteComponent._({
    required super.spritePath,
    super.position,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall tile map.
          scale: Vector2.all(0.9),
          animationData: SpriteAnimationData.sequenced(
            amount: 16,
            amountPerRow: 4,
            textureSize: Vector2(400, 200),
            stepTime: 1 / 24,
          ),
        );

  _CarSpriteComponent._rightToLeft({required String spritePath})
      : this._(
          spritePath: spritePath,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(-0.25, -1.5)..toGameSize(),
        );

  factory _CarSpriteComponent._leftToRight({required String spritePath}) {
    return _CarSpriteComponent._(
      spritePath: spritePath,
      // The `position` has been eyeballed to match with the overall tile map.
      position: Vector2(1.6, -1.5)..toGameSize(),
    )..flipHorizontally();
  }

  /// Creates a [_CarSpriteComponent] that is oriented as per the [direction].
  ///
  /// The `style` of the car is selected randomly.
  factory _CarSpriteComponent._fromDirection({
    required RoadLaneDirection direction,
  }) {
    final style = CarStyle._randomize();
    final spritePath = switch (style) {
      CarStyle.blue => Assets.images.carBlueDriving.path,
      CarStyle.red => Assets.images.carRedDriving.path,
      CarStyle.yellow => Assets.images.carYellowDriving.path,
    };

    return direction == RoadLaneDirection.leftToRight
        ? _CarSpriteComponent._leftToRight(spritePath: spritePath)
        : _CarSpriteComponent._rightToLeft(spritePath: spritePath);
  }
}

class _CarShadowComponent extends GameSpriteComponent {
  _CarShadowComponent.fromPath({
    required super.spritePath,
    super.position,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall tile map.
          scale: Vector2.all(0.9),
        );

  _CarShadowComponent._rightToLeft()
      : this.fromPath(
          spritePath: Assets.images.carRightToLeftShadow.path,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(-0.25, -1.5)..toGameSize(),
        );

  _CarShadowComponent._leftToRight()
      : this.fromPath(
          spritePath: Assets.images.carLeftToRightShadow.path,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(-0.2, -1.5)..toGameSize(),
        );

  /// Creates a [_CarShadowComponent] that is oriented as per the [direction].
  factory _CarShadowComponent._fromDirection(RoadLaneDirection direction) =>
      direction == RoadLaneDirection.leftToRight
          ? _CarShadowComponent._leftToRight()
          : _CarShadowComponent._rightToLeft();
}

/// The different styles of cars.
enum CarStyle {
  /// {@template _CarStyle.blue}
  /// A five-door hatchback blue car.
  /// {@endtemplate}
  blue,

  /// {@template _CarStyle.red}
  /// A five-door hatchback red car.
  /// {@endtemplate}
  red,

  /// {@template _CarStyle.red}
  /// A five-door hatchback yellow car.
  /// {@endtemplate}
  yellow;

  factory CarStyle._randomize({
    @visibleForTesting Random? random,
  }) {
    return CarStyle.values[(random ?? _random).nextInt(CarStyle.values.length)];
  }

  static final _random = Random();
}
