---
paths:
  - "**/*.ps1"
  - "**/*.psm1"
  - "**/*.psd1"
---
# File: PowerShellRules.md

Module: .claude/rules/lang/PowerShellRules.md  
Purpose: Claude adapter projection of POWERSHELL-RULES (compact key list complementing PowerShellStandardsPolicy).  
Path: LCM_AI/.claude/rules/lang/PowerShellRules.md  
Source: .agents/rules/PowerShellRules.md v10.2.2 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 + BUG-365 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.5
Status: Draft  
Date: 2026-11-19 11:44:09

---

- **ps7-exclusive**, **intermediate-parity** (= RULE-PS-019).
- **inline-single-quotes** (= RULE-PS-016), **colon-safe-interpolation** (= RULE-PS-003/015).
- **mandatory-ast-syntax-gate**, **zero-assumption-testing** (= RULE-PS-021).
- **ascii-default**, **utf8-without-bom**, **newline-lf**, **no-non-ascii-identifiers** (= INVARIANT-RULES).
- **no-backticks** Backticks forbidden.
- **no-posix-backslash-escapes** (= RULE-PS-022), **null-on-left-in-comparisons** (= RULE-PS-023), **no-implicit-confirmation** (= RULE-PS-024).
- **no-interpolated-calls** No method calls inside interpolated strings.
- **assign-$_-first** (= RULE-PS-006), **no-hidden-state** No hidden pipeline or implicit variable use, **deterministic-output**.
