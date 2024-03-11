import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({required AudioCache audioCache})
      : _backgroundMusic = Bgm(audioCache: audioCache),
        _audioCache = audioCache,
        super(const AudioState());

  late final Map<GameAudioData, AudioPlayer> _players = {
    GameSoundEffects.depositTrash1: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.depositTrash2: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.depositTrash3: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.depositTrash4: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.depositTrash5: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.hintingArrow: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.trashCollected: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.ratingStars0: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.ratingStars1: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.ratingStars2: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.ratingStars3: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.runningTime: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.gameOver: AudioPlayer()..audioCache = _audioCache,
    GameSoundEffects.stagePass: AudioPlayer()..audioCache = _audioCache,
  };

  late final Map<GameAudioData, Future<AudioPool>> _pools = {
    GameSoundEffects.step1: AudioPool.create(
      source: GameSoundEffects.step1.source,
      maxPlayers: 6,
      audioCache: _audioCache,
    ),
    GameSoundEffects.wrongBin: AudioPool.create(
      source: GameSoundEffects.wrongBin.source,
      maxPlayers: 3,
      audioCache: _audioCache,
    ),
  };

  final Bgm _backgroundMusic;

  final AudioCache _audioCache;

  Future<void> _changeVolume(double volume) async {
    await Future.wait(
      [
        _backgroundMusic.audioPlayer.setVolume(volume),
      ],
    );

    if (!isClosed) {
      emit(state.copyWith(volume: volume));
    }
  }

  /// Plays an effect sound.
  ///
  /// If there are no players available, this method will do nothing.
  Future<void> playEffect(GameAudioData audioData) async {
    final hasPlayer = _players.containsKey(audioData);
    if (hasPlayer) {
      final player = _players[audioData]!;
      if (player.state != PlayerState.playing) {
        await player.play(
          audioData.source,
          volume: audioData.volume,
          mode: PlayerMode.lowLatency,
        );
        return;
      }
    }

    final hasPool = _pools.containsKey(audioData);
    if (hasPool) {
      final pool = await _pools[audioData]!;
      await pool.start(volume: audioData.volume);
      return;
    }
  }

  Future<void> pauseEffect(GameAudioData audioData) async {
    final hasPlayer = _players.containsKey(audioData);
    if (hasPlayer) {
      final player = _players[audioData]!;
      if (player.state == PlayerState.playing) {
        await player.pause();
      }
    }
  }

  Future<void> resumeEffect(GameAudioData audioData) async {
    final hasPlayer = _players.containsKey(audioData);
    if (hasPlayer) {
      final player = _players[audioData]!;
      if (player.state == PlayerState.paused) {
        await player.resume();
      }
    }
  }

  Future<void> stopEffect(GameAudioData audioData) async {
    final hasPlayer = _players.containsKey(audioData);
    if (hasPlayer) {
      final player = _players[audioData]!;
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
    }
  }

  Future<void> playBackgroundMusic(GameAudioData audioData) async {
    // TODO(alestiago): Temporarily disabled the background music.
  }

  Future<void> pauseBackgroundMusic() async {
    // TODO(alestiago): Temporarily disabled the background music.
  }

  Future<void> toggleVolume() async {
    if (state.volume == 0) {
      return _changeVolume(1);
    }
    return _changeVolume(0);
  }

  @override
  Future<void> close() {
    _players.forEach((key, value) async {
      await value.dispose();
    });
    _pools.forEach((key, value) async {
      await (await value).dispose();
    });
    _backgroundMusic.dispose();
    return super.close();
  }
}
