---
description: Safely resume development from the exact point it was stopped, without rework, drift, or loss of architectural context
---

# 🔁 WORKFLOW: `continue-implementation`

> **Purpose:**
> Safely resume development **from the exact point it was stopped**, without rework, drift, or loss of architectural context.
> **Phase-Based Implementation**: Work on ONE phase at a time, mark complete, update JSON files, then stop.

---

## 🎯 When to Use

Trigger this workflow when:

* Implementation was paused
* Context might be partially lost
* You are resuming work across sessions, days, or tools
* An AI agent is re-attached to an ongoing project
* You want **continuity without re-analysis from scratch**
* Continuing to next phase of a multi-phase feature

---

## 🧭 Core Principle

> **Never resume coding until the agent proves it understands the current state better than a human reviewer would.**
> **One Phase Per Run**: Complete one phase, update tracking, then stop. Next run picks up the next phase.

---

## 📄 STEP 0 — Detect Current Phase (MANDATORY)

The agent MUST determine which phase to work on before any implementation.

### Phase Detection Algorithm

1. **Scan for phase files** in `product/features/<feature-name>/`:
   - Look for: `implementation_tasks_phase1.md`, `implementation_tasks_phase2.md`, etc.
   - If no phase files exist, look for: `implementation_tasks.md` (single-phase feature)

2. **Determine current phase**:
   - Read each phase file in order (phase1, phase2, phase3, etc.)
   - Check task completion status:
     - `[x]` = Done
     - `[~]` = In Progress
     - `[ ]` = Pending
   - Current phase = First phase with `[ ]` (pending) or `[~]` (in-progress) tasks
   - If all tasks in a phase are `[x]`, that phase is complete

3. **Read IMPLEMENTATION_STATUS.json**:
   - File: `IMPLEMENTATION_STATUS.json`
   - Check: `currentWork.phaseCompleted` array
   - Verify consistency with phase file completion status

4. **Read FEATURE_STATUS.json**:
   - File: `product/FEATURE_STATUS.json`
   - Check feature state: Should be SPECIFIED or IMPLEMENTING
   - Verify feature is ready for implementation

### Required Output (Step 0)

The agent must explicitly state:

```text
📄 PHASE DETECTION

Feature: <feature-name>
Phase Files Found: [phase1.md, phase2.md, phase3.md, ...]

Phase 1: [COMPLETE | IN_PROGRESS | PENDING]
Phase 2: [COMPLETE | IN_PROGRESS | PENDING]
Phase 3: [COMPLETE | IN_PROGRESS | PENDING]
...

Current Phase to Implement: Phase X
Phase Status: [IN_PROGRESS | PENDING]
Phase File: product/features/<feature-name>/implementation_tasks_phaseX.md

Reason: [Phase X has Y pending tasks | Phase X is marked in-progress | All previous phases complete]
```

### Phase Decision Rules

* If **ALL phases complete** → Feature is DONE, update to IMPLEMENTED state
* If **current phase has in-progress tasks** → Resume that phase
* If **current phase has only pending tasks** → Start that phase
* If **previous phase incomplete** → ERROR: Cannot skip phases
* If **no phase files found** → Use single `implementation_tasks.md` file

---

## 🧩 STEP 1 — Context Rehydration (MANDATORY)

The agent MUST reconstruct the current state **before touching any code**.

### Required Inputs

1. **Read current phase implementation tasks**:
   - File: `product/features/<feature-name>/implementation_tasks_phase<N>.md` (or `implementation_tasks.md`)
   - Identify which tasks are checked off ([x])
   - Identify current in-progress task ([~])
   - Identify next pending task ([ ])

2. **Read Product Layer files** for context:
   - `product/features/<feature-name>/spec.md`
   - `product/features/<feature-name>/acceptance-criteria.md`
   - `product/features/<feature-name>/test-scenarios.md`

3. **Read FEATURE_STATUS.json** for feature state:
   - File: `product/FEATURE_STATUS.json`
   - Verify current feature state

4. **Read IMPLEMENTATION_STATUS.json** for global state:
   - File: `IMPLEMENTATION_STATUS.json`
   - Check current work status and confidence score

### Required Outputs

The agent must explicitly state:

