# How I Understand LCM Methodology

Module: .claude/books/How-I-Understand-LCM-Methodology.md  
Purpose: Book 1 - Claude's reading of the LCM_AI documentation (README -> Architecture -> Requirements -> Implementation -> implementation-level siblings), told as a story, with the consistency, completeness and quality findings written as "the plot of the crime".  
Path: LCM_AI/.claude/books/How-I-Understand-LCM-Methodology.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.7.4  
Status: Draft (Book 1 complete; operator review recorded in Appendices B and C)  
Date: 2026-11-16 21:43:29

---

## Reading Contract

- Commissioned by the operator on 2026-11-15. Scope: the documentation of LCM_AI only; no code. Book 2 (LCM_Inventory) follows.
- Reading order as instructed: README.md (manager view) -> Architecture.md (the house) -> Requirements.md (job description + acceptance criteria) -> Implementation.md (the gory details) -> implementation-level siblings (e.g. `LCM_Deterministic_Hook_Engine_Architecture.md`).
- Not read: `docs/LCM_Rules_Gemini_Export.md` (236 KB generated export of the rules), `docs/Logs/` (history). The canonical rules themselves (`.agents/rules/`) I know from the Claude adapter work; I use them as the yardstick.
- Evidence style: each finding names the document and section. "Today" means facts I observed on 2026-11-15 while working (marked as such); everything else comes from the documents.

---

## Chapter 1 - The Promise (README.md)

### What the operator wants a README to be

A manager-level page: what use the reader can expect from LCM_* (all of it, not only LCM_AI), what must be in place, and how to get it. Installation is a known gap and may stay a placeholder.

### What the README actually is

`LCM_AI/README.md` (2026-11-14, baseline 10.6.4) is an engineer's entry card:

1. **Prerequisites**: PowerShell 7, Git, NTFS junctions/hardlinks, a Python venv with the Google Antigravity SDK, Antigravity IDE / VS Code, Beyond Compare 5.
2. **Documentation index**: the tripartite set (Requirements, Architecture, Implementation).
3. **Extended guides**: CM architecture, CRP-135 regression lifecycle, onboarding, repository inventory, standards, conventions, logs.
4. **Verification commands**: `Test-WorkspaceReadiness.ps1`, `Invoke-LCMOnboardRepo.ps1 -Update`, `Invoke-BeyondCompareReview.ps1`.

`LCM_AI/docs/README.md` (10.2.0, 2026-10-13) repeats the prerequisites and the index and adds `install/Installation.md` and a list of specialized references.

### How I understand the promise from it

LCM is a governance framework for a family of Git repositories on one Windows workstation: a rule set, a proposal-and-review lifecycle, a configuration-management ledger, and AI hosts that work under those rules. The README never says this in one sentence.

### Plot points (README)

- **R-1 Audience miss.** No sentence answers "what do I get". The first content is a toolchain list; a manager learns that Python and Beyond Compare are needed but not why LCM exists.
- **R-2 Scope miss.** The README speaks for LCM_AI only; the reader does not learn that LCM consists of LCM_AI, LCM_Inventory, LCM_Shared, LCM_Supervision and LCM_Tools, nor what each contributes.
- **R-3 Prerequisites incomplete for today's LCM.** Missing: Macrium Reflect (the BCR baseline images, RULE-REV-008/012), Everything / `es.exe` (RULE-EFF-007), Go (the `do` gateway is a Go program), SQLite (proposals and tool catalogs are SQLite databases, D-21), the Desktop daemon as a scheduled task. Claude Code is not mentioned as a sanctioned host (RULE-AUTH-001 lists it).
- **R-4 Stale commands.** `Invoke-BeyondCompareReview.ps1` is the pre-BCR review route; RULE-REV-014 now prohibits ad-hoc comparisons and names `BCR.cmd` / `Invoke-MacriumBcrReview.ps1` as the only valid one. `.\Invoke-BeyondCompareReview.ps1` is also called from the LCM_AI root, where it does not live.
- **R-5 Two READMEs disagree.** Root README is 10.6.4 and lists no installation runbook; `docs/README.md` is 10.2.0 and links `install/Installation.md`. RULE-DOC-002 makes the top-level README the executive summary and index; the second one duplicates it.
- **R-6 Installation placeholder.** Acknowledged by the operator as a known gap; the README should say so explicitly instead of implying a runbook exists.

---

## Chapter 2 - The House (Architecture.md)

### What the operator wants an Architecture to be

The shape of the "house" (the ant hill) for a technically minded reader: what one gets from LCM physically and in prime use cases, not how to run the faucets.

### The house as the document draws it (version 10.6.4, 2026-11-14)

