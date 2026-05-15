import 'package:odo/core/types/result.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

class OfflineStubAiProvider implements AiProvider {
  @override
  String get name => 'offline_stub';

  @override
  Future<Result<AiResponse>> sendContext(AiContextPayload payload) async =>
      Success(
        AiResponse(
          text: 'OdO offline stub response',
          timestamp: DateTime.now(),
        ),
      );

  @override
  Future<Result<Stream<String>>> streamResponse(
          AiContextPayload payload) async =>
      Success(Stream.value('OdO offline stub response'));
}
