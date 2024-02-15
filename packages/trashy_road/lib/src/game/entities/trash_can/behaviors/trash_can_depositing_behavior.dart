import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/bloc/game_bloc.dart';
import 'package:trashy_road/src/game/entities/entities.dart';

class TrashCanDepositingBehavior extends Behavior<TrashCan>
    with FlameBlocReader<GameBloc, GameState> {
  static const int _capacity = 3;
  int _currentTrash = 0;

  /// Updates the capacity text.
  void _updateCapacityText() =>
      parent.children.query().whereType<TextComponent>().first.text =
          '$_currentTrash/$_capacity';

  /// Deposits [Trash] into the [TrashCan].
  ///
  /// Returns `true` if the [Trash] was deposited, `false` otherwise.
  bool deposit() {
    // temporary implementation while the trash can does not have a type
    if (bloc.state.inventory.getTrash(parent.trashType) > 0 &&
        _currentTrash < _capacity) {
      _currentTrash++;
      _updateCapacityText();
      return true;
    }

    return false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _updateCapacityText();
  }
}
