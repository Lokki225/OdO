# Story 6.7: CONVENTIONS.md Enforcement and Code Review

Status: ready-for-dev

## Story

As a developer,
I want to ensure all code follows the documented conventions,
so that the codebase remains maintainable and consistent.

## Acceptance Criteria

**Given** CONVENTIONS.md from Story 1.6
**When** I review code
**Then** all database columns use snake_case
**And** all Riverpod providers use suffix convention (Repository, Notifier, Service)
**And** all imports follow the rules (domain → nothing, data → domain, presentation → domain)
**And** all features have data/domain/presentation structure
**And** all features have single _providers.dart file
**And** all API keys use --dart-define (never hardcoded)

## Tasks / Subtasks

- [ ] Task 1: Database Convention Enforcement (AC: 1)
  - [ ] Audit all Drift table definitions for snake_case columns
  - [ ] Fix any camelCase or other naming violations
  - [ ] Update schema generation and verify conventions
  - [ ] Document database naming patterns in code comments

- [ ] Task 2: Riverpod Provider Naming (AC: 2)
  - [ ] Audit all provider names for suffix conventions
  - [ ] Ensure Repository, Notifier, Service suffixes are used correctly
  - [ ] Fix any non-compliant provider naming
  - [ ] Verify @riverpod code generation follows conventions

- [ ] Task 3: Import Structure Validation (AC: 3)
  - [ ] Audit import statements across all features
  - [ ] Ensure domain layer has no external dependencies
  - [ ] Verify data layer only imports domain
  - [ ] Ensure presentation only imports domain (not data directly)

- [ ] Task 4: Feature Structure Compliance (AC: 4-5)
  - [ ] Verify all features follow data/domain/presentation structure
  - [ ] Ensure each feature has single _providers.dart file
  - [ ] Fix any structural violations
  - [ ] Document folder organization patterns

- [ ] Task 5: API Key Security Audit (AC: 6)
  - [ ] Scan codebase for hardcoded API keys or secrets
  - [ ] Verify all API keys use String.fromEnvironment pattern
  - [ ] Ensure --dart-define usage in build configuration
  - [ ] Document secure API key handling patterns

- [ ] Task 6: Code Review Checklist Creation
  - [ ] Create automated linting rules for conventions
  - [ ] Document manual review checklist
  - [ ] Set up CI/CD checks for convention compliance
  - [ ] Create developer guidelines for maintaining conventions

## Dev Notes

### Architecture Context

- **CONVENTIONS.md Foundation**: Built on documented conventions from Story 1.6
- **Code Quality Standards**: Enforce architectural decisions for maintainability
- **Development Workflow**: Establish patterns for consistent development practices
- **Security Compliance**: Ensure no security vulnerabilities through convention violations

### Technical Requirements from Architecture

**Database Naming Convention (Story 1.4)**:

- All Drift table columns must use snake_case naming
- Consistent naming across all database entities
- Schema generation must reflect naming conventions
- Database queries must follow established patterns

**Riverpod Provider Patterns (Epic 1)**:

- Provider naming with suffix convention: Repository, Notifier, Service
- Code generation syntax (@riverpod) used consistently
- Single _providers.dart file per feature for organization
- State management patterns followed consistently

**Import Architecture (Architecture Document)**:

- Domain layer imports nothing external (pure business logic)
- Data layer imports domain only (implements interfaces)
- Presentation imports domain only (no direct data access)
- Clean architecture boundaries maintained

**Security Requirements (NFR16)**:

- API keys passed via --dart-define at build time
- Never present in source code or version control
- String.fromEnvironment pattern for runtime access
- No hardcoded secrets anywhere in codebase

### Project Structure Notes

**Convention Enforcement Tools**:

- Use analysis_options.yaml for automated linting
- Custom lint rules for architecture-specific patterns
- CI/CD integration for convention checking
- Developer tooling for convention validation

**File Structure Validation**:

- Feature-based folder structure (agenda, practice, ai)
- Consistent _providers.dart organization
- Proper separation of data/domain/presentation layers
- Core utilities and constants organization

**Testing Standards for Conventions**:

- Unit tests validate architectural patterns
- Integration tests verify layer separation
- Code review checklists for manual validation
- Automated tools for convention compliance

### Architecture Compliance

**Clean Architecture Enforcement**:

- Strict separation between data, domain, and presentation layers
- Dependency injection through Riverpod providers
- Business logic isolation in domain layer
- UI components separate from business logic

**Performance Impact Considerations**:

- Convention enforcement should not impact runtime performance
- Build-time checks preferred over runtime validation
- Efficient linting and analysis tool configuration
- Minimal overhead for developer workflow

**Maintenance Workflow**:

- Regular audits of convention compliance
- Developer education on architectural patterns
- Tooling to catch violations early in development
- Documentation updates as conventions evolve

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: Story 6.7]
- [Source: _bmad-output/implementation-artifacts/1-6-conventions-md-documentation.md]
- [Source: _bmad-output/planning-artifacts/architecture.md#Code Structure patterns]
- [Source: _bmad-output/planning-artifacts/epics.md#NFR16: API key security]

### Previous Story Intelligence

**CONVENTIONS.md Foundation (Story 1.6)**:

- Database naming conventions documented (snake_case)
- Riverpod provider naming patterns established
- Import rules specified for clean architecture
- API key security patterns documented

**Established Patterns from Epic 1**:

- Feature-based folder structure implemented
- Riverpod code-gen syntax (@riverpod) established
- Theme system following convention patterns
- Service architecture patterns defined

**Security Patterns (Multiple Stories)**:

- API key handling established in AI provider stories
- Environment variable patterns for configuration
- No hardcoded secrets in any implementation
- Build-time security configuration patterns

### Latest Technical Information

**Flutter/Dart Linting Best Practices**:

- Use pedantic or flutter_lints for baseline rules
- Custom lint rules via analyzer plugins
- IDE integration for real-time feedback
- CI/CD integration for automated checking

**Code Analysis Tools**:

- dart analyze for static analysis
- Custom rules via analysis_options.yaml
- Import organization with dart fix
- Dependency validation tools

**Security Scanning**:

- Secret scanning tools for CI/CD
- Pattern matching for hardcoded credentials
- Environment variable validation
- Build configuration security checks

**Architecture Validation**:

- Dependency graph analysis tools
- Layer violation detection
- Import path validation
- Architectural fitness functions

## Dev Agent Record

### Agent Model Used

Cascade

### Debug Log References

### Completion Notes List

### File List
