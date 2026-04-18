# Story 5.8: AI Provider Swappability in Proactive System

Status: ready-for-dev

## Story

As a developer,
I want the proactive system to use the swappable AI provider,
So that I can test with different providers without changing feature code.

## Acceptance Criteria

**Given** the AiProvider abstraction from Epic 1
**When** the SuggestionEngine needs to call the AI (for pattern detection or reflection generation)
**Then** it uses the injected AiProvider from Riverpod
**And** the provider is selected via single constant in ai_constants.dart
**And** changing the constant swaps the provider without touching feature code
**And** offline state automatically uses OfflineProvider

## Tasks / Subtasks

- [ ] Task 1: Integrate AiProvider with SuggestionEngine (AC: 1-2)
  - [ ] Update SuggestionEngine to use AiProvider interface
  - [ ] Replace any direct AI calls with provider abstraction
  - [ ] Inject AiProvider via Riverpod dependency injection
  - [ ] Handle AI-enhanced suggestion logic

- [ ] Task 2: Implement Provider Selection Configuration (AC: 3)
  - [ ] Create/update ai_constants.dart with provider selection
  - [ ] Define single constant for provider switching
  - [ ] Document provider options and selection process
  - [ ] Ensure configuration is centralized

- [ ] Task 3: Add Offline Provider Integration (AC: 4)
  - [ ] Integrate ConnectivityService with provider selection
  - [ ] Automatic fallback to OfflineProvider when offline
  - [ ] Handle offline state gracefully in proactive system
  - [ ] Test offline behavior with suggestions

- [ ] Task 4: Update Pattern Detection for AI Integration (AC: 1)
  - [ ] Integrate AI provider with unanchored session pattern detection
  - [ ] Use AI for enhanced pattern analysis (optional)
  - [ ] Maintain local-first approach with AI enhancement
  - [ ] Handle AI failures gracefully in pattern detection

## Dev Notes

### Critical Architecture Requirements

**From Architecture - AI Provider Abstraction:**
- AiProvider abstract interface with swappable implementations
- Single constant in ai_constants.dart controls provider selection
- Offline state automatically uses OfflineProvider
- Feature code depends only on AiProvider, never concrete implementations

**From Architecture - Confirmed Decisions:**
- State Management: Riverpod - no alternatives
- AI Context: All context payload construction in AiService, never in UI widgets
- API Key Security: Via String.fromEnvironment, never in source code

### Project Structure Notes

**File Locations:**
```
lib/core/constants/
└── ai_constants.dart                # Provider selection configuration

lib/core/services/
└── ai_provider.dart                 # from Epic 1

lib/features/ai/domain/
├── suggestion_engine.dart           # Update for AI provider integration
└── pattern_detector.dart            # Update for AI enhancement

lib/features/ai/presentation/
└── ai_providers.dart                # Add provider selection logic
```

**Integration Points:**
- SuggestionEngine (Story 5.2) - integrate AiProvider
- Pattern detection (Epic 3) - optional AI enhancement
- Background task system - provider selection in background
- Offline fallback system - automatic OfflineProvider switching

### Technical Requirements

**Provider Configuration in ai_constants.dart:**
```dart
// core/constants/ai_constants.dart
enum AiProviderType { claude, gemini, groq, openai, offline }

class AiConfig {
  final AiProviderType provider;
  final String apiKey;
  final String model;
  final int maxTokens;
  final int contextMaxChars;

  const AiConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.maxTokens = 1024,
    this.contextMaxChars = 4000,
  });
}

// Provider Configurations
const claudeConfig = AiConfig(
  provider: AiProviderType.claude,
  apiKey: String.fromEnvironment('CLAUDE_API_KEY'),
  model: 'claude-sonnet-4-6',
);

const geminiConfig = AiConfig(
  provider: AiProviderType.gemini,
  apiKey: String.fromEnvironment('GEMINI_API_KEY'),
  model: 'gemini-1.5-flash',
);

const groqConfig = AiConfig(
  provider: AiProviderType.groq,
  apiKey: String.fromEnvironment('GROQ_API_KEY'),
  model: 'llama-3.1-8b-instant',
);

const openaiConfig = AiConfig(
  provider: AiProviderType.openai,
  apiKey: String.fromEnvironment('OPENAI_API_KEY'),
  model: 'gpt-4o-mini',
);

// SINGLE CONSTANT FOR PROVIDER SELECTION
// Change this line to switch providers across entire app
const AiConfig activeAiConfig = geminiConfig; // ← Change here to switch providers
```

