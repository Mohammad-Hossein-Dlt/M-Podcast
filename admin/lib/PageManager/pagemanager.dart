import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum AudioSource { url, file }

class PageManager {
  var progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      total: Duration.zero,
      position: Duration.zero,
    ),
  );

  var buttonNotifier = ValueNotifier<AudioState>(AudioState.paused);
  ValueNotifier isLoaded = ValueNotifier(false);

  AudioPlayer player = AudioPlayer();
  String p = "";
  PageManager({required String? audioPath, required AudioSource source}) {
    if (audioPath != null && audioPath.isNotEmpty) {
      () async {
        p = audioPath;
        await _init(audioPath, source);
      }();
    } else {
      isLoaded.value = true;
    }
  }

  _init(String audioPath, AudioSource source) async {
    try {
      if (source == AudioSource.url) {
        await player.setSourceUrl(audioPath);
      }
      if (source == AudioSource.file) {
        print("erferf                ec             erferf");
        await player.setSourceDeviceFile(audioPath);
      }

      player.setReleaseMode(ReleaseMode.stop);
      player.setPlayerMode(PlayerMode.mediaPlayer);

      progressNotifier.value = ProgressBarState(
        total: (await player.getDuration())!,
        position: Duration.zero,
      );

      isLoaded.value = true;
    } catch (e) {
      print("erferf                ac             erferf");

      print(e);
    }

    player.onPositionChanged.listen((event) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        total: oldState.total,
        position: event,
      );
    });
    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.paused) {
        buttonNotifier.value = AudioState.paused;
      }
      if (event == PlayerState.playing) {
        buttonNotifier.value = AudioState.playing;
      }
    });
    player.onPlayerComplete.listen((event) {
      buttonNotifier.value = AudioState.paused;
    });
  }

  void play() async {
    player.resume();
  }

  void pause() {
    player.pause();
  }

  void stop() {
    player.stop();
  }

  Future dispose() async {
    player.dispose();
  }
}

class ProgressBarState {
  final Duration total;
  final Duration position;
  // final Duration buffered;
  ProgressBarState({
    required this.total,
    required this.position,
    // required this.buffered,
  });
}

enum AudioState { paused, playing }
