---
name: DecisionCascadeGovernancePolicy
description: Authoritative governance policy for System-1/System-2 Decision Cascade, Sub-85% Low-Confidence Triage, Standalone Gate 2A Documentation Checkpoint, and Pre-Push Clean State switch reset.
globs: "*"
---
# File: DecisionCascadeGovernancePolicy.md

Module: DecisionCascadeGovernancePolicy
Purpose: Authoritative governance policy for System-1/System-2 Decision Cascade, Sub-85% Low-Confidence Triage, Standalone Gate 2A Documentation Checkpoint, and Pre-Push Clean State switch reset.
Path: .agents/rules/DecisionCascadeGovernancePolicy.md
Authors: Rolf, LCM_AI Engine
Version: 10.2.1
Status: Authoritative Invariant Rule
Date: 2026-11-12 09:30:00

---

## 1. Quick-Reference Invariants Table

| Rule ID | Name | Domain | Core Invariant |
|:---|:---|:---|:---|
| `RULE-DEC-001` | **Decision Cascade Architecture** | System-1 / System-2 Execution | Zero-latency Stage 0 pre-gate, bounded Stage 1 decider client ($\le 1500\text{ms}$), and zero-regression Stage 2 fallback. |
| `RULE-DEC-002` | **Sub-85% Low-Confidence Triage Invariant** | Operator Observability | Model confidence $< 85\%$ must never be silently discarded; surfaces explicit `noul` reasoning and operator triage choices. |
| `RULE-DEC-003` | **Gate 2A Standalone Documentation Checkpoint** | Pre-Commit Stabilization | Independent documentation completeness & consistency audit prior to final visual code review (Gate 2B / Beyond Compare 5). |
| `RULE-DEC-004` | **Gate 2A Automated Bypass Conditions** | Friction-Free Velocity | Automatic bypass for low-significance / mechanical changes and rapid-iteration minimal-testing cycles (`-MinimalTests`). |
| `RULE-DEC-005` | **Pre-Push Clean State & Relief Switch Reset** | Remote Synchronization | Remote `PUSH` deactivates all development relief switches (`minimal-tests`, `coarse` review, `doit` flow mode); blocks unverified `[minimal-tests]` proposals. |

---

## 2. Rule Specifications

### RULE-DEC-001: Multi-Stage System-1 Decision Cascade Architecture
1. Any automated proposal or code evaluation tool shall coordinate through the single orchestrator entry point (`Invoke-LcmDecisionGate.ps1`).
2. **Stage 0 (Deterministic Pre-Gate)**: Executes pure, zero-latency PowerShell validation (YAML frontmatter, scope boundaries, NTFS junction integrity, elevation governance). Hard violations immediately halt execution with exit code 1 without invoking remote services.
3. **Stage 1 (System-1 Decider Client)**: Encapsulates `/v1/systemone` HTTP protocol (`noul`, `choice`, `score`). Enforces a strict timeout of $\le 1500\text{ms}$. If unconfigured, offline, or timed out, execution transparently delegates to Stage 2.
4. **Stage 2 (System-2 Fallback Adapter)**: Executes baseline LCM deterministic quality gates (`Test-RepoReadiness.ps1` / `Test-GeneralReadiness.ps1`), guaranteeing zero functional regression.

### RULE-DEC-002: Sub-85% Low-Confidence Operator Triage Invariant
1. When the System-1 decider produces a confidence score below the threshold ($< 0.85$), the orchestrator shall NOT silently mask or discard the model's reasoning.
2. The orchestrator must surface an explicit diagnostic banner displaying:
   - Proposal ID and target repository.
   - LEV recommendation (`Approve`, `Reject`, `Defer`).
   - Confidence percentage.
   - `noul` plain-English justification chain.
3. In interactive mode, the operator shall be offered the explicit choices:
   - **[1] Accept LEV Decision**: Concur with model skepticism and halt for refinement.
   - **[2] Operator Override**: Certify the change as intentional and force approval.
   - **[3] Fallback to System-2**: Escalate to deterministic AST and quality gate evaluation.

