---
description: Implementation-first workflow with verification
---

# Implementation-First Workflow

## Purpose
Execute implementation tasks using verification-first approach.

## Steps

1. **Check Implementation Status**
   - Read `IMPLEMENTATION_STATUS.json` for current state
   - Review `AI_SESSION_MEMORY.md` for context
   - Identify next priority tasks

2. **Verify Current State**
   - Run tests to establish baseline
   - Verify claimed issues actually exist
   - Document current behavior

3. **Plan Implementation**
   - Break down complex tasks into small steps
   - Identify verification points for each step
   - Plan testing strategy

4. **Implement Incrementally**
   - Make small, testable changes
   - Verify each change before proceeding
   - Update documentation as you go

5. **Quality Assurance**
   - Run full test suite
   - Check performance metrics
   - Verify security requirements

6. **Update Documentation**
   - Update `IMPLEMENTATION_STATUS.json`
   - Update `VERIFICATION_LOG.md`
   - Update `AI_SESSION_MEMORY.md`

## Success Criteria
- All tests passing (95%+ pass rate)
- Performance requirements met
- Documentation accurate and up-to-date
