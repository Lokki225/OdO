---
description: Intelligent workflow orchestration with automated session context management and performance optimization
---

# 🎼 Session Orchestrator Workflow

## Purpose

**Master controller** that orchestrates all BMAD workflows, manages session context automatically, and optimizes session efficiency through intelligent workflow selection and context caching.

---

## 🧠 **Smart Workflow Selection Engine**

### Automatic Workflow Detection

Based on current project state, automatically determine the optimal workflow:

```
📊 WORKFLOW DECISION MATRIX

Current State Analysis:
□ Check IMPLEMENTATION_STATUS.json for current work
□ Check FEATURE_STATUS.json for feature states  
□ Check phase completion status
□ Analyze session memory for context
□ Calculate session efficiency metrics

Decision Logic:
┌─────────────────────────────────────────────────────────┐
│ Condition                    │ Recommended Workflow     │
├─────────────────────────────┼─────────────────────────┤
│ New feature (PROPOSED)      │ /smart-implementation   │
│ Paused work (IN_PROGRESS)   │ /continue-implementation │
│ Suspicious completion       │ /validate-implementation │
│ Multi-workflow session      │ /session-orchestrator   │
│ Performance issues          │ /auto-healing           │
└─────────────────────────────────────────────────────────┘
```

### Context Pre-Loading

**Before any workflow execution**, automatically cache frequently accessed data:

```
🚀 CONTEXT CACHE INITIALIZATION

Pre-load Common Data:
□ All Product Layer files for current feature
□ BMAD Design Contracts
□ Current implementation status
□ Phase completion data
□ Recent session memory
□ Performance baselines

Cache Duration: Current session
Cache Invalidation: On file changes
Performance Target: <50ms cache access
```

---

## 📋 **Automated Status Synchronization**

### Multi-File Update Engine

Eliminate manual JSON file updates with automated synchronization:

```typescript
// Auto-generated status sync logic
interface StatusUpdate {
  feature: string;
  phase: number;
  completedTasks: string[];
  confidenceScore: number;
  performanceMetrics: object;
}

function syncAllStatusFiles(update: StatusUpdate) {
  // Update IMPLEMENTATION_STATUS.json
  updateImplementationStatus(update);
  
  // Update FEATURE_STATUS.json  
  updateFeatureStatus(update);
  
  // Update phase file
  updatePhaseFile(update);
  
  // Update AI_SESSION_MEMORY.md
  updateSessionMemory(update);
  
  // Verify consistency
  validateStatusConsistency();
}
```

### Status Consistency Validation

```
🔍 STATUS CONSISTENCY CHECK

Cross-Reference Validation:
□ IMPLEMENTATION_STATUS.json.currentWork.feature matches FEATURE_STATUS.json
□ Phase completion in JSON matches phase file checkmarks
□ Confidence scores align with actual implementation
□ Session memory reflects current state

Auto-Fix Issues:
□ Resolve conflicts automatically where possible
□ Flag manual resolution needed for complex conflicts
□ Maintain audit trail of all changes
```

---

## ⚡ **Session Efficiency Optimization**

### Context Persistence Engine

Automatically capture and restore session context:

```
💾 SESSION CONTEXT MANAGEMENT

Context Capture (Auto-triggered every 10 minutes):
□ Current workflow state
□ Files being worked on
□ Last completed task
□ Current problems/blockers
□ Performance metrics
□ Time spent on each phase

Context Restoration (Auto-triggered on session start):
□ Load previous session state
□ Restore file context
□ Resume from exact stopping point  
□ Pre-load relevant documentation
□ Display session efficiency metrics
```

### Performance Tracking

```
📊 SESSION PERFORMANCE METRICS

Real-time Tracking:
- Session Duration: [XX] minutes
- Tasks Completed: [N] tasks
- Efficiency Rate: [X] tasks/hour
- Context Switch Time: [XX] seconds
- File Access Time: [XX] ms
- Test Execution Time: [XX] seconds

Optimization Suggestions:
□ Cache frequently accessed files
□ Pre-run tests in background
□ Batch similar operations
□ Optimize file read patterns
```

---

## 🔄 **Intelligent Workflow Chaining**

### Auto-Workflow Transitions

Seamlessly chain workflows based on completion results:

