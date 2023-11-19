import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Constants/colors.dart';
import 'package:user/UserProfile/settings_.dart';
import 'package:user/paths.dart';

enum AudioSource { url, file }

class PageManager {
  AudioPlayer player = AudioPlayer();
  String audioUrl = "";
  Directory audioDirectory = Directory("");
  ValueNotifier<ProgressBarState> progressNotifier =
      ValueNotifier<ProgressBarState>(
    ProgressBarState(
      total: Duration.zero,
      position: Duration.zero,
    ),
  );

  ValueNotifier<AudioState> buttonNotifier =
      ValueNotifier<AudioState>(AudioState.paused);

  ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);
  ValueNotifier<double> downloadProgress = ValueNotifier<double>(0.0);
  ValueNotifier<bool> onDownloading = ValueNotifier<bool>(false);
  ValueNotifier<bool> isDownloaded = ValueNotifier<bool>(false);

  String? fileName;
  String? documentName;
  Function()? playNext;

  final Dio _dio = Dio();
  CancelToken _cancelToken = CancelToken();
  PageManager({
    required this.fileName,
    required this.documentName,
    this.playNext,
  }) {
    if (fileName != null) {
      audioDirectory =
          Directory("${AppDataDirectory.tempDirectory().path}/$fileName");
      audioUrl = "https://mhdlt.ir/DocumentsData/$documentName/$fileName";
      _init();
    } else {
      isLoaded.value = true;
    }
  }

  _init() async {
    AudioSource source = AudioSource.url;
    if (await File(audioDirectory.path).exists()) {
      isDownloaded.value = true;
      source = AudioSource.file;
    } else {
      isDownloaded.value = false;
      source = AudioSource.url;
    }

    try {
      if (source == AudioSource.url) {
        await player.setSourceUrl(audioUrl);
      }
      if (source == AudioSource.file) {
        await player.setSourceDeviceFile(audioDirectory.path);
      }
      player.setReleaseMode(ReleaseMode.stop);
      player.setPlayerMode(PlayerMode.mediaPlayer);

      progressNotifier.value = ProgressBarState(
        total: (await player.getDuration())!,
        position: Duration.zero,
      );

      isLoaded.value = true;
    } catch (e) {}

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
      if (playNext != null && settingsData()!.autoPlyaNextAudio) {
        playNext!();
      } else {
        buttonNotifier.value = AudioState.paused;
      }
    });
  }

  Future<void> download() async {
    try {
      downloadProgress.value = 0.0;
      onDownloading.value = true;
      _cancelToken = CancelToken();

      await _dio.download(
        audioUrl,
        audioDirectory.path,
        onReceiveProgress: (count, total) {
          downloadProgress.value = count / total;
        },
        cancelToken: _cancelToken,
      );
      if (await audioDirectory.exists()) {
        await _init();
      }

      isDownloaded.value = true;
      onDownloading.value = false;
    } catch (e) {
      isDownloaded.value = false;
      onDownloading.value = false;
      if (!settingsData()!.autoDownload) {
        if (_cancelToken.isCancelled) {
          Fluttertoast.showToast(
            msg: "دانلود متوقف شد",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: black,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "خطایی رخ داد",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER_RIGHT,
            backgroundColor: red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  void cancelDownload() {
    try {
      _cancelToken.cancel();
      downloadProgress.value = 0.0;
      onDownloading.value = false;
      isDownloaded.value = false;
    } catch (e) {
      onDownloading.value = false;
      Fluttertoast.showToast(
        msg: "خطایی رخ داد",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> deleteAudio() async {
    File audioFile = File(audioDirectory.path);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }
    downloadProgress.value = 0.0;
    onDownloading.value = false;
    isDownloaded.value = false;
    _init();
  }

  void play() async {
    print(settingsData()!.autoDownload);
    if (settingsData()!.autoDownload) {
      if (!await File(audioDirectory.path).exists()) {
        download();
      }
    }
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

  Future<bool> playing() async {
    return player.state == PlayerState.playing ||
            player.state == PlayerState.paused
        ? true
        : false;
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