**Riverpod Provider Wiring:**
```dart
// features/ai/presentation/ai_providers.dart
@riverpod
AiProvider aiProvider(AiProviderRef ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  
  // Automatic offline fallback
  if (!connectivityService.isOnline) {
    return OfflineProvider();
  }
  
  // Use active config from constants
  const config = activeAiConfig;
  
  return switch (config.provider) {
    AiProviderType.claude => ClaudeProvider(config),
    AiProviderType.gemini => GeminiProvider(config),
    AiProviderType.groq => GroqProvider(config),
    AiProviderType.openai => OpenAiProvider(config),
    AiProviderType.offline => OfflineProvider(),
  };
}

@riverpod
AiService aiService(AiServiceRef ref) {
  final provider = ref.watch(aiProviderProvider);
  return AiService(provider);
}
```

**SuggestionEngine AI Integration:**
```dart
class SuggestionEngine {
  final AgendaRepository agendaRepo;
  final PracticeRepository practiceRepo;
  final SuggestionRepository suggestionRepo;
  final AiService aiService; // NEW: AI integration

  SuggestionEngine({
    required this.agendaRepo,
    required this.practiceRepo,
    required this.suggestionRepo,
    required this.aiService,
  });

  Future<Suggestion?> generateSuggestion({
    DateTime? targetDate,
    Duration minSlotDuration = const Duration(minutes: 30),
  }) async {
    // 1. Run local slot detection and skill ranking (always works offline)
    final localSuggestion = await _generateLocalSuggestion(
      targetDate: targetDate,
      minSlotDuration: minSlotDuration,
    );
    
    if (localSuggestion == null) return null;
    
    // 2. Optional AI enhancement (only if online and AI available)
    final enhancedSuggestion = await _enhanceSuggestionWithAi(localSuggestion);
    
    return enhancedSuggestion ?? localSuggestion;
  }
  
  Future<Suggestion?> _generateLocalSuggestion({
    DateTime? targetDate,
    Duration minSlotDuration = const Duration(minutes: 30),
  }) async {
    // Existing local-first suggestion logic from Story 5.2
    // This always works, even offline
    
    // Get 48-hour agenda window
    final now = targetDate ?? DateTime.now();
    final windowEnd = now.add(Duration(hours: 48));
    final events = await agendaRepo.getEventsInRange(now, windowEnd);
    
    // Find free slots
    final freeSlots = freeSlotDetector.findFreeSlots(
      events: events,
      startTime: now,
      endTime: windowEnd,
      minDuration: minSlotDuration,
    );
    
    if (freeSlots.isEmpty) return null;
    
    // Get non-suppressed skills, ranked by idle duration
    final nonSuppressedSkillIds = await suggestionRepo.getNonSuppressedSkillIds();
    final skills = await practiceRepo.getSkillsByIds(nonSuppressedSkillIds);
    
    if (skills.isEmpty) return null;
    
    final rankedSkills = idleSkillRanker.rankSkillsByIdleDuration(skills);
    
    // Apply priority algorithm (longest idle, shortest slot, earliest time)
    return _applyPriorityAlgorithm(rankedSkills, freeSlots);
  }
  
  Future<Suggestion?> _enhanceSuggestionWithAi(Suggestion baseSuggestion) async {
    try {
      // Build context for AI enhancement
      final context = await _buildAiContext(baseSuggestion);
      
      // Ask AI to enhance or validate the suggestion
      final aiResponse = await aiService.enhanceSuggestion(
        suggestion: baseSuggestion,
        context: context,
      );
      
      // Parse AI response and apply enhancements
      return _parseAiEnhancement(baseSuggestion, aiResponse);
      
    } catch (e) {
      // AI enhancement failed - return original suggestion
      debugPrint('AI enhancement failed: $e');
      return baseSuggestion;
    }
  }
}
```

