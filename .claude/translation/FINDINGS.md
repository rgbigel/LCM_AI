# File: FINDINGS.md

Module: .claude/translation/FINDINGS.md  
Purpose: Register of incomplete, unclear, contradictory or Antigravity-only LCM rules found while mapping .agents/rules to Claude; each entry numbered, quotable, with a proposed resolution.  
Path: LCM_AI/.claude/translation/FINDINGS.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 21:16:37

---

## 1. Legend

| Field | Values |
|:---|:---|
| Type | `CONTRADICTION`, `IMPRECISE`, `GAP` (missing provision or nonexistent referent), `STALE`, `REDUNDANT`, `HOST` (Antigravity-only mechanism), `HOST-CONTEXT` (correct for Antigravity/Gemini; needs a Claude-side reading, not a rule fix), `OPEN-END` (known unfinished area of the evolving methodology; records what is missing, not an error) |
| Baseline | LCM_AI `43e36b0` (2026-11-12 18:30:41) |

Seed findings C1-C6 (already in the operator's CRP) are listed in WORKPLAN section 6 and not repeated here.

## 2. Findings

### Batch 1 - RuleAuthority, InvariantRules, LanguagePolicy, RepositoryContextPolicy, GoalFirstDesignPolicy

| ID | Source | Type | Finding | Proposed resolution |
|:---|:---|:---|:---|:---|
| F-01 | RULE-AUTH-001 | HOST-CONTEXT | "IDE adapter surfaces MUST NOT fork ... without an approved Change Request." No provision exists for a host adapter (e.g. `.claude/`) that must restate rules in another host's format. Every adapter is therefore a violation or needs its own CR. | Add an adapter clause: a host adapter is permitted when it is generated from (or mapped to) the canonical rules, cites source IDs and baseline commit, and is drift-checked by a gate. |
| F-02 | RULE-AUTH-002 | HOST-CONTEXT | Sync list names only `AGENTS.md` and `LCM-Rules-Cross-Reference.md`; host adapter entry points (`CLAUDE.md`, `.claude/rules/`) are not covered, so a rule change silently leaves adapters stale. | Extend the list with "all registered host adapters", produced by the planned sync tool (WORKPLAN D-04). |
| F-03 | RULE-AUTH-002.3 | IMPRECISE | "Verify that the newly created rule is immediately visible across all child junctions" names no method or tool. `LCM_Inventory/tools/Test-LCMRuleHealth.ps1` exists and validates junction integrity. | Name `Test-LCMRuleHealth.ps1` (or the gate that calls it) as the required verification. |
| F-04 | INV/newline-crlf | IMPRECISE | "Windows-native files" is undefined; it is unclear whether e.g. `*.go`, `*.py`, `*.sh`, `*.svg`, `*.sql` must be CRLF. | Replace with an explicit extension list or "all text files except <list>". |
| F-05 | INV/indent-2 | IMPRECISE | Universal 2-space indentation, no tabs; Go (`gofmt` uses tabs) and Python (PEP 8: 4 spaces) conventions differ. Status: to be confirmed against GoRules / PythonRules in the language batch. | Either state language exceptions in InvariantRules or let the language rule own indentation. |
| F-06 | INV/ascii-default vs LANG/code-comments | IMPRECISE | Umlauts are allowed in PowerShell comments, while all comments MUST be English. The cases where umlauts are legitimate (proper names, paths, data) are not stated. | Restrict the exception to proper names, paths and data literals. |
| F-07 | INV/mandatory-pre-handoff-syntax-gate | OPEN-END | Lists `*.cmd` but names no parser for it; omits `*.go`, `*.psd1`, `*.md`, `*.html`, `*.js`, `*.sql`, `*.yaml`, although other rules govern these. | Give a verification command per listed type (e.g. Go: `go vet` / `go build`; psd1: `Import-PowerShellDataFile`) or state explicitly which types have no gate. |
| F-08 | INV/question-response | IMPRECISE | The example of an explicit instruction ("Are you kidding? Fix/correct this like that...!") itself begins with a question. Polite requests phrased as questions ("Can you fix X?", "Maybe you need to scan the docs first?") are not classified. | Define: an imperative addressed to the AI is an instruction even inside a question; a request phrased only as a question is answered, then the AI asks whether to act. Operator to confirm. |
| F-09 | INV/english-default-language vs LanguagePolicy; INV/no-verbosity vs INV/zero-conversational-padding | REDUNDANT | The same obligation is stated twice in different words (and in two files for the language rule). | Keep one owner per obligation; replace the other by a reference. |
| F-10 | RULE-CTX-002 (also LCM-REQ-033) | GAP | Required read `<TargetRepo>/LCM_Inventory/config.json` exists in no repository under `D:\Git_Repositories` (checked 2026-11-13). The rule cannot be followed and every repo would be classified `unonboarded-candidate`. | State the current location of per-repository LCM configuration (operator input needed). |
| F-11 | RULE-CTX-002 note | OPEN-END | Onboarding fallback names `Invoke-LCMOnboardRepo.ps1`; no such file exists in the LCM_* repositories (checked 2026-11-13; only docs mention onboarding). Operator: onboarding as a whole is an open end; it will be needed, almost nothing exists yet. | Mark onboarding as "planned, not available" in the rule until the onboarding area is designed. |
| F-12 | RULE-CTX-004 | STALE | States `LCM_AI` governs release baselines "(10.0.0)"; current LCM version is 10.2.5. Describes `LCM_Shared` as PowerShell-only atoms. | Refer to `.agents/version.json` (planned) instead of a literal version. |
| F-13 | RULE-CTX-001 (1) | HOST | "The currently active document / cursor file path in the IDE metadata" assumes the host always supplies it. Claude receives it only when the VS Code extension attaches it; headless runs (`claude -p`) have none. | Make the order explicit for hosts without IDE metadata (fall back to (2), then (3)). |
| F-14 | RULE-GOAL-002 | IMPRECISE | A written Gate 0 Contract is required for "structural, cross-cutting, materially ambiguous, or scope-expanding" work, but these terms are not defined. This is the trigger for pausing at the planning boundary (Claude: plan mode). Operator context (2026-11-13): the trigger depends on context, not change size - a BUG has a clear error and essentially no Gate 0; `DOIT` means the target is known and work goes quickly to Gate 2 (prototypically implemented, manually runnable, formally tested rough or fine per switch settings). | State the trigger by context: no Gate 0 pause for BUGs or under `DOIT`; Gate 0 pause only for a CRP in standard flow whose target state is not evident from its title or request. |
| F-15 | LanguagePolicy.md | IMPRECISE | File format deviates from the other rule files: Antigravity banner, `Changelog:` instead of `Status:`/`Date:`, no `RULE-*` IDs (only key names). To be checked against DocumentationStandardsPolicy in a later batch. | Align header and introduce rule IDs (e.g. `RULE-LANG-001..005`). |
| F-17 | INV/single-commit-version-increment (and C2 / RULE-REV-007) | IMPRECISE | Component versions increment once per commit cycle. Operator's intended semantics (2026-11-13, WORKPLAN D-14): version bump +1.0.0 resetting minor and patch for all parts (10.2.5 -> 11.0.0); release +0.1.0; GoodNight push +0.0.1 only on components that really changed; "clean" only at release. The rules state neither the reset nor the component-vs-package relation; RULE-REV-007 instead shows `+10.0.0` for patch, minor and major (C2, apparently a literal error). | Restate RULE-REV-007 and INV/single-commit-version-increment with the D-14 semantics (increment unit, reset, component vs all-parts scope, trigger: commit, push, release, version). D-14 supplies the intended content for correcting C2; it does not make C2 obsolete. |
| F-16 | INV/timestamp-header-rule | HOST | Operator waived the header for Claude (WORKPLAN D-07); the canonical rule has no host-exception mechanism. | Add a "host exceptions" provision or record the waiver in `overrides.json`. |

## 3. Open Questions Raised by Findings

| ID | Question | Related |
|:---|:---|:---|
| Q-04 | May Claude write to the shared `.agents/LEARNED_ADVICE.md` (`/learn`, RULE-CTX-005), or must Claude learned advice stay in the separate Claude scheme until synchronization? | RULE-CTX-005, D-11 |
| Q-05 | Where is the per-repository LCM configuration today? | F-10 |
