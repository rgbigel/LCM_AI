# File: MethodEfficiencyPolicy.md

Module: .claude/rules/quality/MethodEfficiencyPolicy.md  
Purpose: Claude adapter projection of MethodEfficiencyPolicy (mechanical artifacts, zero test cascades, DOIT velocity, gate short-circuiting, search dispatch, tool discovery, anti-code-reading, path safety, diagnostic triage).  
Path: LCM_AI/.claude/rules/quality/MethodEfficiencyPolicy.md  
Source: .agents/rules/MethodEfficiencyPolicy.md v10.2.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-EFF-001** Auto-accepted mechanical artifacts (no review gate): `**/data/artifacts/**`, `**/scratch/**`, `LCM_Inventory/data/inventory.json`, `LCM_Inventory/docs/INVENTORY_DASHBOARD.md`, `LCM_Inventory/data/baselines/*.json`, `LCM_Inventory/logs/*.log`, `*_Inventory/data/subsystem_inventory.json`, `*_Inventory/docs/SUBSYSTEM_DASHBOARD.md`, `*_Inventory/logs/*.log`, `*_Inventory/data/proposals/*.json`, `**/out/test_results.json`, routine test output, `.copilot/Logs/*.log`, `.agents/logs/*.log`.
- **RULE-EFF-002** Changes to those artifacts never trigger tests or validation cycles.
- **RULE-EFF-003** Never hand-edit `inventory.json`, `INVENTORY_DASHBOARD.md` or baseline snapshots; only CM tools (`Invoke-LCM_Audit.ps1`, `Create-LCM_Baseline.ps1`).
- **RULE-EFF-004** In DOIT mode execute tool operations and edits directly, without chat planning pauses or per-tool confirmations, up to Gate 2 (`BCR.cmd` / `Invoke-MacriumBcrReview.ps1`, RULE-REV-001/014; never past it); normal cycle via `Proceed` keeps interactive checkpoints; direct execution needs a Gate 0 Contract. [Claude] Per-tool prompts are governed by Claude permission settings (not configured yet; COVERAGE).
- **RULE-EFF-005** Gates run tiers in order (Structure -> Formatting -> GovernanceLinks -> ElevationConsistency -> DocumentationFabric -> PesterSuite) and abort on the first structural failure; never dispatch tests whose prerequisites are known to be missing.
- **RULE-EFF-006** Reserved.
- **RULE-EFF-007** File-name search MUST use `es.exe` (preferably `LCM_Inventory/tools/Search-Everything.ps1`); direct `es.exe` allowed in interactive desktop sessions, not in Session 0 / scheduled tasks; wrapper fallback order `es.exe` -> Everything HTTP (8080) -> scoped `Get-ChildItem`; content search `es.exe content:` when the index is healthy, else `rg.exe`. [Claude] Operator 2026-11-14: where Claude's built-in tools are not suited, run `es.exe` (and every other named external tool) through DO: `LCM_Inventory\DoT\do.exe "<command>" -sync`. Built-in Glob/Grep only as escape hatch, with the reason stated (large performance cost).
- **RULE-EFF-008** Tool discovery queries the authoritative catalog `LCM_Inventory/data/tools/tools.db` first (via `Show-ToolIntents.ps1`; `config/tool_catalog.json` transition fallback); no broad unindexed grep across `.ps1/.psm1/.cmd` for signatures. The enforcement section states the same.
- **RULE-EFF-009** Have an atomic goal before each tool call; resolve commands via `config/tool_intents.json`, the catalog or the database; never read tool source to discover how to run a tool; logs record name, arguments, outcome only. [Claude] Use the catalog and `-h`; reading source is allowed only when the source itself is the subject (BUG, analysis).
- **RULE-ENV-003** No speculative `..` paths; anchor to `$PSScriptRoot`, `LCM_Inventory/DoT/` trampolines, or an explicit `Resolve-Path`/`Test-Path` preflight.
- **RULE-EFF-010** On execution, daemon or UI-to-daemon failures run the 5-stage triage (context whodunit -> dispatch/transport on port 9876 -> handler execution -> procedural/lifecycle correctness -> architectural escalation: stop and report); no speculative loops, stop after attempt 2.
- Enforcement section: readiness runners treat logs/`out/` as non-invalidating; audit syncs may commit as `chore(audit)`/`chore(telemetry)`; direct execution mode applies under `DOIT` only - outside `DOIT`, Gate 1 pauses (RULE-LCM-014) and Gate 0 pauses (RULE-GOAL-002) stay binding.
