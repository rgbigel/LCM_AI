# File: WORKPLAN.md

Module: .claude/translation/WORKPLAN.md  
Purpose: Durable record of the agreed task, layout, operator decisions and open questions for the Claude adaptation of the LCM rules; read at the start of every Claude session.  
Path: LCM_AI/.claude/translation/WORKPLAN.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-16 22:02:57

---

## 1. Origin

- Agreed in Claude session "LCM_* repositories governance rules" (`b800d0c4-5ef9-4c14-9a38-929082f5a63e`, 2026-11-13).
- Refined in session "Model settings and Plan mode rules" (`3c16a548-e597-4d96-afad-b16b323472be`, 2026-11-13/14).
- This file is the authority for the plan; Claude's private memory only points here.

## 2. Goal (operator)

Check the quality of the LCM_* repositories against the rule set they contain NOW.

| Phase | Content | State |
|:---|:---|:---|
| 1 | USE/MAP the Antigravity rules (`.agents/rules`) into `LCM_AI/.claude`; deliver statements on incomplete, unclear or contradictory rules. | Done 2026-11-14 (re-ingested at `2bebbaa`, all 21 files) |
| 2 | Discuss choices; resolve incorrect or imprecise rules; operator "retranslates" them for VS Code and Gemini/Antigravity. | Next |
| 3 | Analyze `docs/` (DOX first level), then code (mostly LCM_Inventory); sort out inconsistencies. | Pending |

- Findings flow into operator-owned CRPs (first: CRP-326, now pushed).
- Claude drafts no CRPs on its own and does not modify `.agents/rules`.

## 3. Deliverables

| Path | Content |
|:---|:---|
| `rules/process/` (10), `rules/quality/` (4), `rules/lang/` (7) | 1:1 projection of the canonical files per RULE-AUTH-004; condensed MUST/MUST NOT with source IDs; host mechanics marked `[Claude]`; lang files path-scoped. |
| `translation/FINDINGS.md` | C1-C6 and F-01..F-46 with type, status and proposed resolution. |
| `translation/COVERAGE.md` | File mapping, drift-check result, rule-group mechanism and enforcement level. |

## 4. Operator Decisions

