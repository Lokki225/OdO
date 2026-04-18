---
description: Intelligent implementation with real-time validation, confidence tracking, and anti-simplification enforcement
---

# Smart Implementation Workflow v2.0

## Purpose

Execute implementation with continuous validation, automatic confidence scoring, goosebumps-free development, and **MANDATORY** prevention of corner-cutting, simplification, or incomplete implementations.

---

## 🚨 CRITICAL: Anti-Simplification Rules

### **ZERO TOLERANCE POLICY**

**AI Agents MUST NEVER:**

- ❌ Propose "simplified" or "minimal" versions of requirements
- ❌ Skip acceptance criteria claiming they're "optional"
- ❌ Omit edge cases or error handling
- ❌ Skip test scenarios documented in Product Layer
- ❌ Remove features to "make implementation easier"
- ❌ Suggest "implementing this later" for documented requirements
- ❌ Replace specified solutions with "simpler alternatives"
- ❌ Skip integration requirements
- ❌ Ignore performance, security, or quality requirements
- ❌ Mark stories complete without implementing ALL acceptance criteria

### **MANDATORY IMPLEMENTATION RULE**

> **Every single item in acceptance criteria, test scenarios, specifications, and risk assessments MUST be implemented EXACTLY as documented. No exceptions. No simplifications. No shortcuts.**

### **Verification Before ANY Code Change**

Before writing ANY code, AI agents MUST:

1. **Read and acknowledge** ALL Product Layer files:
   - `lib/product/features/[FEATURE]/spec.md`
   - `lib/product/features/[FEATURE]/acceptance-criteria.md`
   - `lib/product/features/[FEATURE]/test-scenarios.md`
   - `lib/product/features/[FEATURE]/risks.md`
   - `lib/product/features/[FEATURE]/1-data-implementation-plan.md`
   - `lib/product/features/[FEATURE]/2-domain-implementation-plan.md`
   - `lib/product/features/[FEATURE]/3-ui-implementation-plan.md`

2. **Create implementation checklist** from acceptance criteria
3. **Verify** every item will be implemented
4. **Confirm** no simplifications or omissions
5. **Document** the implementation approach for EACH criterion

---

## 🏗️ Phase 0: Epic Product Layer Scaffolding (MANDATORY FIRST STEP)

### Purpose

Before ANY code is written, the agent MUST create the **Epic Product Layer** — a complete set of product documentation and implementation plans for the current epic. This ensures every epic has its own specification, acceptance criteria, risk assessment, test scenarios, and **layered implementation plans** (Data, Domain, UI) following Clean Architecture.

### 📂 Two-Folder Architecture

- **`lib/product/features/[feature]/`** — Product documentation & implementation plans (specs, AC, risks, tests, plans)
- **`lib/features/[feature]/`** — Actual code implementation (data/, domain/, presentation/)

The product folder guides the implementation. The code folder receives the implementation. They are always kept in sync.

### Trigger Condition

**When starting a NEW epic** (no `lib/product/features/[feature-slug]/` folder exists for this epic), execute Phase 0 BEFORE anything else.

**If the folder already exists and is populated** → skip to Pre-Flight Safety Check.

### Step P0.1: Create Epic Product Folder

```text
🏗️ EPIC PRODUCT LAYER SCAFFOLDING

Epic: [EPIC_NAME]
Feature Slug: [feature-slug] (e.g., foundation, agenda, practice, ai, proactive, polish)

□ Create folder: lib/product/features/[feature-slug]/
□ Copy and populate from templates: lib/product/features/_TEMPLATE/

Files to create:
  ✅ lib/product/features/[feature-slug]/spec.md
  ✅ lib/product/features/[feature-slug]/acceptance-criteria.md
  ✅ lib/product/features/[feature-slug]/risks.md
  ✅ lib/product/features/[feature-slug]/test-scenarios.md
  ✅ lib/product/features/[feature-slug]/1-data-implementation-plan.md
  ✅ lib/product/features/[feature-slug]/2-domain-implementation-plan.md
  ✅ lib/product/features/[feature-slug]/3-ui-implementation-plan.md
```

### Step P0.2: Populate Product Documents from Epic Source

**Source Documents:**
- `_bmad-output/planning-artifacts/epics.md` — Epic stories and acceptance criteria
- `_bmad-output/prd.md` — Product requirements
- `_bmad-output/planning-artifacts/architecture.md` — Architecture decisions
- `_bmad-output/planning-artifacts/ux-design-specification.md` — UX requirements
- `docs/IMPLEMENTATION_PLAN.md` — Implementation sequence

**For each document, the agent MUST:**

1. **spec.md** — Extract from epics.md:
   - Epic goal and rationale
   - All screens/pages required
   - User flows from story acceptance criteria
   - Technical constraints from architecture.md
   - Dependencies on other epics
   - Clean Architecture component breakdown (Domain entities, Data models, Presentation pages)

2. **acceptance-criteria.md** — Extract from epics.md:
   - ALL acceptance criteria from EVERY story in this epic
   - Cross-reference with PRD functional requirements (FR1-FR26)
   - Cross-reference with UX design requirements (UX-DR1-UX-DR28)
   - Cross-reference with non-functional requirements (NFR1-NFR16)
   - Group by: Functional, Integration, Edge Cases, Error Handling, Quality, Security

3. **risks.md** — Analyze:
   - Technical risks specific to this epic's stories
   - Integration risks with dependent epics
   - Performance risks per platform thresholds
   - Data integrity risks (SQLite/Drift specific)

4. **test-scenarios.md** — Derive from acceptance criteria:
   - Data layer test scenarios (model serialization, DAO queries, repository delegation)
   - Domain layer test scenarios (entity validation, use case logic, error cases)
   - Presentation layer test scenarios (widget rendering, state management, navigation)
   - Edge case and error scenarios
   - Performance test scenarios

### Step P0.3: Create Layered Implementation Plans (Clean Architecture)

**CRITICAL**: These plans guide the ENTIRE implementation. They must be thorough.

```text
📐 IMPLEMENTATION PLAN CREATION

For each plan, the agent MUST:

1️⃣  1-data-implementation-plan.md (Data Layer):
  □ List ALL models with field-by-field mapping to domain entities
  □ List ALL Drift DAO queries with SQL operations
  □ List ALL repository implementations with error mapping
  □ Define file paths: lib/features/[feature]/data/models/, datasources/, repositories/
  □ Map each item to a specific story ID
  □ Define test file paths mirroring lib/ structure

2️⃣  2-domain-implementation-plan.md (Domain Layer):
  □ List ALL entities with properties and validation rules
  □ List ALL use cases with input/output and business logic
  □ List ALL repository contracts (abstract interfaces)
  □ Define ALL failure types and when they trigger
  □ Define file paths: lib/features/[feature]/domain/entities/, usecases/, repositories/
  □ Map each item to a specific story ID

3️⃣  3-ui-implementation-plan.md (Presentation Layer):
  □ List ALL screens/pages with routes and purpose
  □ List ALL widgets with responsibilities
  □ List ALL Riverpod providers with types and dependencies
  □ List ALL UI states (loading, loaded, empty, error)
  □ Map ALL UX-DR requirements to specific screens
  □ Define navigation flow between screens
  □ Define file paths: lib/features/[feature]/presentation/pages/, widgets/, providers/
  □ Map each item to a specific story ID
```

### Step P0.4: Validate Epic Product Layer Completeness

