# File: AnalysisGovernancePolicy.md

Module: .claude/rules/process/AnalysisGovernancePolicy.md  
Purpose: Claude adapter projection of AnalysisGovernancePolicy (Check 0, read-only analysis mode, provenance, search fencing, implementation transition, circuit breaker, analysis artifacts).  
Path: LCM_AI/.claude/rules/process/AnalysisGovernancePolicy.md  
Source: .agents/rules/AnalysisGovernancePolicy.md v10.2.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:29:19

---

- **RULE-ANA-000** Step 0 before any analysis level: compare the active rule source with `LCM_AI/.agents/rules/`. Junction-linked native sources: verify junction resolution and content integrity. Translated host adapters (e.g. `.claude/rules/`, RULE-AUTH-004): verify baseline commit equality, tier mapping and the adapter drift check, not byte hashes. Record exactly `Check 0: OK` / `not found` / `mismatch`; not OK halts downstream comparisons; artifacts record paths, linkage, counts, marker. [Claude] Adapter drift check: see FINDINGS F-45 / F-51.
- **RULE-ANA-001** `ANALYZE` locks `READ_ONLY_ANALYSIS`: no file modification tools, destructive shell or Git mutation; model first (entities, state, actions/transitions, constraints); no code diffs or commit proposals. Expected in `suggested` and at Gate 1 / Gate 2 pauses. [Claude] `ANALYZE` = enter plan mode (read-only).
- **RULE-ANA-002** Analysis output contract: (1) structured model; (2) evidence with tags `[VERIFIED: <file#line>]`, `[INFERRED]`, `[GAP: <missing>]`; (3) settled facts / retired hypotheses; (4) end with 2-3 options (A/B/C) and pause.
- **RULE-ANA-003** Search depth <= 2 levels from the target component root; at most 3 primary matches per query; never traverse unrelated sibling repos. [Claude] Use Grep/Glob `path` = component root and `head_limit` 3.
- **RULE-ANA-004** Only `IMPLEMENT` (or `do <ID>`) moves to `GOVERNED_IMPLEMENTATION`, bound to the settled path and an accepted Gate 0 Contract; no implementation CRPs during analysis. [Claude] `IMPLEMENT` = plan approval / exit plan mode.
- **RULE-ANA-005** Circuit breaker: missing API/symbol, inaccessible path/dependency, or need to invalidate a verified consensus -> HALT, drop to analysis, emit the `### [ANALYSIS RESUMED] - Implementation Block Encountered` block (Encountered Block, Impact, Options A/B/C); record the failed assumption as a discrepancy; no reactive patch.
- **RULE-ANA-006** Registers in `LCM_Inventory/data/session_state/active_session.json` (mirrored in `.agents/ACTIVE_SESSION.md`) / Control Hub: `LCM_OperatingMode`, `LCM_ActiveGate`, `LCM_SearchRadius` (<= 2), `LCM_SettledFacts`, `LCM_OpenHypotheses`, `LCM_CircuitBreaker`. [Claude] Claude does not write the JSON register.
- **RULE-ANA-007** Analysis artifacts needed later are retained in the session workspace `files/` (not temp), kept until disposal is requested or follow-ups finish; regenerated artifacts state timestamp, scope, method; provide a compact visualization preserving source locations. [Claude] `files/` = session scratchpad is ephemeral; durable artifacts go to `LCM_Inventory/data/analysis/` per ANA-009 (FINDINGS F-31).
- **RULE-ANA-008** Definitions (`CON-nnn-Lnn`, steps `-Smmm`) are operator-editable; runs (`-Rnnn`) immutable; public parameter gates traceable; purpose comments are semantic evidence; internal control flow is navigational; parse limitations recorded, syntax failures halt; `if`/`elseif`/`else` branch records with kind, index, extent; presence-only checks are safety nets; `try`/`trap`/`switch` deferred.
- **RULE-ANA-009** Runs in `LCM_Inventory/data/analysis/history/`, definitions in `.../definitions/`; full provenance minimum; never overwrite (next `Rnnn`); presentation artifacts regenerable; major release M cleans unreferenced evidence older than M-2.
