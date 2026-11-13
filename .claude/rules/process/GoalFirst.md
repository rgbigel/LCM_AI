# File: GoalFirst.md

Module: .claude/rules/process/GoalFirst.md  
Purpose: Claude mapping of Goal-First design (target state, Gate 0 Contract, discrepancy-led refinement, traceability, safeguard preservation) and its binding to Claude plan mode.  
Path: LCM_AI/.claude/rules/process/GoalFirst.md  
Source: .agents/rules/GoalFirstDesignPolicy.md v10.2.1 @ 43e36b0  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 21:09:25

---

## Rules

- **RULE-GOAL-001** Before structural change, architecture or implementation, the target state MUST be defined; a symptom MUST be traced to it before a correction is chosen.
- **RULE-GOAL-002** Gate 0 Contract = Target State, Invariants and Exit Criteria, Explicit Non-Goals.
  - Ordinary, evidently scoped BUG/CRP: title or request supplies the target state; default Non-Goal: "Cause no havoc: ask rather than invent or infer, and avoid unnecessary complexity."
  - Structural, cross-cutting, materially ambiguous or scope-expanding work requires a written Gate 0 Contract; without it execution MUST pause at the planning boundary until the operator supplies or accepts it.
  - [Claude] The planning boundary is realized as Claude plan mode. The trigger is the context, not the size of the change (operator, FINDINGS F-14):
    - BUG: the error is clear; no Gate 0 pause, no plan mode.
    - `DOIT`: the target is known; no Gate 0 pause; proceed to Gate 2 (never through it).
    - CRP in standard flow whose target state is not evident from title or request: Claude MUST enter plan mode and present the Gate 0 Contract; implementation starts only after operator approval.
    - The operator may request plan mode at any time.
- **RULE-GOAL-003** Doc gaps, rule tensions, lifecycle inconsistencies and failed assumptions MUST be recorded as discrepancies (cause, owner, next design cycle), never patched speculatively or left as an unexplained block. [Claude] Phase 1: record in `translation/FINDINGS.md`.
- **RULE-GOAL-004** Every design step, change, verification and review disposition MUST name the Gate 0 clause it serves; untraceable work leaves scope or enters via a revised contract.
- **RULE-GOAL-005** Goal-First never bypasses proposal intake, lifecycle controls, verification, Gate 2 BCR, commit review or publication safeguards.

## Design Cycle

1. Establish or revise the Gate 0 Contract.
2. Identify the discrepancy between current and target state.
3. Produce the smallest traceable candidate design.
4. Implement and verify only the accepted candidate.
5. Record whether exit criteria are met, or start the next cycle.