1. **Topology.** One root container `D:\Git_Repositories\`. A triad: LCM_AI (baseline authority, quality gates, specs), LCM_Inventory (CM engine, proposals ledger, review audit, rule health), LCM_Shared (reusable PowerShell atoms). LCM_Supervision as a subsystem. Rules live once, in `LCM_AI/.agents/rules/`, and are projected into the other repositories by NTFS junctions ("hub and spoke").
2. **Proposal and review stream.** Ideas become proposals in a ledger; the operator says "do"; the agent changes the live tree; Beyond Compare shows baseline (left) against live (right); the operator accepts; a review receipt is written; a review-gated commit follows; LCM_Inventory records it.
3. **Control Hub.** A lifecycle rail for decisions plus a separate execution ledger for evidence; cohorts (`COH-<prime>`) coordinate several CRPs into one review; Gate 1 is planning, Gate 2 is the BCR decision; `DOIT` reaches Gate 2 but never passes it.
4. **CM engine tools** (diagnostics, reconciliation, proposal CLI, review queue, action runner, audit logging).
5. **Standard repository layout** (docs tripartite, install, modules, tools, tests, junctioned `.agents/rules`).
6. **Governed upgrades** (proposal-first, `-Execute` only on instruction).
7. **Desktop REST bridge daemon** on port 9876 so background agents can open GUI tools in the operator's desktop session; short-name `.cmd` launchers.
8. **DOX principle** - documentation drives implementation - and a bottom-up method to synthesize the tripartite documents from existing code.
9. **Regression CRPs** (CRP-135): automatic child proposals for ripple effects, bounded depth 2, cycle detection.
10. **App-centric decomposition** (CRP-048): `App: n` slices across the three documents, an active context (`Workon:`), a machine catalog `apps.json`, inter-App contracts.
11. **Atomic Assembly** - named "the ultimate goal of LCM": software built from verified atoms -> assemblies -> Apps -> repository ecosystem, so that AI agents assemble instead of inventing.
12. **Model-first analysis** (CRP-243): `ANALYZE` locks read-only mode; `IMPLEMENT` unlocks governed implementation; a circuit breaker drops back to analysis on a failed assumption.

### How I understand the house

The idea is coherent and strong: **one authoritative rule source, one proposal ledger, one review gate (visual diff by the human), one CM record**, and AI agents that are useful only inside those walls. The long-term vision (section 10.9) is a library of verified atoms from which AI assembles software deterministically. The "house" therefore has three floors: governance (rules, lifecycle, gates), operations (ledger, CM, review, daemon), and the product vision (Apps and atoms).

### Plot points (Architecture)

Contradictions with the canonical rules (the yardstick):

- **A-1 Review stream is from an older era (section 3).** States `suggested -> processed`, `CR-*.md` files, `%TEMP%\BC_Review\` git-export baselines, acceptance by deleting the temp folder, `RR.ps1 -Result Accepted`. Today's model: flat states `suggested -> in_progress -> verified -> in_review -> completed -> pushed` (RULE-LCM-007, ProposalReviewFlowPolicy table) and BCR against a mounted Macrium image (RULE-REV-008); RULE-REV-014 prohibits Git-based comparisons. The diagram teaches the reader a workflow that is now forbidden.
- **A-2 Review granularity default inverted (3.2).** Architecture: `coarse` is default. RULE-LCM-003: `tight` is default, and every push resets to `tight`.
- **A-3 Review exemption (3.2).** Architecture: "LCM_Inventory is the sole exempt repository." RULE-LCM-004: only `LCM_Inventory` `data/`, `logs/`, `scratch/` are exempt; `tools/`, `modules/`, `docs/`, `tests/`, `Cmd/` require review.
- **A-4 A third state vocabulary (3.4).** The "proposed" Control Hub statuses `Open / Active / Review / Complete / Published / Held / Cancelled` are neither the ledger states nor marked as superseded; RULE-LCM-007 forbids a second lifecycle vocabulary. The section is labelled "Proposed" with no decision recorded.
- **A-5 Negative priorities (section 9).** Regression children get priorities -1, -2; RULE-LCM-015 and section 3.4 define priority as 0..10.
- **A-6 Proposals inside every repository (5, 6).** The layout puts `docs/Proposals/` (and `Invoke-LCMUpdate.ps1` writes proposals) into each target repository. RULE-LCM-034 / RULE-SUB-008: proposals about `LCM_*` repos live only in LCM_Inventory; child `LCM_*` repos have no `Proposals/`.
- **A-7 App layout contradicts itself and the rule (10.1).** Decision: "flat in-document section slices; folders reserved strictly for autonomous subsystems". RULE-DOC-007: split layout `docs/App#<N>-<Slug>/`. Today's test suite also exercises the split layout (`New-LcmApp -SplitDocs`).
- **A-8 Active context location (10.2).** `Workon:` is said to write `.agents/ACTIVE_SESSION.md`. Today `.agents/ACTIVE_SESSION.md` is the multi-host continuity file (RULE-LCM-030); the App context is stored in the proposal store and `LCM_Inventory/data/session_state/active_session.json` (observed today).

Stale facts against today's system (observed 2026-11-15):

- **A-9 Daemon described as PowerShell.** Section 7: `LcmDesktopDaemon.ps1` with `LcmDaemonCore.psm1` and a `[DaemonActionController]`. Today port 9876 is served by the Go program `LCM_Inventory/DoT/do.exe daemon` (scheduled task `LCM_DesktopDaemon_rgbig`, RunLevel Highest). The PowerShell display coordinator's rebuild logic was not carried over, which caused CRP-335.
- **A-10 Elevation is invisible.** "Session 1 Elevation & Focus Invariant" mentions elevation only in the title. The fact that every DO command runs elevated (CRP-337) and that permits should depend on `tools.admin` and the Administrators group (operator model) is nowhere in the house plan.
- **A-11 Launcher folder and catalog.** `LCM_Inventory/Cmd/` and `tools/tool_catalog.json`; today the trampolines live in `DoT/` and the authoritative catalog is `data/tools/tools.db` (D-21), `config/tool_catalog.json` a transition fallback.
- **A-12 Per-repo `LCM_Inventory/config.json` and `overrides.json` (5).** Do not exist (WORKPLAN fact 5); D-20/Q-05: no per-repository LCM configuration.
- **A-13 Tool names in section 4** (`Get-OpenProposals.ps1`, `Get-ReposUnderReview.ps1`, actions `do/delete/defer`) belong to the legacy vocabulary.

Missing rooms (completeness):

- **A-14** No word on: LCM_Tools and LCM_Supervision's purpose (LCM_Shared even appears twice in the topology diagram, LCM_Tools not at all); the Macrium baseline as the review anchor; the multi-host continuity layer (`.agents/ACTIVE_SESSION.md`, `ACTIVE_CONTEXT.md`, `LEARNED_ADVICE.md`) and GoodMorning/GoodNight; the SQLite ledgers; versioning and release (major/minor/patch); the sanctioned host adapters (Claude Code `.claude/`, Antigravity).
- **A-15 Junction target differs within the document.** Section 2: each repo's `.agents/rules` junction points to `LCM_AI/.agents/rules`. Section 5: `.agents/rules -> D:\Git_Repositories\.agents\rules` (the root container).

Quality (fitness for the intended reader):

- **A-16 Faucets in the house plan.** Large parts are "how": tool file names, JSON paths, wake words, commit-message formats, GitHub labels, script names (`Split-LcmArchitectureToApps.ps1`). By the operator's definition and RULE-DOC-002 these belong in Requirements or Implementation.
- **A-17 Proposed and decided mixed without markers.** "Proposed Control Hub Facets", "Proposed Post-Commit Review Cleanup", "Proposed Query Index Scenarios" sit next to decided architecture; a reader cannot tell what exists.
- **A-18 Section numbering.** Headings "10.0.0 Review Snapshot Chain", "10.0.0 Cohort Coordination", "10.0.0 Documentation Reconciliation Flow" use a version number as a section number; the numbering jumps.

---

## Chapter 3 - The Job Description (Requirements.md)

### What the operator wants Requirements to be

The implementor's job description: the functions the use cases consist of, and the acceptance criteria by which one decides that they are met.

### What the document contains (version 10.6.4, 2026-11-14)

