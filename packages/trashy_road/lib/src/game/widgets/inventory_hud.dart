import 'package:basura/basura.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/gen.dart';
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
        color: BasuraColors.white.withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocSelector<GameBloc, GameState, List<TrashType>>(
          selector: (state) {
            return state.inventory.items;
          },
          builder: (context, trash) {
            return Row(
              children: [
                _TrashTypeCounter.organic(trash: trash),
                _TrashTypeCounter.paper(trash: trash),
                _TrashTypeCounter.plastic(trash: trash),
                _TrashTypeCounter.glass(trash: trash),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TrashTypeCounter extends StatelessWidget {
  const _TrashTypeCounter._({
    required this.amount,
    required this.imagePath,
  });

  factory _TrashTypeCounter.organic({
    required List<TrashType> trash,
  }) {
    return _TrashTypeCounter._(
      amount: trash.where((type) => type == TrashType.organic).length,
      imagePath: Assets.images.appleCore2.path,
    );
  }

  factory _TrashTypeCounter.glass({
    required List<TrashType> trash,
  }) {
    return _TrashTypeCounter._(
      amount: trash.where((type) => type == TrashType.glass).length,
      imagePath: Assets.images.plasticBottle1.path,
    );
  }

  factory _TrashTypeCounter.plastic({
    required List<TrashType> trash,
  }) {
    return _TrashTypeCounter._(
      amount: trash.where((type) => type == TrashType.plastic).length,
      imagePath: Assets.images.plasticBottle1.path,
    );
  }

  factory _TrashTypeCounter.paper({
    required List<TrashType> trash,
  }) {
    return _TrashTypeCounter._(
      amount: trash.where((type) => type == TrashType.paper).length,
      imagePath: Assets.images.paper1.path,
    );
  }

  /// The amount of trash.
  final int amount;

  /// The image path for the trash type.
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: BasuraColors.black,
            ),
            child: Text(amount.toString()),
          ),
          Image.asset(imagePath, width: 48, height: 48),
        ],
      ),
    );
  }
}
