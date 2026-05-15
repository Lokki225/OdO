import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:odo/core/types/result.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

const _apiKey = String.fromEnvironment('AI_API_KEY');
const _model = 'claude-sonnet-4-6';
const _maxTokens = 1024;
const _endpoint = 'https://api.anthropic.com/v1/messages';

class ClaudeAiProvider implements AiProvider {
  ClaudeAiProvider({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  String get name => 'claude';

  @override
  Future<Result<AiResponse>> sendContext(AiContextPayload payload) async {
    try {
      final response = await _client.post(
        Uri.parse(_endpoint),
        headers: _headers,
        body: jsonEncode(_buildBody(payload, stream: false)),
      );

      if (response.statusCode != 200) {
        return const Failure(AppError.aiUnavailable);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final text =
          (decoded['content'] as List).first['text'] as String;

      return Success(AiResponse(text: text, timestamp: DateTime.now()));
    } on http.ClientException {
      return const Failure(AppError.aiUnavailable);
    } catch (_) {
      return const Failure(AppError.aiUnavailable);
    }
  }

  @override
  Future<Result<Stream<String>>> streamResponse(
      AiContextPayload payload) async {
    try {
      final request = http.Request('POST', Uri.parse(_endpoint))
        ..headers.addAll({..._headers, 'accept': 'text/event-stream'})
        ..body = jsonEncode(_buildBody(payload, stream: true));

      final streamed = await _client.send(request);

      if (streamed.statusCode != 200) {
        return const Failure(AppError.aiUnavailable);
      }

      final output = streamed.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .where((line) => line.startsWith('data: '))
          .map((line) => line.substring(6))
          .where((data) => data != '[DONE]')
          .map((data) {
        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['delta'] as Map<String, dynamic>?;
          return (delta?['text'] as String?) ?? '';
        } catch (_) {
          return '';
        }
      }).where((chunk) => chunk.isNotEmpty);

      return Success(output);
    } on http.ClientException {
      return const Failure(AppError.aiUnavailable);
    } catch (_) {
      return const Failure(AppError.aiUnavailable);
    }
  }

  static Map<String, String> get _headers => const {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      };

  Map<String, dynamic> _buildBody(
    AiContextPayload payload, {
    required bool stream,
  }) {
    final messages = <Map<String, String>>[
      if (payload.contextText.isNotEmpty)
        {'role': 'user', 'content': payload.contextText},
      for (final msg in payload.history)
        {'role': msg.role, 'content': msg.content},
      {'role': 'user', 'content': payload.userMessage},
    ];

    return {
      'model': _model,
      'max_tokens': _maxTokens,
      'stream': stream,
      'messages': messages,
    };
  }
}
