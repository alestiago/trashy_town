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
  });

  GameAudioData.fromPath(
    String path, {
    required double volume,
  }) : this._(
          source: AssetSource(path),
          volume: volume,
        );

  final AssetSource source;

  final double volume;

  @override
  List<Object?> get props => [source, volume];
}

abstract class GameBackgroundMusic {
  static final gameBackground = GameAudioData.fromPath(
    Assets.audio.backgroundMusic,
    volume: 0.18,
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
    volume: 0.45,
  );

  static final ratingStars2 = GameAudioData.fromPath(
    Assets.audio.ratingStars2,
    volume: 0.45,
  );

  static final ratingStars3 = GameAudioData.fromPath(
    Assets.audio.ratingStars3,
    volume: 0.45,
  );

  static final wrongBin = GameAudioData.fromPath(
    Assets.audio.wrongBin,
    volume: 0.35,
  );

  static final step1 = GameAudioData.fromPath(
    Assets.audio.step1,
    volume: 0.2,
  );

  static final runningTime = GameAudioData.fromPath(
    Assets.audio.runningTime,
    volume: 0.3,
  );

  static final gameOver = GameAudioData.fromPath(
    Assets.audio.gameOver,
    volume: 0.3,
  );

  static final stagePass = GameAudioData.fromPath(
    Assets.audio.stagePass,
    volume: 0.2,
  );
}
