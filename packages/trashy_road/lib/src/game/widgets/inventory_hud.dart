import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        image: DecorationImage(
          image: Assets.images.paperBackgroundRectThin.provider(),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: BlocSelector<GameBloc, GameState, List<TrashType>>(
          selector: (state) {
            return state.inventory.items;
          },
          builder: (context, trash) {
            final filledTrash = List<TrashType?>.from(trash)
              ..length = Inventory.size;

            return LayoutBuilder(
              builder: (context, constraints) {
                final slotSize =
                    ((constraints.maxWidth - 50) / filledTrash.length)
                        .clamp(10.0, 50.0);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final type in filledTrash)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox.square(
                          dimension: slotSize,
                          child: _InventorySlot.fromType(type),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _InventorySlot extends StatelessWidget {
  const _InventorySlot({
    required this.image,
  });

  factory _InventorySlot.fromType(TrashType? type) {
    switch (type) {
      case TrashType.organic:
        return _InventorySlot.appleCore();
      case TrashType.paper:
        return _InventorySlot.paperBox();
      case TrashType.plastic:
        return _InventorySlot.plasticBottle();

      case null:
        return _InventorySlot.empty();
    }
  }

  _InventorySlot.empty() : image = Assets.images.slotEmpty.image();

  _InventorySlot.appleCore() : image = Assets.images.slotAppleCore.image();

  _InventorySlot.paperBox() : image = Assets.images.slotPaperBox.image();

  _InventorySlot.plasticBottle()
      : image = Assets.images.slotPlasticBottle.image();

  final Image image;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: image,
    );
  }
}