**Pattern Detection AI Enhancement:**
```dart
class PatternDetector {
  final AiService aiService;
  
  PatternDetector({required this.aiService});
  
  Future<PatternDetectionResult> detectPattern(
    List<PracticeSession> unanchoredSessions,
  ) async {
    // 1. Local pattern detection (always works)
    final localPattern = _detectLocalPattern(unanchoredSessions);
    
    // 2. Optional AI enhancement for complex patterns
    final aiEnhancedPattern = await _enhancePatternWithAi(
      unanchoredSessions, 
      localPattern,
    );
    
    return aiEnhancedPattern ?? localPattern;
  }
  
  PatternDetectionResult _detectLocalPattern(List<PracticeSession> sessions) {
    // Existing local pattern detection logic from Epic 3
    // 3 sessions, 90-minute window, 2+ different weeks
    
    if (sessions.length < 3) {
      return PatternDetectionResult.noPattern();
    }
    
    final times = sessions.map((s) => s.startedAt).toList();
    final timeOfDayMinutes = times.map((t) => t.hour * 60 + t.minute).toList();
    final spread = timeOfDayMinutes.reduce(math.max) - timeOfDayMinutes.reduce(math.min);
    final weeks = times.map((t) => _weekNumber(t)).toSet();
    
    if (spread <= 90 && weeks.length >= 2) {
      final suggestedTime = _calculateAverageTime(times);
      return PatternDetectionResult.patternFound(suggestedTime);
    }
    
    return PatternDetectionResult.noPattern();
  }
  
  Future<PatternDetectionResult?> _enhancePatternWithAi(
    List<PracticeSession> sessions,
    PatternDetectionResult localResult,
  ) async {
    if (localResult.hasPattern) {
      // Local detection already found pattern - no need for AI
      return localResult;
    }
    
    try {
      // Ask AI to analyze more complex patterns
      final aiAnalysis = await aiService.analyzeSessionPattern(sessions);
      return _parseAiPatternAnalysis(aiAnalysis);
    } catch (e) {
      // AI analysis failed - use local result
      return localResult;
    }
  }
}
```

**AiService Enhancement Methods:**
```dart
class AiService {
  final AiProvider provider;
  
  AiService(this.provider);
  
  Future<String> enhanceSuggestion({
    required Suggestion suggestion,
    required Map<String, dynamic> context,
  }) async {
    final systemPrompt = _buildSuggestionEnhancementPrompt();
    final userMessage = _buildSuggestionEnhancementMessage(suggestion, context);
    
    return await provider.complete(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      maxTokens: 512, // Shorter response for suggestions
    );
  }
  
  Future<String> analyzeSessionPattern(List<PracticeSession> sessions) async {
    final systemPrompt = _buildPatternAnalysisPrompt();
    final userMessage = _buildPatternAnalysisMessage(sessions);
    
    return await provider.complete(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      maxTokens: 256, // Short response for pattern analysis
    );
  }
  
  String _buildSuggestionEnhancementPrompt() {
    return """You are analyzing a practice suggestion for a productivity app.
The suggestion was generated locally based on free time slots and idle skills.
Your job is to validate the suggestion and optionally suggest improvements.
Keep responses concise and actionable. If the suggestion looks good, just say "APPROVED".
If you see an issue, suggest a brief improvement.""";
  }
}
```

### Offline Provider Integration

**Automatic Offline Switching:**
```dart
@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  late StreamSubscription<ConnectivityResult> _subscription;
  
  @override
  bool build() {
    final connectivity = Connectivity();
    
    // Listen to connectivity changes
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      state = result != ConnectivityResult.none;
    });
    
    return true; // Assume online initially
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@riverpod 
bool isOnline(IsOnlineRef ref) {
  return ref.watch(connectivityNotifierProvider);
}
```

