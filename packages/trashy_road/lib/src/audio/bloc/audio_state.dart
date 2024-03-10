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

class GameAudioData {
  const GameAudioData._({
    required AssetSource source,
    required double volume,
  })  : _source = source,
        _volume = volume;

  GameAudioData.fromPath(
    String path, {
    required double volume,
  }) : this._(
          source: AssetSource(path),
          volume: volume,
        );

  final AssetSource _source;

  final double _volume;
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
    volume: 0.25,
  );

  static final depositTrash2 = GameAudioData.fromPath(
    Assets.audio.depositTrash2,
    volume: 0.25,
  );

  static final depositTrash3 = GameAudioData.fromPath(
    Assets.audio.depositTrash3,
    volume: 0.25,
  );

  static final depositTrash4 = GameAudioData.fromPath(
    Assets.audio.depositTrash4,
    volume: 0.25,
  );

  static final depositTrash5 = GameAudioData.fromPath(
    Assets.audio.depositTrash5,
    volume: 0.25,
  );

  static final hintingArrow = GameAudioData.fromPath(
    Assets.audio.hintingArrow,
    volume: 0.3,
  );

  static final plasticTrash = GameAudioData.fromPath(
    Assets.audio.plasticBottle,
    volume: 0.25,
  );

  static final ratingStars1 = GameAudioData.fromPath(
    Assets.audio.ratingStars1,
    volume: 0.25,
  );

  static final ratingStars2 = GameAudioData.fromPath(
    Assets.audio.ratingStars2,
    volume: 0.25,
  );

  static final ratingStars3 = GameAudioData.fromPath(
    Assets.audio.ratingStars3,
    volume: 0.25,
  );
}
