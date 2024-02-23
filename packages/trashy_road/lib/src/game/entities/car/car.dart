import 'dart:async';
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
          children: [
            _CarShadowComponent.fromDirection(roadLane.direction),
            _CarSpriteComponent.fromDirection(roadLane.direction),
          ],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(1.3, 1)..toGameSize(),
          ),
        );
}

class _CarSpriteComponent extends SpriteAnimationComponent
    with HasGameReference<TrashyRoadGame>, ParentIsA<Car> {
  _CarSpriteComponent._({required super.position})
      : super(
          // The `size` has been eyeballed to match with the hitbox.
          scale: Vector2.all(0.9),
        );

  factory _CarSpriteComponent.fromDirection(RoadLaneDirection direction) =>
      direction == RoadLaneDirection.leftToRight
          ? _CarSpriteComponent.leftToRight()
          : _CarSpriteComponent.rightToLeft();

  factory _CarSpriteComponent.rightToLeft() => _CarSpriteComponent._(
        // eye-balled position to match hitbox
        position: Vector2(-0.25, -1.5)..toGameSize(),
      );

  factory _CarSpriteComponent.leftToRight() => _CarSpriteComponent._(
        // eye-balled position to match hitbox
        position: Vector2(1.6, -1.5)..toGameSize(),
      )..flipHorizontally();

  String get _randomCarAssetPath {
    switch (game.random.nextInt(3)) {
      case 0:
        return Assets.images.carBlueDriving.path;
      case 1:
        return Assets.images.carRedDriving.path;
      case 2:
        return Assets.images.carYellowDriving.path;
      default:
        throw UnimplementedError();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    playing = game.camera.canSee(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final assetPath = _randomCarAssetPath;
    final image = await game.images.fetchOrGenerate(
      assetPath,
      () => game.images.load(assetPath),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 16,
        amountPerRow: 4,
        textureSize: Vector2(400, 200),
        stepTime: 1 / 24,
      ),
    );
  }
}

class _CarShadowComponent extends SpriteComponent
    with ParentIsA<Car>, HasGameRef {
  factory _CarShadowComponent.fromDirection(RoadLaneDirection direction) =>
      direction == RoadLaneDirection.leftToRight
          ? _CarShadowComponent.leftToRight()
          : _CarShadowComponent.rightToLeft();

  factory _CarShadowComponent.rightToLeft() {
    return _CarShadowComponent._(
      assetPath: Assets.images.carRightToLeftShadow.path,
      // The `position` has been eyeballed to match with the hitbox.
      position: Vector2(-0.25, -1.5)..toGameSize(),
    );
  }

  factory _CarShadowComponent.leftToRight() {
    return _CarShadowComponent._(
      assetPath: Assets.images.carLeftToRightShadow.path,
      // The `position` has been eyeballed to match with the hitbox.
      position: Vector2(-0.2, -1.5)..toGameSize(),
    );
  }
  _CarShadowComponent._({required this.assetPath, required super.position})
      // eye-balled size to match hitbox
      : super(scale: Vector2.all(0.9));

  final String assetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      assetPath,
      images: game.images,
    );
  }
}

/// The different styles of plastic bottles.
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