| ID | Decision |
|:---|:---|
| D-01 | Root junction `D:\Git_Repositories\.claude` -> `LCM_AI\.claude`. Further junctions: ask first. |
| D-02 | Git: hide only root items via root `.git/info/exclude` (`/.claude/`, `/CLAUDE.md`). Otherwise ignore git as much as practical; files on disk are the only trusted state. |
| D-03 | Every produced file: DOX header, `Version:` = current LCM version (`.agents/version.json`, now 10.6.4), `Status: Draft`, CRLF, UTF-8 without BOM (verify after writing). |
| D-04 | Entry point: root `CLAUDE.md`, decoupled from `AGENTS.md`; rule-set synchronization via a future tool. |
| D-05 | Rule baseline: LCM_AI commit `2bebbaa` (2026-11-14 18:58:18, LCM 10.6.4) + CRP-331 Batch 1-3 working tree (uncommitted, converged 2026-11-14 22:07); hashes in `translation/CANONICAL_HASHES.md`; previous `43e36b0`. |
| D-06 | Quality audit runs without LEV (prototype-phase speed-up; rigor matters at publish). |
| D-07 | Timestamp response header permanently waived for Claude. |
| D-08 | Work stepwise; at most 1-3 lettered questions in chat; never guess - ask with alternatives. Questions are answered only, no actions. |
| D-09 | Do mechanical steps myself (e.g. test sessions via `claude -p`); bring the operator only real decisions. |
| D-10 | Operator behaviour rules and plan-mode triggers go into the matching process rule file; memory only points to it. |
| D-11 | Session continuity: this WORKPLAN plus `translation/SESSION_HANDOFF.md` (Claude-side analogue of GoodNight/GoodMorning, separate from `.agents` state). |
| D-12 | Finding types `HOST-CONTEXT` and `OPEN-END`: the methodology evolves; open ends are expected. |
| D-13 | Plan-mode trigger is context-based: BUG and `DOIT` -> no Gate 0 pause; CRP in standard flow with non-evident target -> plan mode with Gate 0 Contract. |
| D-14 | Versions: major +1.0.0 resets minor and patch for all parts; release +0.1.0 does not reset patch; patch +0.0.1 on commit only for changed components; clean only at release. (Canonical in REV-007/INV since 2bebbaa.) |
| D-15 | Never write to `D:\GDrive\LCM\INBOX`. Correction requests go into operator-registered CRPs (CRP-326), not while Antigravity pushes or runs GoodNight. |
| D-16 | Adapter layout follows RULE-AUTH-004 1:1 by canonical file name (operator CRP-326 decision 6.1.4). |
| D-17 | (2026-11-14) All repairs are done in Antigravity until sync. Claude's findings and recommendations for the re-ingestion go into a NEW CRP's `Specification.md` under `D:\Git_Repositories\LCM_Inventory\docs\Proposals\` (never GDrive); Antigravity analyzes, outcome designed jointly, operator mediates. Discussion order: contradictions first (F-18, F-19, F-20, F-21, F-22, F-42). Phase 2 starts only after agreement. CRP: **CRP-331** (`LCM_Inventory/docs/Proposals/CRP-331-Claude-Reingestion-Rule-Harmonization-Findings/Specification.md`), created by Claude (operator option B, 2026-11-14); ledger registration by Antigravity; operator reviews before instructing Antigravity. Amended 2026-11-15 by D-29 as part of CRP-332 (operator): the host writing a bundle registers it; the operator may assign implementation to either host (CRP-332: Claude). |
| D-18 | (2026-11-14) After joint agreement on a CRP, Antigravity changes its side first; Claude then converges to the new baseline and confirms it works: pin commit, re-map changed files, drift check 0 issues incl. negative test, verify each CRP item, fresh `claude -p` loading test; key-list files compared by hand and stated as such. |
| D-20 | (2026-11-14, CRP-331 review) Q-02: external tools (`es.exe` etc.) via DO `do.exe "<cmd>" -sync`, built-in search only as escape hatch. Q-04: Claude may and should write `LEARNED_ADVICE.md`. Q-05: no per-repository LCM configuration (rules common, `docs/` specific). SC-1: no concurrent work; operator coordinates; one-sided changes are announced; disk wins over Git. SC-5: Claude commits/pushes via governed tools only, never raw git. SC-6: authors - operator always first; an AI adds its name (ahead of the other AI) only if it changed something. SC-7: removal only manually by the operator or automatically on CRP acceptance. Review rule: during an operator review Claude collects points and applies them in one pass afterwards. |
| D-22 | (2026-11-14) Change-detection contract: the operator only tells Claude THAT Antigravity has finished (and with what); Claude determines WHAT changed via git from its last recorded baseline (log/diff, plus working-tree status/diff), then reads the changed files (disk is the truth). Not visible via git: git-ignored data (`proposals.db`, `tools.db`), untracked/outside-repo files - reported as "not verifiable via git". Corollary (operator): Antigravity changes `proposals.db` and `tools.db` only after CRP acceptance, at the latest at Gate 2. Claude may dump the databases to `.sql` at any time for comparison (into its scratchpad, never over the tracked dumps). Scope (operator, case A): the corollary covers structural/content changes a CRP brings to the databases; routine lifecycle bookkeeping through the governed tools continues at any time. |
| D-23 | (2026-11-14) At every convergence Claude writes `translation/CANONICAL_HASHES.md` (SHA-256 per canonical rule file), so uncommitted batches stay distinguishable (git alone cannot separate them). |
| D-29 | (2026-11-15) Amends D-17: the host that writes a CRP bundle also registers it in the ledger through the governed function (`New-LCM_Proposal` in `ProposalManager.psm1`; the title slug must equal the bundle folder name so the existing `Specification.md` is kept) and announces it in its `ACTIVE_SESSION.md` block. First case: CRP-332 by Claude. If it goes wrong, rewind and let Antigravity register (operator). |
| D-33 | (2026-11-16) Book 1 operator review recorded as binding guidance (Appendices B/C of `books/How-I-Understand-LCM-Methodology.md`): docs reworked bottom up (code atoms -> Implementation -> Requirements -> README last; CM terminology top down); State (internal) vs Status (operator work) are distinct; proposals are not the ledger (history lives in logs); Chapter 8 suggestions 1 (simplify versioning) and 2 (change history in docs) REJECTED, 3-8 accepted. Book 3 decisions A (stamp at commit), B (separate `lcm-hook.exe`), C (enforcement cohort after CRP-339). Cohort BCR defect registered as BUG-341. |
| D-32 | (2026-11-16) LEV (System-1 model, `/v1/systemone`, CRP-252): hands off for now; never used for rule checking (it holds an uncheckable, lagging copy of the rules); may become useful for documentation, then bound to its training rule baseline. |
| D-31 | (2026-11-16) Tripartite doc absorption of the open CRPs is deferred until the Books convergence is finished (operator option B): one collecting CRP, held; bundles are NOT purged at push until absorbed (exception to RULE-LCM-020, to be codified in CRP-339). Collecting CRP still to be registered. |
| D-30 | (2026-11-16) Convergence target (operator option A): one compact canonical rule set in `LCM_AI/.agents/rules` (one MUST/MUST NOT line per rule, rationale to `docs/`), both frontmatter keys (`globs:`/`paths:`), host binding files, `.claude/rules` as junction; retires this projection, `translation/` and the hash check. Contract: CRP-339 (`suggested`, Gate 0 accepted 2026-11-16). Fallback: daily backups, then Git. |
| D-28 | (Revised 2026-11-16: Option B - LF everywhere, CRLF only for `*.cmd`/`*.bat`, no `.md` exception; CRP-332 section 0a. Original:) (2026-11-15) Line endings: Option A (CRLF everywhere, no mixed setup; `translation/NOTE-LineEndings.md` section 9); enforcement in CRP-332 for Antigravity. LF from third-party writes: Claude converts to CRLF silently. |
| D-27 | (2026-11-14) Claude good-morning: operator types `/goodmorning` (skill `LCM_AI/.claude/skills/goodmorning/SKILL.md`) or "good morning"; Claude reads the continuity layer and WORKPLAN, runs the Claude Check 0 against `CANONICAL_HASHES.md`, reports gap and attention items, sets its block to Active, then waits. Never runs `Invoke-LCM_GoodMorning.ps1`. |
| D-26 | (2026-11-14) Claude good-night: operator types `/goodnight` (skill `LCM_AI/.claude/skills/goodnight/SKILL.md`) or "good night"; Claude updates only its `ACTIVE_SESSION.md` block and WORKPLAN, never runs `Invoke-LCM_GoodNight.ps1`, never commits. Order: Claude good-night first, then Antigravity GoodNight (commit), then Macrium backup = next BCR baseline. |
| D-25 | (2026-11-14, F-52 A) Session continuity switched to the host-neutral layer: Claude maintains only its "Host: Claude Code" block in `.agents/ACTIVE_SESSION.md`; `SESSION_HANDOFF.md` is a pointer; WORKPLAN stays the Claude host workplan (charter/decisions). Supersedes D-11. Session concepts per host are individual (operator). 2026-11-16: `SESSION_HANDOFF.md` deleted (operator, baseline review). |
| D-24 | (2026-11-14) Review practice: the operator reviews by priority filtering in BCR (ignores `.git` and other non-review-worthy content; Gate 0 = Specification only; Gate 2 = implementation plus the operator's real-life testing). Claude's checks are automated pre-tests, never acceptance; convergence reads only content-relevant changes (skip dates, whitespace, formatting). DEFERRED: Claude adds a ranked Gate 2 review guide to the Walkthrough (operator agreed in principle; postponed so Antigravity is not overloaded with a review cycle). |
| D-21 | (2026-11-14) Data authority: SQLite tables (`data/proposals/proposals.db`, `data/tools/tools.db`) are authoritative; the JSON files they replace are transition fallback only and will be removed; `.sql` dumps are produced at push, not synchronously. Claude must not rely on the JSON files. Answers Q-03. |
| D-19 | (2026-11-14) Terminology option C: per CRP, Claude's convergence steps go into a Claude section of that CRP's `Implementation_Plan.md`, confirmation evidence into its `Walkthrough.md`; WORKPLAN stays the cross-CRP charter, SESSION_HANDOFF the resume pointer. |

## 5. Verified Platform Facts

- Junction followed; unconditional rules load at session start.
- Path-scoped rules load on Read/Write/Edit of a matching file, also in subfolders; patterns relative to `D:\Git_Repositories` (`**/*.go` works; `../...` and absolute paths do not). A rule file already read is not injected again.
- LCM DO: `LCM_Inventory\DoT\do.exe` reaches the daemon on 127.0.0.1:9876 from Claude's shell; elevation per tool from `tools.admin` in `LCM_Inventory/data/tools/tools.db` (JSON catalog transition fallback only).
- `LCM_Inventory/config.json` does not exist; repository elevation data is in `LCM_Inventory/data/inventory.json`.

## 6. Open Questions

| ID | Question |
|:---|:---|
| Q-01 | ANSWERED by RULE-CTX-006 @2bebbaa: GoodMorning is operator-exclusive. |
| Q-02 | ANSWERED 2026-11-14 (D-20): external tools via DO. |
| Q-03 | ANSWERED 2026-11-14 (D-21): `proposals.db` authoritative, JSON fallback only. |
| Q-04 | ANSWERED 2026-11-14 (D-20): yes, Claude writes learned advice. |
| Q-05 | ANSWERED 2026-11-14 (D-20): no per-repository LCM configuration. |
| Q-06 | ANSWERED 2026-11-13 (D-14). |
| Q-07 | ANSWERED 2026-11-13: question-phrased requests are answered with solution paths, no action. |

## 7. Parked Documentation Observations (phase 3)

- Daemon reported v10.0.1 / 65 MB on 2026-11-13; CRP-320 documents v10.2.0 / 6.77 MB.
- Docs mix `Cmd/` and `DoT/`; LCM_AI Architecture names `AGENTS.md` and `LcmDesktopDaemon.ps1`.
- Elevation mechanism named three ways in docs (see also F-23).
- LCM_AI Requirements: `CR-yyyyMMdd_HHmmss.md` in `Docs/Methods/Proposals/` vs actual `CRP-nnn` bundles.
- Precedence (LCM-REQ-002) ranks repository-local executable behavior above the rules.
- CRP-326 bundle still on disk although `Status: Pushed` (RULE-LCM-020.3 purge).
- CRP-326 `Specification.md`: LF line endings.
