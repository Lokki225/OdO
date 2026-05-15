import 'package:odo/core/types/result.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

class GroqAiProvider implements AiProvider {
  @override
  String get name => 'groq';

  @override
  Future<Result<AiResponse>> sendContext(AiContextPayload payload) async =>
      const Failure(AppError.aiUnavailable);

  @override
  Future<Result<Stream<String>>> streamResponse(
          AiContextPayload payload) async =>
      const Failure(AppError.aiUnavailable);
}
