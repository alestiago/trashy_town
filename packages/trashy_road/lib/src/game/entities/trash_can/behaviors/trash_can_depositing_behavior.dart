import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCanDepositingBehavior extends Behavior<TrashCan>
    with FlameBlocReader<GameBloc, GameState> {
  /// The maximum amount of trash that the [TrashCan] can hold.
  static const int _maximumCapacity = 3;

  /// The current amount of trash that the [TrashCan] holds.
  int _capacity = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(
      !parent.hasBehavior<TrashCanDepositingBehavior>(),
      'The parent can only have a single $TrashCanDepositingBehavior.',
    );

    parent.add(_TrashCapacityTextComponent().._updateText(_capacity));
    parent.children
      ..register<_TrashCapacityTextComponent>()
      ..register<PlasticTrashCanSpriteAnimationComponent>();
  }

  /// Whether the [TrashCan] can deposit some of the [Player]'s trash.
  ///
  /// Returns `true` if the [TrashCan] has enough capacity and the [Player] has
  /// some trash to deposit, `false` otherwise.
  bool _canDeposit() {
    final hasTrash = bloc.state.inventory.items
        .where((item) => item == parent.trashType)
        .isNotEmpty;
    final hasCapacity = _capacity < _maximumCapacity;
    return hasTrash && hasCapacity;
  }

  /// Deposits trash into the [TrashCan].
  ///
  /// Does nothing if the [TrashCan] cannot deposit some trash.
  void deposit() {
    if (!_canDeposit()) return;

    _capacity++;
    bloc.add(GameDepositedTrashEvent(item: parent.trashType));

    parent.children
        .query<_TrashCapacityTextComponent>()
        .first
        ._updateText(_capacity);

    parent.children
        .query<PlasticTrashCanSpriteAnimationComponent>()
        .firstOrNull
        ?.open();
  }

  @override
  void onRemove() {
    parent.children
        .query<_TrashCapacityTextComponent>()
        .first
        .removeFromParent();
    super.onRemove();
  }
}

/// Displays the current capacity of the [TrashCan].
class _TrashCapacityTextComponent extends TextComponent
    with ParentIsA<TrashCan> {
  _TrashCapacityTextComponent();

  void _updateText(int capacity) {
    text = '$capacity/${TrashCanDepositingBehavior._maximumCapacity}';
  }
}
