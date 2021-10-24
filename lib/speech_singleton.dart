import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class SpeechSingleton {
  static final SpeechSingleton _singleton = SpeechSingleton._internal();

  FlutterTts flutterTts;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  factory SpeechSingleton() {
    return _singleton;
  }

  SpeechSingleton._internal() {
    _initTts();
  }

  void _initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-Us");
    flutterTts.setVolume(1.0);
    //flutterTts.setVoice("en-us-x-sfg#male_1-local");

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
  }

  Future<dynamic> setVolume(newVolume) async => flutterTts.setVolume(newVolume);

  Future<dynamic> setSpeechRate(newRate) async =>
      flutterTts.setSpeechRate(newRate);

  Future<dynamic> setPitch(newPitch) async => flutterTts.setPitch(newPitch);

  void speak(sentence) async {
    await stop();
    if (sentence != null && sentence.isNotEmpty) {
      var result = await flutterTts.speak(sentence);
      if (result == 1) {
        ttsState = TtsState.playing;
      }
    }
  }

  void stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
    }
  }
}
