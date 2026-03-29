# Risk Assessment Template

**Feature**: [Feature Name]  
**Version**: 1.0.0  
**Created**: YYYY-MM-DD

---

## 🚨 Risk Categories

Risks are categorized by type and severity (Critical, High, Medium, Low).

---

## 🔴 Critical Risks

### Risk-C1: [Risk Title]
- **Description**: [Detailed description of the risk]
- **Probability**: [High/Medium/Low]
- **Impact**: [Severe/Major/Moderate/Minor]
- **Severity**: Critical
- **Mitigation Strategy**: [How to prevent or mitigate]
- **Contingency Plan**: [What to do if it happens]
- **Owner**: [Team member responsible]

### Risk-C2: [Risk Title]
- **Description**: [Detailed description of the risk]
- **Probability**: [High/Medium/Low]
- **Impact**: [Severe/Major/Moderate/Minor]
- **Severity**: Critical
- **Mitigation Strategy**: [How to prevent or mitigate]
- **Contingency Plan**: [What to do if it happens]
- **Owner**: [Team member responsible]

---

## 🟠 High Risks

### Risk-H1: Performance Degradation Under Load
- **Description**: Feature may become slow when many users access simultaneously
- **Probability**: Medium
- **Impact**: Major - Users experience poor performance
- **Severity**: High
- **Mitigation Strategy**: 
  - Implement caching strategy
  - Optimize database queries
  - Load test before launch
  - Set up auto-scaling
- **Contingency Plan**: 
  - Roll back feature if performance unacceptable
  - Implement rate limiting
  - Notify users of degraded service
- **Owner**: [Team member]

### Risk-H2: Data Loss or Corruption
- **Description**: User data could be lost or corrupted due to bugs or infrastructure failure
- **Probability**: Low
- **Impact**: Severe - Loss of user trust and data
- **Severity**: High
- **Mitigation Strategy**:
  - Implement comprehensive backups
  - Use database transactions
  - Thorough testing of data operations
  - Regular backup verification
- **Contingency Plan**:
  - Restore from backup
  - Notify affected users
  - Conduct root cause analysis
- **Owner**: [Team member]

### Risk-H3: Security Vulnerability
- **Description**: Feature could introduce security vulnerabilities (XSS, SQL injection, etc.)
- **Probability**: Medium
- **Impact**: Severe - User data compromise
- **Severity**: High
- **Mitigation Strategy**:
  - Security code review
  - Input validation and sanitization
  - Security testing
  - Dependency scanning
- **Contingency Plan**:
  - Immediate patch release
  - Security disclosure
  - User notification
- **Owner**: [Team member]

### Risk-H4: Integration Failure
- **Description**: Feature may not integrate properly with existing systems
- **Probability**: Medium
- **Impact**: Major - Feature doesn't work as intended
- **Severity**: High
- **Mitigation Strategy**:
  - Integration testing
  - API contract testing
  - Staging environment testing
  - Gradual rollout
- **Contingency Plan**:
  - Rollback feature
  - Fix integration issues
  - Retest before re-release
- **Owner**: [Team member]

---

## 🟡 Medium Risks

### Risk-M1: User Adoption Issues
- **Description**: Users may not adopt the feature due to complexity or poor UX
- **Probability**: Medium
- **Impact**: Moderate - Feature doesn't achieve business goals
- **Severity**: Medium
- **Mitigation Strategy**:
  - User research and testing
  - Clear documentation
  - Onboarding flow
  - User feedback collection
- **Contingency Plan**:
  - Iterate on UX based on feedback
  - Improve documentation
  - Provide training
- **Owner**: [Team member]

### Risk-M2: Third-Party Dependency Failure
- **Description**: External API or service dependency could become unavailable
- **Probability**: Low
- **Impact**: Major - Feature becomes unavailable
- **Severity**: Medium
- **Mitigation Strategy**:
  - Use reliable vendors with SLAs
  - Implement fallback mechanisms
  - Monitor dependency health
  - Have alternative providers identified
- **Contingency Plan**:
  - Switch to alternative provider
  - Implement offline mode if possible
  - Notify users
- **Owner**: [Team member]

### Risk-M3: Scope Creep
- **Description**: Feature scope may expand beyond original plan
- **Probability**: High
- **Impact**: Moderate - Delays and budget overruns
- **Severity**: Medium
- **Mitigation Strategy**:
  - Clear scope definition
  - Change control process
  - Regular scope reviews
  - Prioritization framework
- **Contingency Plan**:
  - Defer non-essential features
  - Adjust timeline
  - Communicate changes to stakeholders
- **Owner**: [Team member]

### Risk-M4: Compatibility Issues
- **Description**: Feature may not work on all supported browsers/devices
- **Probability**: Medium
- **Impact**: Moderate - Some users can't use feature
- **Severity**: Medium
- **Mitigation Strategy**:
  - Cross-browser testing
  - Device testing
  - Polyfills for older browsers
  - Progressive enhancement
- **Contingency Plan**:
  - Provide alternative implementation
  - Graceful degradation
  - Clear browser requirements
- **Owner**: [Team member]

---

## 🟢 Low Risks

### Risk-L1: Documentation Gaps
- **Description**: Documentation may be incomplete or unclear
- **Probability**: Medium
- **Impact**: Minor - Users need support
- **Severity**: Low
- **Mitigation Strategy**:
  - Documentation review process
  - User testing of documentation
  - Clear examples and screenshots
- **Contingency Plan**:
  - Update documentation based on feedback
  - Provide additional support
- **Owner**: [Team member]

### Risk-L2: Minor Performance Issues
- **Description**: Feature may have minor performance issues that don't affect usability
- **Probability**: High
- **Impact**: Minor - Slight slowness
- **Severity**: Low
- **Mitigation Strategy**:
  - Performance monitoring
  - Optimization as needed
  - User feedback collection
- **Contingency Plan**:
  - Optimize based on monitoring data
  - Communicate improvements
- **Owner**: [Team member]

---

## 📊 Risk Matrix

| Probability | Critical | High | Medium | Low |
|-------------|----------|------|--------|-----|
| High       | C1       | H3   | M1, M3 | L2  |
| Medium     | C2       | H1   | M2, M4 | L1  |
| Low        |          | H2   |        |     |

---

## 🔄 Risk Monitoring

- **Review Frequency**: Weekly during development, daily during launch
- **Escalation Criteria**: Any risk becomes more probable or impactful
- **Owner**: [Team lead]
- **Review Date**: [Date]