```text
📌 CURRENT IMPLEMENTATION CONTEXT

Feature: [FEATURE_NAME]
Current Phase: Phase X - [Phase Name]
Phase Status: [IN_PROGRESS | PENDING]

📋 Task Progress (from implementation_tasks_phaseX.md):
- Completed Tasks: [COUNT] / [TOTAL] in this phase
- Last Completed Task: [Task description]
- Next Task: [Task description]
- Tasks Remaining in Phase: [COUNT]

Completed Acceptance Criteria (this phase):
- AC-1 
- AC-2 

Pending Acceptance Criteria (this phase):
- AC-3 
- AC-4 

Touched Layers (this phase):
- Presentation
- Domain
- Data

Modified Files (this phase):
- file_a.dart → reason
- file_b.dart → reason

Existing Tests (this phase):
- test_x.dart → covers AC-1
- test_y.dart → partial
```

 If any of this cannot be reconstructed → **STOP & ESCALATE**

---

## 🧠 STEP 2 — Integrity Check

Before continuing, the agent must verify:

### Integrity Questions (Must ALL be answered)

1. Is the current implementation **still aligned with the PRD**?
2. Are all completed ACs **fully covered by tests**?
3. Does any implemented code violate **Clean Architecture rules**?
4. Has any shortcut been taken under "temporary" assumptions?
5. Is there any **technical debt already introduced**?

### Required Output

```text
 INTEGRITY ASSESSMENT

Architectural Integrity: PASS / FAIL
Test Integrity: PASS / FAIL
Spec Alignment: PASS / FAIL
Technical Debt Introduced: YES / NO
If YES → describe and justify
```

 Any FAIL → must be resolved **before continuing**

---

## ▶️ STEP 3 — Controlled Phase Resumption

Only after Steps 1 & 2 pass:

### Phase Resumption Rules

* Resume **ONLY** on:
  * Tasks in the current phase file (implementation_tasks_phaseX.md)
  * The next uncompleted task in the phase (marked `[ ]` or `[~]`)
  * Do NOT jump to future phases or skip tasks within the phase
* Do **NOT**:
  * Refactor unrelated code
  * Improve aesthetics opportunistically
  * "Clean up" without scope approval
  * Work on tasks from other phases

### Allowed Actions (Current Phase Only)

* Implement missing logic for current phase tasks
* Extend tests for current phase acceptance criteria
* Complete UI strictly required by the current phase
* Mark tasks as `[x]` when fully complete
* Mark tasks as `[~]` when in-progress

---

## 📘 STEP 4 — Phase Completion Check

After implementing phase tasks, the agent MUST determine if the phase is complete.

### Phase Completion Criteria

A phase is considered **COMPLETE** when:

1. **All tasks marked `[x]`** in the phase file
2. **All acceptance criteria** for the phase are met
3. **All tests** for the phase are passing
4. **No blocking issues** remain

### Required Output

The agent must explicitly state:

```text
📘 PHASE COMPLETION STATUS

Phase: Phase X - [Phase Name]
Phase File: product/features/<feature-name>/implementation_tasks_phaseX.md

Task Completion:
- Total Tasks: [COUNT]
- Completed Tasks: [COUNT]
- In-Progress Tasks: [COUNT]
- Pending Tasks: [COUNT]

Phase Status: [COMPLETE | IN_PROGRESS | BLOCKED]

If COMPLETE:
- All tasks marked [x]
- All acceptance criteria met
- All tests passing
- Ready to proceed to next phase

If IN_PROGRESS:
- X tasks remaining
- Will resume in next run

If BLOCKED:
- Blocker: [Description]
- Requires: [User action needed]
```

### Phase Completion Actions

If phase is **COMPLETE**, agent MUST:

1. Update phase file: Mark all tasks as `[x]`
2. Update IMPLEMENTATION_STATUS.json: Add phase to `currentWork.phasesCompleted` array
3. Update FEATURE_STATUS.json: Update feature state if needed
4. Create phase completion summary
5. **STOP** - Do not proceed to next phase automatically

---

## 🧾 STEP 5 — Update Tracking Files (MANDATORY)

After completing phase work, the agent MUST update all tracking files.

### Update IMPLEMENTATION_STATUS.json

File: `IMPLEMENTATION_STATUS.json`

**If Phase Complete:**

