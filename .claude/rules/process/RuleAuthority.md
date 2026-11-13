# File: RuleAuthority.md

Module: .claude/rules/process/RuleAuthority.md  
Purpose: Claude mapping of the LCM rule-authority policy (single source of truth, matrix synchronization, Goal-First alignment).  
Path: LCM_AI/.claude/rules/process/RuleAuthority.md  
Source: .agents/rules/RuleAuthority.md v10.2.1 @ 43e36b0  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 20:45:09

---

## Rules

- **RULE-AUTH-001** `LCM_AI\.agents\rules\` is the only authoritative rule source. Claude MUST NOT treat any `.claude/` rule as overriding it. [Claude] While `CLAUDE.md` carries the draft notice, this mapping is a sanctioned preliminary adaptation, not a fork (see FINDINGS F-01).
- **RULE-AUTH-002** Any rule change or new rule MUST update, in the same change set: `AGENTS.md` quick-reference, `LCM_AI/docs/LCM-Rules-Cross-Reference.md`, and verify visibility through all child `.agents\rules` junctions. [Claude] Phase 1: Claude does not change `.agents/rules`; it records needed rule changes in `translation/FINDINGS.md`.
- **RULE-AUTH-003** Gate 0 Contract and traceability are defined only in `GoalFirst` (see `GoalFirst.md`); no other rule may redefine a conflicting target state or bypass.
- `@RULEAUTH` activates and validates this policy (macro; mapping pending, see COVERAGE).