```text
✅ EPIC PRODUCT LAYER VALIDATION

□ spec.md is complete — NOT a template, filled with real epic data
□ acceptance-criteria.md is complete — ALL story ACs extracted and organized
□ risks.md is complete — ALL risks identified with mitigations
□ test-scenarios.md is complete — ALL layers have test scenarios
□ 1-data-implementation-plan.md is complete — ALL models, DAOs, repos listed
□ 2-domain-implementation-plan.md is complete — ALL entities, use cases, contracts listed
□ 3-ui-implementation-plan.md is complete — ALL screens, widgets, providers listed

Cross-Reference Check:
□ Every story in epics.md for this epic is covered in at least one implementation plan
□ Every acceptance criterion maps to a test scenario
□ Every screen in spec.md appears in 3-ui-implementation-plan.md
□ Every entity in spec.md appears in 2-domain-implementation-plan.md
□ Every model in spec.md appears in 1-data-implementation-plan.md
□ Implementation order respects Clean Architecture: Domain → Data → Presentation

🎯 RESULT: [PASS/FAIL] — CANNOT proceed to Pre-Flight with FAIL
```

### 🚫 BLOCKING RULE

**DO NOT proceed to Pre-Flight Safety Check or write ANY code until Phase 0 is COMPLETE.**

- ❌ No code before product layer exists
- ❌ No implementation before plans are filled out
- ❌ No story work before ALL 7 files exist and are populated
- ✅ Only after Phase 0 PASSES → proceed to Pre-Flight Safety Check

### 📂 Directory Structure After Phase 0

```text
lib/
├── product/
│   └── features/
│       ├── _TEMPLATE/              ← Source templates (never edited directly)
│       │   ├── spec.md
│       │   ├── acceptance-criteria.md
│       │   ├── risks.md
│       │   ├── test-scenarios.md
│       │   ├── 1-data-implementation-plan.md
│       │   ├── 2-domain-implementation-plan.md
│       │   └── 3-ui-implementation-plan.md
│       └── [feature-slug]/         ← Populated for current epic
│           ├── spec.md
│           ├── acceptance-criteria.md
│           ├── risks.md
│           ├── test-scenarios.md
│           ├── 1-data-implementation-plan.md
│           ├── 2-domain-implementation-plan.md
│           └── 3-ui-implementation-plan.md
│
├── features/
│   └── [feature-slug]/             ← Actual code (populated AFTER Phase 0)
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── usecases/
│       │   └── repositories/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── providers/
```

---

## Pre-Flight Safety Check

### 1. **Product Layer Verification (MANDATORY)**

**BLOCKING CHECK**: Before ANY implementation, verify Product Layer completeness:

```
✅ Product Layer Checklist for [FEATURE_NAME]:

📋 Specifications:
  □ Feature specification exists at lib/product/features/[FEATURE]/spec.md
  □ Problem statement is clear and specific
  □ Goals are well-defined
  □ Non-goals are documented
  □ User flow is complete
  □ Technical constraints are listed
  □ Dependencies are identified
  □ Success metrics are defined

✅ Acceptance Criteria:
  □ Acceptance criteria exists at lib/product/features/[FEATURE]/acceptance-criteria.md
  □ ALL functional requirements are testable
  □ ALL integration requirements are specific
  □ ALL quality requirements have measurable criteria
  □ ALL edge cases are documented
  □ ALL error handling scenarios are defined
  □ ALL performance criteria are quantified
  □ ALL security requirements are specified
  □ Definition of Done is complete

✅ Test Scenarios:
  □ Test scenarios exist at lib/product/features/[FEATURE]/test-scenarios.md
  □ ALL test scenarios map to acceptance criteria
  □ Input/output for each scenario is defined
  □ Validation rules are specific
  □ Unit test requirements are listed
  □ Integration test requirements are listed
  □ Performance test requirements are listed
  □ Security test requirements are listed
  □ Test data requirements are documented

✅ Risk Assessment:
  □ Risk assessment exists at lib/product/features/[FEATURE]/risks.md
  □ Technical risks are identified
  □ Product risks are identified
  □ Performance risks are identified
  □ Security risks are identified
  □ Integration risks are identified
  □ Mitigation strategies are defined
  □ Monitoring metrics are specified

✅ Implementation Plans (Clean Architecture):
  □ lib/product/features/[FEATURE]/1-data-implementation-plan.md filled out (models, DAOs, repos)
  □ lib/product/features/[FEATURE]/2-domain-implementation-plan.md filled out (entities, use cases, contracts)
  □ lib/product/features/[FEATURE]/3-ui-implementation-plan.md filled out (screens, widgets, providers)
  □ Each plan lists exact file paths under lib/features/[FEATURE]/data|domain|presentation/
  □ Each plan maps items to specific story IDs from epics.md
  □ Implementation order follows Clean Architecture: Domain → Data → Presentation
  □ Use implementation plans as task tracking checklists throughout development

🎯 RESULT: [PASS/FAIL] - CANNOT proceed with FAIL
```

**IF ANY ITEM FAILS**:
- ❌ **STOP IMMEDIATELY**
- ❌ **DO NOT write any code**
- ❌ Report missing documentation
- ❌ Request Product Layer completion
- ❌ Wait for approval before proceeding

### 2. **Implementation Plan Validation**

- Read `docs/IMPLEMENTATION_PLAN.md` for current sequence
- Verify epic-level dependencies are satisfied
- Check story-level prerequisites are completed
- Confirm next story in sequence is ready for implementation
- Validate no circular dependency violations

### 3. **System Health Scan**

- Verify all required files exist
- Check confidence score baseline
- Validate Product Layer completeness
- Confirm Design Contracts compliance

### 4. **Platform Detection & Configuration**

- Read platformType from IMPLEMENTATION_STATUS.json
- **MANDATORY**: Set performance thresholds based on platform:
  - **Web**: <300ms interactive, <200ms API, <100ms DB
  - **Mobile**: <200ms interactive, <300ms API, <150ms DB  
  - **Desktop**: <100ms interactive, <100ms API, <50ms DB
  - **API**: <150ms interactive, <50ms API, <25ms DB
  - **CLI**: <500ms interactive, N/A API, N/A DB
- Auto-detect platform if platformType is missing
- Configure monitoring tools for platform type

### 5. **Risk Assessment**

- Analyze implementation complexity
- Identify potential failure points
- Set rollback points
- Calculate confidence impact

---

## 📋 Acceptance Criteria Enforcement System

### **Pre-Implementation Requirements Matrix**

Before writing ANY code, create this matrix:

```
Feature: [FEATURE_NAME]
Date: [YYYY-MM-DD]
Story ID: [STORY_ID]

ACCEPTANCE CRITERIA IMPLEMENTATION MATRIX:

Functional Requirements:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Requirement           │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ FR1 │ [Requirement text]    │ [How to implement] │ ⬜ TODO │
│ FR2 │ [Requirement text]    │ [How to implement] │ ⬜ TODO │
│ FR3 │ [Requirement text]    │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Integration Requirements:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Integration           │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ IR1 │ [Integration text]    │ [How to implement] │ ⬜ TODO │
│ IR2 │ [Integration text]    │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Quality Requirements:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Quality Req           │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ QR1 │ [Quality text]        │ [How to implement] │ ⬜ TODO │
│ QR2 │ [Quality text]        │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Edge Cases:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Edge Case             │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ EC1 │ [Edge case text]      │ [How to implement] │ ⬜ TODO │
│ EC2 │ [Edge case text]      │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Error Handling:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Error Scenario        │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ EH1 │ [Error scenario]      │ [How to implement] │ ⬜ TODO │
│ EH2 │ [Error scenario]      │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Performance Criteria:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Performance Req       │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ PC1 │ [Performance text]    │ [How to implement] │ ⬜ TODO │
│ PC2 │ [Performance text]    │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

Security Requirements:
┌─────────────────────────────────────────────────────────────┐
│ ID  │ Security Req          │ Implementation Plan │ Status │
├─────┼───────────────────────┼────────────────────┼────────┤
│ SR1 │ [Security text]       │ [How to implement] │ ⬜ TODO │
│ SR2 │ [Security text]       │ [How to implement] │ ⬜ TODO │
└─────────────────────────────────────────────────────────────┘

🎯 TOTAL ITEMS: [COUNT]
✅ MUST IMPLEMENT ALL: [COUNT] items
❌ CANNOT SKIP ANY: 0 items allowed to be skipped
```