```json
{
  "currentWork": {
    "feature": "<feature-name>",
    "status": "IMPLEMENTING",
    "currentPhase": <next-phase-number>,
    "phasesCompleted": [1, 2, 3, ...],
    "tasksCompleted": [
      "Phase X: Task description",
      ...
    ]
  },
  "confidenceMetrics": {
    "globalScore": <updated-score>
  }
}
```

**If Phase In-Progress:**

```json
{
  "currentWork": {
    "feature": "<feature-name>",
    "status": "IMPLEMENTING",
    "currentPhase": <current-phase-number>,
    "phasesCompleted": [1, 2, ...],
    "tasksCompleted": [
      "Phase X: Task description",
      ...
    ],
    "nextTask": "Phase X: Next task description"
  }
}
```

### Update FEATURE_STATUS.json

File: `product/FEATURE_STATUS.json`

**If ALL Phases Complete:**

```json
{
  "name": "<feature-name>",
  "state": "IMPLEMENTED",
  "lastUpdated": "<ISO-8601-timestamp>",
  "completionPercentage": 100
}
```

**If Some Phases Complete:**

```json
{
  "name": "<feature-name>",
  "state": "IMPLEMENTING",
  "lastUpdated": "<ISO-8601-timestamp>",
  "completionPercentage": <percentage>,
  "currentPhase": "Phase X"
}
```

### Update Phase File

File: `product/features/<feature-name>/implementation_tasks_phaseX.md`

* Mark completed tasks with `[x]`
* Mark in-progress tasks with `[~]`
* Leave pending tasks as `[ ]`
* Update any notes or blockers

### Required Output

The agent must explicitly state:

```text
🧾 TRACKING FILES UPDATED

Files Updated:
- IMPLEMENTATION_STATUS.json
  - currentPhase: Phase X
  - phasesCompleted: [1, 2, ...]
  - tasksCompleted: [COUNT] tasks

- FEATURE_STATUS.json
  - state: [IMPLEMENTING | IMPLEMENTED]
  - completionPercentage: [X]%

- implementation_tasks_phaseX.md
  - Marked [COUNT] tasks as complete
  - [COUNT] tasks remaining in phase
```

---

## 📊 STEP 6 — Phase Summary Report (MANDATORY)

The agent MUST provide a comprehensive summary before stopping.

### Required Output

The agent must explicitly state:

```text
📊 PHASE IMPLEMENTATION SUMMARY

Feature: <feature-name>
Phase: Phase X - [Phase Name]
Phase Status: [COMPLETE | IN_PROGRESS | BLOCKED]

Work Completed:
- Tasks Completed: [COUNT]
- Files Created: [COUNT]
- Files Modified: [COUNT]
- Tests Added: [COUNT]
- Acceptance Criteria Met: [COUNT]

Key Changes:
- <change 1>
- <change 2>
- <change 3>

Next Steps:
- If COMPLETE: Run `/continue-implementation` to start Phase X+1
- If IN_PROGRESS: Run `/continue-implementation` to continue Phase X
- If BLOCKED: [Describe required action]

Confidence Score:
- Previous: [X]
- Current: [Y]
- Change: [+/-Z]

Tracking Files Updated:
✅ IMPLEMENTATION_STATUS.json
✅ FEATURE_STATUS.json
✅ implementation_tasks_phaseX.md
```

---

## ✅ Definition of Done — `continue-implementation`

A continuation is considered valid **ONLY IF**:

* **Phase detected correctly** from phase files
* **Context was reconstructed explicitly** for the current phase
* **No assumptions were made silently**
* **Only current phase tasks were worked on** (no skipping ahead)
* **Phase file updated** with task completion status
* **IMPLEMENTATION_STATUS.json updated** with phase completion
* **FEATURE_STATUS.json updated** with feature state
* **Phase summary provided** before stopping
* **Agent STOPPED** after phase completion (did not continue to next phase)

---

## 🚫 CRITICAL RULE: One Phase Per Run

**The agent MUST STOP after completing or making progress on ONE phase.**

* ✅ Complete Phase 1 → Update files → STOP
* ✅ Work on Phase 2 (if Phase 1 done) → Update files → STOP
* ❌ Complete Phase 1 → Automatically start Phase 2 (FORBIDDEN)
* ❌ Work on multiple phases in one run (FORBIDDEN)

