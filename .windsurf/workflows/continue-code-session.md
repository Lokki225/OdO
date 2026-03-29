---
description: Continue code development session by checking IMPLEMENTATION_STATUS.json and AI_SESSION_MEMORY for verification-first approach
---

# Continue Code Session Workflow

## Purpose
Verification-first continuation of code development using IMPLEMENTATION_STATUS.json as single source of truth, with universal agent safeguards enforced.

## MANDATORY PRE-REQUIREMENTS - VERIFICATION-FIRST APPROACH

### Step 1: Read Implementation Status Files (MANDATORY)
**BEFORE ANY CONTINUATION - MUST READ THESE FILES:**

#### Primary Authority Files:
1. **IMPLEMENTATION_STATUS.json** - Single source of truth for implementation status
2. **AI_SESSION_MEMORY.md** - Historical context with universal safeguards  
3. **VERIFICATION_LOG.md** - Detailed verification history and trends

#### Verification Requirements:
- **NEVER trust documentation claims** - Always verify against actual source code
- **Check verification accuracy** - Current accuracy is 0% (0/5 claims actually implemented)
- **Review test results** - Current pass rate is 81% (target: 95%+)
- **Identify undocumented issues** - 3 critical issues not previously documented

### Step 2: Follow Universal Agent Safeguards (MANDATORY)
**ALL WORKFLOWS MUST FOLLOW THESE RULES - NO EXCEPTIONS:**

#### From .windsurfrules Section 5:
- **Production System Enforcement** - This is a PRODUCTION system
- **Missing Package Handling** - Auto-install, ask user if fails
- **Complex Implementation Planning** - User approval required for >200 lines
- **Unknown Situation Resolution** - Ask user BEFORE coding alternatives
- **Universal Agent Behavior Rules** - Apply to ALL workflows

#### Forbidden Behaviors:
- Create "good enough" solutions for critical issues
- Use test project shortcuts in production code
- Proceed without user approval when uncertain
- Ignore security or performance requirements

### Step 3: Continue Implementation Process (VERIFICATION-FIRST)

#### Required Analysis:
1. **Read IMPLEMENTATION_STATUS.json** - Get current verified state
2. **Check AI_SESSION_MEMORY.md** - Understand historical context and safeguards
3. **Read product/roadmap.md** - Understand product vision and current phase
4. **Read product/personas.md** - Validate user context for issues
5. **Verify claimed fixes** - Check if documented fixes are actually in source code
6. **Identify real issues** - Focus on actual code, not documentation
7. **Check test failures** - Analyze failed tests for root causes
8. **Security assessment** - Verify encryption, data integrity, vulnerabilities
9. **Performance evaluation** - Check for timeouts violating <300ms requirement

#### Required Implementation Process:
1. **Select highest priority issue** - From IMPLEMENTATION_STATUS.json criticalIssues
2. **Validate Product Layer compliance** - Check issue has proper product documentation
3. **Read relevant feature specs** - Review product/features/*/spec.md for context
4. **Review acceptance criteria** - Check product/features/*/acceptance-criteria.md
5. **Handle missing dependencies** - Auto-install, ask user if fails
6. **Create implementation plan** - If complex (>200 lines or >3 files)
7. **Get user approval** - For complex implementations
8. **Edit actual source files** - Not just documentation
9. **Test implementation** - Verify fix works correctly against acceptance criteria
10. **Update IMPLEMENTATION_STATUS.json** - Mark as VERIFIED IMPLEMENTED
11. **Update VERIFICATION_LOG.md** - Record verification results

---

## Expected Outcomes

### Single Session Goal:
- Implement at least 1-2 critical issues in actual source code
- Update IMPLEMENTATION_STATUS.json with VERIFIED status
- Improve verification accuracy from 0% to 40%+
- Increase test pass rate from 81% to 85%+

### Multiple Sessions Goal:
- Eventually implement all 5+ critical issues
- Achieve 100% verification accuracy
- Reach 95%+ test pass rate
- Eliminate documentation vs implementation gap

---

## Success Criteria
- **Implementation Status**: Issues marked as VERIFIED IMPLEMENTED
- **Verification Accuracy**: 100% of claims verified in source code
- **Test Results**: 95%+ pass rate maintained
- **Security**: All critical vulnerabilities resolved
- **Performance**: All operations <300ms Interactive Pulse
