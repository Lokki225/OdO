---
description: Complete guide to the automated validation loop that ensures implementations are valid before marking IMPLEMENTED
---

# 🔄 Automated Validation Loop Guide

## Overview

The BMAD system now includes an **automated validation loop** that ensures every feature implementation is valid before being marked as IMPLEMENTED. If validation finds gaps, the system automatically triggers fixes and re-validates until the implementation passes.

---

## 🎯 How It Works

### **The Loop Flow**

```
1. Smart Implementation Complete
   ↓
2. Trigger /validate-implementation
   ├─ Confidence ≥75? → Mark IMPLEMENTED ✅ (LOOP ENDS)
   └─ Confidence <75? → Continue to step 3
   ↓
3. Trigger /continue-implementation (with validation findings)
   ├─ Fix all identified gaps
   ├─ Complete missing items
   ├─ Correct incorrect implementations
   └─ Update tracking files
   ↓
4. Re-trigger /validate-implementation (LOOP BACK)
   ├─ Confidence ≥75? → Mark IMPLEMENTED ✅ (LOOP ENDS)
   └─ Confidence <75? → Loop back to step 3

Loop continues UNTIL validation passes or stall detected
```

---

## 📋 **Validation Loop Triggers**

### **Smart Implementation → Validate Implementation**

When smart-implementation completes:

```text
✅ COMPLETION CHECKLIST:
  □ All acceptance criteria implemented
  □ All tests passing (≥95% pass rate)
  □ All screens/pages created
  □ All integrations complete
  □ Performance targets met
  □ Security requirements satisfied

→ AUTOMATIC: Trigger /validate-implementation
```

### **Validate Implementation → Continue Implementation (if fails)**

When validation finds gaps:

```text
❌ VALIDATION FAILURE:
  □ Confidence <75
  □ Gaps identified
  □ Corrective actions documented

→ AUTOMATIC: Trigger /continue-implementation
   With: Gap analysis, findings, corrective actions
```

### **Continue Implementation → Validate Implementation (loop back)**

When gap fixes are complete:

```text
✅ GAPS FIXED:
  □ All identified gaps fixed
  □ All corrective actions completed
  □ All tests passing
  □ All changes committed

→ AUTOMATIC: Re-trigger /validate-implementation
   With: Iteration number, gaps fixed count, changes summary
```

---

## 🔍 **Validation Iteration Protocol**

Each validation iteration follows this protocol:

### **Iteration Start**
- Load previous iteration findings (if any)
- Note previous confidence score
- Identify gaps from previous iteration
- Check for stall conditions

### **Gap Analysis**
- Systematic functional coverage check
- Non-functional requirements check
- Architecture compliance check
- Performance/Security check
- Compare to previous iteration

### **Findings Documentation**
- List all gaps found
- Prioritize by severity
- Identify root causes
- Suggest corrective actions
- Estimate effort to fix

### **Iteration Result**
- **Confidence ≥75?** → Mark IMPLEMENTED, STOP ✅
- **Confidence <75 + Improving?** → Trigger continue-implementation
- **Confidence <75 + Not Improving?** → Escalate to user

### **Loop Metadata**
- Iteration number
- Confidence score
- Gaps found count
- Gaps fixed count
- Timestamp

---

## 📊 **Loop Iteration Tracking**

### **Per Iteration Record**

```json
{
  "iteration": 1,
  "confidence_score": 62,
  "gaps_found": 8,
  "gaps_fixed": 0,
  "new_gaps_discovered": 0,
  "timestamp": "2026-03-29T12:45:00Z",
  "changes_summary": "Initial validation"
}
```

### **Loop Health Metrics**

- **Confidence Trend**: improving/stable/declining
- **Gap Reduction Rate**: gaps fixed per iteration
- **Iteration Duration**: time per iteration
- **Total Loop Time**: cumulative time
- **Stall Detection**: no improvement 3+ iterations

---

## 🛑 **Stall Detection & Escalation**

The loop automatically escalates if it detects a stall:

### **Stall Conditions**

```text
❌ STALL DETECTED IF:
  ├─ Iteration 3+ with no improvement
  ├─ Same gaps found repeatedly
  ├─ Confidence declining
  └─ Blocker cannot be resolved
```

### **Escalation Process**

When a stall is detected:

```text
📤 ESCALATE TO USER:
  ├─ All iteration history
  ├─ Gap analysis
  ├─ Attempted fixes
  ├─ Recommendations
  └─ Await user decision before continuing
```

---

## 🔄 **Loop Continuation Protocol**

When continue-implementation fixes gaps:

### **Input from Validate Implementation**

- Gap analysis results
- List of missing items
- List of incorrect implementations
- Corrective actions needed
- Previous confidence score
- Iteration number

### **Gap Fixing Process**

```text
1. Read all identified gaps
2. Prioritize by severity
3. Implement corrective actions
4. Write tests for fixes
5. Verify all fixes working
6. Update all tracking files
7. Re-trigger /validate-implementation
```

### **Re-validation Trigger**

After fixes are complete:

```text
→ AUTOMATIC: /validate-implementation

With context:
  ├─ Iteration number (incremented)
  ├─ Gaps fixed count
  ├─ Changes made summary
  ├─ New test results
  └─ Ready for re-validation
```

---

## ✅ **Loop Termination Conditions**

### **Successful Termination**

