import 'package:flutter_test/flutter_test.dart';
import 'package:odo/core/services/voice_service.dart';

// VoiceService state machine tests use simulateTransition() to drive
// state changes without requiring hardware STT/TTS plugin bindings.

void main() {
  late VoiceService service;

  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);
  setUp(() => service = VoiceService());
  tearDown(() => service.dispose());

  group('VoiceService state machine (AC4, AC8)', () {
    test('initial state is idle', () {
      expect(service.state, VoiceState.idle);
    });

    test('idle → listening', () async {
      final states = <VoiceState>[];
      service.stateStream$.listen(states.add);

      service.simulateTransition(VoiceState.listening);

      expect(service.state, VoiceState.listening);
      expect(states, [VoiceState.listening]);
    });

    test('listening → parsing (on silence)', () async {
      final states = <VoiceState>[];
      service.stateStream$.listen(states.add);

      service.simulateTransition(VoiceState.listening);
      service.simulateTransition(VoiceState.parsing);

      expect(service.state, VoiceState.parsing);
      expect(states, [VoiceState.listening, VoiceState.parsing]);
    });

    test('parsing → committed (on result)', () async {
      final states = <VoiceState>[];
      service.stateStream$.listen(states.add);

      service.simulateTransition(VoiceState.listening);
      service.simulateTransition(VoiceState.parsing);
      service.simulateTransition(VoiceState.committing);
      service.simulateTransition(VoiceState.committed);

      expect(service.state, VoiceState.committed);
      expect(
        states,
        [
          VoiceState.listening,
          VoiceState.parsing,
          VoiceState.committing,
          VoiceState.committed,
        ],
      );
    });

    test('any → idle on cancel (from listening)', () async {
      final states = <VoiceState>[];
      service.stateStream$.listen(states.add);

      service.simulateTransition(VoiceState.listening);
      service.simulateTransition(VoiceState.idle);

      expect(service.state, VoiceState.idle);
      expect(states.last, VoiceState.idle);
    });

    test('any → idle on cancel (from parsing)', () async {
      final states = <VoiceState>[];
      service.stateStream$.listen(states.add);

      service.simulateTransition(VoiceState.listening);
      service.simulateTransition(VoiceState.parsing);
      service.simulateTransition(VoiceState.idle);

      expect(service.state, VoiceState.idle);
      expect(states.last, VoiceState.idle);
    });

    test('cancelListening resets state to idle', () async {
      service.simulateTransition(VoiceState.listening);
      service.cancelListening();
      expect(service.state, VoiceState.idle);
    });

    test('stateStream emits to multiple listeners', () async {
      final l1 = <VoiceState>[];
      final l2 = <VoiceState>[];
      service.stateStream$.listen(l1.add);
      service.stateStream$.listen(l2.add);

      service.simulateTransition(VoiceState.listening);

      expect(l1, [VoiceState.listening]);
      expect(l2, [VoiceState.listening]);
    });
  });
}