### **Continuous Verification During Implementation**

After implementing EACH requirement:

1. **Update matrix** with ✅ status
2. **Verify implementation** matches acceptance criteria EXACTLY
3. **Write test** that validates the criterion
4. **Run test** and ensure it passes
5. **Document** any deviations (there should be NONE)

### **Blocking Conditions**

**DO NOT proceed to next requirement if:**
- ❌ Current requirement not fully implemented
- ❌ Test for current requirement failing
- ❌ Implementation deviates from acceptance criteria
- ❌ Simplifications were made

---

## Implementation Loop

### **Step-by-Step Implementation Process**

For each feature:

### **Pre-Step: Verify Epic Product Layer Exists (Phase 0 Gate)**

Before entering the implementation loop, verify Phase 0 has been completed:

```text
📋 PHASE 0 GATE CHECK

□ lib/product/features/[FEATURE]/ folder exists
□ spec.md is populated (not a template)
□ acceptance-criteria.md is populated
□ risks.md is populated
□ test-scenarios.md is populated
□ 1-data-implementation-plan.md is populated
□ 2-domain-implementation-plan.md is populated
□ 3-ui-implementation-plan.md is populated

🎯 ALL 7 files exist and are filled with real epic data

❌ IF ANY FILE MISSING OR STILL A TEMPLATE:
   → GO BACK to Phase 0 and complete it first
   → DO NOT proceed to Step 0
```

### **Step 0: Product Layer Deep Dive (MANDATORY)**

```
🔍 DEEP DIVE CHECKLIST:

□ Read specifications file completely
□ Read acceptance criteria file completely
□ Read test scenarios file completely
□ Read risk assessment file completely
□ Create implementation matrix from acceptance criteria
□ Identify ALL requirements (count them)
□ Plan implementation for EACH requirement
□ Verify NO requirements are marked as "optional"
□ Confirm understanding of ALL edge cases
□ Confirm understanding of ALL error scenarios
□ Confirm understanding of ALL performance criteria
□ Confirm understanding of ALL security requirements

🎯 SIGN-OFF: I have read and understood ALL Product Layer documentation
           and will implement EVERY requirement without simplification.

Signature: [AI_AGENT_NAME]
Date: [YYYY-MM-DD]
Total Requirements: [COUNT]
Commitment: Implement ALL [COUNT] requirements
```

### **Step 0.1: Screen & UI Inventory (MANDATORY - CRITICAL)**

**🚨 CRITICAL: This step prevents incomplete feature implementations**

Before ANY coding, extract and document ALL screens/pages from product specs:

```
📱 SCREEN INVENTORY FOR [FEATURE_NAME]:

Source: lib/product/features/[feature-name]/spec.md

Screens Section Analysis:
□ Located "Screens" section in spec.md
□ Read EVERY screen listed
□ Counted total screens required
□ No screens marked as "optional" or "future"

COMPLETE SCREEN LIST:
┌────────────────────────────────────────────────────────────┐
│ # │ Screen Name              │ File Path                   │
├───┼──────────────────────────┼─────────────────────────────┤
│ 1 │ [Screen Name]            │ lib/features/.../pages/     │
│ 2 │ [Screen Name]            │ lib/features/.../pages/     │
│ 3 │ [Screen Name]            │ lib/features/.../pages/     │
│ 4 │ [Screen Name]            │ lib/features/.../pages/     │
│ 5 │ [Screen Name]            │ lib/features/.../pages/     │
└────────────────────────────────────────────────────────────┘

📊 SCREEN COUNT: [X] screens MUST be implemented
🎯 COMMITMENT: I will implement ALL [X] screens - NO EXCEPTIONS

Cross-Reference Check:
□ Checked acceptance criteria for screen requirements
□ Checked user flow for screen transitions
□ Verified navigation requirements between screens
□ Identified all screen dependencies

🚫 BLOCKING RULE:
- If spec.md lists N screens, implementation MUST have N screens
- Missing even ONE screen = INCOMPLETE FEATURE
- DO NOT mark feature as IMPLEMENTED until ALL screens exist
```

### **Step 0.2: Feature Completeness Baseline (MANDATORY)**

Establish completion criteria BEFORE starting:

```
📊 FEATURE COMPLETENESS BASELINE:

Feature: [FEATURE_NAME]
Product Spec: lib/product/features/[feature-name]/spec.md

REQUIRED COMPONENTS INVENTORY:

1. Screens/Pages: [COUNT from spec.md "Screens" section]
   □ Screen 1: [Name]
   □ Screen 2: [Name]
   □ Screen 3: [Name]
   ... (list ALL)

2. User Flows: [COUNT from spec.md "User Flow" section]
   □ Flow 1: [Description]
   □ Flow 2: [Description]
   ... (list ALL)

3. Integration Points: [COUNT from spec.md "Dependencies" section]
   □ Integration 1: [System/Feature]
   □ Integration 2: [System/Feature]
   ... (list ALL)

4. Functional Requirements: [COUNT from acceptance-criteria.md]
   □ FR1: [Description]
   □ FR2: [Description]
   ... (list ALL)

5. Non-Functional Requirements: [COUNT from acceptance-criteria.md]
   □ NFR1: [Description]
   □ NFR2: [Description]
   ... (list ALL)

🎯 TOTAL COMPLETION ITEMS: [SUM of all counts]
📈 COMPLETION FORMULA: (Implemented Items / Total Items) × 100%
🚫 MINIMUM FOR "IMPLEMENTED" STATUS: 100% (ALL items)

⚠️ WARNING: Feature marked IMPLEMENTED with <100% = VIOLATION
```

### **Step 1: Dependency Check**
- Verify IMPLEMENTATION_PLAN.md allows this story
- Check all prerequisite stories are COMPLETE
- Validate no blocking dependencies exist

### **Step 2: Analyze**
- Read all context files
- **RE-READ** Product Layer files (specifications, acceptance criteria, test scenarios, risks)
- **READ** Implementation Plans (1-data, 2-domain, 3-ui) from `lib/product/features/[FEATURE]/`
- Create detailed notes on EVERY requirement

### **Step 3: Plan**
- Create implementation strategy
- **Map strategy to EVERY acceptance criterion**
- **Follow implementation plans** from `lib/product/features/[FEATURE]/` for layer ordering
- Identify files to create/modify for EACH requirement (cross-check with implementation plans)
- Plan test implementation for EACH requirement
- **Implementation order**: Domain (Step 4) → Data (Step 5) → Presentation (Step 6)
- **NO SIMPLIFICATIONS ALLOWED**

### **Step 4: Domain Layer Implementation**

**📐 Reference Plan**: `lib/product/features/[FEATURE]/2-domain-implementation-plan.md`

