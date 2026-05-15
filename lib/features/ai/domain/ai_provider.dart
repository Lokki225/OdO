import 'package:flutter/foundation.dart';

import 'package:odo/core/types/result.dart';

@immutable
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String role;
  final String content;
  final DateTime timestamp;
}

@immutable
class AiContextPayload {
  const AiContextPayload({
    required this.contextText,
    required this.userMessage,
    required this.history,
  });

  final String contextText;
  final String userMessage;
  final List<ChatMessage> history;
}

@immutable
class AiResponse {
  const AiResponse({required this.text, required this.timestamp});

  final String text;
  final DateTime timestamp;
}

abstract class AiProvider {
  String get name;

  Future<Result<AiResponse>> sendContext(AiContextPayload payload);

  Future<Result<Stream<String>>> streamResponse(AiContextPayload payload);
}
