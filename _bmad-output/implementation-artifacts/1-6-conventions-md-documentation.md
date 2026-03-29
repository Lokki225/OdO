---
storyId: 1.6
storyKey: 1-6-conventions-md-documentation
epicId: 1
projectName: TooXTips
date: 2026-03-29
status: ready-for-dev
---

# Story 1.6: CONVENTIONS.md Documentation

## Story Statement

As a developer,
I want to document all architectural conventions and patterns in CONVENTIONS.md,
So that future code follows consistent patterns and decisions are transparent.

## Acceptance Criteria

**Given** all architectural decisions from the architecture document
**When** I create `CONVENTIONS.md` in project root
**Then** it documents database naming (snake_case), Riverpod provider naming, error handling patterns
**And** it specifies feature folder structure (data/domain/presentation)
**And** it lists import rules (domain imports nothing, data imports domain, presentation imports domain only)
**And** it documents AI payload limits (4000 char cap, 48hr agenda window)
**And** it specifies API key security (--dart-define only)
**And** it lists all confirmed architectural decisions (Riverpod, Drift, go_router, etc.)

## Technical Requirements

### File Location

Create `CONVENTIONS.md` in project root (`tooxips/CONVENTIONS.md`)

### Content Structure

The document should include:

1. **Project Overview**
   - Project name: TooXTips
   - Architecture: Offline-first Flutter app
   - State management: Riverpod with code-gen
   - Database: SQLite with Drift ORM
   - Navigation: go_router

2. **Folder Structure**
   - Feature-based organization
   - Three-layer architecture (data/domain/presentation)
   - Core utilities and services

3. **Database Conventions**
   - Table naming: PascalCase (Skills, Sessions, Events, Suggestions)
   - Column naming: snake_case in database, camelCase in Dart
   - Primary keys: `id` (auto-increment integer)
   - Foreign keys: `{tableName}Id` format
   - Timestamps: DateTime type (UTC+0)
   - Boolean flags: `is{Property}` format

4. **Riverpod Provider Naming**
   - Repository providers: `{feature}RepositoryProvider`
   - Notifier providers: `{feature}NotifierProvider`
   - Service providers: `{feature}ServiceProvider`
   - Async providers: return `Future<T>` or `AsyncValue<T>`
   - Use `@riverpod` annotation for code generation

5. **Feature Folder Structure**
   ```
   features/{feature}/
   ├── data/
   │   ├── {feature}_dao.dart
   │   └── {feature}_repository.dart
   ├── domain/
   │   ├── {feature}_entity.dart
   │   └── {feature}_service.dart
   └── presentation/
       ├── {feature}_slide.dart
       ├── {feature}_providers.dart
       └── widgets/
           └── {feature}_widget.dart
   ```

6. **Import Rules**
   - Domain layer: imports nothing (pure business logic)
   - Data layer: imports domain layer only
   - Presentation layer: imports domain layer only
   - Never import presentation from data or domain
   - Never import data from presentation

7. **Error Handling**
   - Use `AsyncValue<T>` at UI boundaries (Riverpod)
   - Use `Result<T>` in services for error handling
   - Handle errors gracefully (no crashes)
   - Log errors locally for debugging

8. **AI Integration**
   - AI payload hard cap: 4000 characters
   - Agenda window: 48 hours (today + next 48 hours)
   - Unanchored sessions window: 7 days
   - Skills included: all with streak/last_session
   - Suggestions included: last 3 with status
   - Context builder: truncate session history first, then extend agenda window

9. **API Key Security**
   - Never hardcode API keys in source code
   - Pass API keys via `--dart-define` at build time
   - Use `String.fromEnvironment()` to retrieve keys
   - Example: `String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '')`

10. **Naming Conventions**
    - Classes: PascalCase
    - Variables/functions: camelCase
    - Constants: camelCase (not UPPER_CASE)
    - Private members: prefix with underscore
    - Enum values: camelCase

11. **Testing**
    - Test structure mirrors lib structure
    - Unit tests for business logic
    - Integration tests for user flows
    - Use mockito for mocking dependencies

12. **Confirmed Architectural Decisions**
    - Riverpod for state management (code-gen syntax)
    - Drift for type-safe SQLite access
    - go_router for navigation with bottom sheets
    - flutter_local_notifications for notifications
    - workmanager for background tasks
    - connectivity_plus for offline detection
    - Two-layer color token system
    - Dark mode as default (light mode opt-in)
    - Offline-first with complete local storage
    - No analytics, no telemetry, no third-party SDKs

## Implementation Details

### File Structure

The CONVENTIONS.md file should be comprehensive and well-organized with:

- Clear headings and subheadings
- Code examples for each convention
- Rationale for each decision
- Links to relevant files/stories
- Quick reference sections

### Key Sections to Include

1. Quick Start Guide
2. Folder Structure Diagram
3. Naming Conventions Table
4. Import Rules Diagram
5. Provider Naming Examples
6. Database Schema Reference
7. Error Handling Patterns
8. API Integration Guidelines
9. Testing Guidelines
10. Deployment Checklist

### Verification Steps

1. Create `CONVENTIONS.md` in project root
2. Document all architectural decisions
3. Include code examples for each convention
4. Add folder structure diagrams
5. Add naming convention tables
6. Add import rules diagram
7. Review for completeness and clarity
8. Verify file is readable and well-formatted

## Success Criteria

- ✓ CONVENTIONS.md created in project root
- ✓ Database naming conventions documented
- ✓ Riverpod provider naming documented
- ✓ Feature folder structure specified
- ✓ Import rules clearly stated
- ✓ Error handling patterns documented
- ✓ AI payload limits documented (4000 char cap, 48hr window)
- ✓ API key security specified (--dart-define only)
- ✓ All architectural decisions listed
- ✓ Code examples provided for each convention
- ✓ File is comprehensive and well-organized
- ✓ Ready for team reference

## Dependencies

- Depends on: Story 1.1 (Project Setup)
- Blocks: None (reference document)

## Notes

- This document is the source of truth for architectural patterns
- Update CONVENTIONS.md when new patterns are established
- Reference this document when reviewing code
- Use this as onboarding guide for new team members
- Keep examples up-to-date with actual codebase