**For EACH acceptance criterion requiring domain logic:**

```
✅ Domain Implementation Checklist:

□ Entity created with ALL required properties
□ Entity includes ALL validation rules from acceptance criteria
□ Entity handles ALL edge cases documented
□ Repository contract defined with ALL required methods
□ Use case created for EACH functional requirement
□ Use case implements ALL business logic exactly as specified
□ Use case handles ALL error scenarios from acceptance criteria
□ Use case validates ALL inputs as per quality requirements
□ Use case returns proper Either<Failure, Success> for ALL cases
□ ALL domain tests written and passing

🚫 BLOCKERS:
- Missing ANY property from specifications
- Skipping ANY validation rule
- Ignoring ANY edge case
- Simplifying ANY business logic
```

### **Step 5: Data Layer Implementation**

**📐 Reference Plan**: `lib/product/features/[FEATURE]/1-data-implementation-plan.md`

**For EACH data requirement:**

```
✅ Data Layer Implementation Checklist:

□ Model created with ALL fields from entity
□ Model includes proper JSON serialization
□ Model handles ALL data transformation edge cases
□ Remote data source implements ALL API calls from integration requirements
□ Data source handles ALL network error scenarios
□ Data source implements ALL retry logic from quality requirements
□ Repository implementation delegates to data sources correctly
□ Repository handles ALL error mapping
□ Repository implements ALL caching requirements
□ ALL data layer tests written and passing

🚫 BLOCKERS:
- Missing ANY field from entity
- Skipping ANY API endpoint
- Ignoring ANY error scenario
- Removing ANY caching requirement
```

### **Step 6: Presentation Layer Implementation**

**📐 Reference Plan**: `lib/product/features/[FEATURE]/3-ui-implementation-plan.md`

**For EACH UI requirement:**

```
✅ Presentation Layer Implementation Checklist:

□ BLoC events defined for ALL user actions
□ BLoC states defined for ALL UI states from specifications
□ BLoC implements ALL business logic delegation
□ BLoC handles ALL error states from acceptance criteria
□ BLoC implements ALL loading states
□ Page created with ALL UI elements from specifications
□ Page handles ALL user interactions
□ Page displays ALL error messages as specified
□ Widgets created for ALL reusable components
□ Widgets implement ALL accessibility requirements
□ ALL presentation tests written and passing

🚫 BLOCKERS:
- Missing ANY user action handler
- Skipping ANY UI state
- Ignoring ANY error message
- Removing ANY accessibility feature
```

### **Step 7: Navigation Implementation**

```
✅ Navigation Implementation Checklist:

□ Routes defined for ALL pages
□ Navigation flow matches user flow in specifications
□ Deep links implemented as per requirements
□ Auth guards applied to ALL protected routes
□ Back navigation works for ALL screens
□ Navigation state persists across app restarts
□ Tab/drawer integration complete
□ ALL navigation tests written and passing

🚫 BLOCKERS:
- Missing ANY route
- Skipping ANY auth guard
- Ignoring ANY deep link requirement
```

### **Step 8: Database Implementation**

```
✅ Database Implementation Checklist:

□ Schema file updated with ALL required tables
□ ALL entity tables created with correct columns
□ ALL relationships defined with foreign keys
□ ALL indexes created for performance requirements
□ ALL constraints added for data integrity
□ ALL RLS policies implemented for security requirements
□ ALL triggers created for data consistency
□ Sample test data added
□ Database migration script created
□ ALL database tests written and passing

🚫 BLOCKERS:
- Missing ANY table
- Skipping ANY index for performance
- Ignoring ANY RLS policy for security
- Missing ANY constraint for integrity
```

### **Step 9: Test Implementation (MANDATORY)**

**For EVERY test scenario in test-scenarios file:**

```
✅ Test Implementation Checklist:

Test Scenario: [TS-XXX]
Description: [Test scenario description]

□ Test scenario ID matches acceptance criteria ID
□ Test written for exact input specified
□ Test validates exact expected output
□ Test checks ALL validation rules
□ Test handles ALL edge cases
□ Test verifies ALL error conditions
□ Test meets performance criteria
□ Test validates security requirements
□ Test uses proper test data
□ Test includes cleanup procedures

Unit Tests:
□ Test 1: [Description] - [Status: ✅/❌]
□ Test 2: [Description] - [Status: ✅/❌]
□ Test 3: [Description] - [Status: ✅/❌]

Integration Tests:
□ Test 1: [Description] - [Status: ✅/❌]
□ Test 2: [Description] - [Status: ✅/❌]

Performance Tests:
□ Test 1: [Description] - [Status: ✅/❌]

Security Tests:
□ Test 1: [Description] - [Status: ✅/❌]

🎯 COVERAGE: [XX]% (Minimum: 80% for ALL new code)
```

**BLOCKING CONDITION:**
- ❌ **ANY test scenario from Product Layer not implemented = FAIL**
- ❌ **ANY test failing = FAIL**
- ❌ **Coverage below 80% = FAIL**

### **Step 10: Quality Validation**

```
✅ Quality Validation Checklist:

Code Quality:
□ Flutter analyze: No issues found!
□ ALL lint errors fixed
□ ALL warnings addressed
□ Code follows design patterns
□ No code duplication
□ Proper error handling everywhere
□ Logging implemented correctly

Performance:
□ Meets platform-specific thresholds
□ No memory leaks detected
□ Smooth animations (60fps)
□ Efficient database queries
□ Proper lazy loading implemented

Security:
□ ALL security requirements from acceptance criteria implemented
□ Input validation on ALL inputs
□ Proper authentication checks
□ Data encryption where required
□ No sensitive data in logs

Accessibility:
□ Screen reader support
□ Proper contrast ratios
□ Keyboard navigation
□ Focus management

Documentation:
□ Code comments for complex logic
□ API documentation updated
□ README updated if needed
□ CHANGELOG entry added
```

### **Step 11: Comprehensive Feature Verification**

**MANDATORY VERIFICATION BEFORE UPDATING IMPLEMENTATION_STATUS.json**

#### 11.1 **Story Requirements Verification**

```
✅ Story Verification:

□ Read story file: docs/stories/[STORY_ID].md
□ ALL acceptance criteria implemented (no exceptions)
□ ALL tasks/subtasks completed
□ ALL integration requirements met
□ ALL edge cases handled
□ ALL error scenarios implemented
□ ALL performance criteria met
□ ALL security requirements satisfied

🔍 VERIFICATION METHOD:
For EACH acceptance criterion:
1. Find the code that implements it
2. Find the test that validates it
3. Confirm test passes
4. Confirm no simplifications were made

📊 SCORE: [X]/[TOTAL] criteria implemented
🎯 REQUIRED: [TOTAL]/[TOTAL] (100%)
```

#### 11.2 **Technical Implementation Verification**

```
✅ Technical Verification:

Domain Layer:
□ ALL entities exist and are complete
□ ALL repositories defined
□ ALL use cases implemented
□ NO business logic in other layers

Data Layer:
□ ALL models implement ALL entity properties
□ ALL datasources implement ALL API endpoints
□ ALL repositories implement ALL contracts
□ ALL error handling implemented

Presentation Layer:
□ ALL BLoCs created and functional
□ ALL pages created and accessible
□ ALL widgets implemented
□ ALL UI states handled

Database:
□ Schema deployed with ALL tables
□ ALL indexes created
□ ALL RLS policies active
□ ALL triggers functional

Navigation:
□ Feature accessible from app
□ ALL routes working
□ Auth flow correct
□ Deep links functional
```