**Why:** This ensures:
* Clear phase boundaries
* Trackable progress
* User can review between phases
* Prevents scope creep

---

## 🔄 WORKFLOW INTEGRATION & AUTO-TRANSITIONS

### Continue Implementation → Automatic Loop Continuation

After completing gap fixes, **automatically re-trigger validation loop**:

```text
✅ GAP FIX COMPLETION TRIGGERS

If fixing validation gaps (from /validate-implementation):
  ✅ All identified gaps fixed
  ✅ All corrective actions completed
  ✅ All tests passing
  ✅ All changes committed
  ✅ IMPLEMENTATION_STATUS.json updated
  ✅ FEATURE_STATUS.json updated
  
  → AUTOMATIC TRIGGER: /validate-implementation (LOOP BACK)
  
  Reason: Re-validate to check if all gaps are fixed
  Action: Run /validate-implementation to audit fixes
  Expected: Confidence ≥75 (loop terminates) or new gaps found (loop continues)
  Loop Control: Validation will decide next step

If phase is COMPLETE (normal phase work):
  ✅ All phase tasks completed
  ✅ All tests passing for phase
  ✅ Phase file updated with [x] marks
  ✅ IMPLEMENTATION_STATUS.json updated
  ✅ FEATURE_STATUS.json updated
  
  → NEXT WORKFLOW: /session-orchestrator
  
  Reason: Intelligent workflow selection for next phase
  Action: Run /session-orchestrator to determine next step
  Expected: Either continue to next phase or trigger validation

If phase is IN_PROGRESS:
  ⚠️ Some phase tasks pending
  ⚠️ Some tests failing
  ⚠️ Some integrations incomplete
  
  → NEXT WORKFLOW: /context-manager
  
  Reason: Save session context and prepare for resumption
  Action: Run /context-manager to capture current state
  Expected: Perfect context restoration on next session

If phase is BLOCKED:
  🚫 Blocker encountered
  🚫 Cannot proceed without external action
  🚫 Requires user decision or dependency resolution
  
  → NEXT WORKFLOW: /auto-healing
  
  Reason: Attempt to resolve blocker automatically
  Action: Run /auto-healing to diagnose and fix issue
  Expected: Blocker resolved and phase can continue
```

### Validation Loop Continuation Protocol

**When fixing validation gaps, follow this protocol**:

```text
🔄 VALIDATION LOOP CONTINUATION

Input from Validate Implementation:
  □ Gap analysis results
  □ List of missing items
  □ List of incorrect implementations
  □ Corrective actions needed
  □ Previous confidence score
  □ Iteration number

Gap Fixing Process:
  □ Read all identified gaps
  □ Prioritize by severity
  □ Implement corrective actions
  □ Write tests for fixes
  □ Verify all fixes working
  □ Update all tracking files

Loop Continuation:
  □ All gaps fixed? → Re-trigger /validate-implementation
  □ Some gaps unfixable? → Document and escalate
  □ New gaps discovered? → Add to fix list and continue
  □ Blocker encountered? → Trigger /auto-healing

Re-validation Trigger:
  → AUTOMATIC: /validate-implementation
  
  With context:
  ├─ Iteration number (incremented)
  ├─ Gaps fixed count
  ├─ Changes made summary
  ├─ New test results
  └─ Ready for re-validation

Expected Outcome:
  ├─ Confidence ≥75? → Loop terminates (Mark IMPLEMENTED)
  ├─ Confidence <75 + Improving? → Loop continues (fix more gaps)
  └─ Confidence <75 + Not Improving? → Escalate to user
```

### Loop Iteration Tracking

**Track loop iterations to detect stalls**:

```text
📊 LOOP ITERATION TRACKING

Per Iteration Record:
  □ Iteration number
  □ Validation confidence score
  □ Gaps found count
  □ Gaps fixed count
  □ New gaps discovered
  □ Timestamp
  □ Changes made summary

Loop Health Metrics:
  □ Confidence trend (improving/stable/declining)
  □ Gap reduction rate
  □ Iteration duration
  □ Total loop time
  □ Stall detection (no improvement 3+ iterations)

Stall Escalation:
  ├─ If iteration 3+ with no improvement
  ├─ If same gaps found repeatedly
  ├─ If confidence declining
  └─ ESCALATE to user with full context:
     ├─ All iteration history
     ├─ Gap analysis
     ├─ Attempted fixes
     ├─ Recommendations
     └─ Await user decision
```

