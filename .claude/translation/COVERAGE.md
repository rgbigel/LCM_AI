# File: COVERAGE.md

Module: .claude/translation/COVERAGE.md  
Purpose: Coverage table mapping every source rule in .agents/rules to its Claude mapping file, mechanism and enforcement level.  
Path: LCM_AI/.claude/translation/COVERAGE.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 21:09:25

---

## 1. Legend

| Column | Values |
|:---|:---|
| Mechanism | `always` (rule loaded at session start), `path` (path-scoped rule), `hook` (settings hook; `hook*` = candidate, not built), `plan` (Claude plan mode), `skill`, `exception`, `pending` (awaits operator answer), `none` |
| Level | `1` mechanically enforced, `2` instructed only, `3` not enforceable here (reason given) |

Current state: no hooks exist yet (built only after discussion), so every `hook*` row is level 2 today; the target level is shown after the arrow.

## 2. Source File Status

| Source file | Batch | Claude mapping |
|:---|:---:|:---|
| RuleAuthority.md | 1 | process/RuleAuthority.md |
| InvariantRules.md | 1 | process/InteractionInvariants.md, quality/FileInvariants.md |
| LanguagePolicy.md | 1 | quality/FileInvariants.md |
| RepositoryContextPolicy.md | 1 | process/RepositoryContext.md |
| GoalFirstDesignPolicy.md | 1 | process/GoalFirst.md |
| ProposalReviewFlowPolicy.md | - | not yet mapped |
| ReviewCommitGovernancePolicy.md | - | not yet mapped |
| AnalysisGovernancePolicy.md | - | not yet mapped |
| DecisionCascadeGovernancePolicy.md | - | not yet mapped |
| MethodEfficiencyPolicy.md | - | not yet mapped |
| ElevationPolicy.md | - | not yet mapped |
| SubsystemGovernancePolicy.md | - | not yet mapped |
| macro-definitions.md | - | not yet mapped |
| DocumentationStandardsPolicy.md | - | not yet mapped |
| DisplayStandardsPolicy.md | - | not yet mapped |
| PowerShellStandardsPolicy.md | - | not yet mapped |
| PowerShellRules.md | - | not yet mapped |
| PythonRules.md | - | not yet mapped |
| GoRules.md | - | not yet mapped |
| JsonRules.md | - | not yet mapped |
| CMDRules.md | - | not yet mapped |

## 3. Rule Coverage

### Batch 1

| Source rule | Claude file | Mechanism | Level | Note |
|:---|:---|:---|:---:|:---|
| RULE-AUTH-001 | process/RuleAuthority.md | always | 2 | F-01 |
| RULE-AUTH-002 | process/RuleAuthority.md | always | 2 | Phase 1: Claude does not edit rules. F-02, F-03 |
| RULE-AUTH-003 | process/RuleAuthority.md | always | 2 | |
| `@RULEAUTH` | - | skill* | 2 | Macro batch |
| INV/question-response | process/InteractionInvariants.md | always | 2 | F-08 |
| INV/boundary-ambiguity-alternatives | process/InteractionInvariants.md | always | 2 | |
| INV/determinism, reproducibility | process/InteractionInvariants.md | always | 3 | Model output is not strictly deterministic; instructed intent only |
| INV/no-assumptions | process/InteractionInvariants.md | always | 2 | |
| INV/zero-assumption-testing | process/InteractionInvariants.md | always, hook* (Stop) | 2 -> 1 | Stop hook can refuse turn end without verification evidence |
| INV/mandatory-pre-handoff-syntax-gate | process/InteractionInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | Parse after every Edit/Write. F-07 |
| INV/no-verbosity, zero-conversational-padding | process/InteractionInvariants.md | always | 2 | F-09 |
| INV/explicit-reasoning, structure | process/InteractionInvariants.md | always | 2 | |
| INV/timestamp-header-rule | process/InteractionInvariants.md | exception | - | D-07, F-16 |
| `@ml`, `@tsr`/`@THR`/`@TRH`/`@IRA` | - | skill* | 2 | Macro batch |
| INV/utf8-without-bom | quality/FileInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | |
| INV/newline-crlf | quality/FileInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | Write tool emits LF. F-04 |
| INV/indent-2 | quality/FileInvariants.md | always | 2 | F-05 |
| INV/ascii-default, no-non-ascii-identifiers | quality/FileInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | F-06 |
| INV/constant-string-apostrophes | quality/FileInvariants.md | always | 2 | Language batch may add a lint |
| INV/no-backtick-line-continuations | quality/FileInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | Regex check on `.ps1`/`.psm1` |
| INV/english-default-language, LANG/* | quality/FileInvariants.md | always | 2 | F-09, F-15 |
| INV/comment-preservation | quality/FileInvariants.md | always | 2 | Diff-based hook conceivable, not proposed yet |
| INV/universal-header-modification-timestamp | quality/FileInvariants.md | always, hook* (PostToolUse) | 2 -> 1 | |
| INV/single-commit-version-increment | quality/FileInvariants.md | always | 2 | |
| INV/tool-and-log-timestamp-precision | quality/FileInvariants.md | always | 2 | |
| RULE-CTX-001 | process/RepositoryContext.md | always | 2 | F-13 |
| RULE-CTX-002 | process/RepositoryContext.md | always | 2 | F-10, F-11 |
| RULE-CTX-003 | process/RepositoryContext.md | always | 2 | |
| RULE-CTX-004 | process/RepositoryContext.md | always | 2 | F-12 |
| RULE-CTX-005 | process/RepositoryContext.md | always, hook* (SessionStart), pending | 2 | Read: SessionStart injection; write: Q-04 |
| RULE-CTX-006 | process/RepositoryContext.md | pending | - | Q-01, C1 |
| RULE-GOAL-001 | process/GoalFirst.md | always | 2 | |
| RULE-GOAL-002 | process/GoalFirst.md | always, plan | 2 | Context trigger (D-13). Plan mode blocks edits once entered; entering is instructed. F-14 |
| RULE-GOAL-003 | process/GoalFirst.md | always | 2 | Phase 1 sink: FINDINGS.md |
| RULE-GOAL-004 | process/GoalFirst.md | always | 2 | |
| RULE-GOAL-005 | process/GoalFirst.md | always | 2 | |
