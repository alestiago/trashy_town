import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({required AudioCache audioCache})
      : _audioCache = audioCache,
        super(const AudioState());

  // ignore: unused_field
  final AudioCache _audioCache;

  /// Plays an effect sound.
  ///
  /// If there are no players available, this method will do nothing.
  Future<void> playEffect(GameAudioData audioData) async {}

  Future<void> pauseEffect(GameAudioData audioData) async {}

  Future<void> resumeEffect(GameAudioData audioData) async {}

  Future<void> stopEffect(GameAudioData audioData) async {}

  Future<void> playBackgroundMusic(GameAudioData audioData) async {}

  Future<void> pauseBackgroundMusic() async {}

  Future<void> toggleVolume() async {}
}