### Context Handoff to Next Workflow

**Before triggering next workflow, prepare context package:**

```text
📦 CONTEXT HANDOFF PACKAGE

Prepared for: /session-orchestrator or /context-manager

Phase Completion Status:
□ Phase number identified
□ All phase tasks listed
□ Completion status for each task
□ Test results captured
□ Performance metrics recorded

Session Context:
□ IMPLEMENTATION_STATUS.json updated
□ FEATURE_STATUS.json updated
□ Phase file updated with completion marks
□ Session memory saved with phase summary
□ Next phase identified (if applicable)

Handoff Quality:
□ Zero context loss
□ All changes committed
□ All tests passing
□ Performance targets met
□ Ready for next phase or validation
```

### Integration with Context Manager

**Automatic context management during phase work:**

```text
🧠 CONTEXT MANAGEMENT INTEGRATION

During Phase Work:
□ /context-manager auto-captures state every 5 minutes
□ Phase progress saved to session memory
□ Current blockers documented
□ Attempted solutions recorded
□ Mental model preserved

On Phase Completion:
□ Final phase snapshot created
□ Phase summary recorded
□ Performance metrics captured
□ Learnings documented
□ Context ready for next phase or validation
```

### Integration with Performance Optimizer

**Real-time performance monitoring during phase work:**

```text
⚡ PERFORMANCE MONITORING INTEGRATION

Continuous Monitoring:
□ /performance-optimizer tracks phase completion time
□ Detects bottlenecks in phase work
□ Suggests optimizations for faster completion
□ Monitors test execution times
□ Tracks context switching overhead

Auto-Optimizations Applied:
□ Pre-compile frequently used templates
□ Cache validation rules
□ Parallelize test execution
□ Optimize file access patterns
□ Background process non-blocking tasks

Performance Targets:
- Phase completion: <2 hours per phase
- Test execution: <5 seconds
- File access: <50ms
- Context switches: <10 seconds
```

### Integration with Session Orchestrator

**Seamless workflow orchestration on phase completion:**

```text
🎼 SESSION ORCHESTRATOR INTEGRATION

Workflow Selection:
□ /session-orchestrator detects phase completion
□ Analyzes feature state (all phases done? more phases?)
□ Automatically recommends next workflow
□ Prepares context for transition

Workflow Chaining:
- Phase Complete + More Phases → Continue next phase
- Phase Complete + All Phases Done → Validate Implementation
- Phase Blocked → Auto-healing workflow
- Context loss detected → Context Manager restore
- Multiple failures → Escalate to user
```

### Integration with Auto-Healing

**Automatic blocker resolution:**

```text
🔧 AUTO-HEALING INTEGRATION

Blocker Detection:
□ /auto-healing detects phase blockers
□ Analyzes blocker type (dependency, code, environment)
□ Attempts automatic resolution
□ Logs resolution attempts

Resolution Strategies:
- Missing dependency → Install/configure
- Code error → Diagnose and fix
- Environment issue → Reset/reconfigure
- External blocker → Escalate to user

Success Criteria:
- Blocker resolved → Resume phase work
- Blocker unresolvable → Escalate with context
```

---

## ✅ FINAL STATUS

This workflow is now:

- ✔ Compatible with **BMAD**
- ✔ Compatible with **Flutter Clean Architecture**
- ✔ Safe for **AI agents**
- ✔ Suitable for **long-lived products**
- ✔ Pedagogical by design
- ✔ Resistant to shortcutting
- ✔ **Integrated with Session Orchestrator**
- ✔ **Auto-triggers validation on completion**
- ✔ **Seamlessly hands off to Smart Implementation**
- ✔ **Leverages Context Manager for perfect continuity**
- ✔ **Optimized by Performance Optimizer**
- ✔ **Supported by Auto-Healing for blocker resolution**
- ✔ **One Phase Per Run enforced**
- ✔ **Ready for multi-phase feature development**
* Maintains confidence scoring accuracy