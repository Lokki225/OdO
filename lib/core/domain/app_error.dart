enum AppError {
  aiUnavailable,
  databaseWriteFailed,
  suggestionSuppressed,
  contextPayloadTooLarge,
  voiceCaptureFailed,
  voiceParseAmbiguous,
  slotNoLongerAvailable,
  authFailed;

  String get message => switch (this) {
        AppError.aiUnavailable => 'AI service is unavailable',
        AppError.databaseWriteFailed => 'Database write failed',
        AppError.suggestionSuppressed => 'Suggestion is suppressed',
        AppError.contextPayloadTooLarge => 'Context payload too large',
        AppError.voiceCaptureFailed => 'Voice capture failed',
        AppError.voiceParseAmbiguous => 'Voice input was ambiguous',
        AppError.slotNoLongerAvailable => 'The suggested slot is no longer available',
        AppError.authFailed => 'Authentication failed',
      };
}
