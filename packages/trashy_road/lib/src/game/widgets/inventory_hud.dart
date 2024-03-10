import 'dart:collection';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
// ignore: implementation_imports
import 'package:flame/src/widgets/animation_widget.dart';
// ignore: implementation_imports
import 'package:flame/src/widgets/sprite_widget.dart';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slotSize = Size.square(
                ((constraints.maxWidth - 50) / Inventory.size)
                    .clamp(10.0, 50.0),
              );

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  Inventory.size,
                  (index) => SizedBox.fromSize(
                    size: slotSize,
                    child: _InventorySlot(index: index),
                  ),
                ),
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

class _InventorySlot extends StatefulWidget {
  const _InventorySlot({required this.index});

  final int index;

  @override
  State<_InventorySlot> createState() => _InventorySlotState();
}

class _InventorySlotState extends State<_InventorySlot> {
  TrashType? _previousType;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, TrashType?>(
      selector: (state) {
        if (state.inventory.items.length <= widget.index) {
          return null;
        }
        return state.inventory.items[widget.index];
      },
      builder: (context, type) {
        print('previousType: $_previousType');
        print('type: $type');

        final child = Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox.square(
            dimension: 50,
            child: Stack(
              children: [
                const Positioned.fill(child: _EmptyInventorySlot()),
                if (type != null || _previousType != null)
                  Positioned.fill(
                    child: _FilledInventorySlot.fromType(
                      type ?? _previousType!,
                      animate: _previousType == null || type == null,
                      reverse: _previousType != null && type != _previousType,
                    ),
                  ),
              ],
            ),
          ),
        );

        _previousType = type;
        return child;
      },
    );
  }
}

class _EmptyInventorySlot extends StatelessWidget {
  const _EmptyInventorySlot();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xffff0000),
      child: SizedBox.square(dimension: 50),
    );
  }
}

class _FilledInventorySlot extends StatefulWidget {
  _FilledInventorySlot._({
    required this.spriteSheetData,
    required this.animate,
    required this.reversed,
  }) {
    Flame.images.prefix = '';
  }

  factory _FilledInventorySlot.fromType(
    TrashType type, {
    bool animate = true,
    bool reverse = false,
  }) {
    final spriteSheetData = _spriteSheetsData[type]!;
    return _FilledInventorySlot._(
      spriteSheetData: spriteSheetData,
      animate: animate,
      reversed: reverse,
    );
  }

  /// The sprite sheet data for each trash type.
  ///
  /// The [_SpriteSheetData] is derived from the actual sprite sheet image
  /// characterstics. Hence, if the sprite sheet is updated, this data should be
  /// updated as well.
  static final _spriteSheetsData = UnmodifiableMapView(
    <TrashType, _SpriteSheetData>{
      TrashType.organic: _SpriteSheetData(
        asset: Assets.images.display.slotAppleCore.path,
        frames: 23,
        amountPerRow: 6,
        size: const Size.square(458),
      ),
      TrashType.paper: _SpriteSheetData(
        asset: Assets.images.display.slotPaperBox.path,
        frames: 21,
        amountPerRow: 6,
        size: const Size.square(458),
      ),
      TrashType.plastic: _SpriteSheetData(
        asset: Assets.images.display.slotPlasticBottle.path,
        frames: 21,
        amountPerRow: 6,
        size: const Size.square(458),
      ),
    },
  );

  /// The data of the sprite sheet being used.
  ///
  /// This is derived from the sprite sheet image characterstics. Hence, if the
  /// sprite sheet is updated, this data should be updated as well.
  final _SpriteSheetData spriteSheetData;

  /// Whether the sprite should animate or not.
  final bool animate;

  /// Whether the animation should play in reverse.
  final bool reversed;

  @override
  State<_FilledInventorySlot> createState() => _FilledInventorySlotState();
}

class _FilledInventorySlotState extends State<_FilledInventorySlot> {
  late bool _completed = !widget.animate;

  @override
  void didUpdateWidget(covariant _FilledInventorySlot oldWidget) {
    super.didUpdateWidget(oldWidget);

    final changeDirection = widget.reversed != oldWidget.reversed;
    if (widget.animate && changeDirection) {
      _completed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_completed) {
      var spriteAnimationData = widget.spriteSheetData.toSpriteAnimationData();
      if (widget.reversed) {
        spriteAnimationData = spriteAnimationData.reverse();
      }

      return SpriteAnimationWidget.asset(
        path: widget.spriteSheetData.asset,
        data: spriteAnimationData,
        onComplete: () {
          if (_completed) return;
          setState(() => _completed = true);
        },
      );
    }

    if (_completed && !widget.reversed) {
      final lastFrameOffset =
          widget.spriteSheetData.getOffset(widget.spriteSheetData.frames - 1);

      return SpriteWidget.asset(
        path: widget.spriteSheetData.asset,
        srcPosition: Vector2(lastFrameOffset.dx, lastFrameOffset.dy),
        srcSize: Vector2(
          widget.spriteSheetData.size.width,
          widget.spriteSheetData.size.height,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// {@template SpriteSheetData}
/// Object which contains meta data for a collection of sprites.
/// {@endtemplate}
class _SpriteSheetData {
  /// {@macro SpriteSheetData}
  const _SpriteSheetData({
    required this.asset,
    required this.size,
    required this.frames,
    required this.amountPerRow,
  });

  /// The sprite sheet asset name.
  final String asset;

  /// The size an individual sprite within the sprite sheet, the texture size.
  final Size size;

  /// The number of frames within the sprite sheet.
  final int frames;

  /// The number of frames per row within the sprite sheet.
  final int amountPerRow;

  /// Number of seconds per frame.
  ///
  /// Defaults to 1 / 32.
  static const double stepTime = 1 / 32;

  SpriteAnimationData toSpriteAnimationData() {
    return SpriteAnimationData.sequenced(
      amount: frames,
      stepTime: stepTime,
      amountPerRow: amountPerRow,
      textureSize: Vector2(size.width, size.height),
      loop: false,
    );
  }

  Offset getOffset(int index) {
    final row = index ~/ amountPerRow;
    final column = index % amountPerRow;
    return Offset(
      column * size.width,
      row * size.height,
    );
  }
}

extension on SpriteAnimationData {
  /// Reverses the animation.
  SpriteAnimationData reverse() {
    return SpriteAnimationData(
      frames.reversed.toList(),
      loop: loop,
    );
  }
}
