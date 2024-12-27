import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();
  static Function? _onCompletionHandler;
  static String _currentText = '';
  // 初始化 TTS
  static Future<void> init() async {
    await _flutterTts.setLanguage("en-US"); // Set language to English
    await _flutterTts.setSpeechRate(0.5);   // 設定語速
    await _flutterTts.setVolume(1.0);       // 設定音量
    await _flutterTts.setPitch(1.0);        // 設定音調
  }

  static Future<void> setText(String text) async {
    if (text.isEmpty) return;
    _currentText = text;
  }

  // 說話功能
  static Future<void> play() async {
    if (_currentText.isEmpty) return;
    await _flutterTts.speak(_currentText);
  }

  // 停止說話
  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  // 暫停說話
  static Future<void> pause() async {
    await _flutterTts.pause();
  }

  // 設置播放完成的回調函數
  static void setCompletionHandler(Function handler) {
    _onCompletionHandler = handler;
    _flutterTts.setCompletionHandler(() {
      if (_onCompletionHandler != null) {
        _onCompletionHandler!();
      }
    });
  }
}