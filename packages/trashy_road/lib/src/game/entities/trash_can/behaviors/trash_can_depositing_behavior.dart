import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/audio/audio.dart';
import 'package:trashy_road/src/game/game.dart';

final _random = math.Random(0);

class TrashCanDepositingBehavior extends Behavior<TrashCan>
    with
        FlameBlocReader<GameBloc, GameState>,
        HasGameReference<TrashyRoadGame> {
  /// The maximum amount of trash that the [TrashCan] can hold.
  static const int _maximumCapacity = 999;

  /// The sound effects that are played when trash is deposited into the
  /// [TrashCan].
  ///
  /// The sound effect is chosen randomly when trash is deposited.
  static final _depositSoundEffects = UnmodifiableSetView({
    GameSoundEffects.depositTrash1,
    GameSoundEffects.depositTrash2,
    GameSoundEffects.depositTrash3,
    GameSoundEffects.depositTrash4,
    GameSoundEffects.depositTrash5,
  });

  /// The current amount of trash that the [TrashCan] holds.
  int _capacity = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(
      !parent.hasBehavior<TrashCanDepositingBehavior>(),
      'The parent can only have a single $TrashCanDepositingBehavior.',
    );
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

    game.audioBloc.playEffect(
      _depositSoundEffects.elementAt(
        _random.nextInt(_depositSoundEffects.length),
      ),
    );

    _capacity++;
    bloc.add(GameDepositedTrashEvent(item: parent.trashType));
    parent.open();
  }
}