#### 11.3 **Quality Assurance Verification**

```
✅ Quality Verification:

□ Flutter analyze: No issues found!
□ ALL tests passing (0 failures)
□ Test coverage ≥ 80%
□ Performance meets platform thresholds
□ No memory leaks
□ No security vulnerabilities
□ Accessibility requirements met
```

#### 11.4 **Integration Verification**

```
✅ Integration Verification:

□ Authentication integration working
□ State management connected
□ Design system components used
□ Observability/logging implemented
□ Dependency injection configured
□ Feature works with existing features
□ No breaking changes to other features
```

#### 11.5 **User Experience Verification**

```
✅ UX Verification:

□ Feature accessible in app
□ UI follows design system
□ Error handling provides clear feedback
□ Loading states implemented
□ Success confirmations shown
□ Performance feels smooth
□ Works offline if required
□ Responsive on all screen sizes
```

### **Step 12: Final Acceptance Criteria Audit**

**BEFORE marking as complete, perform this audit:**

```
🔍 FINAL AUDIT: [FEATURE_NAME]

Acceptance Criteria Audit:
┌────────────────────────────────────────────────────────┐
│ Criterion ID │ Implemented? │ Tested? │ Verified? │
├──────────────┼──────────────┼─────────┼───────────┤
│ FR1          │ ✅           │ ✅      │ ✅        │
│ FR2          │ ✅           │ ✅      │ ✅        │
│ FR3          │ ✅           │ ✅      │ ✅        │
│ IR1          │ ✅           │ ✅      │ ✅        │
│ IR2          │ ✅           │ ✅      │ ✅        │
│ QR1          │ ✅           │ ✅      │ ✅        │
│ QR2          │ ✅           │ ✅      │ ✅        │
│ EC1          │ ✅           │ ✅      │ ✅        │
│ EC2          │ ✅           │ ✅      │ ✅        │
│ EH1          │ ✅           │ ✅      │ ✅        │
│ EH2          │ ✅           │ ✅      │ ✅        │
│ PC1          │ ✅           │ ✅      │ ✅        │
│ PC2          │ ✅           │ ✅      │ ✅        │
│ SR1          │ ✅           │ ✅      │ ✅        │
│ SR2          │ ✅           │ ✅      │ ✅        │
└────────────────────────────────────────────────────────┘

📊 COMPLETION SCORE:
- Total Criteria: [COUNT]
- Implemented: [COUNT]
- Tested: [COUNT]
- Verified: [COUNT]

🎯 REQUIREMENT: ALL must be 100%

❌ IF ANY CRITERION IS NOT ✅✅✅:
   - DO NOT mark as complete
   - DO NOT update IMPLEMENTATION_STATUS.json
   - FIX the missing implementation
   - RE-RUN this audit
```

### **Step 12.1: Screen Completeness Verification (MANDATORY)**

**🚨 CRITICAL: Cross-check ALL screens from product spec**

```
📱 SCREEN COMPLETENESS AUDIT:

Feature: [FEATURE_NAME]
Source: lib/product/features/[feature-name]/spec.md

Step 1: Extract Required Screens from Spec
□ Opened spec.md file
□ Located "Screens" section (usually around line 40-50)
□ Listed EVERY screen mentioned
□ Counted total screens: [N]

Step 2: Verify Implementation
□ Checked lib/features/[feature]/presentation/pages/ directory
□ Counted implemented screens: [M]
□ Compared: M must equal N

Screen-by-Screen Verification:
┌──────────────────────────────────────────────────────────────┐
│ # │ Screen Name (from spec)  │ File Exists? │ Functional? │
├───┼──────────────────────────┼──────────────┼─────────────┤
│ 1 │ [Screen Name]            │ ✅/❌        │ ✅/❌       │
│ 2 │ [Screen Name]            │ ✅/❌        │ ✅/❌       │
│ 3 │ [Screen Name]            │ ✅/❌        │ ✅/❌       │
│ 4 │ [Screen Name]            │ ✅/❌        │ ✅/❌       │
│ 5 │ [Screen Name]            │ ✅/❌        │ ✅/❌       │
└──────────────────────────────────────────────────────────────┘

📊 SCREEN COMPLETION RATE: [M]/[N] = [X]%

🎯 REQUIREMENT: 100% (ALL screens must exist and be functional)

❌ BLOCKING CONDITIONS:
- If M < N: Feature is INCOMPLETE
- If any screen marked ❌: Feature is INCOMPLETE
- DO NOT mark feature as IMPLEMENTED
- DO NOT update FEATURE_STATUS.json to IMPLEMENTED
- CREATE missing screens before proceeding

✅ ONLY IF M = N AND ALL ✅:
- Feature screens are complete
- May proceed to mark as IMPLEMENTED
```

### **Step 12.2: Integration Completeness Verification (MANDATORY)**

**Verify ALL integration points from product spec**

```
🔗 INTEGRATION COMPLETENESS AUDIT:

Feature: [FEATURE_NAME]
Source: lib/product/features/[feature-name]/spec.md (Dependencies section)

Required Integrations (from spec.md):
┌──────────────────────────────────────────────────────────┐
│ # │ Integration Point      │ Implemented? │ Tested?   │
├───┼────────────────────────┼──────────────┼───────────┤
│ 1 │ [Integration name]     │ ✅/❌        │ ✅/❌     │
│ 2 │ [Integration name]     │ ✅/❌        │ ✅/❌     │
│ 3 │ [Integration name]     │ ✅/❌        │ ✅/❌     │
└──────────────────────────────────────────────────────────┘

Integration Details:
□ Authentication integration working
□ State management connected
□ Navigation routes configured
□ Database schema deployed
□ API endpoints accessible
□ Feature flags configured
□ Observability/logging active
□ Dependency injection setup

📊 INTEGRATION COMPLETION: [X]/[TOTAL] = [Y]%

🎯 REQUIREMENT: 100% (ALL integrations must work)

❌ IF ANY INTEGRATION MISSING:
- Feature is INCOMPLETE
- DO NOT mark as IMPLEMENTED
- COMPLETE missing integrations first
```

### **Step 12.3: Feature Completeness Percentage Calculation (MANDATORY)**

**Calculate exact completion percentage before marking IMPLEMENTED**

```
📊 FEATURE COMPLETENESS CALCULATION:

Feature: [FEATURE_NAME]
Date: [YYYY-MM-DD]

Component Inventory:
1. Screens/Pages:
   - Required (from spec.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

2. User Flows:
   - Required (from spec.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

3. Functional Requirements:
   - Required (from acceptance-criteria.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

4. Integration Points:
   - Required (from spec.md Dependencies): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

5. Tests:
   - Required (from test-scenarios.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

6. Edge Cases:
   - Required (from acceptance-criteria.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

7. Error Handling:
   - Required (from acceptance-criteria.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

8. Performance Criteria:
   - Required (from acceptance-criteria.md): [N]
   - Validated: [M]
   - Completion: [M/N × 100]%

9. Security Requirements:
   - Required (from acceptance-criteria.md): [N]
   - Implemented: [M]
   - Completion: [M/N × 100]%

📈 OVERALL FEATURE COMPLETION:
Formula: Average of all component completions
Result: [PERCENTAGE]%

🎯 IMPLEMENTATION STATUS RULES:
- 100%: Mark as IMPLEMENTED ✅
- 90-99%: INCOMPLETE - Missing critical elements ❌
- 80-89%: INCOMPLETE - Significant gaps ❌
- <80%: INCOMPLETE - Major work remaining ❌

🚨 CRITICAL RULE:
ONLY mark feature as IMPLEMENTED if completion = 100%
ANY percentage < 100% = Feature is INCOMPLETE

❌ IF COMPLETION < 100%:
1. DO NOT update FEATURE_STATUS.json to IMPLEMENTED
2. DO NOT update IMPLEMENTATION_STATUS.json with "completed"
3. IDENTIFY missing components from calculation above
4. CREATE/IMPLEMENT missing components
5. RE-RUN this calculation
6. ONLY proceed when 100% achieved
```