- **Scope**: conformance = all MUST/MUST NOT met, every exception documented, prerequisites active, evidence preserved. A package-version rule: at commit the LCM_AI package version equals the highest component version, and README plus the three specifications agree.
- **System prerequisites** (SYS-001..005): PowerShell 7, Git with `main`, NTFS links, the Antigravity Python environment, Beyond Compare 5.
- **Authority and precedence** (REQ-001..006): LCM_AI is the single authority; a five-level precedence; identity `LCM_AI`; overrides; skills packaging; a `Working/` scratch folder.
- **Lifecycle** (REQ-010..012): repository classification; CR-first updates; explicit execution switch.
- **Ownership and change requests** (REQ-020..023): per-repository proposals as `CR-yyyyMMdd_HHmmss.md`, test bundles.
- **Verification and gates** (REQ-030..041): readiness runners, drift monitoring, elevation declaration, documentation fabric, auto-accepted telemetry, the Review Result subsystem, review-gated commits, the tripartite standard, the installation runbook, review scope.
- **Proposed** REQ-042..045 (Control Hub facets, review snapshots, BCR cleanup, query index) and **decided** REQ-046 (cohorts, CRP-259) and REQ-LCM-196 (documentation reconciliation).

### How I understand the job

The requirements say three things clearly and well: (1) nothing changes without an approved change request and a dry run; (2) nothing is committed without a recorded visual review disposition; (3) one authority root, no divergent copies. The cohort contract (REQ-046) is the most mature text in the set: precise, atomic, fail-closed, testable.

### Plot points (Requirements)

Contradictions with the canonical rules:

- **Q-1 Precedence upside down (REQ-002).** Rank 1 is "repository-local executable behavior and configuration", above the authoritative rules (rank 2). RULE-AUTH-001: `.agents/rules` is the single authoritative source. As written, any script's behavior overrules the rules. (Already parked in WORKPLAN phase-3 observations.)
- **Q-2 Change requests of an older generation (REQ-020..022).** Per-repository `Docs/Methods/Proposals/CR-yyyyMMdd_HHmmss.md`. Today: `CRP-nnn` / `BUG-nnn` bundles with `Specification.md`, `Implementation_Plan.md`, `Walkthrough.md`, ledger id from `proposals.db`, all in `LCM_Inventory/docs/Proposals/` (RULE-LCM-009, -011, -034).
- **Q-3 Review subsystem of an older generation (REQ-037, -038).** `%TEMP%\BC_Review` git-export baselines, folder-deletion consent, dispositions `Accepted / AcceptedWithEdits / Rejected / Deferred`. Today: BCR against the Macrium image (RULE-REV-008, -014); dispositions `completed / completed_with_edits / rejected / held` (RULE-REV-002, -005).
- **Q-4 Elevation declared in a file that does not exist (REQ-033, -034).** `execution_context` in `LCM_Inventory/config.json` per repository. RULE-ELEV-001: `Elevation:` line in the repository's `AGENTS.md`, aggregated into `inventory.json`, tool level in `tools.admin`. D-20: no per-repository LCM configuration.
- **Q-5 Overrides file (scope paragraph, REQ-004).** Every exception "documented in `LCM_Inventory/overrides.json`": that file does not exist; the rules know no overrides file.
- **Q-6 Tripartite mapping mislabelled (REQ-039).** Maps Architecture -> RULE-DOC-001, Requirements -> RULE-DOC-002, Implementation -> RULE-DOC-003. In the rules DOC-001 defines all three, DOC-002 is "no conceptual bleed", DOC-003 is the DOX header. REQ-039 and REQ-035 also require `docs/README.md` as a fourth document; RULE-DOC-002 makes the top-level `README.md` the index.
- **Q-7 Installation runbook scope (REQ-040).** "Every governed repository MUST provide `install/Installation.md`." RULE-DOC-004: repositories that deploy payloads, with seven named phases. The REQ omits the phases; the rule omits non-deploying repos.
- **Q-8 Scratch folder name (REQ-006).** `Working/`; the rules and today's layout use `scratch/` (RULE-EFF-001, RULE-LCM-034).
- **Q-9 Bundle meaning collides (REQ-023).** "Bundle" = test bundle `BUNDLE-2026-01` here; `BUNDLE-YYYYMMDD.json` in RULE-SUB-006; and "bundle" = the CRP folder in RULE-LCM-009. Three meanings, one word.

Stale or internally inconsistent:

- **Q-10 Version identity.** Header 10.6.4; scope sentence "Version 10.0.1"; REQ-003 "LCM 10.0.0".
- **Q-11 Classification depends on a missing file (REQ-010).** `lcm-governed` = "active junctions and `LCM_Inventory/config.json`".
- **Q-12 Proposed requirements carry MUST (REQ-042..045).** A "proposed" MUST cannot be tested or enforced; there is no status saying who decides and when.
- **Q-13 Three ID schemes.** `LCM-REQ-SYS-nnn`, `LCM-REQ-nnn`, `REQ-LCM-196`.
- **Q-14 Header.** `ModulePath:` instead of the DOX header (Module, Purpose, Path, ...; RULE-DOC-003).

Completeness - the job description lacks whole functions that the rules and the running system have:

- **Q-15** No requirements for: the proposal lifecycle as a state machine (states, transitions, Gate 0/1/2, DOIT, held/continue), BUG intake and DOIT, the Macrium baseline and BCR, the proposal ledger database and its JSON/SQL projection, the tool catalog (`tools.db`) and short-name launchers, the DO gateway / desktop daemon and its elevation permits (CRP-337), multi-host session continuity (RULE-LCM-030), analysis governance (RULE-ANA-*), learned advice, versioning and release (+1.0.0 / +0.1.0 / +0.0.1), English and encoding invariants, App-centric documentation (CRP-048), regression CRPs (CRP-135).
- **Q-16 Acceptance criteria are mostly missing.** Except REQ-046 (and partly REQ-037/-038), requirements state obligations but not how acceptance is decided: no test, no observable outcome, no evidence named. By the operator's definition this is half of a requirements document.
- **Q-17 No link to use cases or to rules.** Requirements are grouped by technical area, not by the use cases the Architecture should name; and no requirement cites the RULE-* it implements (except a few in REQ-036/-038).

---

## Chapter 4 - The Gory Details (Implementation.md)

### What the operator wants Implementation to be

The code with its details: functions, flows, data design, mapping to requirements, cross-references, design choices.

### What the document contains (version 10.6.4, 2026-11-14)

1. A package-version check at commit (`LcmPackageVersion.psm1` via `Submit-ReviewResult.ps1` and `Test-ReviewCommitGate.ps1`).
2. A tool table (17 tools, all "10.0.0") and the old Beyond Compare session token.
3. Documentation versus operational evidence; the cohort realization contract (CRP-259).
4. A module table (6 modules).
5. "Intended Control Hub Data World": an explicitly marked target design (authority = NTFS files; `es.exe` discovery; an LCM Query Index projection with index entries and contracts).
6. Antigravity Python setup instructions.
7. Data schemas: per-repository `config.json`, `inventory.json` (one sentence), test bundles.
8. A requirement traceability matrix (14 rows).
9. Design choices (intake gate, `PROCEED ALL`, loop breaker, batch guard).

### How I understand the machinery from it

