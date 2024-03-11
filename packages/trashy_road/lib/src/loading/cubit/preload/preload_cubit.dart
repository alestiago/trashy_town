import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/loading/loading.dart';

export 'image_provider_cache.dart';
export 'tiled_cache.dart';

part 'preload_state.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit({
    required this.images,
    required this.tiled,
    required this.audio,
    required this.imageProviderCache,
  }) : super(const PreloadState.initial());

  final Images images;

  final TiledCache tiled;

  final AudioCache audio;

  final ImageProviderCache imageProviderCache;

  /// Load items sequentially allows display of what is being loaded
  Future<void> loadSequentially() async {
    final displayImages =
        Assets.images.display.values.whereType<AssetGenImage>().toList();
    final spritePaths =
        Assets.images.sprites.values.map((image) => image.path).toList();

    final phases = [
      ...PreloadPhase.sliced(
        name: 'audio',
        items: Assets.audio.values,
        start: audio.loadAll,
      ),
      ...PreloadPhase.sliced(
        name: 'images',
        items: displayImages,
        start: imageProviderCache.loadAll,
      ),
      ...PreloadPhase.sliced(
        name: 'sprites',
        items: spritePaths,
        start: images.loadAll,
      ),
      ...PreloadPhase.sliced(
        name: 'maps',
        items: [
          Assets.tiles.map1,
          Assets.tiles.map2,
          Assets.tiles.map5,
          Assets.tiles.map6,
        ],
        start: tiled.loadAll,
      ),
    ];

    emit(state.copyWith(totalCount: phases.length));
    for (final phase in phases) {
      emit(state.copyWith(currentLabel: phase.label));
      // Throttle phases to take at least 1/5 seconds
      await Future.wait([
        Future.delayed(Duration.zero, phase.start),
        Future<void>.delayed(const Duration(milliseconds: 200)),
      ]);
      emit(state.copyWith(loadedCount: state.loadedCount + 1));
    }
  }
}

@immutable
class PreloadPhase {
  const PreloadPhase(this.label, this.start);

  final String label;
  final ValueGetter<Future<void>> start;

  static Iterable<PreloadPhase> sliced<T>({
    required String name,
    required Iterable<T> items,
    required Future<void> Function(List<T> items) start,
  }) {
    const sliceSize = 15;
    final slices = items.slices(sliceSize).toList();
    final phases = <PreloadPhase>[];
    for (var phaseIndex = 0; phaseIndex < slices.length; phaseIndex++) {
      final phase = slices[phaseIndex];
      phases.add(
        PreloadPhase(
          '$name ${phaseIndex + 1} of ${slices.length}',
          () => start(phase),
        ),
      );
    }
    return phases;
  }
}
