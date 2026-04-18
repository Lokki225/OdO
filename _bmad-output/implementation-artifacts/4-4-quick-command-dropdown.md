# Story 4.4: Quick-Command Dropdown

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a user,
I want to see quick-command suggestions when I open the chat,
So that I can interact with the AI without typing.

## Acceptance Criteria

**Given** the chat interface from Story 4.3
**When** the chat opens
**Then** quick-command suggestions appear below the state summary
**And** suggestions are context-aware (e.g., "When should I practice?", "Show my week")
**And** tapping a suggestion sends it as a message
**And** the AI responds to the command
**And** suggestions are generated locally (no API call)

## Tasks / Subtasks

- [ ] Task 1: Create QuickCommandGenerator (AC: Context-aware suggestions)
  - [ ] Build command generator that analyzes current context
  - [ ] Create template-based commands for common scenarios
  - [ ] Generate 3-4 relevant commands based on user state
  - [ ] Ensure commands are locally generated (no API calls)
- [ ] Task 2: Build quick command UI components (AC: Command display, tapping)
  - [ ] Create command chip/button components
  - [ ] Design horizontal scrollable command list
  - [ ] Add tap handling to send commands as messages
  - [ ] Integrate with chat message flow
- [ ] Task 3: Context analysis for command relevance (AC: Context-aware)
  - [ ] Analyze idle skills for practice-related commands
  - [ ] Check agenda state for scheduling commands
  - [ ] Consider time of day for relevant suggestions
  - [ ] Filter commands based on available data
- [ ] Task 4: Integration with chat flow (AC: AI responds to command)
  - [ ] Send selected commands through normal message flow
  - [ ] Ensure commands trigger appropriate AI responses
  - [ ] Handle command-specific response formatting
  - [ ] Maintain conversation context after commands

## Dev Notes

### Critical UX Patterns

**Conversation Starters (UX-DR6):** Quick commands act as conversation starters that lower activation energy to zero. The blank chat with a blinking cursor is intimidating, so these suggestions give users immediate ways to engage with the AI.

**Context-Aware Generation:** Commands are dynamically generated based on current user state. If Japanese hasn't been practiced in 5 days, suggest "When should I practice Japanese?". If calendar is busy, suggest "Show my free slots this week."

**Local Generation Only:** Commands are generated entirely on-device using the same context data that feeds the AI. No API calls are made to generate suggestions - this keeps the interface fast and works offline.

### Source Tree Components

**Primary Files to Create:**

```
features/ai/presentation/widgets/
├── quick_command_generator.dart    # Context analysis and command generation
├── quick_command_chip.dart         # Individual command button component
├── quick_command_list.dart         # Horizontal scrollable command list
└── quick_command_templates.dart    # Command templates and formatting
```

**Dependencies Required:**
- `features/ai/domain/context_builder.dart` (Story 4.1) - For context analysis
- Chat interface from Story 4.3 - For integration
- Current user state (agenda, practice data)

### Command Generation Strategy

**Template-Based Approach:**
Commands are generated from templates that fill in context-specific details:

```dart
class CommandTemplate {
  final String template;
  final String Function(ContextPayload) generator;
  final bool Function(ContextPayload) isRelevant;
  
  const CommandTemplate({
    required this.template,
    required this.generator, 
    required this.isRelevant,
  });
}
```

**Example Templates:**

```dart
final commandTemplates = [
  CommandTemplate(
    template: "When should I practice {skill}?",
    generator: (context) {
      final idleSkill = context.mostIdleSkill;
      return "When should I practice ${idleSkill.name}?";
    },
    isRelevant: (context) => context.hasIdleSkills,
  ),
  
  CommandTemplate(
    template: "Show my free slots {timeframe}",
    generator: (context) {
      final timeframe = context.hasEventsToday ? "this week" : "today";
      return "Show my free slots $timeframe";
    },
    isRelevant: (context) => context.hasAgendaData,
  ),
  
  CommandTemplate(
    template: "What's my longest streak?",
    generator: (context) => "What's my longest streak?",
    isRelevant: (context) => context.hasActiveSkills,
  ),
];
```

### Project Structure Notes

**Integration with Chat Interface:**
Quick commands appear in the chat sheet between the state summary and the message thread. They're part of the chat UI, not a separate component.

