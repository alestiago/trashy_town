import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({required AudioCache audioCache})
      : _effectPlayers =
            List.generate(5, (index) => AudioPlayer()..audioCache = audioCache),
        _backgroundMusic = Bgm(audioCache: audioCache),
        super(const AudioState());

  final List<AudioPlayer> _effectPlayers;

  final Bgm _backgroundMusic;

  Future<void> _changeVolume(double volume) async {
    await Future.wait(
      [
        ..._effectPlayers.map((player) => player.setVolume(volume)),
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
    final player = _effectPlayers.where(
      (player) => player.state != PlayerState.playing,
    );

    if (player.isEmpty) {
      return;
    }

    await player.first.play(
      audioData._source,
      volume: audioData._volume,
    );
  }

  Future<void> playBackgroundMusic(GameAudioData audioData) async {
    if (_backgroundMusic.isPlaying) {
      await _backgroundMusic.stop();
    }

    await _backgroundMusic.play(
      audioData._source.path,
      volume: audioData._volume,
    );
  }

  Future<void> pauseBackgroundMusic() async {
    if (_backgroundMusic.isPlaying) {
      await _backgroundMusic.pause();
    }
  }

  Future<void> toggleVolume() async {
    if (state.volume == 0) {
      return _changeVolume(1);
    }
    return _changeVolume(0);
  }

  @override
  Future<void> close() {
    for (final player in _effectPlayers) {
      player.dispose();
    }
    _backgroundMusic.dispose();
    return super.close();
  }
}
