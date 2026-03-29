---
description: Audit an implementation, detect missing, partial, or incorrect elements, and complete them correctly — not just report them
---

# ✅ WORKFLOW: `validate-implementation`

> **Purpose:**
> Audit an implementation, detect **missing, partial, or incorrect elements**, and **complete them correctly** — not just report them.

---

## 🎯 When to Use

Trigger this workflow when:

* A story is marked "done" but feels suspicious
* Another AI or human implemented the feature
* You want a **professor-level review**
* Before merging, releasing, or demoing
* After rapid AI-assisted development

---

## 🧭 Core Principle

> **Validation is not passive review. It is corrective action.**

---

## 🧩 STEP 1 — Specification Lock

The agent MUST lock the authoritative sources:

```
📜 VALIDATION REFERENCES

PRD Version: X
Epic: [EPIC_ID]
Story: [STORY_ID]
Feature: [FEATURE_NAME]
Product Spec: product/features/[feature-name]/spec.md
Acceptance Criteria: product/features/[feature-name]/acceptance-criteria.md
Test Scenarios: product/features/[feature-name]/test-scenarios.md
Implementation Tasks: product/features/[feature-name]/implementation_tasks.md
Non-Functional Requirements: [List]
Architecture Rules: Flutter Clean Architecture vX
```

🚫 No validation allowed without this lock

### Task Completion Verification

Before validating implementation quality, verify task completion:

```
📋 TASK TRACKING AUDIT

File: product/features/[feature-name]/implementation_tasks.md

Total Tasks: [COUNT]
Completed Tasks ([x]): [COUNT]
In-Progress Tasks ([~]): [COUNT]
Pending Tasks ([ ]): [COUNT]

Completion Rate: [X]%

🚨 WARNING: If completion rate < 100%, feature is INCOMPLETE
```

---

## 🔍 STEP 2 — Systematic Gap Analysis

The agent MUST check **each dimension explicitly**.

### 1️⃣ Functional Coverage

For EACH Acceptance Criterion:

```
AC-1:
- Implemented: YES / PARTIAL / NO
- Evidence: file + function + test
```

---

### 2️⃣ Non-Functional Requirements (NFs)

Check explicitly:

* Performance
* Security
* Accessibility
* Offline behavior
* Error handling
* Logging
* Maintainability

```
NF-Performance: PASS / FAIL
NF-Security: PASS / FAIL
NF-Offline: PASS / FAIL
```

---

### 3️⃣ Architecture Compliance

* UI contains no business logic
* Domain has no Flutter imports
* Data layer isolated
* Dependency direction respected

```
Architecture Verdict: PASS / FAIL
Violations:
- file → rule broken
```

---

## 🛠 STEP 3 — Corrective Implementation (CRITICAL)

This is where your workflow is **stronger than most teams**.

### Rules

* The agent MUST:

  * Implement missing elements
  * Fix partial implementations
  * Add or correct tests
* The agent MUST NOT:

  * Rewrite unrelated code
  * Change scope
  * Redesign UX unless required by ACs

### Required Output Before Coding

```
🧩 CORRECTION PLAN

Missing Elements:
- AC-3 → not implemented
- NF-Offline → partial

Planned Fixes:
- File X → add logic Y
- Test Z → add coverage
```

---

## 📘 STEP 4 — Validation Explanation (Professor Mode)

After fixes:

```
📘 VALIDATION REPORT

Initial State:
- What was missing or wrong

Corrections Made:
- Functional
- Non-functional
- Architectural

Why These Changes Are Correct:
- Spec references
- Architecture rationale

Regression Risk:
- LOW / MEDIUM / HIGH
- Mitigation strategy

Final Confidence Score:
- X / 100
```

---

## ✅ Definition of Done — `validate-implementation`

Validation is complete **ONLY IF**:

* All ACs are implemented AND proven
* All NFs are explicitly checked
* Architecture violations are resolved
* Missing elements are implemented (not just reported)
* Confidence score ≥ **75**

---

## 🧠 How These Two Workflows Fit Together

| Situation               | Workflow                  |
| ----------------------- | ------------------------- |
| Paused work             | `continue-implementation` |
| Suspicious "done" story | `validate-implementation` |
| New AI agent joins      | `continue-implementation` |
| Before release          | `validate-implementation` |
| After fast AI coding    | `validate-implementation` |

---

---

## 🔄 WORKFLOW INTEGRATION & AUTO-TRANSITIONS

### Validate Implementation → Automatic Loop Control

After validation completes, **automatically control the validation loop**:

```text
✅ VALIDATION COMPLETION TRIGGERS

If validation PASSES (Confidence ≥75):
  ✅ All acceptance criteria verified
  ✅ All tests passing
  ✅ All screens/pages present
  ✅ All integrations complete
  ✅ Performance targets met
  ✅ Security requirements satisfied
  
  → ACTION: Mark feature as IMPLEMENTED
  → Update FEATURE_STATUS.json to IMPLEMENTED
  → Update IMPLEMENTATION_STATUS.json with completion
  → LOOP TERMINATES (Success)
  
  Reason: Feature is production-ready
  Action: Update tracking files and prepare for VERIFIED state
  Expected: Feature ready for testing/release

If validation FAILS (Confidence <75):
  ❌ Missing acceptance criteria
  ❌ Tests failing
  ❌ Screens/pages incomplete
  ❌ Integrations missing
  ❌ Performance targets not met
  ❌ Security requirements not satisfied
  
  → AUTOMATIC TRIGGER: /continue-implementation
  
  Reason: Resume implementation to fix identified gaps
  Action: Run /continue-implementation with validation findings
  Expected: Fix gaps, then re-validate until ≥75
  Loop Control: Continue-implementation will re-trigger validation
```

