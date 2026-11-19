# File: RuleAuthority.md

Module: .claude/rules/process/RuleAuthority.md  
Purpose: Claude adapter projection of RuleAuthority (single source of truth, multi-host adapters, matrix sync, Goal-First alignment, tri-tier architecture).  
Path: LCM_AI/.claude/rules/process/RuleAuthority.md  
Source: .agents/rules/RuleAuthority.md v10.3.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:29:19

---

- **RULE-AUTH-001** `LCM_AI\.agents\rules\` is the single authoritative rule source; no fork or conflicting local copy without an approved CR. Host adapters (Claude Code `.claude/`, Antigravity, Gemini, VS Code, Cursor) are sanctioned read-only projections if they: (1) cite an `LCM_AI` commit baseline, (2) keep 1:1 rule IDs, (3) confine host mechanics to explicit adapter annotations while canonical rules state the host-neutral intent, (4) are verified by host adapter drift checks (file inventories, baseline parity, rule code coverage; centralized automation in `LCM_Inventory/tools/Test-LCMRuleHealth.ps1` planned, currently adapter-specific checks), (5) follow the host-neutral session continuity of RULE-LCM-030 (`.agents/ACTIVE_SESSION.md`, `ACTIVE_CONTEXT.md`, `LEARNED_ADVICE.md`; host memory = pointers only). [Claude] Annotations are marked `[Claude]`; Claude's adapter-specific drift check: scratch `Test-ClaudeAdapterDrift.ps1` with `translation/CANONICAL_HASHES.md`; condition 5 met since 2026-11-14 (F-52 A).
- **RULE-AUTH-002** A rule change or new rule MUST, in the same change set, update: `AGENTS.md` quick reference; `LCM_AI/docs/LCM-Rules-Cross-Reference.md`; registered host adapters (`CLAUDE.md`, `.claude/rules/`, `GEMINI.md`); and verify child junction visibility with `LCM_Inventory/tools/Test-LCMRuleHealth.ps1`. [Claude] Claude does not edit `.agents/rules` in phase 1/2 drafting; it records needed changes in `translation/FINDINGS.md` and CRP amendments.
- **RULE-AUTH-003** Gate 0 Contract and traceability are defined only by GoalFirstDesignPolicy; no other rule may redefine a conflicting target state or bypass.
- **RULE-AUTH-004** Tri-tier rule architecture: `process/` (always active: RuleAuthority, GoalFirstDesignPolicy, ProposalReviewFlowPolicy, ReviewCommitGovernancePolicy, AnalysisGovernancePolicy, DecisionCascadeGovernancePolicy, RepositoryContextPolicy, ElevationPolicy, SubsystemGovernancePolicy, macro-definitions); `quality/` (always active: InvariantRules, LanguagePolicy, DocumentationStandardsPolicy, MethodEfficiencyPolicy); `lang/` (path-scoped; language rules take precedence over generic quality defaults: PowerShellStandardsPolicy/PowerShellRules, PythonRules, GoRules, CMDRules, JsonRules, DisplayStandardsPolicy). [Claude] Mirrored 1:1 by file name in `.claude/rules/{process,quality,lang}/`.
- `@RULEAUTH` activates and validates this policy. [Claude] No skill yet (COVERAGE).
