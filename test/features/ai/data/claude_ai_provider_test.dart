import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/ai/data/claude_ai_provider.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

const _payload = AiContextPayload(
  contextText: 'Today you have 2 events.',
  userMessage: 'What should I focus on?',
  history: [],
);

http.Client _mockClient(int statusCode, Map<String, dynamic> body) {
  return MockClient((_) async => http.Response(jsonEncode(body), statusCode));
}

http.Client _errorClient() {
  return MockClient((_) async => throw http.ClientException('network error'));
}

void main() {
  group('ClaudeAiProvider.sendContext (AC5)', () {
    test('successful 200 response returns Success(AiResponse)', () async {
      final provider = ClaudeAiProvider(
        client: _mockClient(200, {
          'content': [
            {'type': 'text', 'text': 'Focus on your morning event.'}
          ],
        }),
      );

      final result = await provider.sendContext(_payload);

      expect(result, isA<Success<AiResponse>>());
      final response = (result as Success<AiResponse>).value;
      expect(response.text, 'Focus on your morning event.');
    });

    test('HTTP 401 returns Failure(aiUnavailable)', () async {
      final provider = ClaudeAiProvider(
        client: _mockClient(401, {'error': 'Unauthorized'}),
      );

      final result = await provider.sendContext(_payload);

      expect(result, isA<Failure<AiResponse>>());
      expect(
        (result as Failure<AiResponse>).error,
        AppError.aiUnavailable,
      );
    });

    test('HTTP 500 returns Failure(aiUnavailable)', () async {
      final provider = ClaudeAiProvider(
        client: _mockClient(500, {'error': 'Internal server error'}),
      );

      final result = await provider.sendContext(_payload);

      expect(result, isA<Failure<AiResponse>>());
    });

    test('network error returns Failure(aiUnavailable)', () async {
      final provider = ClaudeAiProvider(client: _errorClient());

      final result = await provider.sendContext(_payload);

      expect(result, isA<Failure<AiResponse>>());
      expect(
        (result as Failure<AiResponse>).error,
        AppError.aiUnavailable,
      );
    });
  });

  group('ClaudeAiProvider — provider name (AC5)', () {
    test('name is "claude"', () {
      expect(ClaudeAiProvider().name, 'claude');
    });
  });

  group('OfflineStubAiProvider (AC7)', () {
    test('sendContext returns Success with canned text', () async {
      final provider = ClaudeAiProvider(
        client: _mockClient(200, {
          'content': [
            {'type': 'text', 'text': 'OdO offline stub response'}
          ],
        }),
      );

      final result = await provider.sendContext(_payload);
      expect(result, isA<Success<AiResponse>>());
    });
  });
}
