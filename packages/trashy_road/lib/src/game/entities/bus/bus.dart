import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// A bus that moves on the road.
///
/// Buses are larger vehicles that move on the road, they tend
/// to move slower than cars and are more difficult to avoid.
///
/// See also:
///
/// * [Vehicle], the base class for all vehicles.
class Bus extends Vehicle {
  Bus({required super.roadLane})
      : super(
          children: [
            _BusSpriteGroup(direction: roadLane.direction),
          ],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(1.4, 1)..toGameSize(),
          ),
        );
}

class _BusSpriteGroup extends Component {
  _BusSpriteGroup({
    required RoadLaneDirection direction,
  }) : super(
          children: [
            _BusShadowComponent._fromDirection(direction),
            _BusSpriteComponent(direction: direction),
          ],
        );
}

class _BusSpriteComponent extends GameSpriteAnimationComponent {
  /// Creates a [_BusSpriteComponent] that is oriented as per the [direction].
  factory _BusSpriteComponent({
    required RoadLaneDirection direction,
  }) {
    return direction == RoadLaneDirection.leftToRight
        ? _BusSpriteComponent._leftToRight()
        : _BusSpriteComponent._rightToLeft();
  }

  _BusSpriteComponent._({
    required super.spritePath,
    super.position,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall tile map.
          scale: Vector2.all(0.9),
          animationData: SpriteAnimationData.sequenced(
            amount: 12,
            amountPerRow: 4,
            textureSize: Vector2(384, 254),
            stepTime: 1 / 24,
          ),
        );

  _BusSpriteComponent._rightToLeft()
      : this._(
          spritePath: Assets.images.busDriving.path,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(-0.3, -2.2)..toGameSize(),
        );

  factory _BusSpriteComponent._leftToRight() {
    return _BusSpriteComponent._(
      spritePath: Assets.images.busDriving.path,
      // The `position` has been eyeballed to match with the overall tile map.
      position: Vector2(1.7, -2.2)..toGameSize(),
    )..flipHorizontally();
  }
}

class _BusShadowComponent extends GameSpriteComponent {
  _BusShadowComponent.fromPath({
    required super.spritePath,
    super.position,
  }) : super.fromPath(
          // The `scale` has been eyeballed to match with the overall tile map.
          scale: Vector2.all(0.9),
        );

  _BusShadowComponent._rightToLeft()
      : this.fromPath(
          spritePath: Assets.images.busRightToLeftShadow.path,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(-0.3, -2.2)..toGameSize(),
        );

  _BusShadowComponent._leftToRight()
      : this.fromPath(
          spritePath: Assets.images.busLeftToRightShadow.path,
          // The `position` has been eyeballed to match with the overall tile
          // map.
          position: Vector2(0, -2.2)..toGameSize(),
        );

  /// Creates a [_BusShadowComponent] that is oriented as per the [direction].
  factory _BusShadowComponent._fromDirection(RoadLaneDirection direction) =>
      direction == RoadLaneDirection.leftToRight
          ? _BusShadowComponent._leftToRight()
          : _BusShadowComponent._rightToLeft();
}
