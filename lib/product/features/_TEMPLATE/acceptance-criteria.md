# Acceptance Criteria — [Epic Name]

**Epic**: [Epic Name]  
**Version**: 1.0.0  
**Created**: YYYY-MM-DD  
**Source**: _bmad-output/planning-artifacts/epics.md

---

## ✅ Functional Requirements

### User-Visible Behaviors
- [ ] [AC-FR1] [Requirement from epic stories]
- [ ] [AC-FR2] [Requirement from epic stories]
- [ ] [AC-FR3] [Requirement from epic stories]

### Integration Requirements
- [ ] [AC-IR1] [Integration with other epics/features]
- [ ] [AC-IR2] [Integration with other epics/features]

---

## 🔍 Edge Cases

- [ ] [AC-EC1] When [edge case], [expected behavior]
- [ ] [AC-EC2] When [edge case], [expected behavior]
- [ ] [AC-EC3] When [edge case], [expected behavior]

---

## ⚠️ Error Handling

- [ ] [AC-EH1] When [error condition], system [expected behavior]
- [ ] [AC-EH2] When [error condition], system [expected behavior]
- [ ] [AC-EH3] When [error condition], system [expected behavior]

---

## 📊 Quality Requirements

### Performance
- [ ] [AC-QP1] Feature loads in <[X]ms (per platform thresholds)
- [ ] [AC-QP2] Database queries complete in <[X]ms
- [ ] [AC-QP3] UI interactions respond in <[X]ms

### Reliability
- [ ] [AC-QR1] Feature works offline (if applicable)
- [ ] [AC-QR2] Feature handles concurrent access correctly
- [ ] [AC-QR3] Feature recovers from [failure scenario]

### Accessibility
- [ ] [AC-QA1] Feature meets WCAG AA text contrast (NFR7)
- [ ] [AC-QA2] Minimum 44dp touch targets (NFR8)
- [ ] [AC-QA3] Screen reader support

---

## 🔐 Security Requirements

- [ ] [AC-SR1] No analytics, no telemetry, no third-party SDKs (NFR15)
- [ ] [AC-SR2] API keys via --dart-define only (NFR16)
- [ ] [AC-SR3] Input validation on all user inputs
- [ ] [AC-SR4] No sensitive data in logs

---

## 📱 Platform-Specific

- [ ] [AC-PS1] Works on Android with correct permissions
- [ ] [AC-PS2] Works on iOS with correct setup
- [ ] [AC-PS3] Handles platform-specific constraints

---

## 🧪 Testing Requirements

- [ ] [AC-T1] Unit tests cover ≥80% of new code
- [ ] [AC-T2] Integration tests cover critical paths
- [ ] [AC-T3] Widget tests cover all screens/pages
- [ ] [AC-T4] All tests passing before marking complete

---

## 📝 Cross-Reference

| Story ID | Acceptance Criteria Covered |
|----------|---------------------------|
| [X.1]    | AC-FR1, AC-FR2            |
| [X.2]    | AC-FR3, AC-IR1            |
| [X.3]    | AC-EC1, AC-EH1            |