### **Step 13: Final Pre-Commit Verification (BLOCKING)**

**🚨 MANDATORY: All checks must pass before marking IMPLEMENTED**

```
✅ FINAL PRE-COMMIT CHECKLIST:

Product Spec Compliance:
□ ALL screens from spec.md implemented (100%)
□ ALL user flows from spec.md working (100%)
□ ALL dependencies from spec.md integrated (100%)
□ ALL success metrics from spec.md measurable

Acceptance Criteria Compliance:
□ ALL functional requirements implemented (100%)
□ ALL integration requirements working (100%)
□ ALL quality requirements met (100%)
□ ALL edge cases handled (100%)
□ ALL error scenarios implemented (100%)
□ ALL performance criteria validated (100%)
□ ALL security requirements satisfied (100%)

Implementation Completeness:
□ Feature completeness calculation = 100%
□ Screen completeness audit = 100%
□ Integration completeness audit = 100%
□ NO TODOs remaining in feature code
□ NO placeholder implementations
□ NO "implement later" comments

Code Quality:
□ Confidence score ≥ 75
□ ALL tests passing (0 failures)
□ Test coverage ≥ 80%
□ Flutter analyze: No issues found!
□ No lint errors
□ No lint warnings

Validation:
□ Performance validated against thresholds
□ Security validated against requirements
□ User experience validated (feature is usable)
□ Documentation updated

🎯 PASS CRITERIA: ALL boxes must be checked (✅)

❌ IF ANY BOX UNCHECKED:
- Feature is INCOMPLETE
- DO NOT proceed to commit
- DO NOT update FEATURE_STATUS.json
- DO NOT update IMPLEMENTATION_STATUS.json
- FIX missing items
- RE-RUN this checklist

✅ ONLY IF ALL BOXES CHECKED:
Proceed to Step 14: Commit and Status Update
```

### **Step 14: Commit and Status Update (Only if Step 13 passed)**

```
✅ Commit Checklist:

□ Step 13 Final Pre-Commit Verification: PASSED ✅
□ Feature completeness: 100% ✅
□ All screens implemented ✅
□ All integrations working ✅
□ Confidence score ≥ 75 ✅
□ ALL acceptance criteria implemented ✅
□ ALL tests passing ✅
□ Flutter analyze clean ✅
□ Documentation updated ✅

Status Updates:
□ Update product/FEATURE_STATUS.json: state = "IMPLEMENTED"
□ Update IMPLEMENTATION_STATUS.json with completion details
□ Add evidence to confidenceMetrics.evidence array
□ Document feature completion percentage (must be 100%)

Commit Message Template:
feat([FEATURE_ID]): Complete [Feature Name] implementation

Implemented:
- [All N screens from spec.md]
- [All M functional requirements]
- [All K integrations]
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

Completion: 100%
Screens: [N]/[N] (100%)
Tests: [X] passing
Coverage: [XX]%
Confidence: [XX]

Closes #[FEATURE_ID]
```

---

## 🚫 BLOCKING CONDITIONS - NEVER PROCEED IF

### **Product Layer Incomplete**
- ❌ Specifications missing or incomplete
- ❌ Acceptance criteria not fully defined
- ❌ Test scenarios not documented
- ❌ Risk assessment not performed

### **Requirements Not Met**
- ❌ ANY acceptance criterion not implemented
- ❌ ANY test scenario not written
- ❌ ANY edge case not handled
- ❌ ANY error scenario not implemented
- ❌ ANY performance criterion not met
- ❌ ANY security requirement not satisfied

### **Quality Issues**
- ❌ Flutter analyze shows errors
- ❌ ANY test failing
- ❌ Test coverage below 80%
- ❌ Performance below platform thresholds
- ❌ Lint errors exist in ANY file

### **Integration Issues**
- ❌ Feature not accessible from app
- ❌ Navigation not working
- ❌ Authentication broken
- ❌ State management not connected
- ❌ Database schema not deployed

### **Simplification Detected**
- ❌ Any requirement marked as "we can skip this"
- ❌ Any "simple version" proposed
- ❌ Any "implement later" suggestions
- ❌ Any edge cases ignored
- ❌ Any error handling omitted

---

## Code Quality Standards (MANDATORY)

### 🚫 **CRITICAL RULE: Zero Lint Errors Policy**

**NEVER move to create or edit another file if the current file has lint errors.**

#### Implementation Process:
1. **Create/Edit File** - Make changes to current file
2. **Run Flutter Analyze** - `flutter analyze` on current file
3. **Fix ALL Lint Errors** - Zero tolerance for lint issues
4. **Validate Clean State** - `flutter analyze` shows "No issues found!"
5. **Proceed to Next File** - Only after current file is clean

#### 🔴 **BLOCKING CONDITIONS**:
- ❌ **DO NOT** create new files if current file has lint errors
- ❌ **DO NOT** edit other files if current file has lint errors  
- ❌ **DO NOT** proceed to next implementation step if lint errors exist
- ❌ **DO NOT** commit code if any files have lint errors

#### ✅ **ALLOWED ACTIONS**:
- ✅ Fix lint errors in current file
- ✅ Run tests on current file
- ✅ Validate current file functionality
- ✅ Proceed to next file ONLY when current file is clean

### Flutter Analysis Compliance

- **use_super_parameters**: Use `super.parameter` syntax instead of explicit parameter passing
- **prefer_const_constructors**: Use `const` constructors whenever possible for performance
- **avoid_print**: Never use `print()` in production code - use proper logging instead
- **unused_import**: Remove all unused imports
- **dead_code**: Remove unreachable code
- **invalid_null_aware_operator**: Fix unnecessary null-aware operators
- **unnecessary_non_null_assertion**: Remove unnecessary non-null assertions

### Implementation Rules

1. **Constructor Optimization**

   ```dart
   // ❌ Bad
   class MyFailure extends Failure {
     const MyFailure(String message) : super(message);
   }
   
   // ✅ Good  
   class MyFailure extends Failure {
     const MyFailure(super.message);
   }
   ```

2. **Const Constructor Usage**

   ```dart
   // ❌ Bad
   return Left(ValidationFailure('Error message'));
   
   // ✅ Good
   return const Left(ValidationFailure('Error message'));
   ```

3. **Logging Standards**

   ```dart
   // ❌ Bad
   print('Debug message');
   
   // ✅ Good
   AppLogger.debug('Debug message', 'MyClass');
   // For standalone scripts, use simple print with context
   _logInfo('Debug message');
   ```

### Automated Validation

After each implementation:

1. Run `flutter analyze` - must show "No issues found!"
2. Run `flutter test` - all tests must pass
3. Check confidence score - must not drop below 75
4. Verify no new lint warnings introduced

---

## Best Practices & Anti-Patterns

### ✅ **DO: Best Practices**

1. **Implement First, Optimize Later**
   - Implement ALL requirements completely
   - THEN optimize if needed
   - NEVER skip requirements for "performance"

