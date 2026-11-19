# File: DecisionCascadeGovernancePolicy.md

Module: .claude/rules/process/DecisionCascadeGovernancePolicy.md  
Purpose: Claude adapter projection of DecisionCascadeGovernancePolicy (System-1/System-2 cascade, low-confidence triage, Gate 2A, pre-push clean state).  
Path: LCM_AI/.claude/rules/process/DecisionCascadeGovernancePolicy.md  
Source: .agents/rules/DecisionCascadeGovernancePolicy.md v10.2.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-DEC-001** Automated evaluation runs through `Invoke-LcmDecisionGate.ps1`: Stage 0 deterministic pre-gate (hard violations exit 1), Stage 1 System-1 client `/v1/systemone` (<= 1500 ms, else Stage 2), Stage 2 deterministic gates (`Test-RepoReadiness.ps1` / `Test-GeneralReadiness.ps1`). [Claude] Quality audit runs without LEV (WORKPLAN D-06).
- **RULE-DEC-002** Confidence < 0.85: never discard; show banner (ID, repo, LEV recommendation, confidence, `noul` reasoning); interactive choices [1] accept LEV, [2] operator override, [3] fall back to System-2.
- **RULE-DEC-003** Gate 2A before Gate 2B (BC5): tripartite proposal docs exist and match; `Walkthrough.md` has real test output; caveats/rationale (RULE-DOC-011); header timestamps current (RULE-DOC-010); rough edges -> semantic-delta restart (RULE-LCM-025).
- **RULE-DEC-004** Gate 2A auto-bypass for low-significance mechanical changes (`[GATE 2A: BYPASSED] ...`) and minimal-testing cycles (`-MinimalTests` active, or `state: completed` with `test_scope: minimal`; `[GATE 2A: DEFERRED] ...`).
- **RULE-DEC-005** At PUSH Gate 2A has zero bypass. With relief mode or minimal-test debt (`test_scope: minimal`, `quality_checks_deferred: true`), `Invoke-LCM_Push.ps1` offers [1] Force Requalification (visible numbered DAG with injected remediation steps), [2] Circumvent with audit receipt, [3] Continue, [4] Cancel. A successful push resets `review_granularity` -> `tight`, `flow_mode` -> `standard`, `always_proceed` -> false, `testing_mode` -> active, `minimal_tests` -> false.
