# File: FINDINGS.md

Module: .claude/translation/FINDINGS.md  
Purpose: Register of incomplete, unclear, contradictory or host-specific LCM rules found while mapping .agents/rules to the Claude adapter; numbered, quotable, each with a proposed resolution and current status.  
Path: LCM_AI/.claude/translation/FINDINGS.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:29:32

---

## 1. Legend

| Field | Values |
|:---|:---|
| Type | `CONTRADICTION`, `IMPRECISE`, `GAP` (missing provision or nonexistent referent), `STALE`, `REDUNDANT`, `HOST` (one host only), `HOST-CONTEXT` (correct for Antigravity; needs host reading), `OPEN-END` (known unfinished area, not an error) |
| Status | `RESOLVED @2bebbaa`, `PARTIAL`, `OPEN`, `NEW` (first found at 2bebbaa) |
| Baseline | First pass `43e36b0` (2026-11-12); re-ingestion `2bebbaa` (2026-11-14 18:58:18, LCM 10.6.4) |

Existence checks ("does not exist") were run on 2026-11-14 against the files on disk.

## 2. Seed Findings C1-C6 (CRP-326 items 1-6)

| ID | Topic | Status | Evidence at 2bebbaa |
|:---|:---|:---|:---|
| C1 | GoodMorning AI vs operator | RESOLVED | RULE-CTX-006 now operator-exclusive. |
| C2 | `+10.0.0` increments | RESOLVED, but see F-18 | RULE-REV-007 restored; RULE-DOC-005 now contradicts it. |
| C3 | Dual-session junction review | RESOLVED | RULE-LCM-004 single session per RULE-REV-008. |
| C4 | Two lifecycle vocabularies | OPEN (see F-20) | CRP-326 6.2 does not list LCM-007/LCM-016; both still use sync points. |
| C5 | `proposals.json` vs `proposals.db` | OPEN (see F-46) | Item 5 transition protocol absent from all rules. |
| C6 | Rule count, `.iew.` typo | RESOLVED | LCM-013 says 21 files; typo gone. |

## 3. Batch 1 Findings F-01..F-17 (status at 2bebbaa)

| ID | Rule | Type | Status | Note |
|:---|:---|:---|:---|:---|
| F-01 | RULE-AUTH-001 adapter clause | HOST-CONTEXT | RESOLVED | Multi-Host Adapter Standard added. |
| F-02 | RULE-AUTH-002 adapters in sync list | HOST-CONTEXT | RESOLVED | Item 3 names `CLAUDE.md`, `.claude/rules/`, `GEMINI.md`. |
| F-03 | RULE-AUTH-002 verification tool | IMPRECISE | RESOLVED | `Test-LCMRuleHealth.ps1` named. |
| F-04 | newline-crlf scope | IMPRECISE | RESOLVED | Binary and `*.sh` excluded. |
| F-05 | indent-2 vs Go/Python | IMPRECISE | SUPERSEDED by F-19 | Deference added, but targets missing. |
| F-06 | umlauts in comments | IMPRECISE | RESOLVED | Restricted to names, literals, paths. |
| F-07 | syntax gate coverage | OPEN-END | PARTIAL | Go added; `*.cmd` still without parser (F-36); `*.psd1`, `*.md`, `*.html`, `*.js`, `*.sql`, `*.yaml` unstated. |
| F-08 | question-phrased requests | IMPRECISE | PARTIAL | INVARIANT-RULES updated; duplicate RULE-LCM-028 unchanged (F-30). |
| F-09 | duplicated obligations | REDUNDANT | OPEN | Unchanged; grown (F-30). |
| F-10 | per-repo config path | GAP | OPEN (see F-22) | New path `LCM_Inventory/config.json` does not exist either. |
| F-11 | onboarding tool | OPEN-END | RESOLVED | Marked planned under CRP-298 (bundle exists). |
| F-12 | CTX-004 literal version | STALE | RESOLVED | Points to `.agents/version.json`. |
| F-13 | headless scope fallback | HOST | RESOLVED | CTX-001 (3). |
| F-14 | Gate 0 trigger undefined | IMPRECISE | OPEN | GoalFirstDesignPolicy unchanged; operator context (D-13) only in the Claude adapter. |
| F-15 | LanguagePolicy format, no IDs | IMPRECISE | OPEN | Unchanged. |
| F-16 | no host-exception provision | HOST | PARTIAL | `@tsr` retired; Claude waiver of the header (D-07) still not canonical. |
| F-17 | version semantics | IMPRECISE | RESOLVED, but see F-18 | REV-007 and INV state D-14 semantics. |

