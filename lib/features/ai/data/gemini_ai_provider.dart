import 'package:odo/core/types/result.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

class GeminiAiProvider implements AiProvider {
  @override
  String get name => 'gemini';

  @override
  Future<Result<AiResponse>> sendContext(AiContextPayload payload) async =>
      const Failure(AppError.aiUnavailable);

  @override
  Future<Result<Stream<String>>> streamResponse(
          AiContextPayload payload) async =>
      const Failure(AppError.aiUnavailable);
}
