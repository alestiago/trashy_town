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
        color: const Color(0xFFFFFFFF),
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
                TrashTypeCounter.organic(
                  trash: trash,
                ),
                TrashTypeCounter.paper(
                  trash: trash,
                ),
                TrashTypeCounter.plastic(
                  trash: trash,
                ),
                TrashTypeCounter.glass(
                  trash: trash,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TrashTypeCounter extends StatelessWidget {
  factory TrashTypeCounter.organic({
    required List<TrashType> trash,
  }) {
    return TrashTypeCounter._(
      trash: trash,
      iconPath: Assets.images.appleCore2.path,
      type: TrashType.organic,
      displayName: 'Organic',
    );
  }
  factory TrashTypeCounter.glass({
    required List<TrashType> trash,
  }) {
    return TrashTypeCounter._(
      trash: trash,
      iconPath: Assets.images.plasticBottle1.path,
      type: TrashType.glass,
      displayName: 'Glass',
    );
  }
  factory TrashTypeCounter.plastic({
    required List<TrashType> trash,
  }) {
    return TrashTypeCounter._(
      trash: trash,
      iconPath: Assets.images.plasticBottle1.path,
      type: TrashType.plastic,
      displayName: 'Plastic',
    );
  }
  factory TrashTypeCounter.paper({
    required List<TrashType> trash,
  }) {
    return TrashTypeCounter._(
      trash: trash,
      iconPath: Assets.images.paper1.path,
      type: TrashType.paper,
      displayName: 'Organic',
    );
  }
  const TrashTypeCounter._({
    required this.trash,
    required this.type,
    required this.displayName,
    required this.iconPath,
  });

  final List<TrashType> trash;
  final TrashType type;
  final String displayName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
            child: Text(
              '${trash.where((t) => t == type).length}',
            ),
          ),
          Image.asset(iconPath, width: 48, height: 48),
        ],
      ),
    );
  }
}