2. **Follow Acceptance Criteria Exactly**
   - Read each criterion word-by-word
   - Implement exactly as written
   - Ask for clarification if ambiguous
   - NEVER interpret as "optional"

3. **Test-Driven Development**
   - Write test for acceptance criterion
   - Implement to make test pass
   - Verify test passes
   - Move to next criterion

4. **Incremental Commits**
   - Commit after each complete acceptance criterion
   - Include test in commit
   - Document what criterion was implemented
   - Never commit incomplete implementations

5. **Error Handling Everywhere**
   - EVERY API call has error handling
   - EVERY user input is validated
   - EVERY edge case is handled
   - EVERY error has user-friendly message

6. **Performance by Design**
   - Use proper indexes on database
   - Implement lazy loading where appropriate
   - Cache expensive operations
   - Monitor and measure performance

7. **Security First**
   - Validate ALL inputs
   - Sanitize ALL outputs
   - Use proper authentication
   - Implement authorization checks
   - Encrypt sensitive data

### ❌ **DON'T: Anti-Patterns to Avoid**

1. **NEVER Simplify Requirements**
   - ❌ "This is too complex, let's simplify"
   - ❌ "We can skip this edge case"
   - ❌ "This error handling is overkill"
   - ✅ "I will implement exactly as specified"

2. **NEVER Skip Testing**
   - ❌ "I'll write tests later"
   - ❌ "This is too simple to test"
   - ❌ "Manual testing is enough"
   - ✅ "Every requirement has automated tests"

3. **NEVER Ignore Edge Cases**
   - ❌ "Users won't do that"
   - ❌ "This edge case is unlikely"
   - ❌ "We can handle this later"
   - ✅ "Every documented edge case is handled"

4. **NEVER Cut Corners on Security**
   - ❌ "We'll add security later"
   - ❌ "This is internal, security doesn't matter"
   - ❌ "Input validation is too slow"
   - ✅ "Security is implemented from day one"

5. **NEVER Assume Requirements**
   - ❌ "I think users want this instead"
   - ❌ "This is better than what's documented"
   - ❌ "The spec is wrong, I'll fix it"
   - ✅ "I implement exactly what's documented"

6. **NEVER Hide Issues**
   - ❌ "I'll fix this later"
   - ❌ "This test failure doesn't matter"
   - ❌ "Let's ignore this warning"
   - ✅ "I report and fix all issues immediately"

7. **NEVER Mark Incomplete as Complete**
   - ❌ "90% is good enough"
   - ❌ "We can finish the rest later"
   - ❌ "Close enough to acceptance criteria"
   - ✅ "100% of acceptance criteria or it's not done"

---

## Automatic Safety Nets

### **Confidence Drop Detection**
- Auto-pause if score drops >20 points
- Investigate cause of drop
- Fix issues before continuing
- Never proceed with low confidence

### **Rollback Triggers**
- Auto-revert on critical failures
- Restore last known good state
- Document what went wrong
- Plan fix before retrying

### **Progress Validation**
- Ensure real progress, not documentation churn
- Verify code changes match documentation
- Check tests actually validate requirements
- Confirm features are usable

### **Acceptance Criteria Compliance**
- Auto-check implementation against criteria
- Flag any missing implementations
- Block completion if criteria not met
- Require explicit acknowledgment

---
## 🚨 ESCALATION PROCEDURES (CONTINUATION)

### **When to Escalate**

If **ANY** of the following conditions occur, the AI agent **MUST STOP immediately** and escalate to the human owner (you):

1. **Ambiguous Requirements**

   * Acceptance criteria unclear or contradictory
   * Missing inputs, outputs, or constraints
   * Conflicting specs between Product Layer documents
     👉 **Action:**
   * Pause implementation
   * List ambiguities explicitly
   * Ask for clarification
   * Do **NOT** infer or "fix" the spec

2. **Specification Conflicts**

   * PRD contradicts Acceptance Criteria
   * Test scenarios conflict with specifications
   * Risk mitigation contradicts performance/security rules
     👉 **Action:**
   * Stop all coding
   * Report conflict with file references
   * Wait for authoritative resolution

3. **Unimplementable Requirement**

   * Requirement is technically impossible as written
   * Platform limitations prevent compliance
   * Third-party dependency blocks compliance
     👉 **Action:**
   * Provide a technical explanation
   * Propose **ONLY** spec-compliant alternatives
   * Await explicit approval before proceeding

4. **Confidence Score Collapse**

   * Confidence drops below **60**
   * Confidence fluctuates unpredictably
   * Confidence degradation cause unclear
     👉 **Action:**
   * Freeze progress
   * Diagnose root cause
   * Fix before proceeding

5. **Security or Safety Uncertainty**

   * Any doubt regarding data protection
   * Any uncertainty involving minors
   * Any AI safety ambiguity
     👉 **Action:**
   * Default to **maximum safety**
   * Escalate immediately
   * Do not experiment

---

## 🧠 AI AGENT BEHAVIORAL CONTRACT

### **Mandatory Agent Mindset**

The AI agent operating under this workflow is:

* ❌ **NOT** a junior developer
* ❌ **NOT** a fast prototype generator
* ❌ **NOT** a "good enough" implementer

✅ The agent **IS**:

* A **senior engineer**
* A **compliance-aware architect**
* A **pedagogical explainer**
* A **discipline enforcer**
* A **guardian of long-term maintainability**

---

## 🎓 Pedagogical Obligation (VERY IMPORTANT)

After **EVERY story**, the AI agent **MUST** provide an explanation section.

### **Mandatory Post-Story Explanation**

```
📘 STORY IMPLEMENTATION EXPLANATION

Story ID: [STORY_ID]
Epic: [EPIC_NAME]

1. Purpose of This Story
   - Why this story exists
   - What problem it solves in the product

2. What Was Implemented
   - Domain logic
   - Data flow
   - UI behavior
   - Side effects

3. File-by-File Breakdown
   - File name → Responsibility
   - Why this file exists
   - How it collaborates with others

4. Architectural Alignment
   - Clean Architecture layer mapping
   - Dependency direction validation
   - Why this design was chosen

5. Acceptance Criteria Mapping
   - AC → Code → Test mapping
   - Proof that nothing was skipped

6. Common Mistakes Avoided
   - What shortcuts were NOT taken
   - What anti-patterns were explicitly avoided

7. Future Impact
   - How this affects future features
   - What would break if done incorrectly

8. Confidence Assessment
   - Current confidence score
   - What improved it
   - What could reduce it in future
```

👉 **This explanation is NOT OPTIONAL.**
It is part of the Definition of Done.

---

## 📊 Confidence Scoring Model (Formalized)

### Confidence Score Factors

| Dimension                      | Weight |
| ------------------------------ | ------ |
| Acceptance Criteria Coverage   | 30%    |
| Test Coverage & Quality        | 25%    |
| Architectural Integrity        | 15%    |
| Error & Edge Case Handling     | 15%    |
| Performance Compliance         | 10%    |
| Code Readability & Cleanliness | 5%     |

### Confidence Interpretation

* **90–100** → Exceptional, production-grade
* **75–89** → Acceptable, safe to proceed
* **60–74** → Warning, proceed with caution
* **< 60** → 🚫 STOP IMMEDIATELY

---

## 🧭 Workflow Position Awareness

At all times, the AI agent must be able to answer:

* Which **Epic** am I in?
* Which **Story** am I implementing?
* Which **Acceptance Criterion** am I working on?
* Which **Layer** am I touching?
* Which **Test** validates this?

If the agent **cannot answer instantly**, it must stop.

---

