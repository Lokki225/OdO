import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum VoiceState { idle, listening, parsing, committing, committed }

class VoiceService {
  VoiceService({SpeechToText? stt, FlutterTts? tts})
      : _stt = stt ?? SpeechToText(),
        _tts = tts ?? FlutterTts();

  final SpeechToText _stt;
  final FlutterTts _tts;

  final _stateController = StreamController<VoiceState>.broadcast(sync: true);
  VoiceState _state = VoiceState.idle;
  Timer? _silenceTimer;
  String _transcript = '';

  Stream<VoiceState> get stateStream$ => _stateController.stream;
  VoiceState get state => _state;
  String get transcript => _transcript;

  void _emit(VoiceState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  Future<void> startListening() async {
    final available = await _stt.initialize();
    if (!available) return;

    _transcript = '';
    _emit(VoiceState.listening);

    await _stt.listen(
      onResult: (result) {
        _transcript = result.recognizedWords;
        if (result.finalResult) {
          _silenceTimer?.cancel();
          _emit(VoiceState.committing);
          _emit(VoiceState.committed);
        }
      },
      onSoundLevelChange: null,
    );

    _stt.statusListener = (status) {
      if (status == 'notListening' && _state == VoiceState.listening) {
        _silenceTimer = Timer(const Duration(milliseconds: 1500), () {
          if (_state == VoiceState.listening) {
            _emit(VoiceState.parsing);
          }
        });
      }
    };
  }

  void stopListening() {
    _stt.stop();
    _silenceTimer?.cancel();
    if (_state == VoiceState.listening) {
      _emit(VoiceState.parsing);
    }
  }

  void cancelListening() {
    _stt.cancel();
    _silenceTimer?.cancel();
    _transcript = '';
    _emit(VoiceState.idle);
  }

  Future<void> speak(String text) async {
    await _tts.setLanguage('fr-FR');
    await _tts.setSpeechRate(0.5);
    await _tts.speak(text);
  }

  @visibleForTesting
  void simulateTransition(VoiceState newState) => _emit(newState);

  void dispose() {
    _silenceTimer?.cancel();
    _stateController.close();
  }
}
