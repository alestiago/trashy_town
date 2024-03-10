import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';

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
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox.square(
        dimension: 50,
        child: BlocSelector<GameBloc, GameState, TrashType?>(
          selector: (state) {
            if (state.inventory.items.length <= widget.index) {
              return null;
            }
            return state.inventory.items[widget.index];
          },
          builder: (context, type) {
            final child = Stack(
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: type == null ? 1 : 0.1,
                    child: Assets.images.display.slotEmpty.image(),
                  ),
                ),
                if (type != null)
                  Positioned.fill(
                    child: _FilledInventorySlot.fromType(
                      type,
                      animate: _previousType == null,
                    ),
                  ),
              ],
            );

            _previousType = type;
            return child;
          },
        ),
      ),
    );
  }
}

class _FilledInventorySlot extends StatefulWidget {
  _FilledInventorySlot._({
    required this.type,
    required this.spriteSheetData,
    required this.animate,
  }) {
    Flame.images.prefix = '';
  }

  factory _FilledInventorySlot.fromType(
    TrashType type, {
    bool animate = true,
  }) {
    final spriteSheetData = _spriteSheetsData[type]!;
    return _FilledInventorySlot._(
      type: type,
      spriteSheetData: spriteSheetData,
      animate: animate,
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

  final TrashType type;

  /// The data of the sprite sheet being used.
  ///
  /// This is derived from the sprite sheet image characterstics. Hence, if the
  /// sprite sheet is updated, this data should be updated as well.
  final _SpriteSheetData spriteSheetData;

  /// Whether the sprite should animate or not.
  final bool animate;

  @override
  State<_FilledInventorySlot> createState() => _FilledInventorySlotState();
}

class _FilledInventorySlotState extends State<_FilledInventorySlot> {
  Future<SpriteAnimation>? _animationFuture;
  SpriteAnimationTicker? _animationTicker;
  late bool _completed = widget.animate;

  @override
  void initState() {
    super.initState();

    if (_animationFuture == null) {
      _updateSpriteAnimation();
    }
  }

  void _updateSpriteAnimation() {
    final spriteAnimationData = _FilledInventorySlot
        ._spriteSheetsData[widget.type]!
        .toSpriteAnimationData();
    _animationFuture = SpriteAnimation.load(
      widget.spriteSheetData.asset,
      spriteAnimationData,
    );
    _animationTicker = null;
  }

  @override
  void didUpdateWidget(covariant _FilledInventorySlot oldWidget) {
    super.didUpdateWidget(oldWidget);

    final changedSpriteData = oldWidget.type != widget.type;
    if (changedSpriteData) {
      _updateSpriteAnimation();
    }
  }

  void _onFrame(int index) {
    final isLastFrame = index == widget.spriteSheetData.frames - 1;
    if (isLastFrame && !_completed) {
      _animationTicker!.paused = true;
      setState(() {
        if (_completed) return;
        _completed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpriteAnimation>(
      future: _animationFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final animation = snapshot.data!;
        final animationTicker =
            _animationTicker = animation.createTicker()..onFrame = _onFrame;

        if (!widget.animate) {
          animationTicker
            ..setToLast()
            ..paused = true;
        }

        return InternalSpriteAnimationWidget(
          animation: animation,
          playing: widget.animate,
          animationTicker: animationTicker,
        );
      },
    );
  }
}

/// {@template SpriteSheetData}
/// Object which contains meta data for a collection of sprites.
/// {@endtemplate}
class _SpriteSheetData extends Equatable {
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

  @override
  List<Object?> get props => [
        asset,
        size,
        frames,
        amountPerRow,
      ];
}
