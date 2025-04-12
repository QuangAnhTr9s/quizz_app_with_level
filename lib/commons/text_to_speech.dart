import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  // Singleton instance
  static final TextToSpeech _instance = TextToSpeech._internal();

  // Factory constructor trả về instance đã tồn tại
  factory TextToSpeech() {
    return _instance;
  }

  // Internal constructor
  TextToSpeech._internal();

  bool _isInitialized = false; // để kiểm tra đã init hay chưa

  static FlutterTts flutterTts = FlutterTts();
  Map? _currentVoice;
  double _volume = 1.0;
  double _pitch = 1.0;
  double _rate = 0.5;
  String _language = "en-US";
  String localEng = "en-US";
  String localChina = "zh-CN";

  Future<void> initTTS() async {
    if (_isInitialized) return; // nếu đã init thì không làm lại

    try {
      flutterTts.setSharedInstance(true);
      flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.voicePrompt);
      await flutterTts.getVoices.then(
        (data) {
          try {
            List<Map> _voices = List<Map>.from(data);
            Map? tempVoice;
            for (var element in _voices) {
              if (element["locale"].toLowerCase().contains(localEng)) {
                _currentVoice = element;
                break;
              } else if (element["locale"].toLowerCase().contains('en')) {
                tempVoice ??= element;
              }
            }
            _currentVoice ??= tempVoice;
            // _voices = _voices
            //     .where((voice) =>
            //         voice["locale"].toLowerCase().contains(localEng) ||
            //         voice["locale"].toLowerCase().contains('en'))
            //     .toList();
            // _currentVoice = _voices.first;
            setVoice(_currentVoice);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      );
      await flutterTts.setLanguage(_language);

      await flutterTts.setSpeechRate(_rate);

      await flutterTts.setVolume(_volume);
      await flutterTts.setPitch(_pitch);
      _isInitialized = true; // đánh dấu đã init

      // _flutterTTS.setStartHandler(() {
      //   _debugPrint("Playing");
      // });
      //
      // _flutterTTS.setCompletionHandler(() {
      //     _debugPrint("Complete");
      // });
      //
      // _flutterTTS.setCancelHandler(() {
      //   setState(() {
      //     _debugPrint("Cancel");
      //   });
      // });
      //
      // _flutterTTS.setPauseHandler(() {
      //   _debugPrint("Paused");
      // });
      //
      // _flutterTTS.setContinueHandler(() {
      //   _debugPrint("Continued");
      // });
      //
      // _flutterTTS.setErrorHandler((msg) {
      //   _debugPrint("error: $msg");
      // });
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
    }
  }

  Future<void> setVoice(Map? voice) async {
    if (voice == null) return;
    flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  Future<void> speakText(String text) async {
    if (text.isEmpty) return;
    await stopSpeaking();
    await flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }
}
