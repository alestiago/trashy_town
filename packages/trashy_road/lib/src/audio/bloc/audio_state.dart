part of 'audio_cubit.dart';

class AudioState extends Equatable {
  const AudioState({this.volume = 1});
  final double volume;

  AudioState copyWith({double? volume}) {
    return AudioState(volume: volume ?? this.volume);
  }

  @override
  List<Object> get props => [volume];
}

class GameAudioData extends Equatable {
  const GameAudioData._({
    required this.source,
    required this.volume,
    this.duration,
  });

  GameAudioData.fromPath(
    String path, {
    required double volume,
    Duration? duration,
  }) : this._(
          source: AssetSource(path),
          volume: volume,
          duration: duration,
        );

  final AssetSource source;

  final double volume;

  final Duration? duration;

  @override
  List<Object?> get props => [source, volume, duration];
}

abstract class GameBackgroundMusic {
  static final gameBackground = GameAudioData.fromPath(
    Assets.audio.backgroundMusic,
    volume: 0.2,
  );
}

abstract class GameSoundEffects {
  static final depositTrash1 = GameAudioData.fromPath(
    Assets.audio.depositTrash1,
    volume: 0.35,
  );

  static final depositTrash2 = GameAudioData.fromPath(
    Assets.audio.depositTrash2,
    volume: 0.35,
  );

  static final depositTrash3 = GameAudioData.fromPath(
    Assets.audio.depositTrash3,
    volume: 0.35,
  );

  static final depositTrash4 = GameAudioData.fromPath(
    Assets.audio.depositTrash4,
    volume: 0.35,
  );

  static final depositTrash5 = GameAudioData.fromPath(
    Assets.audio.depositTrash5,
    volume: 0.35,
  );

  static final hintingArrow = GameAudioData.fromPath(
    Assets.audio.hintingArrow,
    volume: 0.4,
  );

  static final trashCollected = GameAudioData.fromPath(
    Assets.audio.trashCollected,
    volume: 0.55,
  );

  static final ratingStars0 = GameAudioData.fromPath(
    Assets.audio.ratingStars0,
    volume: 0.35,
  );

  static final ratingStars1 = GameAudioData.fromPath(
    Assets.audio.ratingStars1,
    volume: 0.35,
  );

  static final ratingStars2 = GameAudioData.fromPath(
    Assets.audio.ratingStars2,
    volume: 0.35,
  );

  static final ratingStars3 = GameAudioData.fromPath(
    Assets.audio.ratingStars3,
    volume: 0.35,
  );

  static final wrongBin = GameAudioData.fromPath(
    Assets.audio.wrongBin,
    volume: 0.35,
    duration: const Duration(seconds: 1),
  );

  static final steps = GameAudioData.fromPath(
    Assets.audio.steps,
    volume: 0.12,
    duration: const Duration(milliseconds: 820),
  );

  static final runningTime = GameAudioData.fromPath(
    Assets.audio.runningTime,
    volume: 0.3,
  );
}