```
🔗 WORKFLOW CHAIN LOGIC

Smart Implementation → Auto-trigger:
✅ If implementation complete → /validate-implementation
⚠️ If issues found → /code-fixing  
🔄 If paused → Update session memory

Validate Implementation → Auto-trigger:
✅ If validation passes → Mark feature IMPLEMENTED
❌ If validation fails → /continue-implementation  
🔧 If fixes needed → Apply fixes then re-validate

Continue Implementation → Auto-trigger:
✅ If phase complete → Move to next phase
⚠️ If blockers found → /auto-healing
📊 If context lost → Restore from session memory
```

### Workflow Handoff Protocol

```
📤 WORKFLOW HANDOFF CHECKLIST

Before Transition:
□ Update IMPLEMENTATION_STATUS.json with current progress
□ Save session context to AI_SESSION_MEMORY.md
□ Cache current file states
□ Record performance metrics
□ Set expectations for next workflow

After Transition:
□ Verify context restoration successful
□ Confirm file consistency
□ Load cached data
□ Display progress summary
□ Start performance tracking
```

---

## 🎯 **Usage Examples**

### Starting a New Session

```bash
# User runs: /session-orchestrator

🎼 SESSION ORCHESTRATOR ACTIVATED

Analyzing Current State...
□ Reading IMPLEMENTATION_STATUS.json
□ Checking FEATURE_STATUS.json  
□ Loading session memory
□ Calculating optimal workflow

Recommendation: /continue-implementation
Reason: Feature "user-authentication" is IN_PROGRESS at Phase 2
Last Session: 2 hours ago
Context: Available and recent

Would you like to:
1. 🔄 Continue with recommended workflow
2. 🎯 Override with specific workflow
3. 📊 View detailed status first
```

### Mid-Session Optimization

```bash
# Auto-triggered every 15 minutes

⚡ SESSION EFFICIENCY CHECK

Performance Metrics:
- Time in session: 47 minutes
- Tasks completed: 3
- Efficiency: 3.8 tasks/hour (Above average!)
- Context switches: 2 (Optimal)

Optimization Applied:
✅ Pre-loaded next phase files
✅ Cached test results
✅ Prepared validation checklist

Continuing with current workflow...
```

---

## 🛡️ **Quality Safeguards**

### Session Integrity Monitoring

```
🔍 CONTINUOUS MONITORING

File Change Detection:
□ Monitor Product Layer files for changes
□ Detect code changes outside current workflow
□ Track configuration drift
□ Alert on potential conflicts

State Consistency:
□ Verify JSON file synchronization
□ Check workflow state validity
□ Validate context integrity  
□ Ensure no data loss
```

### Auto-Recovery Mechanisms

```
🔧 AUTO-RECOVERY PROTOCOLS

Context Loss Recovery:
1. Detect context loss (missing session data)
2. Attempt recovery from AI_SESSION_MEMORY.md
3. Reconstruct state from file analysis
4. Validate recovered context
5. Continue or escalate to user

File Corruption Recovery:
1. Detect file inconsistencies
2. Restore from version control
3. Merge recent changes carefully
4. Validate system integrity
5. Resume operations
```

---

## ✅ **Session Orchestrator Benefits**

### **For Developers:**
- 🚀 **3x Faster Session Startup** - Pre-loaded context and automated workflow selection
- 🎯 **Zero Context Loss** - Automatic session persistence and restoration  
- ⚡ **50% Fewer Manual Updates** - Automated status file synchronization
- 🔄 **Seamless Workflow Transitions** - Intelligent chaining eliminates friction

### **For AI Agents:**
- 🧠 **Perfect Context Restoration** - Never start from scratch
- 📊 **Performance Optimization** - Real-time efficiency tracking
- 🛡️ **Error Prevention** - Automated consistency validation
- 🎼 **Workflow Harmony** - Seamless integration between all BMAD workflows

### **For Project Success:**
- 📈 **Higher Velocity** - Optimized session efficiency
- 🎯 **Better Quality** - Automated quality gates and validation
- 📊 **Complete Traceability** - Full session and workflow audit trails
- 🔒 **Zero Data Loss** - Bulletproof session persistence

---

**The Session Orchestrator transforms BMAD from a collection of workflows into a unified, intelligent development environment.**
