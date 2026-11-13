# File: WORKPLAN.md

Module: .claude/translation/WORKPLAN.md  
Purpose: Durable record of the agreed task, layout, operator decisions and open questions for the Claude adaptation of the LCM rules; read at the start of every Claude session.  
Path: LCM_AI/.claude/translation/WORKPLAN.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 21:34:53

---

## 1. Origin

- Agreed in Claude session "LCM_* repositories governance rules" (`b800d0c4-5ef9-4c14-9a38-929082f5a63e`, 2026-11-13).
- Refined in session "Model settings and Plan mode rules" (`3c16a548-e597-4d96-afad-b16b323472be`, 2026-11-13).
- This file is the authority for the plan; Claude's private memory only points here.

## 2. Goal (operator)

Check the quality of the LCM_* repositories against the rule set they contain NOW.

| Phase | Content | State |
|:---|:---|:---|
| 1 | USE/MAP the Antigravity rules (`.agents/rules`) into `LCM_AI/.claude`; deliver statements on incomplete, unclear or contradictory rules. | Active |
| 2 | Discuss choices; resolve incorrect or imprecise rules; operator "retranslates" them for VS Code and Gemini/Antigravity. | Pending |
| 3 | Analyze `docs/` (DOX first level), then code (mostly LCM_Inventory); sort out inconsistencies. | Pending |

- The operator collects Claude's findings into a CRP of their own.
- Phase 1 is a preliminary design: no CRPs, no source modifications.

## 3. Phase 1 Deliverables

| Path | Content |
|:---|:---|
| `rules/process/` | Lifecycle, gates, review/commit, analysis, goal-first, session protocol, macros. |
| `rules/quality/` | Language-neutral solution quality obligations, each stated once. |
| `rules/lang/` | Language bindings (PowerShell, Python, Go, CMD, JSON, Markdown/docs, HTML/display): how each language meets each neutral obligation; a missing binding is a finding. |
| `translation/FINDINGS.md` | Contradictions, imprecisions, gaps, Antigravity-only mechanisms; each with a proposed resolution; numbered and quotable. |
| `translation/COVERAGE.md` | Every source rule -> Claude mechanism (always-loaded rule, path-scoped rule, hook, skill, or not enforceable + reason) and enforcement level (1 mechanical, 2 instructed, 3 not enforceable). |

Translation fidelity: condensed normative MUST / MUST NOT statements with source rule IDs. Enforcement matters most; hooks and settings are built only after discussion.

## 4. Operator Decisions