## 🧩 Clean Architecture Enforcement (Flutter)

The workflow **MUST** respect Flutter Clean Architecture:

```
presentation/
  ├── pages/
  ├── widgets/
  ├── blocs/
domain/
  ├── entities/
  ├── usecases/
  ├── repositories/
data/
  ├── models/
  ├── datasources/
  ├── repositories/
```

🚫 **Forbidden:**

* Business logic in UI
* API calls in BLoC
* Data models used in UI
* UI imports in domain layer

---

## 🧪 Test Philosophy (Non-Negotiable)

* Tests are **evidence**, not decoration
* A feature without tests **does not exist**
* Passing tests are required, but **insufficient**
* Tests must **prove compliance**, not coverage vanity

---

## 🧠 Final Rule (The "Professor Rule")

> If the implementation cannot be explained clearly to a student **after it is written**, it is considered **incorrect**, even if it works.

Readable > clever
Explicit > implicit
Correct > fast

---

---

## 🔄 WORKFLOW INTEGRATION & AUTO-TRANSITIONS

### Smart Implementation → Automatic Validation Loop

After completing implementation, **automatically trigger validation and loop until valid**:

```text
✅ IMPLEMENTATION COMPLETION TRIGGERS

If implementation is COMPLETE:
  ✅ All acceptance criteria implemented
  ✅ All tests passing (≥95% pass rate)
  ✅ All screens/pages created
  ✅ All integrations complete
  ✅ Performance targets met
  ✅ Security requirements satisfied
  
  → TRIGGER: /validate-implementation (MANDATORY)
  
  Reason: Validate that implementation matches ALL specifications
  Action: Run /validate-implementation to audit the work
  Expected: Confidence score ≥75 before marking IMPLEMENTED

If implementation is PAUSED or INCOMPLETE:
  ⚠️ Some acceptance criteria pending
  ⚠️ Some tests failing
  ⚠️ Some screens missing
  ⚠️ Some integrations incomplete
  
  → NEXT WORKFLOW: /continue-implementation
  
  Reason: Resume from exact stopping point with context restoration
  Action: Run /continue-implementation to safely resume
  Expected: Complete one phase, update tracking, stop for next session
```

### Validation Loop: Auto-Continue Until Valid

**CRITICAL: Smart Implementation triggers an automated validation loop**:

```text
🔄 AUTOMATED VALIDATION LOOP

Step 1: Implementation Complete
  ↓
Step 2: Trigger /validate-implementation
  ├─ Confidence ≥75? → DONE (Mark IMPLEMENTED)
  └─ Confidence <75? → Continue to Step 3

Step 3: Trigger /continue-implementation
  ├─ With validation findings as input
  ├─ Fix identified gaps
  ├─ Complete missing items
  ├─ Correct incorrect implementations
  └─ Update all tracking files

Step 4: Re-trigger /validate-implementation
  ├─ Confidence ≥75? → DONE (Mark IMPLEMENTED)
  └─ Confidence <75? → Loop back to Step 3

Loop continues UNTIL:
  ✅ Validation passes (Confidence ≥75)
  ✅ Feature marked as IMPLEMENTED
  ✅ Ready for VERIFIED state

🚫 BLOCKING RULE:
- Feature CANNOT be marked IMPLEMENTED without validation passing
- Validation CANNOT pass with Confidence <75
- Loop MUST continue until validation succeeds
- No shortcuts or manual overrides allowed
```

### Validation Loop Orchestration

**The loop is orchestrated automatically by workflows**:

```text
🎼 AUTOMATED LOOP ORCHESTRATION

Smart Implementation:
  └─ On completion: Trigger /validate-implementation

Validate Implementation:
  ├─ If PASSES (≥75): Mark IMPLEMENTED, STOP
  └─ If FAILS (<75): Trigger /continue-implementation with findings

Continue Implementation:
  ├─ Fix identified gaps
  ├─ Complete missing items
  ├─ Correct implementations
  └─ On completion: Trigger /validate-implementation (loop back)

Session Orchestrator:
  ├─ Detects validation failure
  ├─ Prepares context for continue-implementation
  ├─ Ensures seamless loop continuation
  └─ Monitors loop progress

Context Manager:
  ├─ Captures state at each loop iteration
  ├─ Preserves gap analysis results
  ├─ Maintains loop context
  └─ Enables perfect resumption if interrupted

Performance Optimizer:
  ├─ Tracks total loop time
  ├─ Detects loop inefficiencies
  ├─ Suggests optimizations
  └─ Monitors iteration times
```

### Loop Termination Conditions

**The loop terminates ONLY when**:

```text
✅ SUCCESSFUL TERMINATION:
  ✅ Validation passes (Confidence ≥75)
  ✅ All acceptance criteria verified
  ✅ All tests passing
  ✅ All screens/pages present
  ✅ All integrations complete
  ✅ Performance targets met
  ✅ Security requirements satisfied
  ✅ Feature marked as IMPLEMENTED
  ✅ Ready for VERIFIED state

❌ ESCALATION (if loop stalls):
  ❌ Same gap found 3+ iterations
  ❌ Confidence not improving
  ❌ Blocker cannot be resolved
  ❌ External dependency missing
  → Escalate to user with full context
  → Provide detailed findings and recommendations
  → Await user decision before continuing
```

### Context Handoff to Validation

**Before triggering validation, prepare context package:**

```text
📦 CONTEXT HANDOFF PACKAGE

Prepared for: /validate-implementation

Current State:
□ IMPLEMENTATION_STATUS.json updated with current progress
□ All modified files saved and committed
□ Test results captured
□ Performance metrics recorded
□ Session memory updated with completion status

Validation Expectations:
□ Validate against lib/product/features/[feature]/spec.md
□ Validate against lib/product/features/[feature]/acceptance-criteria.md
□ Validate against lib/product/features/[feature]/test-scenarios.md
□ Check all screens/pages exist
□ Verify all integrations complete
□ Confirm performance targets met
□ Ensure security requirements satisfied

Confidence Target: ≥75 for IMPLEMENTED status
```

### Integration with Context Manager

**Automatically invoke context management:**

```text
🧠 CONTEXT MANAGEMENT INTEGRATION

During Implementation:
□ /context-manager auto-captures state every 5 minutes
□ Session context saved with implementation progress
□ Mental model of current work preserved
□ Next steps documented for resumption

On Implementation Completion:
□ Final context snapshot created
□ Session summary recorded
□ Performance metrics captured
□ Learnings documented for future sessions
□ Context ready for /validate-implementation handoff
```

### Integration with Performance Optimizer

**Real-time performance monitoring during implementation:**

```text
⚡ PERFORMANCE MONITORING INTEGRATION

Continuous Monitoring:
□ /performance-optimizer tracks implementation time
□ Detects bottlenecks in development process
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
- Test execution: <5 seconds
- File access: <50ms
- Context switches: <10 seconds
- Overall task completion: 3+ tasks/hour
```

---

## ✅ FINAL STATUS

This workflow is now:

* ✔ Compatible with **BMAD**
* ✔ Compatible with **Flutter Clean Architecture**
* ✔ Safe for **AI agents**
* ✔ Suitable for **long-lived products**
* ✔ Pedagogical by design
* ✔ Resistant to shortcutting
* ✔ **Integrated with Session Orchestrator**
* ✔ **Auto-triggers validation on completion**
* ✔ **Seamlessly hands off to Continue Implementation**
* ✔ **Leverages Context Manager for perfect continuity**
* ✔ **Optimized by Performance Optimizer**
* ✔ Ready for real development