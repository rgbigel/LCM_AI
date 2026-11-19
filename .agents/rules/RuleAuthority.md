---
name: RuleAuthority
description: Authoritative governance hierarchy, single source of truth, and mandatory rule matrix synchronization policy.
globs: "*"
---
# File: RuleAuthority.md

Module: RuleAuthority  
Purpose: Defines canonical rule authority, governance hierarchy, multi-host adapter standards, and mandatory cross-reference synchronization across the workspace.  
Path: .agents/rules/RuleAuthority.md  
Authors: Rolf, LCM_AI Governance  
Version: 10.3.0  
Status: Authoritative Policy  
Date: 2026-11-14 22:25:00

---

## 1. Governance Authority Invariants

### `RULE-AUTH-001` (Single Source of Truth, Zero Rule Forking & Multi-Host Adapters)
- **Canonical Physical Hub**: `LCM_AI\.agents\rules\` is the single, authoritative physical host and primary commit gate for all LCM governance rules.
- **Root & Child Discovery**: The root workspace container links `D:\Git_Repositories\.agents\rules\` directly to `LCM_AI\.agents\rules\` via NTFS directory junction (`mklink /J`), avoiding rule commit churn on the root container. All governed child repositories link their local `.agents\rules` directory to this canonical hub.
- **No Independent Truth**: Child repositories and IDE adapter surfaces `MUST NOT` fork, maintain conflicting local copies, or override core governance policies without an approved Change Request.
- **Multi-Host Adapter Standard**: Specialized host-adapter environments (specifically **Claude Code** in `.claude/`, **Antigravity** in `.agents/`, **Gemini** in `GEMINI.md`, **VS Code** in `.vscode/`, and **Cursor** in `.cursor/`) are recognized as sanctioned, read-only projections of the canonical rule hub, provided each adapter:
  1. Derives from and explicitly references an authoritative `LCM_AI` Git commit baseline.
  2. Retains 1:1 mapping with canonical rule identifiers (`RULE-*`, `INV/*`).
  3. Confines host-specific operational mechanisms or constraints (e.g. path-scoping, automated hooks, editor API mechanics) to explicit adapter annotations without altering the underlying normative governance mandates. Canonical rules state the host-neutral architectural intent; host implementations map that intent to their runtime tools.
  4. Is verified against rule drift via host adapter drift checks (planned for centralized automation in `LCM_Inventory/tools/Test-LCMRuleHealth.ps1`; currently validated via adapter-specific drift checks), auditing file inventories, baseline commit parity, and rule code coverage across registered host adapters.
  5. Adheres to the Host-Neutral Session Continuity Architecture (`RULE-LCM-030`) using workspace-level state files (`.agents/ACTIVE_SESSION.md`, `.agents/ACTIVE_CONTEXT.md`, `.agents/LEARNED_ADVICE.md`); host-native memory stores pointers only, and disk files are the sole authority.

---

### `RULE-AUTH-002` (Mandatory Rule Matrix & Host Adapter Synchronization Invariant)
Whenever an existing rule is updated, or a new rule/policy is created ("invented"), the author or AI agent `MUST` update all discovery entrypoints and registered host adapters in the same change set:
1. **Root Quick-Reference Table**: Update [`AGENTS.md`](file:///d:/Git_Repositories/AGENTS.md) with the new rule name, rule codes (`RULE-*`), domain, scope, and key invariant.
2. **Comprehensive Matrix**: Update [`LCM_AI/docs/LCM-Rules-Cross-Reference.md`](file:///d:/Git_Repositories/LCM_AI/docs/LCM-Rules-Cross-Reference.md) with the full metadata, enforcing scripts, and quality gate mappings.
3. **Registered Host Adapters**: Synchronize registered host adapter indexes and rule files ([`CLAUDE.md`](file:///d:/Git_Repositories/CLAUDE.md), `.claude/rules/`, [`GEMINI.md`](file:///d:/Git_Repositories/GEMINI.md)) to prevent silent rule staleness.
4. **Child Junction Verification**: Verify that the newly created or modified rule is immediately visible across all child repository `.agents\rules` junctions using [`LCM_Inventory/tools/Test-LCMRuleHealth.ps1`](file:///d:/Git_Repositories/LCM_Inventory/tools/Test-LCMRuleHealth.ps1).

### `RULE-AUTH-003` (Goal-First Authority Alignment)
The canonical `GoalFirstDesignPolicy.md` defines the Gate 0 Contract and traceability requirements. Other governance policies may apply those requirements but MUST NOT redefine a conflicting target-state or bypass rule.

---

### `RULE-AUTH-004` (Tri-Tier Governance Rule Architecture: Process, Quality, Language)
To ensure optimal context-window efficiency, clear precedence boundaries, and cross-host parity with Claude Code, Antigravity, Gemini, VS Code, and Cursor, all LCM governance rules are organized into three canonical functional tiers:
1. **Process Rules (`process/`)**:
   - Govern lifecycle state transitions, review checkpoints, commit gating, analysis boundaries, and operator interaction protocols.
   - *Loading Scope*: Universal. Always active at session start across all governed repositories.
   - *Authoritative Rules*: `RuleAuthority.md`, `GoalFirstDesignPolicy.md`, `ProposalReviewFlowPolicy.md`, `ReviewCommitGovernancePolicy.md`, `AnalysisGovernancePolicy.md`, `DecisionCascadeGovernancePolicy.md`, `RepositoryContextPolicy.md`, `ElevationPolicy.md`, `SubsystemGovernancePolicy.md`, `macro-definitions.md`.
2. **Quality Rules (`quality/`)**:
   - Define universal, language-neutral solution invariants: formatting, character sets, newline discipline, comment preservation, timestamp precision, zero-assumption testing, and documentation standards.
   - *Loading Scope*: Universal. Binding upon every file created, modified, or verified across the workspace.
   - *Authoritative Rules*: `InvariantRules.md`, `LanguagePolicy.md`, `DocumentationStandardsPolicy.md`, `MethodEfficiencyPolicy.md`.
3. **Language Rules (`lang/`)**:
   - Define language-specific syntax standards, compiler/AST validation rules, and idiomatic practices.
   - *Precedence & Scope*: **Path-Scoped with Explicit Deference**. Generic formatting defaults in Quality Rules yield unconditionally to the target language's authoritative rule file (e.g. Go hard tabs via `gofmt`, Python 4 spaces via PEP 8). Any language may introduce its own standalone rule file.
   - *Authoritative Rules*: `PowerShellStandardsPolicy.md` / `PowerShellRules.md` (`*.ps1`, `*.psm1`, `*.psd1`), `PythonRules.md` (`*.py`), `GoRules.md` (`*.go`), `CMDRules.md` (`*.cmd`, `*.bat`), `JsonRules.md` (`*.json`), `DisplayStandardsPolicy.md` (`*.html`, `*.css`, `*.js`).

---

## 2. Activation Commands
- `@RULEAUTH`: Activates and validates the canonical source-of-truth and synchronization policy.
