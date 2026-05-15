import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/constants/ai_config.dart';
import 'package:odo/features/ai/data/claude_ai_provider.dart';
import 'package:odo/features/ai/data/gemini_ai_provider.dart';
import 'package:odo/features/ai/data/groq_ai_provider.dart';
import 'package:odo/features/ai/data/offline_stub_ai_provider.dart';
import 'package:odo/features/ai/data/openai_ai_provider.dart';
import 'package:odo/features/ai/domain/ai_provider.dart';

final aiProviderServiceProvider = Provider<AiProvider>((ref) {
  return switch (kActiveAiProvider) {
    'claude' => ClaudeAiProvider(),
    'gemini' => GeminiAiProvider(),
    'groq' => GroqAiProvider(),
    'openai' => OpenAiAiProvider(),
    'offline_stub' => OfflineStubAiProvider(),
    _ => OfflineStubAiProvider(),
  };
});