**Command Layout:**
```
[State Summary]
[Quick Command Chips - Horizontal Scroll]
[Chat Message Thread]
[Message Input]
```

### Context Analysis Patterns

**Relevance Scoring:**
Each command template has an `isRelevant` function that determines if it should appear based on current context:

```dart
bool _hasIdleSkills(ContextPayload context) {
  return context.skills.any((skill) => skill.daysSinceLastSession > 1);
}

bool _hasUpcomingEvents(ContextPayload context) {
  return context.agendaToday.isNotEmpty || context.agendaTomorrow.isNotEmpty;
}

bool _hasFreeTime(ContextPayload context) {
  return context.freeSlots.isNotEmpty;
}
```

**Command Prioritization:**
Generate 3-4 most relevant commands based on context urgency:
1. Most idle skill commands (highest urgency)
2. Free time/scheduling commands (medium urgency)
3. General inquiry commands (lowest urgency)

### Testing Standards Summary

**Unit Tests:**
- Command generation with various context states
- Relevance filtering accuracy
- Template rendering with different data
- Context analysis functions

**Widget Tests:**
- Quick command chips display correctly
- Horizontal scrolling works properly
- Tap handling sends correct messages
- Integration with chat message flow

**Test File Location:** `test/features/ai/presentation/widgets/quick_command_generator_test.dart`

### Technical Implementation Details

**Command Generation Flow:**
```dart
List<String> generateQuickCommands(ContextPayload context) {
  final relevantTemplates = commandTemplates
    .where((template) => template.isRelevant(context))
    .take(4) // Limit to 4 commands max
    .toList();
    
  return relevantTemplates
    .map((template) => template.generator(context))
    .toList();
}
```

**UI Component Structure:**
```dart
class QuickCommandList extends StatelessWidget {
  final List<String> commands;
  final Function(String) onCommandTapped;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: commands.length,
        itemBuilder: (context, index) {
          return QuickCommandChip(
            text: commands[index],
            onTap: () => onCommandTapped(commands[index]),
          );
        },
      ),
    );
  }
}
```

**Chat Integration:**
```dart
void _onCommandTapped(String command) {
  // Send command as regular chat message
  final message = ChatMessage(
    text: command,
    isUser: true,
    timestamp: DateTime.now(),
  );
  
  // Add to chat thread and send to AI
  _sendMessage(message);
}
```

### Command Categories

**Practice-Focused Commands:**
- "When should I practice [skill]?"
- "What's my longest idle skill?"
- "Plan a practice session"
- "Show my streak progress"

**Schedule-Focused Commands:**
- "Show my free slots today"
- "What's on my agenda this week?"
- "When's my next free hour?"
- "Plan my practice time"

**General Inquiry Commands:**
- "Give me a productivity tip"
- "What should I focus on?"
- "Review my recent progress"
- "Help me prioritize"

### Performance Considerations

**Local Generation Performance:**
Command generation happens locally on every chat open. Keep analysis lightweight to avoid UI lag. Context analysis should complete in <50ms.

**Memory Efficiency:**
Don't cache generated commands - regenerate based on current context each time. Context changes frequently enough that caching would be stale.

### References

- [UX Design: Quick Commands for Conversation Starters] (ux-design-specification.md#claude--chatgpt--always-accessible-input-with-conversation-starters)
- [UX Design: AI Chat Opening State] (ux-design-specification.md#ai-chat-opening-state)
- [Epic 4: AI Layer - Story 4.4] (epics.md#story-44-quick-command-dropdown)
- [Architecture: Local-First Proactive Logic] (architecture.md#local-proactive-logic)

### Epic Context & Dependencies

**This Story Enables:**
- Enhanced user engagement with AI chat interface
- Lower activation energy for AI interactions
- Context-aware assistance that feels intelligent

**Dependencies from Previous Work:**
- Story 4.1: ContextBuilder for context analysis
- Story 4.3: AI Chat Interface for integration
- Agenda and Practice data from Epics 2 and 3

**User Experience Impact:**
Quick commands transform the AI from a blank text field to an intelligent assistant that understands current context and offers relevant starting points for conversation.

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

### Completion Notes List

### File List
