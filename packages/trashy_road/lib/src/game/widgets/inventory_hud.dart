import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template InventoryHud}
/// A widget that displays the current trash count.
/// {@endtemplate}
class InventoryHud extends StatelessWidget {
  /// {@macro InventoryHud}
  const InventoryHud({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        color: const Color(0xFFFFFFFF),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocSelector<GameBloc, GameState, int>(
          selector: (state) {
            return state.inventory.trash;
          },
          builder: (context, trash) {
            return DefaultTextStyle(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
              child: Text('Trash: $trash'),
            );
          },
        ),
      ),
    );
  }
}
