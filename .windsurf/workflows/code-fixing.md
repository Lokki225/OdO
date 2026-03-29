---
description: Fix actual code issues using verification-first approach
---

# Code Fixing Workflow

## Purpose
Fix actual code issues based on verification-first implementation workflow.

## Steps

1. **Read Status Files**
   - Read `IMPLEMENTATION_STATUS.json` to understand critical issues
   - Read `VERIFICATION_LOG.md` to confirm issues and their root causes

2. **Investigate Issues**
   - Run targeted tests to verify current failure behavior
   - Identify exact root causes in source code
   - Document findings with specific file locations

3. **Plan Fixes**
   - For complex implementations (>200 lines), create detailed plan
   - Identify all dependencies and potential conflicts
   - Plan incremental changes with verification points

4. **Implement Fixes**
   - Make minimal, targeted changes
   - Follow BMAD architecture principles
   - Add comprehensive error handling

5. **Verify Fixes**
   - Run targeted tests to confirm fixes work
   - Run full test suite to ensure no regressions
   - Update documentation with verification evidence

6. **Update Status**
   - Move completed items from `criticalIssues` to `completedIssues`
   - Update `VERIFICATION_LOG.md` with accurate results
   - Clean up `nextActions` array

## Quality Gates
- Test pass rate must be 95%+
- All critical issues must be resolved
- Documentation must be updated
