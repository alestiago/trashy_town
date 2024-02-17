import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// An entity that cannot be traversed by other the [Player].
abstract class UntraversableEntity extends PositionedEntity {
  UntraversableEntity({
    super.size,
    super.position,
    super.children,
    super.anchor,
    super.priority,
    super.behaviors,
  });
}
