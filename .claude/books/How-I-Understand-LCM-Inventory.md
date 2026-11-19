# How I Understand LCM Inventory

Module: .claude/books/How-I-Understand-LCM-Inventory.md  
Purpose: Book 2 - Claude's reading of the LCM_Inventory documentation (the machine room of LCM), in the same order and with the same yardstick as Book 1; findings written as the plot.  
Path: LCM_AI/.claude/books/How-I-Understand-LCM-Inventory.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft (Book 2 complete, documentation only)  
Date: 2026-11-15 17:47:30

---

## Reading Contract

- Commissioned 2026-11-15 together with Book 1 (`How-I-Understand-LCM-Methodology.md`). Documentation only; no code review yet (a few read-only checks of the running system are marked "observed").
- Scope: the LCM parts only. Not read: other subsystems (HaSSD06, SystemConfiguration), ordinary repositories, external tools, proposal bundles, generated dashboards (`INVENTORY_DASHBOARD.md`), historical reports (`AR_2026-10-14_*`, `LCM_BETA_10.0.0_*`, `ACTIVE_SESSION_CONTEXT.md`, `CHANGE_REQUEST_INDEX.md`).
- **Scope correction (observed):** the operator expected the LCM tools to carry subsystem `LCM` in the tools table. In `tools.db` only 1 tool has subsystem `LCM`; the LCM tools are classified `LCM_Inventory` (136), `LCM_Tools` (78) and `LCM_Supervision` (3). I treat these three as LCM. Other subsystems: `SystemConfiguration` (72), `HaSSD06` (30).
- Read: `README.md`, `docs/Architecture.md`, `docs/Requirements.md`, `docs/Implementation.md`, `docs/DataDesign-Proposals.md`, `docs/DataDesign-Tools.md`, `install/Installation.md`, `docs/Implementation of Security in LCM.md` (core sections), and the key sections of `CM_POLICIES.md`, `LCM_METHODOLOGY_AND_MEMORY_ANCHOR.md`; headings of `StandardDisplayFreshness.md`, `AnalysisOperations.md`, `FailureModeAnalysis.md`, `docs/README.md` (a 353-line tool index).

---

## Chapter 1 - The Promise (README.md, 10.2.1, 2026-10-18)