### RULE-DEC-003: Standalone Gate 2A Documentation Checkpoint
1. Before entering the final visual Beyond Compare review (Gate 2B) and committing code locally, the proposal shall pass a dedicated **Gate 2A: Documentation Completeness & Consistency Check**.
2. Gate 2A verifies:
   - **Tripartite Proposal Alignment** (`RULE-DOC-001`): `Specification.md`, `Implementation_Plan.md`, and `Walkthrough.md` exist and match the actual implementation.
   - **Empirical Evidence Invariant**: `Walkthrough.md` contains verified console test output and pass counts (no placeholder or synthetic claims).
   - **Caveats & Rationale Synchronization** (`RULE-DOC-011`): Architectural compromises or known limitations are documented.
   - **Header Timestamp Parity** (`RULE-DOC-010`): All modified source files and markdown documents carry current `YYYY-MM-DD HH:mm:ss` timestamps.
3. **Semantic-Delta Restart Trigger (`RULE-LCM-025`)**: If Gate 2A reveals unaddressed rough edges, ambiguity, or architectural drift, the operator or agent shall pause code completion, clean up the specification, and execute a semantic-delta restart rather than committing half-baked work.

### RULE-DEC-004: Gate 2A Automated Bypass Conditions
To eliminate friction and prevent reviewing irrelevant details, Gate 2A shall be automatically bypassed under two explicit conditions:
1. **Low-Significance / Mechanical Changes**:
   - Changes with zero contract, interface, or behavioral impact (e.g., internal variable renames, comment adjustments, formatting, or 2-attempt mechanical bug fixes per `RULE-REV-002`).
   - Gate 2A auto-passes with: `[GATE 2A: BYPASSED] Low-significance mechanical change; no contract impact.`
2. **Minimal-Testing Cycles (`RULE-LCM-023`)**:
   - When `-MinimalTests` is active, or the proposal is in `completed [minimal-tests]` state.
   - Gate 2A auto-passes with: `[GATE 2A: DEFERRED] Minimal testing active; documentation polishing deferred until final verification.`

### RULE-DEC-005: Pre-Push Clean State & Relief Switch Reset Invariant
1. **Zero-Bypass on Remote Push**: At the time of `PUSH` (`Invoke-LCM_Push.ps1`), *there are no irrelevant documentation aspects*. Gate 2A is strictly enforced with zero bypasses allowed.
2. **Interactive Pre-Publish Triage**: If Relief Mode is active or any proposal carries minimal-test debt (`completed [minimal-tests]` or `quality_checks_deferred: true`) at publish time, `Invoke-LCM_Push.ps1` shall not silently bypass or abruptly fail. It must present the four-choice pre-publish triage:
   - `[1] Force Requalification`: Executes the transparent Stepwise Requalification Pipeline to bring all code and proposals into full qualification before push.
   - `[2] Circumvent / Force Push`: Temporarily bypasses preflight gating with an explicit audit receipt (`-BypassReliefGate` / `-ForceRelief`).
   - `[3] Continue (May Fail)`: Proceeds without altering state; fails downstream if unresolvable blockers remain.
   - `[4] Cancel`: Immediately aborts the publish pipeline, leaving git working trees and relief switches untouched.
3. **Stepwise Requalification & Dynamic Remediation Invariant**:
   - Requalification shall not be executed as an opaque, silent black box. It must execute as a transparent Directed Acyclic Graph (DAG) with discrete, numbered steps and real-time operator progress feedback (`[1/5] Reset Switches`, `[2/5] AST & Syntax Gate`, `[3/5] Quality Gates`, `[4/5] Proposal State Upgrade`, `[5/5] Push Hand-off`).
   - If any step encounters a failure, syntax drift, or quality gate violation, the pipeline shall **dynamically inject an interactive remediation step (`Step X.a`)** offering targeted resolution choices (`[Auto-Remediate]`, `[Inspect]`, `[Retry]`, `[Skip/Defer]`, `[Abort]`) rather than terminating with an unhandled fatal exception.
4. **Automated Relief Switch Reset**: Successfully executing a remote push shall automatically reset all temporary development relief switches across the workspace:
   - `review_granularity` $\rightarrow$ `tight` (clearing `coarse`).
   - `flow_mode` $\rightarrow$ `standard` (clearing `doit`).
   - `always_proceed` $\rightarrow$ `$false`.
   - `testing_mode` $\rightarrow$ `active`.
   - `minimal_tests` $\rightarrow$ `$false`.
5. This guarantees that post-push, the workspace immediately reverts to a pristine, fully guarded, zero-assumption baseline.
