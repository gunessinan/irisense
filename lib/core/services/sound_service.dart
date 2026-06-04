import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService { // speech to text en_US kullanıyor en-US değil!!!!
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isSpeechInitialized = false;
  String _language = "en-US";

  Future<void> init() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isSpeechInitialized = await _speechToText.initialize(
      onError: (val) => print('STT Error: $val'),
      onStatus: (val) => print('STT Status: $val'),
    );
  }

  void updateLanguage(String newLanguage) {
    _language = newLanguage;
  }

  Future<void> playBeep() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/beep_short.ogg'));
    } catch (e) {
      print("Beep Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    await _flutterTts.setLanguage(_language);
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<void> listenToSpeech({
    required Function(String) onResult,
  }) async {
    if (!_isSpeechInitialized) {
      await init();
    }

    if (_isSpeechInitialized) {

      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        localeId: _language,
        listenMode: ListenMode.dictation, 
        pauseFor: const Duration(seconds: 2),
        cancelOnError: true,
      );
    } else {
      print("Speech recognition not initialized.");
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
  
  bool get isListening => _speechToText.isListening;
}