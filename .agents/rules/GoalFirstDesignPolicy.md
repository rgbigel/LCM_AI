---
name: GoalFirstDesignPolicy
description: Authoritative Goal-First design policy requiring a target-state contract, traceable design cycles, and explicit non-goals before structural implementation.
globs: "*"
---
# File: GoalFirstDesignPolicy.md

Module: GoalFirstDesignPolicy  
Purpose: Defines Goal-First execution, Gate 0 target-state contracts, discrepancy-led design refinement, and traceability from implementation work to an accepted target state.  
Path: .agents/rules/GoalFirstDesignPolicy.md  
Authors: Rolf, LCM_AI Governance  
Version: 10.2.1  
Status: Authoritative Policy  
Date: 2026-10-17

---

## 1. Purpose

LCM work begins with the intended completed state, not with a local symptom or an assumed patch. A reported error, friction point, or requested feature is evidence to investigate; it is not by itself a complete implementation assignment.

## 2. Invariant Rules

### RULE-GOAL-001 (Target-State-First Invariant)
Before proposing structural changes, designing an architecture, or implementing work, the responsible proposal, BUG, or analysis MUST define the intended target state. A local symptom MUST be traced to that target state before a corrective action is selected.

### RULE-GOAL-002 (Gate 0 Contract)
The Gate 0 Contract MUST state:
1. **Target State:** what must be observably true when the work is complete;
2. **Invariants and Exit Criteria:** the testable evidence that proves the target state;
3. **Explicit Non-Goals:** deliberately excluded work that prevents lateral scope expansion.

For an ordinary, evidently scoped BUG or CRP, the title, stated defect, or stated request may supply the target state and the following default Non-Goal applies without separate prose: **Cause no havoc: ask rather than invent or infer, and avoid unnecessary complexity.**

An explicit, written Gate 0 Contract is required only for structural, cross-cutting, materially ambiguous, or scope-expanding work. If that contract is missing, execution MUST pause at the planning boundary until the operator supplies or accepts it. This is a planning requirement, not a waiver of any later review gate.

### RULE-GOAL-003 (Discrepancy-Led Design Refinement)
Documentation gaps, rule tensions, lifecycle inconsistencies, and failed assumptions MUST be recorded as discrepancies with their known cause, owner, and next candidate design cycle. They MUST NOT cause speculative local patching or an unexplained terminal block.

### RULE-GOAL-004 (Traceable Execution)
Every design step, source change, verification, and review disposition MUST identify the Gate 0 target-state clause it serves. Work that cannot be traced to a target-state clause MUST be removed from the active scope or explicitly added through a revised Gate 0 Contract.

### RULE-GOAL-005 (Safeguard Preservation)
Goal-First execution does not bypass proposal-first intake, lifecycle state controls, verification, Gate 2 BCR, commit review, or publication safeguards. Goal-First refines why and what work is performed; existing governance controls determine when it may advance.

## 3. Required Design Cycle

1. Establish or revise the Gate 0 Contract.
2. Identify the material discrepancy between current and target state.
3. Produce the smallest traceable candidate design.
4. Implement and verify only the accepted candidate.
5. Record whether the exit criteria are met or begin the next design cycle.
