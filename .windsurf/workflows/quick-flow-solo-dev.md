---
description: Rapid solo development workflow
---

# Quick Flow Solo Development

## Purpose
Rapid development workflow for solo developers with BMAD compliance.

## Workflow Steps

### 1. Quick Setup (5 min)
```bash
# Check current status
npm run status-check

# Run baseline tests
npm test -- --watchAll=false --passWithNoTests
```

### 2. Feature Development
```bash
# Create feature branch
git checkout -b feature/feature-name

# Implement with TDD
npm run dev:test -- --testPathPattern=feature-name

# Make incremental changes
# Verify each step
```

### 3. Quick Verification
```bash
# Run targeted tests
npm test -- --testPathPattern="feature-name"

# Check performance
npm run test:performance

# Full test suite
npm test -- --watchAll=false
```

### 4. Quick Documentation
```bash
# Update status
npm run status:update "Feature completed"

# Commit with verification
git add .
git commit -m "feat: feature-name [verified]"
```

## Speed Tips
- Use hot reload for rapid testing
- Pre-commit hooks for quality gates
- Automated status updates
- Template-based documentation

## Quality Gates
- All tests must pass
- Performance benchmarks met
- Documentation updated
