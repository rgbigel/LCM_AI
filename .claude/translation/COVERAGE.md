# File: COVERAGE.md

Module: .claude/translation/COVERAGE.md  
Purpose: Coverage table mapping every source rule file and rule group in .agents/rules to its Claude adapter file, mechanism and enforcement level.  
Path: LCM_AI/.claude/translation/COVERAGE.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 19:14:51

---

## 1. Legend

| Column | Values |
|:---|:---|
| Mechanism | `always` (loaded at session start), `path` (path-scoped), `plan` (Claude plan mode), `hook*` (settings hook, candidate, not built), `skill*` (slash-command candidate), `exception`, `pending`, `none` |
| Level | `1` mechanically enforced, `2` instructed only, `3` not enforceable here (reason) |

No hooks or skills exist yet; every `hook*` row is level 2 today, target after the arrow. Baseline `LCM_AI 2bebbaa`.

## 2. File Mapping (RULE-AUTH-004, 1:1 by name)

| Tier | Canonical file | Version | Adapter file | Loading |
|:---|:---|:---:|:---|:---|
| process | RuleAuthority | 10.3.0 | process/RuleAuthority.md | always |
| process | GoalFirstDesignPolicy | 10.2.1 | process/GoalFirstDesignPolicy.md | always |
| process | ProposalReviewFlowPolicy | 10.3.0 | process/ProposalReviewFlowPolicy.md | always |
| process | ReviewCommitGovernancePolicy | 10.3.0 | process/ReviewCommitGovernancePolicy.md | always |
| process | AnalysisGovernancePolicy | 10.2.1 | process/AnalysisGovernancePolicy.md | always |
| process | DecisionCascadeGovernancePolicy | 10.2.1 | process/DecisionCascadeGovernancePolicy.md | always |
| process | RepositoryContextPolicy | 10.3.0 | process/RepositoryContextPolicy.md | always |
| process | ElevationPolicy | 10.2.0 | process/ElevationPolicy.md | always |
| process | SubsystemGovernancePolicy | 10.2.0 | process/SubsystemGovernancePolicy.md | always |
| process | macro-definitions | 10.2.3 | process/macro-definitions.md | always |
| quality | InvariantRules | 10.3.0 | quality/InvariantRules.md | always |
| quality | LanguagePolicy | 10.2.0 | quality/LanguagePolicy.md | always |
| quality | DocumentationStandardsPolicy | 10.3.0 | quality/DocumentationStandardsPolicy.md | always (canonical globs `*.md`: F-34) |
| quality | MethodEfficiencyPolicy | 10.2.1 | quality/MethodEfficiencyPolicy.md | always |
| lang | PowerShellStandardsPolicy | 10.3.0 | lang/PowerShellStandardsPolicy.md | path `**/*.ps1`, `**/*.psm1`, `**/*.psd1` |
| lang | PowerShellRules | 10.2.1 | lang/PowerShellRules.md | path (canonical globs `*`: F-34) |
| lang | PythonRules | 10.2.0 | lang/PythonRules.md | path `**/*.py` |
| lang | GoRules | 10.2.0 | lang/GoRules.md | path `**/*.go` (canonical `alwaysApply`: F-34) |
| lang | CMDRules | 10.2.0 | lang/CMDRules.md | path `**/*.cmd`, `**/*.bat` |
| lang | JsonRules | 10.2.0 | lang/JsonRules.md | path `**/*.json` |
| lang | DisplayStandardsPolicy | 10.2.0 | lang/DisplayStandardsPolicy.md | path `**/*.html`, `**/*.css`, `**/*.js` (canonical `*`: F-34) |

Drift check 2026-11-14 (scratch `Test-ClaudeAdapterDrift.ps1`): 21 files, 158 defined `RULE-*` IDs, versions, baseline citation, tiers, CRLF/BOM: 0 issues; negative test detected a removed ID. Key-list files (InvariantRules, LanguagePolicy, PowerShellRules, PythonRules keys, GoRules, CMDRules, JsonRules, macros) mapped key by key, not machine-checked (F-45).

## 3. Rule Group Coverage

| Rule / group | Mechanism | Level | Note |
|:---|:---|:---:|:---|
| AUTH-001..004 | always | 2 | Adapter conditions met (baseline, IDs, annotations); drift check F-45 |
| GOAL-001..005 | always, plan | 2 | Plan-mode trigger D-13; plan mode blocks edits once entered |
| LCM-001, 014, 015 (intake, Gate 1 halt) | always, plan | 2 | Gate 1 halt = plan mode / end turn |
| LCM-002, 007, 016, 026 (lifecycle, commands, cohorts) | always | 2 | Claude does not run lifecycle tools on its own; F-20 |
| LCM-008, 010, 017 (BUG, self-discovered bugs, loop breaker) | always | 2 | 2-attempt breaker instructed |
| LCM-013, REV-001, REV-006 (no direct push/commit; stop at Gate 2) | always, hook* (PreToolUse) | 2 -> 1 | Block `git push` / `git commit` outside governed tools |
| LCM-022 (single edit per turn, pending diff) | always | 3 | Editor review state invisible to Claude (F-31) |
| LCM-024, REV-010, PS-021, INV syntax gate | always, hook* (PostToolUse) | 2 -> 1 | Parse after every Edit/Write (pwsh AST, py_compile, go vet, ConvertFrom-Json) |
| LCM-027, 028, 029, INV question/boundary | always | 2 | |
| LCM-030 (Quiescent, greetings) | always | 2 | Claude never runs GoodNight |
| REV-007, INV single-commit-version | always | 2 | F-18 conflict |
| REV-011 ADMINMODE | none | 3 | Enforced by review tooling, not by Claude |
| REV-014 (BCR exclusivity) | always, hook* (PreToolUse on `BCompare.exe`) | 2 -> 1 | |
| ANA-000..009 | always, plan | 2 | `ANALYZE` = plan mode; Check 0 adapted (F-32) |
| DEC-001..005 | always | 2 | LEV not used (D-06) |
| CTX-001..006 | always, hook* (SessionStart) | 2 | Inject ACTIVE_SESSION/CONTEXT/LEARNED_ADVICE; CTX-005 writes pending Q-04 |
| ELEV-001..007 | always | 2 | Admin tools via `do.exe`; F-22, F-23 |
| SUB-001..008 | always | 2 | HA access read-only |
| macros | always, skill* | 2 | Bare words as chat instructions; skills candidate |
| INV encoding (UTF-8 no BOM, CRLF, ASCII, no backticks, header date) | always, hook* (PostToolUse) | 2 -> 1 | Write emits LF; normalize and verify |
| INV determinism | always | 3 | Model output not strictly reproducible |
| INV timestamp-header-rule | exception | - | D-07, F-16 |
| DOC-001..012 | always | 2 | |
| EFF-001..010, ENV-003 | always | 2 | EFF-007 pending Q-02; EFF-004 permissions not configured |
| PS, PY, GO, CMD, JSON, DSP | path | 2 | Loaded on Read/Write/Edit of matching files |