```text
✅ LOOP ENDS WHEN:
  ✅ Validation passes (Confidence ≥75)
  ✅ All acceptance criteria verified
  ✅ All tests passing
  ✅ All screens/pages present
  ✅ All integrations complete
  ✅ Performance targets met
  ✅ Security requirements satisfied
  ✅ Feature marked as IMPLEMENTED
  ✅ Ready for VERIFIED state
```

### **Escalation Termination**

```text
❌ LOOP ESCALATES WHEN:
  ❌ Same gap found 3+ iterations
  ❌ Confidence not improving
  ❌ Blocker cannot be resolved
  ❌ External dependency missing
  → Escalate to user with full context
  → Provide detailed findings and recommendations
  → Await user decision before continuing
```

---

## 🎼 **Workflow Orchestration**

### **Smart Implementation**
- On completion: Trigger /validate-implementation
- Pass context package with implementation details

### **Validate Implementation**
- If PASSES (≥75): Mark IMPLEMENTED, STOP
- If FAILS (<75): Trigger /continue-implementation with findings
- Track iteration number and confidence scores

### **Continue Implementation**
- Fix all identified gaps
- On completion: Re-trigger /validate-implementation
- Increment iteration number

### **Session Orchestrator**
- Detects validation failure
- Prepares context for continue-implementation
- Ensures seamless loop continuation
- Monitors loop progress

### **Context Manager**
- Captures state at each loop iteration
- Preserves gap analysis results
- Maintains loop context
- Enables perfect resumption if interrupted

### **Performance Optimizer**
- Tracks total loop time
- Detects loop inefficiencies
- Suggests optimizations
- Monitors iteration times

---

## 📈 **Example Loop Execution**

### **Scenario: Feature with 3 Validation Iterations**

```
ITERATION 1:
  Smart Implementation completes
  ↓
  Validate Implementation runs
  Gaps found: 8 (missing screens, incomplete tests)
  Confidence: 62
  → Trigger Continue Implementation

ITERATION 2:
  Continue Implementation fixes gaps
  ↓
  Validate Implementation runs
  Gaps found: 3 (performance issues, security gaps)
  Confidence: 78 ✅
  → Mark IMPLEMENTED
  → LOOP ENDS (Success)
```

### **Scenario: Feature with Stall Detection**

```
ITERATION 1:
  Validate Implementation runs
  Gaps found: 5
  Confidence: 65
  → Trigger Continue Implementation

ITERATION 2:
  Continue Implementation fixes gaps
  Gaps found: 4 (same + 1 new)
  Confidence: 68
  → Trigger Continue Implementation

ITERATION 3:
  Continue Implementation fixes gaps
  Gaps found: 4 (same gaps, no progress)
  Confidence: 68 (no improvement)
  → STALL DETECTED
  → ESCALATE to user with full context
```

---

## 🛡️ **Loop Safety Guarantees**

### **Quality Assurance**

- ✅ **No shortcuts**: Every gap must be fixed
- ✅ **Validation required**: Cannot mark IMPLEMENTED without passing validation
- ✅ **Stall detection**: Prevents infinite loops
- ✅ **Full context**: Every escalation includes complete history
- ✅ **Automatic tracking**: All iterations recorded and tracked

### **User Control**

- ✅ **Escalation on stall**: User notified and asked to decide
- ✅ **Full visibility**: Complete iteration history available
- ✅ **Recommendations**: Suggestions provided for next steps
- ✅ **Manual override**: User can intervene at any time

---

## 📊 **Loop Metrics & Monitoring**

### **Key Metrics**

```text
Per Feature:
  □ Total iterations
  □ Total loop time
  □ Average iteration time
  □ Confidence progression
  □ Gap reduction rate
  □ Stall occurrences

Per Iteration:
  □ Iteration number
  □ Confidence score
  □ Gaps found/fixed
  □ Duration
  □ Changes made
```

### **Performance Targets**

```text
Loop Efficiency:
  □ Most features: 1-2 iterations
  □ Complex features: 2-3 iterations
  □ Stall detection: iteration 3+
  □ Total loop time: <2 hours for most features
```

---

## 🚀 **Benefits of Automated Validation Loop**

### **For Developers**
- 🎯 **Guaranteed Quality** - Features cannot be incomplete
- 🔄 **Automatic Fixes** - Gaps are automatically fixed
- 📊 **Full Visibility** - Complete iteration history
- ⏱️ **Time Saved** - No manual validation needed

### **For AI Agents**
- 🧠 **Clear Objectives** - Loop until validation passes
- 📋 **Structured Process** - Defined iteration protocol
- 🛡️ **Safety Guardrails** - Stall detection prevents infinite loops
- 📈 **Progress Tracking** - Metrics show improvement

### **For Project Success**
- ✅ **Quality Guarantee** - All implementations validated
- 📈 **Continuous Improvement** - Gaps fixed automatically
- 🔒 **No Shortcuts** - Anti-simplification enforced
- 📊 **Complete Traceability** - All iterations tracked

---

## ✨ **The Validation Loop Ensures**

**Every feature implementation is:**
- ✅ **Complete** - All acceptance criteria implemented
- ✅ **Correct** - All implementations match specifications
- ✅ **Tested** - All tests passing (≥95% pass rate)
- ✅ **Validated** - Confidence score ≥75
- ✅ **Production-Ready** - Ready for VERIFIED state

**Without:**
- ❌ Shortcuts or simplifications
- ❌ Manual validation overhead
- ❌ Incomplete implementations
- ❌ Infinite loops or stalls
- ❌ Loss of context or history

**The validation loop transforms quality assurance from a manual process into an automated, intelligent system that guarantees every feature meets production standards.**
