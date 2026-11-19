# File: GoalFirstDesignPolicy.md

Module: .claude/rules/process/GoalFirstDesignPolicy.md  
Purpose: Claude adapter projection of GoalFirstDesignPolicy (target state, Gate 0 Contract, discrepancy-led refinement, traceability, safeguard preservation) and its binding to Claude plan mode.  
Path: LCM_AI/.claude/rules/process/GoalFirstDesignPolicy.md  
Source: .agents/rules/GoalFirstDesignPolicy.md v10.2.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-GOAL-001** Before structural change, architecture or implementation, the target state MUST be defined; a symptom MUST be traced to it before a correction is chosen.
- **RULE-GOAL-002** Gate 0 Contract = Target State; Invariants and Exit Criteria; Explicit Non-Goals. Ordinary evidently scoped BUG/CRP: title or request supplies the target state, and the binding core invariant applies: "Cause no havoc: ask rather than invent or infer, and avoid unnecessary complexity." Explicit Non-Goals exclude work to prevent lateral scope expansion. The written Gate 0 Contract is triggered by context: `BUG` -> no Gate 0 pause (target inherent in the defect); `DOIT` -> target authorized by `do`, run continuously to Gate 2 (never through it); `CRP` in standard flow -> written contract only for structural, cross-cutting, materially ambiguous or scope-expanding work whose target is not evident; if missing, pause at the planning boundary until accepted.
  - [Claude] Planning boundary = Claude plan mode: enter it for the `CRP` case above, present the Gate 0 Contract, implement only after approval; the operator may request plan mode any time.
- **RULE-GOAL-003** Doc gaps, rule tensions, lifecycle inconsistencies and failed assumptions MUST be recorded as discrepancies (cause, owner, next design cycle), never patched speculatively. [Claude] Sink: `translation/FINDINGS.md`.
- **RULE-GOAL-004** Every design step, change, verification and review disposition MUST name the Gate 0 clause it serves; untraceable work leaves scope or enters via a revised contract.
- **RULE-GOAL-005** Goal-First never bypasses proposal intake, lifecycle controls, verification, Gate 2 BCR, commit review or publication safeguards.
- Design cycle: (1) establish/revise Gate 0; (2) identify discrepancy; (3) smallest traceable candidate; (4) implement and verify only the accepted candidate; (5) record exit-criteria result or start next cycle.