Less than from any other document. The honest part is section 2: it says plainly that it describes a target, not current tools. The cohort contract (C.1) and the package-version check are concrete and current. The rest describes a 10.0.0 toolset.

### Plot points (Implementation)

- **I-1 The machine room is missing.** None of today's central components appear: `ProposalManager.psm1` (the lifecycle engine), `Invoke-ProposalAction.ps1`, `proposals.db` and `Sync-LcmProposalsDb.ps1`, `tools.db`, `BCR.cmd` / `Invoke-MacriumBcrReview.ps1`, `Show-LcmControl.ps1` (Control Hub), the Go `do` gateway and daemon (`src/do/`), the display modules, `Invoke-LCM_GoodMorning.ps1` / `Invoke-LCM_GoodNight.ps1`, `Save-AllSessionMemory.ps1`, `Invoke-LCM_Push.ps1`, `Update-Gemini.ps1`, the learned-advice tools.
- **I-2 Listed tools that the rules retired or replaced.** `Invoke-BeyondCompareReview.ps1` and `Clear-BCReviewTemp.ps1` (pre-BCR review), `ChangeRequestManager.psm1` (CR-* files), `LcmDesktopDaemon.ps1` with `LcmDaemonCore.psm1` (today the Go daemon serves 9876).
- **I-3 Repository column versus link.** Tools listed as "LCM_AI" link into `LCM_Inventory/tools/`.
- **I-4 Data design is absent.** No schema for `proposals.db` / `proposals.sql`, `tools.db`, `apps.json`, `active_session.json`, review receipts, `cm_activity.log`. RULE-DOC-012 requires a `DataDesign` document for repositories with structured databases (that may belong to Book 2, LCM_Inventory). The one schema shown (`config.json`) belongs to a file that does not exist and lists the junction `.agents/rules/core` twice; the rules folder has no `core` subfolder.
- **I-5 Traceability covers a third.** 14 of about 40 requirements; REQ-002 is traced to "`Workspace-Rules.md` & `LanguagePolicy.md`" (LanguagePolicy is about English); no test traceability (RULE-DOC-001 requires it).
- **I-6 Design choices cite rules that changed.** "Mandatory `OPEN` state" and "directional `PROCEED ALL`" (RULE-LCM-015/016): today intake creates `suggested`, and `Proceed` is exactly one state step; there is no `PROCEED ALL` rule.
- **I-7 Installation material in the wrong document.** The Antigravity Python setup is an installation runbook step (RULE-DOC-004 -> `install/Installation.md`).
- **I-8 Structure.** A "2.1" subsection appears after section 6; header uses `ModulePath:`; `LCM_Inventory/Cmd/` path (today `DoT/`).

## Chapter 5 - The Annexes (implementation-level and side documents)

| Document | Status in its header | What it is | Main observation |
|:---|:---|:---|:---|
| `LCM_Deterministic_Hook_Engine_Architecture.md` | Proposed, 10.0.0 | Antigravity `PreToolUse` / `PostToolUse` / `SessionStart` hooks that block unreviewed commits, enforce encoding and boundaries, audit after each tool call | Host-specific (Antigravity tool names); RULE-AUTH-001 wants host-neutral intent with host mechanics in adapters. Its session hook audits PC hardware settings (ULPS, MPO, Logitech): SystemConfiguration matters inside LCM governance. Since 2026-11-15 the Claude adapter has a real PostToolUse hook (CRLF) - the first realized piece, on the "other" host. |
| `LCM_Subsystem_Architecture.md` | Authoritative, 10.2.0 | Subsystem boundaries, single log sink, tool isolation boundary, tracking policy, version synchronization | The best-kept document: every design section ends with a "Status:" line stating what is real. But: "governance lives in three repos" then lists four, LCM_Tools absent; "all logs to `LCM_Inventory/data/logs/`" while RULE-EFF-001 and today's tools also write `LCM_Inventory/logs/`; tool discovery via `config/tool_catalog.json` (D-21: `tools.db`); version parity model (see plot thread 2); "10.0.0 reset pending, tooling at 7.x" is stale. `ACTIVE_CONTEXT.md` (2026-10-13) says a 10.0.0 version of this document is NOT ACCEPTED; the current 10.2.0 says "Authoritative" - which holds is unclear. |
| `LCM-Configuration-Management.md` | Authoritative, 10.2.0 | CM roles, CR architecture with junction mirroring of per-repo proposal folders, upgrade workflow, drift, baselines, priming | Built entirely on the CR-* generation (per-repo `Docs/Methods/Proposals`, `change_requests/<Repo>` junctions); RULE-CTX-002 quoted with `config.json` and `docs/Methods/Proposals/`, which the current rule no longer says. |
| `LCM-Onboarding-Architecture.md` | 10.2.0 | LCM_AI's own 4-state life (workshop -> verification -> dormant baseline -> unlocked) and the 4-phase onboarding of a target repo | The LCM_AI "dormant baseline" state exists in no rule. Onboarding hardlinks `AGENTS.md` from LCM_AI into every target, but RULE-ELEV-001 expects each repository's own `AGENTS.md` to declare its elevation: a shared hardlink gives all repos the same line. Junction line duplicated (`.agents/rules/core` twice; no `core` subfolder exists). Front matter placed after the header. |
| `LCM-Repository-Inventory.md` | Historical archive | 2026-08 directory matrix | Correctly marked historical - but the root README still advertises it as the current "classification and state matrix across all 33+ directories". |
| `Standards.md`, `version-bump-procedure.md`, `version-consistency-check.md` | 10.2.0 | Terse rule lists: naming, junctions, versioning, parity checks | First line `# version: 10.2.0` instead of a title; changelogs claim bumps "to 10.0.0" three times on one day and to 5.0.0 / 4.1.0 afterwards. Versioning content conflicts with the rules (plot thread 2). Parity checks read `.github/agents/*.json`, `.vscode/settings.json` and per-repo `config.json`. |
| `Workspace Conventions.md`, `Workspace-Location.md` | 10.2.0 | Paths and conventions | Canonical workspace root `D:\Git_Repositories\LCM_AI` (the rest of LCM says `D:\Git_Repositories`); `.copilot/` declared "authoritative control directory for Workspace rules" - contradicts RULE-AUTH-001; `Working/` scratch. |
| `Parent_Workspace_Solution.md` | Authoritative, 10.2.0 | Mirror of the VS Code multi-root workspace | Accurate and useful; matches the folders this Claude session sees. Mirrored 2026-09-04; header says "LCM V10.0.0". |
| `Requisites/README.md` | (no header) | External tools declared as data (`external-tools.json`), machine value `Git_Root` | Important and nowhere else: the workspace root comes from the machine registry value `Git_Root` (the Go daemon reads it too). Missing from README and Requirements. No DOX header. |
| `MODULES_INVENTORY_REPORT.md` | Historical reference | Origins of the repository structure; DOX methodology reference (agent0ai/dox) | Fine as history. |
| `GEMINI_INBOX_SPECIFICATION.md` | 10.2.0 | Format for Gemini drop files in `D:\GDrive\LCM\INBOX` | Uses legacy commands (`GetOpenProposals`, `do/defer/delete`) and `proposals.json`; header half in `#` comment style. (Claude never writes there, D-15.) |
| `real-repo-dry-run.md` | 10.2.0 | Dry-run cases for onboarding real repos | Establishes "target-local Markdown proposal authority"; for `LCM_*` targets this contradicts RULE-LCM-034. |
| `PC_Host_Subsystem_Architecture_Proposal.md` | Architectural proposal | Model the PC itself as a subsystem `HostSystem_PC` with a 7-phase re-provisioning runbook | A proposal living in LCM_AI docs instead of the ledger; overlaps the existing `SystemConfiguration` subsystem. Out of LCM scope for this book - noted only. |
| `OneDrive-Sync-Diagnostic-and-Repair-Guide.md` | Authoritative runbook | OneDrive repair, `AuthorizeMasterUser` ACLs | Not about LCM; belongs to the workstation subsystem. Out of scope - noted only. |
| `Optimizations/*` (3) | Design / audit / proposed plan | Data atoms for faster state discovery; a Copilot post-restructuring audit and its plan | Point-in-time records of 2026-10; no status saying whether done. |
| `LCM-Rules-Cross-Reference.md` | Authoritative, 10.6.4 | Matrix of all 21 rules, junction deployment, precedence | Current with the rules (it is part of the RULE-AUTH-002 sync set). Its precedence section is a different ordering from Requirements REQ-002 (plot thread 3). `docs/README.md` still describes it as "14 governance policies". |
| `AGENTS.md`, `GEMINI.md` (LCM_AI root) | - | Host entry instructions for Antigravity / Gemini | `AGENTS.md` lists 17 of 21 rule files (AnalysisGovernance, DecisionCascade, GoalFirstDesign, GoRules missing); `GEMINI.md` lists 9 and still contains the unexpanded template token `$targetName`. Both instruct "proceed directly ... without approval pauses", which contradicts the Gate 1 halt (RULE-LCM-014), DOIT-only direct execution (RULE-EFF-004) and the question invariant. |

