import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
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
    final phases = [
      PreloadPhase(
        'audio',
        () => audio.loadAll(Assets.audio.values),
      ),
      PreloadPhase(
        'images',
        () => imageProviderCache.loadAll(
          [
            Assets.images.display.pauseIcon,
            Assets.images.display.paperBackground,
            Assets.images.display.replayIcon,
            Assets.images.display.playIcon,
            Assets.images.display.menuIcon,
            Assets.images.display.nextIcon,
          ],
        ),
      ),
      PreloadPhase(
        'game images',
        () => images.loadAll([]),
      ),
      PreloadPhase(
        'maps',
        () => tiled.loadAll(
          [
            Assets.tiles.map1,
            Assets.tiles.map2,
          ],
        ),
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
}
