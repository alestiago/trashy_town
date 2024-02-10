import 'dart:async';

import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template BehaviorSelector}
/// Selects a subset of behaviors from an entity.
///
/// Used by [PausingBehavior] to select which behaviors to remove when the game
/// is paused.
/// {@endtemplate}
typedef BehaviorSelector<T> = Iterable<Behavior> Function(T entity);

/// {@template PausingBehavior}
/// A behavior that pauses and resumes.
///
/// It operates by removing some behaviors from the entity when the game is
/// paused and adding them back when the game is resumed.
/// {@endtemplate}
class PausingBehavior<T extends EntityMixin> extends Behavior<T> {
  /// {@macro PausingBehavior}
  PausingBehavior({
    required BehaviorSelector<T> selector,
  }) : _selector = selector;

  /// {@macro BehaviorSelector}
  final BehaviorSelector<T> _selector;

  /// A collection of behaviors that were removed from the entity and are yet
  /// to be added back.
  final List<Behavior> _removedBehaviors = [];

  void _removeBehaviors() {
    final behaviours = _selector(parent);
    for (final behavior in behaviours) {
      behavior.removeFromParent();
    }
    _removedBehaviors.addAll(behaviours);
  }

  void _addBehaviors() {
    for (final behavior in _removedBehaviors) {
      parent.add(behavior);
    }
    _removedBehaviors.clear();
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await addAll([
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (previousState, newState) {
          return previousState.status == GameStatus.playing &&
              newState.status == GameStatus.paused;
        },
        onNewState: (_) => _removeBehaviors(),
      ),
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (previousState, newState) {
          return previousState.status == GameStatus.paused &&
              newState.status == GameStatus.playing;
        },
        onNewState: (_) => _addBehaviors(),
      ),
    ]);
  }
}
