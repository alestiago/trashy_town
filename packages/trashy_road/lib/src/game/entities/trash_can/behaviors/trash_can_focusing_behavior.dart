import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template TrashCanFocusingBehavior}
/// Makes the [TrashCan] focused whenever the player is within a certain radius.
/// {@endtemplate}
class TrashCanFocusingBehavior extends Behavior<TrashCan>
    with HasGameReference {
  final _TrashCanFocus _focusComponent = _TrashCanFocus();

  late final Player _player;

  /// The radius in which the trash can should focus on the player.
  ///
  /// In other words, when the player is within this radius, the trash can
  /// will be focused.
  final _focusingRadius = GameSettings.gridDimensions.x * 2;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _player = game.descendants().whereType<Player>().first;
  }

  bool _shouldFocus() {
    // TODO(alestiago): ensure the player and the trash can are anchored to its
    // center to better calculate the distance between them:
    // https://github.com/alestiago/trashy_road/issues/71
    final playerPosition = _player.position;
    final trashCanPosition = parent.position;

    final distanceBetween = playerPosition.distanceTo(trashCanPosition);
    return distanceBetween < _focusingRadius;
  }

  @override
  void update(double dt) {
    parent.focused = _shouldFocus();

    final hasFocusComponent = _focusComponent.parent != null;
    if (parent.focused && !hasFocusComponent) {
      parent.add(_focusComponent);
    } else if (!parent.focused && hasFocusComponent) {
      _focusComponent.removeFromParent();
    }
  }
}

class _TrashCanFocus extends Component {
  _TrashCanFocus()
      : super(
          children: [
            // TODO(alestiago): Replace with a more complex focus effect, when
            // the design is ready.
            CircleComponent(
              anchor: Anchor.center,
              position: GameSettings.gridDimensions / 2,
              radius: 10,
              paint: Paint()..color = const Color(0xFF00FFFF),
            ),
          ],
        );
}
