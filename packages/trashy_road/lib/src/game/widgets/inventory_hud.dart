import 'package:flame/flame.dart';
import 'package:flame/game.dart';
// ignore: implementation_imports
import 'package:flame/src/widgets/animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Image;
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
    return PlayingHudTransition(
      slideTween: Tween<Offset>(
        begin: const Offset(0, 1.2),
        end: Offset.zero,
      ),
      child: _PaperBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                            child: type == null
                                ? const _EmptyInventorySlot()
                                : _InventorySlot.fromType(type),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PaperBackground extends StatelessWidget {
  const _PaperBackground({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.display.paperBackgroundRectThin.provider(),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}

class _EmptyInventorySlot extends StatelessWidget {
  const _EmptyInventorySlot();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: const SizedBox.square(dimension: 50),
    );
  }
}

class _InventorySlot extends StatelessWidget {
  const _InventorySlot({
    required this.imagePath,
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

  _InventorySlot.empty() : imagePath = Assets.images.display.slotEmpty.path;

  _InventorySlot.appleCore()
      : imagePath = Assets.images.display.slotAppleCore.path;

  _InventorySlot.paperBox()
      : imagePath = Assets.images.display.slotPaperBox.path;

  _InventorySlot.plasticBottle()
      : imagePath = Assets.images.display.slotPlasticBottle.path;

  final String imagePath;

  /// The data of the sprite sheet being used.
  ///
  /// This is derived from the sprite sheet image characterstics. Hence, if the
  /// sprite sheet is updated, this data should be updated as well.
  static final _spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 23,
    stepTime: 1 / 32,
    amountPerRow: 6,
    textureSize: Vector2.all(458),
    loop: false,
  );

  @override
  Widget build(BuildContext context) {
    Flame.images.prefix = '';
    return SpriteAnimationWidget.asset(
      path: imagePath,
      data: _spriteAnimationData,
    );
  }
}