---

## Chapter 6 - LCM as I Understand It

Read with the rules as the yardstick, the documents tell one story, even where they disagree on details.

**Purpose.** LCM (Lifecycle Model) makes a single developer workstation with many repositories and several AI assistants behave like a disciplined engineering organization: every change is proposed, decided, implemented, verified, reviewed by a human, committed and published in a traceable way, and the AI assistants are powerful but fenced in by rules they cannot overrule.

**The parts.**

- **LCM_AI - the law and the method.** Owns the rules (`.agents/rules/`, projected into every governed repository by junctions), the methodology documents (this book's subject), templates and quality gates. It is the version lead.
- **LCM_Inventory - the registry and the machine room.** Owns the proposal ledger (`proposals.db`), the proposal bundles, review receipts, the activity log, inventory and baselines, the tool catalog (`tools.db`) and the tools themselves, the Control Hub and the DO gateway/daemon. (Book 2.)
- **LCM_Shared - the atoms.** Reusable modules.
- **LCM_Supervision - the operator's surfaces** (hubs, scheduled supervision).
- **LCM_Tools** - present in the governed list (RULE-LCM-034) but absent from every LCM_AI document.
- **Outside LCM but known to it**: subsystems (HaSSD06, the workstation's SystemConfiguration) and ordinary repositories; and the world of tools LCM merely knows about.

**The life of a change.** Idea -> `suggested` proposal (CRP or BUG) with a Gate 0 contract when the target is not evident -> Gate 1: operator accepts the specification -> `in_progress` (DOIT = run without pauses) -> `verified` by automated pre-tests -> Gate 2: the operator reviews the live tree against a Macrium baseline in Beyond Compare (BCR) and tests it live -> `completed` = local commit with a version increment -> `pushed` via the governed push. Cohorts bundle several proposals into one review. BUGs run in DOIT to Gate 2. Nothing passes Gate 2 without the human.

**The AI's place.** AI hosts (Antigravity, Claude Code, others) are sanctioned adapters of the same rules. They analyse in read-only mode until told to implement, stop after two failed attempts, never commit or push outside the governed tools, and keep a shared, host-neutral memory of the session on disk (`.agents/`). Disk is the truth; Git is a transport.

**The long goal.** DOX - documentation drives implementation - and Atomic Assembly: a growing library of verified atoms and assemblies from which AI builds software by composition, with Apps and contracts keeping the pieces apart.

This is a convincing design. The documents, however, describe it in several generations at once - which is the plot.

---

## Chapter 7 - The Plot

### The crime

A reader who opens the LCM_AI documentation today is taught a workflow that the rules forbid, file locations that do not exist, and five different ways to version a release - in documents whose headers all say 10.6.4.

### The scene

Between LCM 10.0.0 (2026-08..10) and 10.6.4 (2026-11-14) the rules moved in governed steps (CRP-326, CRP-331): proposal bundles in LCM_Inventory, the SQLite ledgers, BCR on Macrium images, the Go DO gateway, the multi-host continuity layer. The tripartite documents of LCM_AI did not move with them.

### The threads

1. **Two LCMs in one book.** The 10.0-generation (per-repository `CR-*.md`, `%TEMP%\BC_Review` git-export reviews with folder-deletion consent, per-repo `config.json` / `overrides.json`, PowerShell daemon, `Cmd/`, `tool_catalog.json`, `processed/deferred/OPEN` states) runs through README, Architecture, Requirements, Implementation and five annexes. The 10.6-generation lives in the rules, the cross-reference, the cohort sections (CRP-259) and the running system. Evidence: A-1, A-6, A-9, A-11..13, Q-2..5, Q-11, I-1, I-2, I-6.
2. **Five versioning models.** (a) Rules (RULE-REV-007, RULE-DOC-005, INVARIANT-RULES): major +1.0.0 resets minor and patch for all components; release +0.1.0 keeps patch; +0.0.1 only for changed components. (b) `version-bump-procedure.md`: a major keeps minor and patch (`M.Y.Z`); a minor resets patch to 0. (c) `LCM_Subsystem_Architecture.md` section 7: in a clean state all components carry the same version, propagated by tooling. (d) Requirements scope: package version = highest component version; component minor and patch MUST NOT be flattened. (e) `Standards.md`: parity on MAJOR only. (a) and (b) contradict each other on both reset rules; (c) contradicts (a) and (d). **This decides what your planned "+0.1.0 for all items" push must do** - flatten everything to one number (c), or raise each component's minor while keeping its patch (a).
3. **Four answers to "who is in charge".** RULE-AUTH-001: `.agents/rules` is the single authority. Requirements REQ-002: repository-local executable behavior ranks first. Cross-reference section 4: safety, then efficiency, then execution integrity, then synchronization. `Workspace-Location.md`: `.copilot/` is the authoritative control directory. Add `AGENTS.md`/`GEMINI.md` telling agents to proceed without approval pauses.
4. **Three lifecycle vocabularies.** Ledger states (`suggested ... pushed`), the proposed Control Hub statuses (`Open / Active / Review / Complete / Published / Held / Cancelled`), and the legacy words (`processed`, `deferred`, `OPEN`, `blocked`, `implemented`, dispositions `Accepted/AcceptedWithEdits/Deferred`). RULE-LCM-007 allows one.
5. **The review gate is described in its retired form.** Every LCM_AI description of the review is the pre-BCR one (A-1, Q-3, I-2, README R-4); RULE-REV-014 prohibits it. Defaults and exemptions are inverted (A-2, A-3).
6. **Elevation: declared three ways, enforced nowhere.** `config.json execution_context` (Requirements), `Elevation:` line in `AGENTS.md` (rules; but onboarding hardlinks one shared `AGENTS.md` into every repo), `tools.admin` in `tools.db` (rules). At run time the DO daemon runs every command elevated (observed 2026-11-15, CRP-337). The house plan does not show the lock that matters most.
7. **Missing rooms.** LCM_Tools, LCM_Supervision's purpose, Macrium baselines, the continuity layer, the SQLite ledgers, the DO gateway, the AI host adapters, `Git_Root`, versioning/release as a process - all absent or scattered (A-14, Q-15, I-1, Requisites).
8. **Proposed, decided, historical - all look alike.** "Proposed" sections and "Proposed" requirements with MUST sit in authoritative documents without decision records (A-4, A-17, Q-12, Hook Engine). Good counter-examples exist: `LCM_Subsystem_Architecture.md` (Status lines), `Implementation.md` section 2, `LCM-Repository-Inventory.md` (historical warning).
9. **No acceptance criteria.** Requirements rarely say how fulfilment is decided (Q-16), and nothing traces requirements to use cases, rules or tests (Q-17, I-5).
10. **Housekeeping.** Non-DOX headers (`ModulePath:`, `# version:` first line, front matter after the header), a template token left unexpanded, duplicated junction lines and a non-existent `rules/core` folder, version numbers used as section numbers, out-of-scope runbooks in the methodology folder.

### The motive and the method

The rules have a governed maintenance cycle: CRPs, the cross-reference sync (RULE-AUTH-002), host adapters with drift checks. The tripartite documents have only a **number** check: the package-version gate (Implementation section 1) makes README and the three specifications carry the same version - so their headers were bumped to 10.6.4 - but nothing compares their **content** with the rules. Requirements REQ-041.3 even promises that delivery knowledge is "reconciled into the authoritative methodology ... no later than a major-version push". The documents carry 10.6.4 badges over 10.0 bodies: the alibi is the version stamp.

### The verdict

No single wrong decision; a missing gate. Content reconciliation of the methodology documents was never made a mandatory step of `COMPLETE` / `PUBLISH`, so each CRP updated rules and code and left the tripartite documents behind.

---

## Chapter 8 - What I Would Do (suggestions for the operator; no CRP drafted)

1. **Before the +0.1.0 push: decide the versioning model** (plot thread 2) - otherwise the push either flattens component versions (contradicting the rules and Requirements) or leaves components unaligned (contradicting the Subsystem Architecture). Then mark the losing documents as superseded.
2. **Mark before rewriting.** Give each outdated section a status line ("historical - 10.0 generation, superseded by RULE-...") as `LCM_Subsystem_Architecture.md` already does. This is cheap, honest, RULE-DOC-008-compatible (no deletion) and makes the books readable immediately.
3. **Rewrite the README as the manager page** you described: what LCM gives (one paragraph), the five LCM repos and their roles, what must be in place (with Macrium, Everything, Go, SQLite, `Git_Root`), and an explicit "installation: not yet documented" placeholder.
4. **Architecture: draw the 10.6 house** - repos, ledger, BCR on Macrium, DO gateway with its elevation boundary, hosts and the continuity layer - and move tool names and file paths down to Implementation.
5. **Requirements: one ID scheme, one requirement per lifecycle function, and an acceptance criterion for each**; trace each to its RULE-*. REQ-046 is the model to copy.
6. **Implementation: rebuild the tool/module tables from `tools.db`** (Subsystem LCM) rather than by hand, and add the data design (or point to LCM_Inventory's DataDesign documents).
7. **Add the missing gate:** a documentation-reconciliation check in `COMPLETE` (or at least in `PUBLISH`) that lists which tripartite sections a CRP touches - REQ-041.3 made executable.
8. **Small fixes:** `AGENTS.md` / `GEMINI.md` rule lists and the "proceed without pauses" sentence; `$targetName`; duplicated junction lines; `docs/README.md` versus root README; move OneDrive and PC-host material to their subsystem.

---

## Epilogue - For Book 2

LCM_Inventory is the machine room: proposals, ledgers, tools, Control Hub, DO gateway, inventory of the LCM parts. Book 2 reads its documentation the same way, limited to the parts that the tools table classifies as Subsystem LCM, and ignores the outside world (other subsystems, ordinary repositories, external tools).

---

## Appendix A - Host Side Folders (convergence check, 2026-11-16)

Commissioned 2026-11-16 by the operator: check `.copilot`, then `.gemini`, and any host folder that comes up later, for convergence with the canonical rules. Read-only check; everything below observed on disk unless marked.

**Test applied** (agreed in the "Projects" discussion): a host-side file is safe if it only points to the disk authority. It breaks convergence when it holds its own copy of rules or state. A copy is tolerable only if it is generated from disk, marked as derived and covered by a drift check.

### A.1 `.copilot` (VS Code Copilot profile)

Root `.copilot` is a junction to `LCM_AI\.copilot`: 17 files plus `Rules/` and `Logs/`, tracked in LCM_AI, all at version 10.2.0, last changed 2026-11-10 or earlier.

- **H-C1 Rules converged.** `Rules/` is a junction to `LCM_AI\.agents\rules`; 21 of 21 files identical. FINDINGS F-32 (Check 0 hashing `.copilot/Rules/`) is moot: they match by construction.
- **H-C2 Loading not wired [INFERRED].** Nothing in `.vscode/settings.json` points Copilot at `.copilot`, and there is no `.github/copilot-instructions.md`. Copilot's standard discovery does not read `.copilot/`, so the profile is most likely inert. The operator's open check of 2026-10-13 ("does Copilot really follow the `.agents` rules?", ACTIVE_CONTEXT) remains open.
- **H-C3 A second authority set.** `instructions.md` (an `@`-command language with `@S`, `@IRA`, `ADM*` operators and the retired timestamp header), `CopilotRules.md` (CRLF - contradicts D-28 Option B), `Standards.md` / `version-bump-procedure.md` / `version-consistency-check.md` (own versioning: "MINOR+1, PATCH=0" contradicts RULE-REV-007 "release does not reset patch"). `Workspace-Location.md`, `Workspace Conventions.md` and `instructions.md` declare `.copilot` "authoritative" - contradicts RULE-AUTH-001.
- **H-C4 Dangling references.** `Config.json`, `MEMORY.md` and `Workspace-Location.md` list `MyTools.md`, `tests/profile-tests.md`, and `macro-definitions.md` / `InvariantRules.md` at top level (they exist only under `Rules/`); `VSCode_Agent.md` needs `Fixes/` and `Atoms/` - all missing. The `APPLY <fix-module>` pipeline is dead.
- **H-C5 Live references into `.copilot`.** ACTIVE_CONTEXT section 2 names `CopilotTools.md` as permanent memory anchor 2 (its content duplicates the tool paths already in ACTIVE_CONTEXT and `tools.db`); macros `S` and `profile status` refer to the "copilot profile"; RULE-EFF-001 lists `.copilot/Logs/*.log`.
- **H-C6 Empty variable memory.** `projects.md`, `problems.md`, `servicing-notes.md` contain only "(empty)".
- **H-C7 Next door in `.github/`.** `hooks/lcm-guardrails.json` is a Copilot `preToolUse` hook running `pwsh ... LCM_Inventory/tools/Test-Guardrail.ps1` - the only Copilot-side enforcement found (belongs in the Book 3 L2 inventory). `extensions/lcm-control-hub/` (2026-10-01) not checked.

**Verdict:** the rules part passes (junction). The profile part fails the test: hand-written copies, not generated, not drift-checked, partly contradicting current rules, and probably not loaded at all.

### A.2 Gemini / Antigravity

- **H-G1 Pointers pass.** Root `GEMINI.md` points to `.agents/rules/`, `AGENTS.md` and the cross-reference. Six child `GEMINI.md` files (71 bytes, identical) and `SystemConfiguration/GEMINI.md` are pointer-only.
- **H-G2 `LCM_AI/GEMINI.md` fails.** Generated 2026-10-13 with an unresolved `$targetName`; lists 9 of 21 rules; restates invariants that have since moved (CRLF; "proceed ... without approval pauses", which outside DOIT conflicts with the Gate 1 halt RULE-LCM-014; `RR.ps1`; `Test-WorkspaceReadiness.ps1`). Already named in Chapter 8 item 8; unchanged since.
- **H-G3 No workspace `.gemini/` folder.** The user-level `~/.gemini` holds host state (plugins, sidecars, user settings, conversations). Antigravity "projects" (`~/.gemini/config/projects/*.json`, `projects.json` mapping `d:\git_repositories`) hold only folder links, permission grants and review/auto-execution settings - no rules: pass. The knowledge store `~/.gemini/antigravity/knowledge` is empty (lock file only). Not inspected: `brain/`, conversations (host transcripts).
- **H-G4 Permission policy lives outside LCM.** Two plugin projects and the Obsidian Vault project run with `artifactReviewMode: TURBO` (Obsidian also `autoExecutionPolicy: AUTO`); user settings carry global permission grants. Not a rule copy, but an enforcement setting no LCM tool sees (input for Book 3).

### A.3 Standing check

Every further host folder that comes up (`.github` agents/instructions, `.cursor`, `.windsurf`, `~/.claude`, ...) gets a section here with the same test.

### A.4 What I would do

1. **`.copilot`:** make the Copilot binding a CRP-339 host binding file (`.github/copilot-instructions.md` or `AGENTS.md` pointing to `.agents/rules`), keep the `Rules/` junction only if something still reads it, and retire the 10.2.0 profile files (operator decision; RULE-DOC-008 applies to removals).
2. **`LCM_AI/GEMINI.md`:** replace with a pointer like the root file (CRP-339).
3. **ACTIVE_CONTEXT anchor 2:** point to `tools.db` instead of `CopilotTools.md`; drop the `copilot profile` wording from macros `S` / `profile status` when CRP-339 rewrites macro-definitions.

## Appendix B - Operator Review, First Sequential Pass (2026-11-16)

Operator remarks on Book 1, recorded per plot point. They are binding for the documentation rework. "Bottom up" means: derive from code -> Implementation -> Requirements -> Architecture -> README.

### B.1 Standing agreements

- **Host convergence is settled (CRP-339).** The concern that claude.ai Projects or other host features could erode convergence is closed by the extra degree of convergence agreed in CRP-339 (one compact canonical rule set, `.claude/rules` junction, host binding files). It is treated as fixed and is not reopened here.
- **Reading contracts / JSON to SQLite.** For every JSON file already intended to move to SQLite, compare its content with the database and remove the JSON side. The difficult cases found so far are sorted out with the operator. Together with the General_Tools CRP, this gives a cleaner base for later passes.
- **Order of rework.** The README is the oldest and most incorrect document, so it needs the largest change and is reworked last, bottom up.

### B.2 README (NR1-NR6)

- NR1-NR6 are correct and all need rework.
- NR5 correction: the topology lists neither tools nor modules.
- Missing content, to be extracted from Requirements:
  - external software LCM needs to run;
  - where to find installation;
  - what the operator does, and how, when operating LCM;
  - the key items of the methodology: goals first, design freedom with guides, DOX, implementation efficiency by AI, testing against goals, configuration management.

### B.3 Architecture (NA1-NA6)

- **NA1 Vocabulary.** The implementation wins. **State** is what LCM holds internally and is relevant for understanding it. **Status** is what the operator uses or works on next. The two boxes have different meanings and use only similar words. "verified: ready for 2 - Review" and "2 - Review" duplicate each other; only the latter should remain.
- **NA2 "Rule hub".** This was my wording, not LCM terminology; drop it. Intent: rules are governed, so they are referenced by LCM_Inventory, linked to their docs, and all reside in LCM_AI.
- **NA3 Languages and the daemon.** The Architecture names no implementation language (Go, PS7). The daemon is plumbing, not an architectural component, and has nothing to do with testing. Testing was not considered when DOX started and must be added as an architectural concern.
- **NA4 Data design.** It is completely missing and must be made visible.
- **NA5 Content.** The Architecture holds use-case areas, not tool names. Its focus is "goals to means". The goals are condensed in the README and detailed in Requirements.
- **NA6 Goals on top.** Present each tool by the goal it serves: BCR serves review of ongoing work; ShowXYZ serves presentation and controllability. The goal "Security" names its App-level documentation, sourced from Implementation via Requirements to the Architecture condensation.

### B.4 Requirements (NQ1-NQ7)

- **NQ1** The existing requirements are old; update them bottom up.
- **NQ2 Proposals are not the ledger.** Proposals are ongoing work grouped into CRPs, BUGs and FIXes (by number), eventually absorbed into the documentation, where they lose focus completely. The ledger, the history, lives in the logs. For the Architecture, proposals only have status and states.
- **NQ3 Chosen tools.** External tools such as Beyond Compare are explained by what they do, how they present themselves and why they were chosen. The same applies to the models in use.
- **NQ4** There will be many discrepancies; each must be resolved.
- **NQ5 Open question from the operator.** Does LCM reflect the freedom to choose other implementation concepts (fast prototyping)? To be answered in Book 2.
- **NQ6** The scattered state is today's "ant hill". The goal is to tidy it with AI and keep it in order through rule-driven method support.
- **NQ7** Confirmed.

### B.5 Implementation, Data, Security, Tbd, CM

- **NI1-NI6** Very probably the area that needs the most attention. A code analysis would make the list about five times longer, so there is no need to go deeper now.
- **ND1-ND4, NS1-NS2** The newest area. Derive it from the code, then condense it to Requirements and upward.
- **NN\*** All tbd; no work yet.
- **NP\* = CM\*** Exception to "bottom up": viewed top down for terminology and matched to the code bottom up.

### B.6 Chapters 5-7

- **Chapter 5** Confirmed: Records, Machines, Safety. The history is much longer than shown; LCM is at major version 10.
- **Chapter 6** Not a problem, only work toward the goal.
- **Chapter 7** New and accepted:
  - (3) DDL via `sqlite_master`.
  - (5) Data cleanup reminder: logs no longer relevant at version + 2 must actually be cut (RULE-DOC-006).

### B.7 Status

The operator's insight pass is complete. Further refinement needs the code analysis passes (Book 2).

## Appendix C - Operator Review of Book 1, Chapter by Chapter (2026-11-16)

These remarks are binding for the documentation rework. Where this appendix and Appendix B differ, this appendix is more specific.

### C.1 Hosts

- **Gemini** was used only to get better documents from the LCM_* files, which it could not access directly. It has nothing to do with LCM itself, and this may change once it becomes more capable.
- **The INBOX feature** that is currently implemented is not used, and never was.

### C.2 README (Chapter 1)

- **Target confirmed.** A manager-level page: what the reader can expect from LCM_* as a whole (not only LCM_AI), what must be in place, and how to get it. Installation may stay a placeholder.
- **RD1 Prerequisites.** Name the exact products and versions, and state that the user can extend the list or substitute products.
- **RD2 Order.** The DOX methodology comes before the documentation index.
- **RD3** Confirmed and very important. AI is not yet brought into context and must be.
- **RD4 Verification and testing** tell management that this is not a free-running "vibe code" area. LCM enforces reviews, with AI thoroughness and speed.
- **R1, R3** Confirmed.
- **R2** Management is not interested in this; leave it out of the README.
- **R4** True, but off target. No account of how LCM got here will interest a manager.
- **R5** There must be exactly one README.
- **R6** Later, maybe.

### C.3 Topology (Chapter 2, items 1-12)

- Items 1-7 are understood correctly.
- **New order:**
  1. Item 8 becomes the top item.
  2. Item 12 follows.
  3. Then a new item, **"Tool support"**.
  4. Then items 2-7.
  5. Items 9, 10 and 11 become one group, **"Design patterns"**.
- **New item 13:** LCM is built for self-progression and is self-governed.
- The General_Tools rename fits this topology.

### C.4 Architecture plot points (A1-A18)

Convergence here is the goal of the next efforts. The work goes bottom up from here, because the system currently works better than its documentation.

- **A1, A4 Terminology.** See the terminology in the other book (the Inventory book, Book 2).
- **A2 Granularity** is not a discrepancy but a top-down choice. Coarse fits prototyping, the first design step; tight is needed as the work matures. This is a wording matter. The fast-fix and bug-handling switches matter much more.
- **A3** Wording only. The meaning is clear; phrase it correctly.
- **A5 Priority range** is -n..10. "Alive" items are 0..10.
- **A6 Proposals** live only in LCM_Inventory, including those about the LCM_* repositories. Other subsystems may keep their own specialized inventory: HaSSD06 does now, and the future PC subsystem will too.
- **A7 App naming** is a future convention, since Apps are not really in use yet. Example: a security App area would be named `APP#1 Security`.
- **A8** Not a contradiction: correct at architecture level, more detailed in Implementation.
- **A9** Confirmed.
- **A10** Elevation is mentioned at this level. The operator expected an empty set.
- **A11** The material comes from the newest CRP. Every CRP ends with a documentation change in one or more of the three tripartite documents.
- **A12-A15** Gaps, and errors too. This is work to do. A13: much to clean out.
- **A16 Important: the document hierarchy.**
  - Implementation is mainly the summary and detail of idealized code atoms plus their comments. The better the atoms are defined, the better the Implementation document.
  - Summaries of Implementation become Requirements.
  - Summaries of Requirements, at the top, feed the README.
- **A17, A18** Most likely taken from the proposal list. They are probably not defined as goals or requirements.

### C.5 Requirements plot points (Q1-Q17)

- **Q1 Correction.** "Any script's behavior overrules the rules" must be an incorrect implication. Rules can be changed; their goals cannot. A rule change can require a goal change, and that is called evolution.
- **Q2 Retention horizon.** This results from missing cleanup. The horizon should be a single version; tracking back to -2.0.0 can help regression analysis. Docs kept current would make the limit clearer.
- **Q3-Q17** Correct observations and all work items. No documentation updates happened during implementation; the priority was getting things to work. The task borders on human capability and is only attempted because AI can help.

### C.6 Chapters 6-8

- **Chapter 6** shows LCM forming itself in its documentation. Much of that chapter is what the operator calls Architecture.
- **Chapter 7** Confirmed. The documents lack a Goals section, especially at the top level.
- **Chapter 8, suggestion 1 (simplify versioning): rejected.** Versioning is inherently not simple. Expected long-run versions look like 27.9.104, with patch counts beyond 104 for some components.
- **Chapter 8, suggestion 2 (change history in the docs): rejected.** Change history lives in the logs and has no place in the documentation. Module header histories exist, but clipped; nobody needs 104 change details.
- **Chapter 8, suggestions 3-8:** accepted.