**Offline Behavior in Proactive System:**
```dart
class OfflineProvider implements AiProvider {
  @override
  Future<String> complete({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 1024,
  }) async {
    // Return empty string for graceful degradation
    return '';
  }
}

// In SuggestionEngine
Future<Suggestion?> _enhanceSuggestionWithAi(Suggestion baseSuggestion) async {
  try {
    final aiResponse = await aiService.enhanceSuggestion(
      suggestion: baseSuggestion,
      context: context,
    );
    
    if (aiResponse.isEmpty) {
      // Offline provider or AI unavailable - use base suggestion
      return baseSuggestion;
    }
    
    return _parseAiEnhancement(baseSuggestion, aiResponse);
  } catch (e) {
    // Any error - gracefully fall back to base suggestion
    return baseSuggestion;
  }
}
```

### Testing Requirements

**Unit Tests:**
- Provider selection configuration parsing
- AiProvider interface implementation for all providers
- Offline provider behavior (returns empty strings)
- SuggestionEngine works with and without AI enhancement
- Provider switching via constant change

**Integration Tests:**
- End-to-end suggestion generation with different providers
- Automatic offline fallback when connectivity lost
- Background task works with different AI providers
- Pattern detection works with and without AI enhancement

**Manual Testing:**
- Change activeAiConfig constant, verify provider switches
- Disconnect network, confirm OfflineProvider activation
- Test different AI providers (Claude, Gemini, Groq, OpenAI)
- Verify suggestions work even when AI fails

### Error Handling Requirements

**AI Provider Failure Scenarios:**
1. **Invalid API key** - Log error, fall back to OfflineProvider
2. **API timeout** - Use base suggestion without AI enhancement
3. **Rate limiting** - Graceful degradation, retry on next suggestion
4. **Provider unavailable** - Automatic fallback to OfflineProvider
5. **Malformed response** - Use base suggestion, log for debugging

**Error Handling Implementation:**
```dart
@riverpod
AiProvider aiProvider(AiProviderRef ref) {
  final isOnline = ref.watch(isOnlineProvider);
  
  if (!isOnline) {
    return OfflineProvider();
  }
  
  try {
    const config = activeAiConfig;
    
    if (config.apiKey.isEmpty) {
      debugPrint('No API key configured, using offline provider');
      return OfflineProvider();
    }
    
    return _createProvider(config);
  } catch (e) {
    debugPrint('AI provider creation failed: $e');
    return OfflineProvider(); // Graceful fallback
  }
}
```

### Performance Requirements

**Provider Switching:**
- Should be instantaneous (constant change)
- No app restart required
- Riverpod handles provider lifecycle automatically
- Minimal memory overhead for provider abstractions

**AI Enhancement:**
- Must not slow down suggestion generation significantly
- Timeout protection for AI calls (3 seconds max)
- Local suggestion always available as fallback
- Background task performance unaffected by AI provider

### References

**Source Documents:**
- [Epics: Epic 5, Story 5.8] - Core requirements and acceptance criteria
- [Architecture: AI Provider Abstraction] - Provider interface and swapping mechanism
- [Architecture: Confirmed Decisions] - Riverpod and API key security requirements
- [Architecture: AI Provider Cost Analysis] - Provider selection rationale

**Dependencies:**
- Epic 1: AiProvider abstraction and base implementations
- Story 5.2: SuggestionEngine (integrate AI provider)
- Epic 3: Pattern detection (optional AI enhancement)
- ConnectivityService for offline detection

**External Dependencies:**
- Riverpod for dependency injection
- connectivity_plus for online/offline detection
- Individual AI provider packages (HTTP clients)

## Dev Agent Record

### Agent Model Used

TBD - Will be filled during implementation

### Debug Log References

TBD - Will be filled during implementation

### Completion Notes List

- [ ] Verify single constant provider switching works
- [ ] Test automatic offline fallback to OfflineProvider
- [ ] Confirm SuggestionEngine works with and without AI
- [ ] Test all AI provider implementations (Claude, Gemini, Groq, OpenAI)
- [ ] Verify error handling gracefully falls back to local suggestions
- [ ] Test background task works with different providers
- [ ] Confirm API key security via String.fromEnvironment
- [ ] Validate performance impact of AI enhancement is minimal

### File List

TBD - Will be filled during implementation
