---
description: Comprehensive code review with BMAD compliance
---

# Code Review Workflow

## Purpose
Perform comprehensive code review ensuring BMAD compliance and quality standards.

## Review Checklist

### Architecture Compliance
- [ ] Follows BMAD structure (Backend, Model, API, Database)
- [ ] Clear separation of concerns
- [ ] Proper dependency injection
- [ ] Single responsibility principle followed

### Code Quality
- [ ] Meaningful variable and function names
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Adequate comments explaining "why"
- [ ] Function complexity under 10

### Testing
- [ ] Unit tests for business logic
- [ ] Integration tests for APIs
- [ ] Test coverage >80%
- [ ] Tests are deterministic
- [ ] External dependencies mocked

### Performance
- [ ] Database queries optimized
- [ ] Caching implemented where appropriate
- [ ] No N+1 query problems
- [ ] Pagination for list endpoints

### Security
- [ ] Input validation at API boundaries
- [ ] No hardcoded secrets
- [ ] Proper authentication/authorization
- [ ] SQL injection prevention
- [ ] XSS prevention

### Documentation
- [ ] Code is self-documenting
- [ ] Complex algorithms explained
- [ ] API endpoints documented
- [ ] Database schema documented

## Review Process

1. **Automated Checks**
   - Run linting and formatting
   - Run test suite
   - Check code coverage
   - Run security scans

2. **Manual Review**
   - Architecture compliance
   - Code quality assessment
   - Performance review
   - Security assessment

3. **Feedback Integration**
   - Document all findings
   - Prioritize issues by severity
   - Create action items
   - Follow up on fixes

## Output
- Detailed review report
- Action items for fixes
- Updated implementation status