LCM_Inventory presents itself as the Configuration Management system for everything under `D:\Git_Repositories\`: inventory and classification of every directory, special tracking of LCM_AI's four lifecycle states, LCM version upgrades, commit/push audit, a central change-request index, baselines and drift detection. It lists CLI workflows, a Beyond Compare integration ("RR" shortcut), methodology anchors and the directory layout.

**How I understand it:** the registry, the clerk and the machine room of LCM - it records what exists, what changed, what was decided and reviewed, and it owns the machinery that moves a proposal through its life.

Plot points:

- **N-R1 Not a manager page** either; it starts with document links and a diagram.
- **N-R2 Two generations on one page.** `Invoke-MacriumBcrReview.ps1` (current) next to `Submit-ReviewResult.ps1` "Accepted, AcceptedWithEdits, Rejected, Deferred" and `RR.ps1` (legacy dispositions); `Find-ChangeRequest.ps1`, `overrides.json`, LCM_AI's four states.
- **N-R3 "Approach 1": rules physically in `LCM_Inventory/.agents/`.** See plot thread 1.
- **N-R4 Ledger invariant:** logs "strictly tracked and pushed" - the LCM_AI Subsystem Architecture says logs are gitignored runtime state.
- **N-R5 Topology** omits LCM_Tools (78 LCM tools live there).
- **N-R6 Module list** names `WorkspaceCM.psm1`, `ChangeRequestManager.psm1`; the lifecycle authority `ProposalManager.psm1` is not mentioned.

---

## Chapter 2 - The House (Architecture.md, 10.2.1, 2026-10-18)

The document draws three surfaces (HTML dashboards, CLI tools, data stores), a proposal lifecycle, cohorts (CRP-259, current and precise), the Macrium BCR gate as a sequence, the junction topology, the documentation-reconciliation service and ADMINMODE. It begins with two late additions (1.1 daemon availability, 1.2 original proposal intake) placed before section 1.

**How I understand the house:** a ledger at the center, a Control Hub as the window onto it, a review gate in front of every commit, a daemon that lets background agents reach the operator's desktop, and a rule hub projected into every repository.

Plot points:

- **N-A1 Fourth lifecycle vocabulary.** Diagram: `suggested -> approved -> completed -> review_gated -> accepted -> pushed`. Rules and this repository's own Implementation 4.1: `suggested -> in_progress -> verified -> in_review -> completed -> pushed`. Section 2.1 of the same document already adopts the flat `state`/`state_reason` record - the diagram contradicts its own text.
- **N-A2 The rule hub is placed in LCM_Inventory** ("canonical physical storage for all 17 authoritative governance policies at `LCM_Inventory/.agents/rules/`"). Rules today: 21 files, physically in `LCM_AI/.agents/rules/` (RULE-AUTH-001; observed: root `.agents` is a junction to `LCM_AI\.agents`).
- **N-A3 The daemon is described as PowerShell** (`LcmDesktopDaemon.ps1`) with a `/hub-events` stream that reloads every open hub on completion. Observed: port 9876 is served by the Go `do.exe daemon`; `/hub-events` exists only in `tools/LcmDesktopDaemon.ps1` and a test - the running daemon has no such route. The documented automatic hub reload therefore cannot happen; CRP-335 restored only the manual Refresh.
- **N-A4 Data stores** named as `proposals.json`, `tool_catalog.json`; today the SQLite databases are authoritative (D-21) and documented in this repository's own DataDesign files.
- **N-A5 Tool names in the house plan** (`Show-CmControlHub.ps1`, `Show-LcmActiveLauncher.ps1`, `Invoke-WorkspacePush.ps1`) - several differ from the tools in use (`Show-LcmControl.ps1`, `Invoke-LCM_Push.ps1`).
- **N-A6 BCR commits by itself** in the sequence diagram; the rules let `COMPLETE` / `Submit-ReviewResult.ps1` commit after the disposition.
- Good: ADMINMODE (section 6) is precise and matches RULE-REV-011, including "an elevated process without Administrators membership is not authorized" - the same principle the operator stated for elevation permits.

---

## Chapter 3 - The Job Description (Requirements.md, 10.2.0, 2026-10-13)

Prerequisites (PowerShell 7.4+, Windows 11, default un-elevated, encoding), invariants REQ-WINV-001..006 (review gate, receipts, proposals, audit, lockstep push, artifact isolation), display standards, a draft concept for contract/interface/atom inspection tools (REQ-WINV-007..010), documentation reconciliation (011), recovery lifecycle and cohorts (012, 013).

**How I understand the job:** keep the ledger single and complete, never commit without a reviewed disposition, audit every repository, push in lockstep, keep generated views out of `docs/`.

Plot points:

- **N-Q1 Elevation route retired.** Admin tools "must route through `Start-ScriptProcessElevated.ps1`"; RULE-ELEV-006 routes admin tools through the DO gateway and lists the older wrappers as retired.
- **N-Q2 Ledger.** REQ-WINV-003: `proposals.json` is the single source; D-21: `proposals.db` is authoritative, JSON a transition fallback.
- **N-Q3 Push tool.** REQ-WINV-005: `Invoke-WorkspacePush.ps1`; RULE-LCM-013: `Invoke-LCM_Push.ps1`.
- **N-Q4 Rule citations off by one** (receipts cited as RULE-REV-003, they are RULE-REV-005; audit cited as RULE-EFF-001). Receipt file pattern `review_<Repo>_<ts>.json` versus RULE-REV-005 `REVIEW-<Repo>-<Timestamp>.json`.
- **N-Q5 Draft concept with MUSTs** (007..010), explicitly marked "not authoritative" - good marking, but MUST language in a draft.
- **N-Q6 Versions disagree inside the repo:** README 10.2.1, Architecture 10.2.1, Requirements 10.2.0, Implementation 10.2.0, Installation 10.2.0, DataDesign 10.2.3; PowerShell 7.4+ here, 7.0+ in LCM_AI.
- **N-Q7 Acceptance criteria** missing, as in Book 1; REQ-WINV-012 and -013 are the good exceptions.

---

## Chapter 4 - The Gory Details (Implementation.md, DataDesign, Security, Installation)

### Implementation.md (10.2.0)

Directory layout, `WorkspaceCM.psm1` cmdlets, tool table, Control Hub safe-action contract, the pre-commit review authorization (2-hour token), the IDE canvas projection, ledger schema, and - the highlight - section 4.1: the lifecycle state/gate/action/switch contract with `ProposalManager.psm1` as lifecycle authority, the `1 - REVIEW` / `2 - REVIEW` labels, the switch table and a list of unresolved design questions. Section 4.1 is the most accurate description of how LCM actually works that I found in either repository.

Plot points:

- **N-I1 Two lifecycle engines in one document.** Section 2: `WorkspaceCM.psm1` exports `New-Proposal` and `Set-ProposalState` with states `suggested, approved, completed, pushed, rejected`. Section 4.1: `ProposalManager.psm1` is the lifecycle authority with the flat ten-state table.
- **N-I2 Terminal states.** 4.1 (and, observed, the code's action table) allow `withdrawn -> superseded` and `rejected -> superseded` / `create-linked-bug`; the rules' table makes `withdrawn`, `rejected`, `superseded` terminal (`view` only). Here the documentation follows the code, not the rules.
- **N-I3 Read-only hub claim (3.1)** - "disabled: proposal state changes" - is older than CRP-329 (hub actions via the daemon's `/api/action`).
- **N-I4 Inventory schema versus code (observed).** The schema shows `"workspace_ai_baseline": "10.0.0"` as a string; `New-LCM_Proposal` reads `workspace_ai_baseline.GlobalLCMVersion` as an object field.
- **N-I5 Ledger schema** shows `"priority": "M"` (letters); rules and DataDesign use integers 0..10.
- **N-I6 Numbering:** two sections "3.1"; unresolved question 5 refers to `last_proposal_id: 262` (today 337).

### DataDesign-Proposals.md and DataDesign-Tools.md (10.2.3, 2026-11-12)

Exactly what RULE-DOC-012 asks for: DDL, constraints, indexes, views, tools. They are the right kind of document. But they do not describe the databases that exist (observed read-only 2026-11-15):

- **N-D1 `proposals.db`.** Documented: wide `proposals` table (timestamp, cr_id, app ids, docs_json, gate1 flags, dates_json, state_history_json, ...) plus `review_cohorts` and two views. Actual: a narrow `proposals` table with `raw_json`, `is_active`, `is_historical`, `pushed_at`; tables `strategies` and `strategy_crps` (undocumented); no `review_cohorts`; no views. Documented `priority DEFAULT 8`; the creating function uses 5.
- **N-D2 `v_active_proposals`** (documented) filters `lcm_version LIKE '10.2.%'`; current proposals carry `10.6.4`.
- **N-D3 `tools.db`.** Documented `intent_id` column and view `v_maintenance_tools` do not exist; an undocumented table `tool_intents` (with its own `elevated` column, next to `tools.admin`) and view `v_tool_intents_summary` do.
- **N-D4 Dual-state wording.** "Textual baseline: `proposals.sql` & `proposals.json`" and "`config/tool_catalog.json`" - D-21 makes the JSON files transition fallbacks.

### Implementation of Security in LCM.md (10.2.0, 2026-11-09)

The clearest statement of the security model in all of LCM: least privilege; GUIs (Beyond Compare, editors, browsers) must never run elevated (UIPI, file ownership poisoning); elevation confined to the atomic operation; one machine-registry hive; no opaque `-EncodedCommand` UAC prompts. Three tiers: standard user space; an elevated desktop daemon whose security gateway runs a tool elevated only if `tool_catalog.json` says `Admin: true`, otherwise un-elevated; standalone elevated atoms as fallback.

- **N-S1 The model the operator stated (CRP-337) is already written here** - and was implemented in the PowerShell daemon. The Go daemon now on port 9876 runs every command at High integrity (observed), so the anti-GUI-poisoning invariant is currently violated for anything the daemon opens.
- **N-S2** Tier 3 names `Invoke-PrivilegedTool.ps1`, which RULE-ELEV-006 lists as retired; the catalog source is `tool_catalog.json`, not `tools.db`.

### install/Installation.md (10.2.0, 2026-11-10)

A real 7-phase runbook (RULE-DOC-004): prerequisites, layout, preflight, deployment, verification, servicing, rollback. So an installation description exists for LCM_Inventory - but it does not install today's LCM:

- **N-N1 Missing steps:** the Go `do` gateway (build, `DoT/do.exe`), the scheduled daemon task, Macrium and the BCR baseline, Everything / `es.exe`, `Git_Root`, the SQLite databases and their sync, the Python venv.
- **N-N2 Paths:** Beyond Compare under `C:\Program Files\...` (LCM_AI says `D:\Tools\Beyond Compare 5\`); `Cmd\` instead of `DoT\`; `config/config.json`.
- **N-N3 Rollback is dangerous as written:** `Remove-Item scratch/*` (would delete, for example, the daemon rollback binary kept there since CRP-335) and `git clean -fd`; it stops `Show-LcmDaemon.ps1` (a viewer) instead of the daemon task; it preserves `proposals.json` but not `proposals.db` / `.sql`.
- **N-N4 It is right where the others are wrong:** phase 4 checks that `.agents/rules` points to `LCM_AI/.agents/rules` - the current truth, contradicting this repository's Architecture, Implementation, README, CM_POLICIES and Methodology Anchor.

### CM_POLICIES.md and LCM_METHODOLOGY_AND_MEMORY_ANCHOR.md (10.2.0, 2026-10-13)

- **N-P1 Fifth lifecycle vocabulary.** CM_POLICIES 3: a two-tier model, plan state `bug / suggested / approved / deferred / rejected / completed` and progress state `undecided / queued / in_progress / verification / completed / blocked / failed`. Its own section 5.3 then declares the flat `state`/`state_reason` record. (The `progress_state` column survives in `proposals.db` with values such as `verification`, `undecided`, `pushed` - observed.)
- **N-P2 "Approach 1" in full:** physical `LCM_Inventory/.agents/` holding rules, `hooks.json`, `mcp_config.json`, `ACTIVE_SESSION.md`, `ACTIVE_CONTEXT.md`; root `.agents` and child `.agents/rules` as junctions into it; Git tracks the physical path. Today the physical owner is LCM_AI (Book 1, RULE-AUTH-001, CLAUDE.md, observed junction).

---

## Chapter 5 - LCM Inventory as I Understand It

**What it is for.** LCM_Inventory is where LCM keeps its records and its machines:

- **Records:** the proposal ledger (`proposals.db`, projected to `proposals.sql`, JSON fallback), the proposal bundles of all `LCM_*` work, review receipts, the activity log, the workspace inventory and baselines, the tool catalog (`tools.db`), analysis evidence.
- **Machines:** the lifecycle engine (`ProposalManager.psm1` + `Invoke-ProposalAction.ps1`), the review gate (`BCR.cmd` / `Invoke-MacriumBcrReview.ps1`, `Submit-ReviewResult.ps1`, the pre-commit hook), the Control Hub (`Show-LcmControl.ps1`, displays), the DO gateway and Session-1 daemon (`src/do/`, `DoT/`), the session tools (GoodMorning, GoodNight, Save-AllSessionMemory, learned advice), the push conductor, the inventory/audit and rule-health tools.
- **Safety model:** least privilege, atomic elevation by catalog flag, GUIs never elevated, ADMINMODE for rule changes, review authorization tokens for commits.

**What changed underneath the documents.** In the autumn of 2026 three migrations happened: JSON ledgers -> SQLite; PowerShell daemon -> Go `do` gateway; rule ownership LCM_Inventory -> LCM_AI. The documents describe the state before all three, with patches added on top (cohorts, recovery lifecycle, documentation reconciliation) that are current.

---

## Chapter 6 - The Plot

### The crime

The machine room's manual describes machines that were replaced: the rules' home, the daemon, the ledgers. And the replacement machines silently lost three documented capabilities.

### The threads

1. **Where do the rules live?** Five LCM_Inventory documents (README, Architecture, Implementation, CM_POLICIES, Methodology Anchor) say `LCM_Inventory/.agents/` (17 rules), with the root junction pointing there. LCM_AI's documents, the rules themselves, `Installation.md` and the disk say `LCM_AI/.agents/` (21 rules). Two repositories each claim, in "authoritative" documents, to be the physical owner.
2. **The migration that forgot (PowerShell daemon -> Go `do` daemon).** Documented and implemented in the PowerShell daemon, absent in the Go daemon:
   - (a) display refresh re-renders - restored by CRP-335 (2026-11-15);
   - (b) `/hub-events` completion push to every open hub - still absent;
   - (c) the security gateway: elevate only catalog-admin tools, never elevate GUIs - still absent; every DO command runs elevated (CRP-337).
   No document records that the Go daemon replaced the PowerShell daemon, so nobody had a list of what had to be carried over.
3. **Five lifecycle vocabularies** across the two books: rules/ledger (flat ten states), LCM_AI Control Hub proposal (`Open/Active/...`), LCM_AI legacy (`processed`, `OPEN`), LCM_Inventory Architecture (`approved -> review_gated -> accepted`), CM_POLICIES two-tier (`bug/approved/deferred` + `queued/verification/blocked/failed`). Only one is enforced by the database CHECK - the documentation of that CHECK is itself out of date (N-D1).
4. **Data documented, data different.** DataDesign describes a schema the databases do not have, misses tables they do have (`strategies`, `tool_intents`), and the active-proposal view filters an old version series.
5. **Two elevation flags and no enforcement.** `tools.admin` and `tool_intents.elevated` coexist (observed); neither is consulted by the running daemon.
6. **The installation exists, but for an older LCM** and with a rollback that can destroy the CRP-335 rollback copy.
7. **Version numbers drift inside one repository** (10.2.0 / 10.2.1 / 10.2.3 across its own tripartite set), while LCM_AI's tripartite set is uniformly 10.6.4 - two different interpretations of the version rules side by side (Book 1, plot thread 2).

### The verdict

The same missing gate as in Book 1 - nothing compares documentation content with the running system or the rules - plus a second gap specific to the machine room: **component replacements (ledger, daemon, rule home) were done without a carry-over checklist**, so the replacements are documented nowhere and lost capabilities surfaced only as operator observations (stale hub, elevation everywhere).

---

## Chapter 7 - What I Would Do (suggestions; no CRP drafted)

1. **Decide and record the rule home** (LCM_AI, as the rules say) and mark "Approach 1" historical in the five LCM_Inventory documents.
2. **Write the missing migration record for the Go daemon:** a capability carry-over table (PowerShell daemon feature -> Go status). It feeds CRP-335 (done), CRP-337 (security gateway, open) and a new item for `/hub-events`.
3. **Regenerate the DataDesign documents from the live databases** (DDL via `sqlite_master`), then decide which side is right for each difference.
4. **One lifecycle vocabulary** in all documents: the ledger states; map every older word once in a glossary and mark the old diagrams historical.
5. **Fix the installation runbook's rollback** (no blanket `scratch` purge, no `git clean -fd`, stop the daemon task, preserve the databases) and add the missing installation steps as placeholders.
6. **Before the +0.1.0 push:** decide whether LCM_Inventory's mixed component versions (10.2.0..10.2.3) are intended (component versioning) or must be aligned (Book 1, plot thread 2).