## 4. New Findings at 2bebbaa (F-18..F-46)

| ID | Rule(s) | Type | Finding | Proposed resolution |
|:---|:---|:---|:---|:---|
| F-18 | RULE-DOC-005 vs RULE-REV-007, INV/single-commit-version-increment | CONTRADICTION | DOC-005 preserves minor/patch at a major step (`9.2.1` -> `10.2.1`); REV-007 and INV reset them for all components (`10.2.5` -> `11.0.0`). Introduced by CRP-326 (DOC-005 examples fixed, formula kept). | Restate DOC-005 with the D-14 reset semantics, or state which rule wins. |
| F-19 | INV/indent-2, RULE-AUTH-004 vs GoRules, PythonRules | CONTRADICTION | Both say GoRules mandates tabs (`gofmt`) and PythonRules 4 spaces (PEP 8); neither file contains any indentation rule, so 2-space default still applies to Go and Python. CMDRules keeps indent-2. | Add the indentation rules to GoRules and PythonRules, or drop the claim. |
| F-20 | RULE-LCM-002 (command list), RULE-LCM-007, RULE-LCM-016.1, RULE-REV-001.2, RULE-REV-006.2, RULE-DSP-003.3, RULE-DSP-011 | CONTRADICTION | Old sync-point vocabulary remains (`Scoped`, `Decided`, `Committed`, `Published`, `Cancelled`, `REVIEW -> COMMITTED`); LCM-007 even mixes both vocabularies (matrix vs diagram). `cancel`/`Cancelled` vs table `withdraw`/`withdrawn`; `resume` vs `continue` vs `reopen`. CRP-326 item 4 not implemented. | Rewrite these passages onto the flat state table; one verb per transition. |
| F-21 | RULE-LCM-004, RULE-LCM-008, RULE-REV-001, RULE-EFF-004, macro BCR vs RULE-REV-014, RULE-REV-008 | CONTRADICTION / GAP | `Invoke-BeyondCompareReview.ps1` is the named review tool but does not exist. REV-014 makes BCR (`Invoke-MacriumBcrReview.ps1` / `Invoke-MacriumDailyBcrBaseline.ps1`, workspace root, Macrium image) the ONLY valid method and forbids single-repo comparisons, while LCM-004 prescribes `<RepoName>` reviews and REV-008 a Git `BaseCommit` export baseline. | Name one review tool and one baseline model; align LCM-004/REV-001/REV-008/EFF-004/macro BCR with REV-014. |
| F-22 | RULE-CTX-002, RULE-ELEV-001/003/004, RULE-SUB-001/003, RULE-DOC-005.4 | GAP | `LCM_Inventory/config.json` does not exist; elevation data (`ElevationRequired`, `MinimumPrivilege`) lives in `LCM_Inventory/data/inventory.json`. CRP-326 6.2 records CTX-002 as fixed. | Point all rules to `inventory.json` (or create and specify `config.json`). |
| F-23 | RULE-ELEV-006, RULE-PS-011, RULE-DSP-008 | STALE / CONTRADICTION | CRP-320 retired `Invoke-PrivilegedTool.ps1` and `Invoke-InteractiveDesktop.ps1` in favour of DO; ELEV-006 still lists both as routes and fallback; PS-011/DSP-008 mandate `Invoke-InteractiveDesktop.ps1` at `LCM_Tools\...` (file is in `LCM_Inventory\tools\`). | Make DO the single dispatch route in ELEV-006, PS-011, DSP-008; record the retirement. |
| F-24 | RULE-EFF-008 | GAP | Names `LCM_Inventory/tools/tool_catalog.json`; actual file `LCM_Inventory/config/tool_catalog.json` (ELEV-006 is correct). | Fix the path. |
| F-25 | RULE-EFF-003 | GAP | `Invoke-LCMUpdate.ps1` does not exist (`Invoke-LCM_Audit.ps1`, `Create-LCM_Baseline.ps1` exist). | Remove or name the replacement. |
| F-26 | RULE-ANA-006 | IMPRECISE | `active_session.json` location unspecified; not in `LCM_Inventory/data/`. | State the path (or `.agents/ACTIVE_SESSION.md`). |
| F-27 | RULE-LCM-007.5 vs RULE-LCM-020 | CONTRADICTION | LCM-007.5 archives plans in `LCM_Inventory/data/proposals/plans/` (does not exist) with `plan_path`; LCM-020 uses bundles and purges them after push. | Keep one archive model (bundles + Git retrieval); retire the plans path. |
| F-28 | RULE-LCM-003 vs RULE-DEC-005.4 | CONTRADICTION | Default granularity `coarse`, but every push resets it to `tight`. | Decide the post-push default. |
| F-29 | RULE-LCM-034 vs RULE-SUB-008 | REDUNDANT / CONTRADICTION | Same invariant twice; both list `LCM_SystemConfiguration`, which does not exist, while SUB-008.4 names `SystemConfiguration` as a disjunct subsystem. | Keep one owner; fix the repository list. |
| F-30 | RULE-LCM-024, RULE-LCM-028, RULE-LCM-029, RULE-REV-010, RULE-PS-021 vs INVARIANT-RULES | REDUNDANT | Duplicates have diverged: LCM-024/REV-010 lack Go in the syntax gate; LCM-028 keeps the old example that INV replaced. | One owner (INVARIANT-RULES); others reference it. |
| F-31 | RULE-LCM-022, RULE-LCM-021.2, RULE-ANA-001.2, RULE-ANA-007, macros `ar`, `S` | HOST-CONTEXT | Antigravity-specific mechanics (`multi_replace_file_content`, editor pending-diff state, bare-word `@` popup, `files/` workspace, host transcript provider, copilot profile). | Keep as host annotations per RULE-AUTH-001.3; state host-neutral intent. |
| F-32 | RULE-ANA-000 | HOST-CONTEXT | Check 0 compares `.copilot/Rules/` hashes; translated adapters (AUTH-001) can never hash-match. | Define Check 0 per adapter: baseline commit equality plus clean canonical tree. |
| F-33 | macro-definitions, PowerShellRules, GoRules, LanguagePolicy vs RULE-DOC-003.2 | STALE / IMPRECISE | Headers deviate (banners, `# version:` comments, `Changelog:`, GoRules frontmatter after an HTML block with `alwaysApply`); macro file claims source authority `LCM_Inventory/.agents/rules/...` (junction to LCM_AI); `tsr` macro still described as automated. | Normalize headers; fix authority line; drop the `tsr` entry. |
| F-34 | RULE-AUTH-004 vs rule frontmatter | IMPRECISE | Loading scope in AUTH-004 differs from file globs: DocumentationStandardsPolicy `*.md` (quality = universal), PowerShellRules and DisplayStandardsPolicy `*` (lang = path-scoped), GoRules `alwaysApply: true`. | Align globs with AUTH-004. |
| F-35 | RULE-PS-008, RULE-DOC-003, RULE-DOC-010, INV/universal-header-modification-timestamp | IMPRECISE | Date format: `YYYY-MM-DD` (PS-008, DOC-003 template) vs mandatory `YYYY-MM-DD HH:mm:ss` (DOC-010) vs either (INV). | One format per file class. |
| F-36 | INV/mandatory-pre-handoff-syntax-gate, CMDRules | GAP | `*.cmd` is gated, no parser named. | Name a check or exempt CMD explicitly. |
| F-37 | GoRules header template | IMPRECISE | Hardcodes `VERSION: 10.2.0`, `AUTHOR: Rolf`, change log `10.0.0`; ENCODING ASCII vs UTF-8 rule; field names differ from DOX. | Placeholders; align with DOX/REV-007. |
| F-38 | RULE-REV-003 | STALE | Uses review state `DEFERRED`; lifecycle has `held`. | Use `held`. |
| F-39 | RULE-LCM-009.2 vs RULE-LCM-012.3 | IMPRECISE | Two header schemas for `Specification.md` (Target Scope / Affected Version Range / Impacted Repositories vs YAML CRP-ID / Scope / Status / ...). | One schema. |
| F-40 | RULE-DSP-008.5 vs RULE-REV-012.1 | CONTRADICTION | DSP requires terminating stale display/diff windows; REV-012 forbids killing operator BC instances. | Exclude operator-owned BC windows from DSP cleanup. |
| F-41 | RULE-LCM-023.2, RULE-REV-002.4, RULE-DEC-004/005 | CONTRADICTION | `state: "completed [minimal-tests]"` is not a state of the flat table nor of the `proposals.state` CHECK constraint. | Keep `state: completed` plus `test_scope: minimal`. |
| F-42 | CRP-326 section 6.2 vs rules | GAP | The implementation record claims changes that are not in the rules: item 4 lifecycle reconciliation, item 5 ledger protocol, CTX-002 config location; it states `version.json` 10.3.0 (file shows 10.6.4). | Reopen the unimplemented items or correct the record. |
| F-43 | RULE-LCM-030, macros GoodMorning/GoodNight vs macro `technical`, INV/ascii-default | IMPRECISE | Mandated messages contain emojis; `technical` mode forbids emojis/unicode. | State precedence. |
| F-44 | MethodEfficiencyPolicy section 3 vs RULE-LCM-014, RULE-GOAL-002 | IMPRECISE | "Agents must operate in direct execution mode; interactive approval loops ... superseded" is unconditional; Gate 1 halt and Gate 0 pause still apply outside DOIT. | Scope the sentence to DOIT. |
| F-45 | RULE-AUTH-001.4 | OPEN-END | Drift check of adapters "via `Test-LCMRuleHealth.ps1`": its support for translated adapters is unverified. Claude used a scratch check (file set, tier, source version, 158 rule IDs, encoding): 0 issues at 2bebbaa. | Specify the adapter drift check (inputs, pass criteria) and host it in a governed tool. |
| F-47 | RULE-GOAL-002, RULE-DOC-003.1 | IMPRECISE | "Cause no havoc: ask rather than invent or infer, and avoid unnecessary complexity" is labelled "default Non-Goal"; listed as a Non-Goal it reads as excluded, although it is the binding principle of all work (operator 2026-11-14: "the bible"). | Label it a binding principle of every Gate 0 Contract. |
| F-46 | RULE-LCM-001, RULE-LCM-010, RULE-LCM-007.5 (C5) | GAP | Rules name `proposals.json` 9 times, never `proposals.db`, `Sync-LcmProposalsDb.ps1` or `Update-Proposal.ps1`; agents have no ledger protocol. | Add the CRP-326 item 5 transition protocol. |

## 4a. Status after CRP-331 Batch 1 (2bebbaa + working tree, verified 2026-11-14)

| ID | Status | Note |
|:---|:---|:---|
| F-18, F-19, F-22, F-46, F-47, F-27, F-38 | RESOLVED | See CRP-331 Walkthrough section 3.4. |
| F-20 | RESOLVED | `reopen` / `continue` / `resume` are accepted synonyms (operator 2026-11-14: normal conversational variation); not a finding. |
| F-21 | PARTIAL | Entry point unified (BCR); RULE-REV-008.3 Git `BaseCommit` baseline vs RULE-REV-014 Macrium image. |
| F-41 | PARTIAL | RULE-DEC-004/005 still `completed [minimal-tests]`. |
| F-42 | OPEN | CRP-326 implementation record not corrected. |
| F-48 | NEW | RULE-ELEV-001/003/004 "declare" repository elevation in `inventory.json`, which is generated and must not be hand-edited (RULE-EFF-003); generator source not named. |
| F-49 | NEW | Header `Date:` not updated in the 12 rule files changed by Batch 1 (INV universal-header-modification-timestamp, RULE-DOC-010). |

## 4b. Status after CRP-331 Batch 2 (verified 2026-11-14 21:48)

| ID | Status | Note |
|:---|:---|:---|
| F-21, F-23, F-25, F-28, F-40, F-41, F-48, F-49 | RESOLVED | CRP-331 Walkthrough section 5. |
| F-24 | RESOLVED (residue F-50) | |
| F-33, F-34, F-15 | PARTIAL | See Walkthrough 5.3. |
| F-42 | PARTIAL | CRP-326 section 6.3 added by Antigravity; not re-checked. |
| F-50 | NEW | MethodEfficiencyPolicy enforcement section still names `tool_catalog.json` as first-query target (contradicts RULE-EFF-008). |
| Unassigned | OPEN | F-07, F-09, F-14, F-16, F-26, F-29, F-30, F-31, F-32, F-35, F-36, F-37, F-39, F-43, F-44, F-45. |

## 4c. Status after CRP-331 Leftovers and Batch 3 (verified 2026-11-14 22:07)

| ID | Status | Note |
|:---|:---|:---|
| F-07, F-09, F-14, F-15, F-16, F-29, F-30, F-31, F-32, F-33, F-34, F-35, F-36, F-37, F-39, F-43, F-44, F-50 | RESOLVED | CRP-331 Walkthrough section 6. |
| F-26 | PARTIAL | Path named; `active_session.json` does not exist. |
| F-45 / F-51 | OPEN | RULE-AUTH-001.4 claims adapter auditing that `Test-LCMRuleHealth.ps1` does not implement. |
| F-52 | NEW | Continuity layer requires Claude's `ACTIVE_SESSION.md` block; transition from `SESSION_HANDOFF.md` (D-11, SC-8) and SC-5 undecided. |

## 4d. Status after CRP-331 Final Reconciliation (2026-11-14)

| ID | Status | Note |
|:---|:---|:---|
| F-26 | RESOLVED | `LCM_Inventory/data/session_state/active_session.json` exists; RULE-ANA-006 points there. |
| F-45 / F-51 | RESOLVED (planned) | RULE-AUTH-001.4 marks centralized adapter auditing as planned; adapter-specific checks meanwhile. |
| F-52 | RESOLVED | Operator decision A (D-25). |
| LCM-030 numbering | WITHDRAWN | Claude error: second item 4 belongs to RULE-LCM-031. |

All CRP-331 findings are resolved, planned, or withdrawn. Remaining work: operator Gate 2.

## 5. Open Questions

| ID | Question | Related |
|:---|:---|:---|
| Q-02 | ANSWERED 2026-11-14: external tools via DO (`do.exe "<cmd>" -sync`); built-in search only as escape hatch. | RULE-EFF-007 |
| Q-04 | ANSWERED 2026-11-14: Claude may and should write learned advice. | RULE-CTX-005 |
| Q-05 | ANSWERED 2026-11-14: no per-repository LCM configuration; rules (common) and `docs/` (specific). | F-22 |