| ID | Decision |
|:---|:---|
| D-01 | Root junction `D:\Git_Repositories\.claude` -> `LCM_AI\.claude`. Further junctions: ask first. |
| D-02 | Git: hide only root items via root `.git/info/exclude` (`/.claude/`, `/CLAUDE.md`). Otherwise ignore git as much as practical; files on disk are the only trusted state. |
| D-03 | Every produced file: DOX header, `Version: 10.2.5`, `Status: Draft`, CRLF, UTF-8 without BOM (verify after writing). |
| D-04 | Entry point: root `CLAUDE.md`, decoupled from `AGENTS.md`; rule-set synchronization via a future tool. |
| D-05 | Rule baseline: LCM_AI commit `43e36b0` (2026-11-12 18:30:41). |
| D-06 | Quality audit runs without LEV (LEV is a prototype-phase speed-up; rigor matters at publish). |
| D-07 | Timestamp response header permanently waived for Claude (operator-approved exception to the timestamp-header rule). |
| D-08 | Work stepwise; at most 1-3 lettered questions in chat; never guess - ask with alternatives. Questions from the operator are answered only, no actions. |
| D-09 | Do mechanical steps myself (e.g. test sessions via `claude -p`); bring the operator only real decisions. |
| D-10 | Operator behaviour rules and plan-mode triggers go into a rule file under `rules/process/`; memory only points to it. |
| D-12 | Finding types `HOST-CONTEXT` (correct for Antigravity, needs Claude reading) and `OPEN-END` (known unfinished, not an error) - the methodology evolves; open ends and sparse context are expected. |
| D-13 | Plan-mode trigger is context-based: BUG and `DOIT` -> no Gate 0 pause; CRP in standard flow with non-evident target -> plan mode with Gate 0 Contract. |
| D-14 | Version semantics (corrected 2026-11-13): version bump = +1.0.0 with minor and patch reset to 0, for ALL parts (e.g. 10.2.5 -> 11.0.0); release = +0.1.0; GoodNight push = +0.0.1 only for components that really changed (component level), unchanged components keep their patch digit. "Clean" required at release only, not at GoodNight pushes. Open: whether a release resets patch and applies to all parts (not stated). |
| D-15 | Correction requests to the Antigravity side: Claude MUST NOT write to `D:\GDrive\LCM\INBOX` (processed periodically by another daemon). The operator has AG register the existing "fragment" (start of Claude's delivered items) as an open proposal and gives Claude its CRP number; Claude stores its correction requests into that CRP when ready. CRP number: **CRP-326** (`LCM_Inventory/docs/Proposals/CRP-326-Governance-Rules-Harmonization-and-Documentation-Alignment/Specification.md`); Claude appends to its section 5 ("Scope for Upcoming Claude Amendments"); edit at Claude's discretion, but not while Antigravity is pushing / running GoodNight. |
| D-11 | Session continuity: this WORKPLAN plus `translation/SESSION_HANDOFF.md` (Claude-side analogue of GoodNight/GoodMorning, kept separate from `.agents` state until the rule sets are synchronized). |

## 5. Verified Platform Facts

- Junction followed; unconditional rules load at session start.
- Path-scoped rules load on Read/Write/Edit of a matching file, also in subfolders; patterns are relative to `D:\Git_Repositories` (`**/*.go`, `LCM_Inventory/**/*.go` work; `../...` and absolute paths do not). A rule file Claude has already read is not injected again.
- LCM DO: `LCM_Inventory\DoT\do.exe` reaches the daemon on 127.0.0.1:9876 from Claude's shell; elevation per tool from `config/tool_catalog.json` `Admin`.

## 6. Seed Findings (already in the operator's CRP)

| ID | Finding |
|:---|:---|
| C1 | RULE-CTX-006 requires the agent to run `GoodMorning -Auto`; LEARNED_ADVICE says only the operator runs it; script names differ. |
| C2 | RULE-REV-007 gives `+10.0.0` for patch, minor and major alike. |
| C3 | RULE-LCM-004 requires a second junction review session; RULE-REV-008 retires dual sessions. |
| C4 | Two lifecycle vocabularies (state table vs 7 sync points); LCM-007/014/016 still use the older terms. |
| C5 | Rules name `proposals.json` as ledger; LEARNED_ADVICE names `Proposals.db`. |
| C6 | Rule count stated as 17 / 18, 21 files exist; stray "iew." in LCM-016. |

## 7. Open Questions (ask when the matching rule is mapped)

| ID | Question |
|:---|:---|
| Q-01 | May Claude (or a hook) run GoodMorning, or is it strictly the operator's? |
| Q-02 | Are Claude's built-in Glob/Grep acceptable, or must discovery always use `es.exe` / `Search-Everything.ps1`? |
| Q-03 | Which proposal ledger is authoritative today: `proposals.json` or `proposals.db`? |
| Q-04 | May Claude write to the shared `.agents/LEARNED_ADVICE.md` (`/learn`), or stay in the separate Claude scheme (D-11)? (FINDINGS) |
| Q-05 | Where is the per-repository LCM configuration today (`<Repo>/LCM_Inventory/config.json` exists nowhere)? (FINDINGS F-10) |

## 8. Parked Documentation Observations (not judged; phase 3)

- Daemon reports v10.0.1 / 65 MB; CRP-320 documents v10.2.0 / 6.77 MB.
- Docs mix `Cmd/` and `DoT/`; LCM_AI Architecture still names `AGENTS.md` and `LcmDesktopDaemon.ps1`.
- Elevation mechanism named three ways: `Start-ScriptProcessElevated.ps1`, `lcm do` + `LcmDesktopDaemon.ps1`, `do.exe` (CRP-320 retires the PowerShell daemon and `Invoke-PrivilegedTool`).
- LCM_AI Requirements: `CR-yyyyMMdd_HHmmss.md` in `Docs/Methods/Proposals/` vs actual `CRP-nnn` bundles in `docs/Proposals/`.
- `proposals.json` called single source while `proposals.db` exists.
- Precedence (LCM-REQ-002) ranks repository-local executable behavior above the rules.
- LCM_AI Requirements names LCM 10.0.1 in a 10.2.5 document.