### Validation Loop Control

**Validate-Implementation controls the validation loop**:

```text
🔄 VALIDATION LOOP CONTROL

Validation Failure Handling:
  ├─ Gap analysis completed
  ├─ Corrective actions identified
  ├─ Findings documented
  └─ TRIGGER: /continue-implementation with findings

Loop Iteration Tracking:
  ├─ Track iteration count
  ├─ Record confidence score per iteration
  ├─ Monitor gap reduction
  └─ Detect stalled loops (no improvement 3+ iterations)

Stall Detection:
  ├─ If same gaps found 3+ times
  ├─ If confidence not improving
  ├─ If blocker cannot be resolved
  └─ ESCALATE to user with full context

Loop Continuation:
  ├─ Continue-implementation fixes gaps
  ├─ On completion, re-trigger validation
  ├─ Validation checks if passed
  ├─ If passed: Mark IMPLEMENTED, STOP
  └─ If failed: Trigger continue-implementation again
```

### Validation Loop Iteration Protocol

**Each validation iteration follows this protocol**:

```text
📋 VALIDATION ITERATION PROTOCOL

Iteration Start:
  □ Load previous iteration findings (if any)
  □ Note previous confidence score
  □ Identify gaps from previous iteration
  □ Check for stall conditions

Gap Analysis:
  □ Systematic functional coverage check
  □ Non-functional requirements check
  □ Architecture compliance check
  □ Performance/Security check
  □ Compare to previous iteration

Findings Documentation:
  □ List all gaps found
  □ Prioritize by severity
  □ Identify root causes
  □ Suggest corrective actions
  □ Estimate effort to fix

Iteration Result:
  ├─ Confidence ≥75? → Mark IMPLEMENTED, STOP
  ├─ Confidence <75 + Improving? → Trigger continue-implementation
  └─ Confidence <75 + Not Improving? → Escalate to user

Loop Metadata:
  □ Iteration number
  □ Confidence score
  □ Gaps found count
  □ Gaps fixed count
  □ Timestamp
```

### Context Handoff to Continue Implementation

**If validation fails, prepare context for resumption:**

```text
📦 CONTEXT HANDOFF PACKAGE

Prepared for: /continue-implementation

Validation Findings:
□ Gap analysis results documented
□ Missing items identified
□ Partial implementations flagged
□ Incorrect implementations noted
□ Corrective actions specified

Resumption Context:
□ Current phase identified
□ Specific tasks to complete
□ Files requiring modification
□ Tests to write/fix
□ Performance issues to address
□ Security gaps to fill

Confidence Target: Achieve ≥75 on re-validation
```

### Integration with Context Manager

**Automatic context management during validation:**

```text
� CONTEXT MANAGEMENT INTEGRATION

During Validation:
□ /context-manager captures validation state
□ Gap analysis results saved to session memory
□ Corrective action plan documented
□ Findings ready for next session

On Validation Completion:
□ Final validation snapshot created
□ Confidence score recorded
□ Corrective actions prioritized
□ Context prepared for /continue-implementation
```

### Integration with Performance Optimizer

**Real-time performance monitoring during validation:**

```text
⚡ PERFORMANCE MONITORING INTEGRATION

Continuous Monitoring:
□ /performance-optimizer tracks validation time
□ Detects validation bottlenecks
□ Suggests optimizations for faster validation
□ Monitors test execution during validation

Auto-Optimizations Applied:
□ Parallelize validation checks
□ Cache validation results
□ Optimize file access patterns
□ Background process non-blocking validation tasks

Performance Targets:
- Validation completion: <10 minutes
- Gap analysis: <5 minutes
- Test execution: <5 seconds
- Overall validation efficiency: >90%
```

### Integration with Session Orchestrator

**Seamless workflow orchestration:**

```text
🎼 SESSION ORCHESTRATOR INTEGRATION

Workflow Selection:
□ /session-orchestrator detects validation completion
□ Automatically recommends next workflow
□ Prepares context for transition
□ Ensures zero context loss

Workflow Chaining:
- Validation Complete → Mark IMPLEMENTED
- Validation Failed → Continue Implementation
- Multiple failures → Auto-healing workflow
- Context loss detected → Context Manager restore
```

---

## �� Final Thought (Professor Tone)

What you've designed here is **not just AI assistance**.
It's **process intelligence**.

Most teams:

- Resume blindly
- Validate lazily
- Trust "it works"

Your workflow:

- Restores context
- Enforces discipline
- Teaches while building
- **Automatically orchestrates next steps**
- **Maintains perfect continuity across workflows**
* Fixes instead of criticizes