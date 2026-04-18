# Story 3.8: Practice State Management with Riverpod

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want to manage Practice state with Riverpod providers,
So that UI widgets reactively update when skills and sessions change.

## Acceptance Criteria

**Given** PracticeRepository from Story 3.1
**When** I create `features/practice/presentation/practice_providers.dart`
**Then** `practiceRepositoryProvider` returns PracticeRepository
**And** `allSkillsProvider` returns all skills (async)
**And** `skillWithSessionsProvider(skillId)` returns skill with session history (async)
**And** `unanchoredSessionsProvider` returns unanchored sessions from last 7 days (async)
**And** `practiceNotifierProvider` provides StateNotifier for create/log actions
**And** all providers use @riverpod annotation

## Tasks / Subtasks

- [ ] Create base repository provider (AC: 1)
  - [ ] Create `features/practice/presentation/practice_providers.dart`
  - [ ] Implement `practiceRepositoryProvider` returning PracticeRepository instance
  - [ ] Setup proper dependency injection
- [ ] Create data providers (AC: 2-4)
  - [ ] Implement `allSkillsProvider` returning List<Skill> (async)
  - [ ] Implement `skillWithSessionsProvider(skillId)` with parameter (async)
  - [ ] Implement `unanchoredSessionsProvider` returning recent unanchored sessions (async)
  - [ ] Use @riverpod annotation for code generation
- [ ] Create action notifier (AC: 5)
  - [ ] Implement `PracticeNotifier` extending StateNotifier
  - [ ] Add methods: createSkill(), logSession(), deleteSkill()
  - [ ] Handle loading, success, and error states
  - [ ] Provide `practiceNotifierProvider` with @riverpod annotation
- [ ] Integrate with UI components (AC: 6)
  - [ ] Update practice_slide.dart to use providers
  - [ ] Update skill_card.dart to watch skill data changes
  - [ ] Update session_logging_sheet.dart to use notifier actions
  - [ ] Ensure reactive updates across all Practice UI

## Dev Notes

### Architecture Patterns and Constraints

- **State Management**: Riverpod with code generation (@riverpod annotation)
- **Provider Naming**: Repository/Notifier/Service suffix convention
- **Error Handling**: AsyncValue at UI boundaries, Result<T> in services
- **Reactive Updates**: Providers automatically notify dependents on data changes
- **Code Generation**: Uses riverpod_generator for type-safe providers

### Riverpod Provider Architecture

**Provider Hierarchy:**
1. **Repository Provider** - Base data access layer
2. **Data Providers** - Specific data queries (skills, sessions)
3. **Computed Providers** - Derived data (streaks, patterns)
4. **Notifier Provider** - State mutations and actions

**Naming Conventions** (from architecture.md):
- Repository providers: `*RepositoryProvider`
- Data providers: `*Provider` 
- Notifier providers: `*NotifierProvider`
- All use @riverpod annotation for code generation

### Provider Implementations

**Repository Provider:**
```dart
@riverpod
PracticeRepository practiceRepository(PracticeRepositoryRef ref) {
  return PracticeRepositoryImpl(/* dependencies */);
}
```

**Data Providers:**
```dart
@riverpod
Future<List<Skill>> allSkills(AllSkillsRef ref) async {
  final repository = ref.watch(practiceRepositoryProvider);
  return repository.getAllSkills();
}
```

**Parametrized Provider:**
```dart
@riverpod
Future<SkillWithSessions> skillWithSessions(
  SkillWithSessionsRef ref, 
  String skillId
) async {
  final repository = ref.watch(practiceRepositoryProvider);
  return repository.getSkillWithSessions(skillId);
}
```

### PracticeNotifier State Management

**StateNotifier Implementation:**
- Manages Practice module actions (create/log/delete)
- Uses AsyncValue for loading states
- Provides methods for UI to call
- Invalidates related providers on state changes

**Key Methods:**
- `createSkill(String name)` - Creates new skill, invalidates allSkillsProvider
- `logSession(String skillId, int minutes, String notes)` - Logs session, invalidates skill and session providers
- `deleteSkill(String skillId)` - Removes skill, invalidates allSkillsProvider

### Integration with Existing Stories

**Story Dependencies:**
- Story 3.1: Uses PracticeRepository interface and implementation
- Story 3.2: SkillCard widgets watch skill data providers
- Story 3.3: First launch sheet uses createSkill notifier method
- Story 3.4: Session logging sheet uses logSession notifier method
- Story 3.5: Streak data computed from session providers
- Story 3.6: Unanchored sessions provider for flagged sessions
- Story 3.7: Pattern detection uses unanchored session data

### Source Tree Components to Touch

- `features/practice/presentation/practice_providers.dart` (NEW)
- `features/practice/presentation/practice_slide.dart` (modify to use providers)
- `features/practice/presentation/widgets/skill_card.dart` (modify to watch data)
- `features/practice/presentation/widgets/session_logging_sheet.dart` (modify to use notifier)
- `features/practice/presentation/widgets/first_launch_sheet.dart` (modify to use notifier)

### Testing Standards Summary

- Unit tests for all providers with mock repository
- Test provider invalidation and dependencies
- Test AsyncValue states (loading, data, error)
- Test notifier actions and state changes
- Integration test: UI updates when providers change

### Project Structure Notes

Complete Practice feature structure:
```
features/practice/
├── data/
│   ├── practice_dao.dart           # Story 3.1
│   └── practice_repository.dart    # Story 3.1
├── domain/
│   ├── practice_repository.dart    # Story 3.1 interface
│   ├── streak_calculator.dart      # Story 3.5
│   ├── pattern_detector.dart       # Story 3.7
│   └── models/                     # Domain models
└── presentation/
    ├── practice_slide.dart         # Story 3.2
    ├── practice_providers.dart     # Story 3.8 (THIS STORY)
    └── widgets/
        ├── skill_card.dart         # Story 3.2
        ├── first_launch_sheet.dart # Story 3.3
        └── session_logging_sheet.dart # Story 3.4
```

### Code Generation Setup

**Dependencies Required:**
- `riverpod_annotation: ^2.3.5`
- `riverpod_generator: ^2.4.0`
- `build_runner: ^2.4.9`

**Build Command:**
```bash
dart run build_runner build
```

**Generated Files:**
- `practice_providers.g.dart` - Generated provider code
- Must be imported alongside manual provider file

### Error Handling Strategy

**AsyncValue Pattern:**
```dart
Consumer(
  builder: (context, ref, child) {
    final skillsAsync = ref.watch(allSkillsProvider);
    return skillsAsync.when(
      data: (skills) => SkillsList(skills),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  },
)
```

### Performance Considerations

**Provider Optimization:**
- Use provider families for parametrized data
- Implement provider caching where appropriate
- Minimize provider rebuilds with proper dependency watching
- Use provider.select() for granular UI updates

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.8: Practice State Management with Riverpod]
- [Source: _bmad-output/planning-artifacts/architecture.md#Riverpod provider naming conventions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Error handling with AsyncValue]
- [Source: All previous Practice module stories 3.1-3.7 for integration context]

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
