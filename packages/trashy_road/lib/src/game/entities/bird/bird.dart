import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

class Bird extends PositionedEntity with ZIndex {
  Bird._({required this.isFlyingRight, required this.speed})
      : super(
          scale: Vector2.all(0.5),
          behaviors: [
            BirdFlyingBehavior(),
            BirdRandomSpawningBehavior(),
            PausingBehavior<Bird>(
              selector: (bird) => bird.findBehaviors<BirdFlyingBehavior>(),
            ),
          ],
          children: [
            GameSpriteAnimationComponent.fromPath(
              spritePath: Assets.images.sprites.birdFlying.path,
              animationData: SpriteAnimationData.sequenced(
                amount: 25,
                amountPerRow: 5,
                textureSize: Vector2.all(128),
                stepTime: 1 / 24,
              ),
            ),
          ],
        );

  factory Bird.randomize() {
    final isFlyingRight = random.nextBool();
    final speed = minSpeed + random.nextDouble() * (maxSpeed - minSpeed);

    return Bird._(isFlyingRight: isFlyingRight, speed: speed);
  }

  static List<Bird> randomAmount() {
    final amountOfBirds = random.nextInt(maxAmountOfBirds + 1);

    return List.generate(amountOfBirds, (_) => Bird.randomize());
  }

  static final random = Random();

  /// The maximum amount of birds that are loaded into a map.
  static const maxAmountOfBirds = 5;

  static const maxSpeed = 3.0;
  static const minSpeed = 1.0;

  /// Whether the bird is flying right.
  final bool isFlyingRight;

  /// Speed Multiplier
  final double speed;

  @override
  int get zIndex => 100000;
}
