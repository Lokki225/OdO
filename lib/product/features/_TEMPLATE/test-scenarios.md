# Test Scenarios — [Epic Name]

**Epic**: [Epic Name]  
**Version**: 1.0.0  
**Created**: YYYY-MM-DD  
**Source**: _bmad-output/planning-artifacts/epics.md

---

## 🧪 Test Scenario Format

Each scenario includes:
- **Scenario ID**: Unique identifier (TS-[EPIC]-001, etc.)
- **Title**: Clear description of what is being tested
- **Layer**: Data / Domain / Presentation
- **Story**: Which story this validates
- **Preconditions**: State before test starts
- **Input**: Data or actions provided
- **Expected Output**: What should happen
- **Validation Rules**: How to verify success

---

## ✅ Data Layer Test Scenarios

### TS-[EPIC]-D01: [Data operation test]
- **Layer**: Data
- **Story**: [X.1]
- **Preconditions**: [Database state]
- **Input**: [Data operation]
- **Expected Output**: [Expected result]
- **Validation**: [How to verify]

### TS-[EPIC]-D02: [Model serialization test]
- **Layer**: Data
- **Story**: [X.1]
- **Preconditions**: [Model state]
- **Input**: [JSON/data input]
- **Expected Output**: [Correct model]
- **Validation**: [Field-by-field check]

---

## ✅ Domain Layer Test Scenarios

### TS-[EPIC]-DO1: [Use case happy path]
- **Layer**: Domain
- **Story**: [X.2]
- **Preconditions**: [Repository mock state]
- **Input**: [Use case parameters]
- **Expected Output**: [Expected result]
- **Validation**: [Business rule check]

### TS-[EPIC]-DO2: [Entity validation test]
- **Layer**: Domain
- **Story**: [X.2]
- **Preconditions**: [Entity creation]
- **Input**: [Invalid/edge case data]
- **Expected Output**: [Validation error]
- **Validation**: [Error type check]

---

## ✅ Presentation Layer Test Scenarios

### TS-[EPIC]-P01: [Widget renders correctly]
- **Layer**: Presentation
- **Story**: [X.3]
- **Preconditions**: [Widget mounted with mocked state]
- **Input**: [User action / state change]
- **Expected Output**: [UI state]
- **Validation**: [Widget test assertions]

### TS-[EPIC]-P02: [User interaction flow]
- **Layer**: Presentation
- **Story**: [X.3]
- **Preconditions**: [Screen loaded]
- **Input**: [User taps/swipes]
- **Expected Output**: [Navigation/state change]
- **Validation**: [Finder assertions]

---

## ⚠️ Edge Case Scenarios

### TS-[EPIC]-EC1: [Boundary value test]
- **Layer**: [Layer]
- **Story**: [X.N]
- **Preconditions**: [State]
- **Input**: [Boundary input]
- **Expected Output**: [Expected behavior]
- **Validation**: [How to verify]

---

## ❌ Error Scenarios

### TS-[EPIC]-ER1: [Error condition test]
- **Layer**: [Layer]
- **Story**: [X.N]
- **Preconditions**: [State]
- **Input**: [Error trigger]
- **Expected Output**: [Graceful handling]
- **Validation**: [Error message / recovery check]

---

## ⚡ Performance Scenarios

### TS-[EPIC]-PF1: [Performance threshold test]
- **Layer**: [Layer]
- **Story**: [X.N]
- **Preconditions**: [Data volume]
- **Input**: [Operation]
- **Expected Output**: Completes in <[X]ms
- **Validation**: [Timing measurement]

---

## 📊 Test Coverage Matrix

| Story | Data Tests | Domain Tests | UI Tests | Edge Cases | Total |
|-------|-----------|-------------|----------|------------|-------|
| [X.1] | [N]       | [N]         | [N]      | [N]        | [N]   |
| [X.2] | [N]       | [N]         | [N]      | [N]        | [N]   |
| [X.3] | [N]       | [N]         | [N]      | [N]        | [N]   |
| **TOTAL** | [N]   | [N]         | [N]      | [N]        | [N]   |
