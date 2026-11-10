---
name: ProposalReviewFlowPolicy
description: Governs the LCM Two-Tier Proposal lifecycle, ticket-first enforcement, batch operations, granularity controls, and dual-commit synchronization.
globs: "*"
---
# File: ProposalReviewFlowPolicy.md

Module: ProposalReviewFlowPolicy  
Purpose: Enforces ticket-first proposals, batch commands, Beyond Compare 5 review gates, granularity controls, and LCM_Inventory dual-commit synchronization.  
Path: .agents/rules/ProposalReviewFlowPolicy.md  
Authors: Rolf, LCM_AI Governance  
Version: 10.0.3
Status: Authoritative Policy  
Date: 2026-11-10 18:47:00

---

## 1. Core LCM Review Flow Rules

### RULE-LCM-001: Proposal-First Intent Invariant
When working in LCM mode (`active`), all user ideas, questions, and exploratory discussions `MUST` be treated as **Proposals only** (State = `suggested`).
- The AI agent `MUST NOT` execute file modifications, code rewrites, or commits immediately upon receiving an initial idea or question.
- When discussion yields a conclusive path of action, register the Change Request / Proposal with State `suggested` in `LCM_Inventory\data\proposals\proposals.json`.
- Every structural proposal or BUG MUST include the Gate 0 Contract required by `RULE-GOAL-002` before it crosses the planning boundary. A reported symptom supplies intake evidence; it does not replace target-state definition.

### RULE-LCM-002: Batch Execution, Control Commands & Flow Switch Activation
#### CRP-261 Transition Compatibility Rule
Until legacy documentation and historical ledger records are reconciled, the following lifecycle
matrix is authoritative for all new or modified tooling. Legacy terms such as `Scoped`,
`Decided`, `Approved`, `Committed`, `Published`, `processed`, and `deferred` are
compatibility vocabulary only; they MUST NOT create a second lifecycle authority or determine
available operator actions.

#### Automatic BCR Gate Invariant
At every CRP or COH review gate, the governing action surface and backend MUST automatically
initiate BCR for the exact resolved target before permitting review-gate continuation. A CRP
may not complete, commit, or otherwise pass the review gate until a matching BCR disposition
is recorded; a COH may not continue until every member has one. The only exception is an
explicit authorized BCR bypass recorded in the proposal ledger. `-Force` and `-Immediately`
remain separate governed mechanisms and MUST NOT be treated as BCR bypasses.

#### Canonical Cohort Gate Synchronization Invariant
Before review-gate continuation, an active/open declared cohort MUST automatically synchronize
all declared members to the shared required gate state. A member MAY be verified only when its
existing validated evidence and required preconditions satisfy that state. If any member fails,
the operation MUST stop with that member's specific error; it MUST NOT initiate BCR or partially
advance any member through the gate. BCR MAY begin only after every member is verified, and its
recorded disposition MUST resolve all cohort members together. If all members are already
aligned, the operation is a no-op; the audit metadata MUST record the synchronization attempt,
evidence/precondition checks, and no-op or resolved result.

#### CRP-259 Cohort Identity, Target Resolution, and Atomicity
An action MUST resolve one explicit **Item** target of kind `CRP` (including a
BUG) or `COH`; these kinds are not interchangeable. Target resolution MUST
fail closed and MUST NOT fall back to a repository, selected row, earlier
selection, or active cohort where a selector is required. A cohort identity is
`COH-<prime>` and is valid only with exactly one head member identified by that
prime. Additional members are optional.

There MUST be at most one active/open COH. An inactive/closed COH may be
created while another is open. Opening an inactive COH MUST atomically close
the current open COH and open the requested one; it MUST reject any result that
would have two open COHs. The only selector-free convenience is add-member to
the sole open COH. Membership, head integrity, lifecycle, and open/close
validation MUST be all-or-nothing; a failure leaves no partial change.

For a COH Gate 2 operation, automatic synchronization MUST validate every
declared member's required gate and evidence before BCR. Gate equivalence means
the same required gate with valid evidence, not a superficially similar state.
Any failure stops all advancement and BCR launch. Once aligned, exactly one BCR
MUST cover the resolved COH and record every member disposition. Gate 1 is the
CRP plan/activation boundary; Gate 2 is the BCR decision. `DOIT` is a flow
switch that may cross Gate 1 execution pauses but NEVER bypasses Gate 2.
Action results and audit evidence MUST show the resolved Item, head/members,
synchronization outcome, BCR disposition, and refusal reason.

| Authoritative `state` | Valid actions | Valid next states |
|:---|:---|:---|
| `suggested` | `edit`, `do`, `hold`, `withdraw`, `supersede` | `in_progress`, `held`, `withdrawn`, `superseded` |
| `in_progress` | `edit`, `verify`, `hold`, `reset`, `withdraw`, `supersede` | `verified`, `held`, `suggested`, `withdrawn`, `superseded` |
| `verified` | `bcr`, `reopen`, `hold`, `supersede` | `in_review`, `in_progress`, `held`, `superseded` |
| `in_review` | `complete`, `commit`, `reject`, `reopen`, `hold` | `completed`, `rejected`, `in_progress`, `held` |
| `completed` | `push`, `hold`, `reinstate` | `pushed`, `held`, revision route below |
| `held` | `continue`, `edit`, `withdraw` | the recorded `resume_state`, `withdrawn` |
| `pushed` | `view`, `reinstate` | revision route below |
| `withdrawn`, `rejected`, `superseded` | view-only actions defined by the lifecycle model | terminal except documented supersession |

`state` and its companion `state_reason` form the single flat current lifecycle record:
`state_reason` explains why the current state applies and is not a second state. `progress_state`
and `disposition` may be retained only as derived compatibility fields. Existing history is
immutable; new events append forward-only records and may add richer transition, revision,
cohort, review, and test metadata. `BCR` enters the Review Gate for an exact CRP/BUG, a resolved
repository, or a declared cohort; Gate 2 begins only when the review launcher has succeeded and
the resolved scope is in `in_review`. `COMPLETE` accepts the same resolved forms and can
transition only `in_review` work to `completed`. Unresolved or ambiguous scope MUST fail closed.

### Reinstating Delivered CRPs

`reinstate <CRP-ID>` is the only route for reopening a `completed` or `pushed`
CRP without erasing its accepted history. It MUST append a forward-only
reinstatement revision event; prior completion, push, receipt, and commit
evidence remain immutable.

1. **No concrete correction requests:** when `reinstate` has no `-Changes`
   value, the CRP MUST return to `suggested`. It remains at Gate 1 awaiting
   revised intent, plan, and explicit authorization; it MUST NOT start
   implementation or BCR.
2. **Concrete correction requests:** when `reinstate` includes a non-empty
   `-Changes` value, the CRP MUST return to `in_progress`. After the named
   corrections and focused verification pass, it MUST advance to `verified`
   and launch an exact-identity BCR for that same CRP. It MUST NOT fall back to
   a repository, active session, latest proposal, or prior BCR identity.
3. A stale BCR session for the formerly delivered CRP MUST NOT be completed.
   Completion remains valid only when the current revision is `in_review` and
   the review identity matches that CRP revision.

Proposals transition through the defined lifecycle via deterministic operator commands:
- **`Proceed` / `Proceed <ID>`**: **Single-step status increment**. Deterministically advances matching proposal(s) forward by exactly one discrete Sync Point along the flat lifecycle continuum (`Suggested` $\rightarrow$ `Scoped` $\rightarrow$ `Decided` $\rightarrow$ `In_Progress` $\rightarrow$ `Verified` $\rightarrow$ `Committed` $\rightarrow$ `Published`).
- **`do <all, #n, #n-#m> Proposals`**: **Sets flow switches!** Specifically activates the **`-DOIT` switch** (`always-proceed = $true`), bypassing Gate 1 planning pauses and executing continuously through `In_Progress` and verification until the downstream Review Decision checkpoint (Gate 2) is reached per `RULE-EFF-004`.
- **`hold <all, #n, #n-#m> Proposals`**: Sets the **`HELD` disposition** with a mandatory reason, suspending active work at its current Sync Point. Pauses all active flow switches. (Supersedes legacy `defer`).
- **`resume <all, #n, #n-#m> Proposals`**: **Reactivation action** that clears the `HELD` disposition and restores the proposal to active flow at its suspended Sync Point. Resume is an operator action, NOT a milestone or status.
- **`COMPLETE` / `COMPLETE ALL`**: Records a completed visual review, creates local commits, and advances the reviewed proposal to `Committed`. It never pushes to a remote.
- **`PUBLISH`**: Publishes only a preflighted cohort of `Committed` proposals and `LCM_Inventory` to their remotes in lockstep (`Committed` $\rightarrow$ `Published`). `PUSH` remains a backward-compatible command alias. Suggested, scoped, in-progress, and uncommitted items are strictly excluded.
- **`cancel <all, #n, #n-#m>`**: **Administrative ticket withdrawal at Gate 1**. Indicates the proposal is dropped, infeasible, or superseded during intake, scoping, or planning ratification. Zero working-tree modifications, zero code reverts, and zero rule modifications occur. The proposal transitions to terminal disposition `Cancelled` and all active flow switches are unconditionally turned **OFF**.
- **`reject <all, #n, #n-#m>`**: **Implementation rejection at Gate 2**. Indicates the physical implementation or review failed visual inspection, automated verification, or operator acceptance during the `Verified` review checkpoint. Actively rolls back and undoes working-tree modifications introduced by the proposal (for batches/cohorts, reverts all proposals in the cohort back to the clean pre-CRP baseline). The proposal transitions to terminal disposition `Rejected` and all active flow switches are unconditionally turned **OFF**.
- **`give open Proposals`**: Returns numbered list of active proposals (`#n`).
- **`give repos under review`**: Displays repositories with uncommitted changes, their BC5 review status, and commit readiness.

### RULE-LCM-003: Review Granularity Controls
The review frequency is governed by `review_granularity` in `LCM_Inventory`:
- **`coarse` (Default)**: Executes all proposals in the batch, runs automated quality gates, then presents a **single BC5 review stop** for the combined changes across the repository before commit.
- **`tight`**: Implements each proposal incrementally with intermediate test runs and a **dedicated BC5 review stop per proposal**.
- **Idempotent Single-Window Review Invariant**: A review stop `MUST NOT` open a duplicate window or redundant tab if the comparison or proposal is already open or currently being reviewed. In Beyond Compare 5, re-invoking review for an open comparison must simply refresh the existing session/tab in place and bring it to focus; opening two windows for the same comparison is strictly prohibited.
- Can be set via `set review granularity <coarse|tight>` or inline `do #1-#3 Proposals --tight`.

### RULE-LCM-004: Visual Diff Review & Exemption Scope
- **Governed Repositories & Root Container**: Every governed repository and the Root Container (`D:\Git_Repositories`) `MUST` undergo visual diff review via `Invoke-BeyondCompareReview.ps1 <RepoName>` before commit, subject to authorized exceptions in `RULE-REV-001`.
- **Dual-Session Junction Review**: For repositories containing NTFS directory junctions (e.g. `.agents` pointing to `LCM_AI\.agents`, or `.agents\rules` pointing to `LCM_AI\.agents\rules`), `Invoke-BeyondCompareReview.ps1` `MUST` automatically dispatch a second Beyond Compare review session targeting the live junction destination on the right pane per `RULE-REV-008`.
- **Privileged Subsystem Data Exemption vs. Tool Scrutiny**:
  - **Dynamic Configuration & Ledger Data Exemption (`RULE-EFF-001`)**: Ledger data, review staging receipts, baseline manifests, telemetry logs, generated artifacts, routine test output, and scratch generation outputs located in `LCM_Inventory` (`data/`, `logs/`, `scratch/`) are auto-accepted mechanical evidence and exempt from visual diff review stops. An operator may request an unfiltered BCR peek at exempt paths; resulting advice is non-blocking.
  - **Executable Tools & Documentation Scrutiny**: All permanent scripts, PowerShell modules, test suites, and architectural documentation located in `LCM_Inventory` (`tools/`, `modules/`, `docs/`, `tests/`, `Cmd/`) are first-class governed LCM software assets and `MUST` undergo visual diff review via `Invoke-BeyondCompareReview.ps1 LCM_Inventory` prior to commit.

### RULE-LCM-005: Dual-Commit and Push Synchronization Invariant
1. Whenever code changes in a target repository are accepted and committed, `LCM_Inventory` `MUST ALWAYS` be updated (updating proposal state to `completed`, recording review evidence) and **committed immediately**.
2. On any `PUSH`, all completed target repositories and `LCM_Inventory` `MUST` pass a non-mutating lockstep preflight before any remote dispatch. A failed preflight blocks the entire cohort.
3. A cohort coordination bundle MAY declare repository and/or proposal members, dependencies,
   shared semantic deltas, and aggregate verification. It coordinates members but does not
   replace their individual immutable histories.

### RULE-LCM-006: Pause, Resume, and Escape Controls
1. **`LCM OFF` (Emergency Escape Switch)**:
   - Temporarily suspends proposal bundle scaffolding and governance gating to enable immediate emergency remediation of corrupted host configurations or broken environments.
   - Re-activated via `LCM ON` or `resume LCM`.
2. **`Testing OFF` (Deferred Deep Testing Switch)**:
   - Suppresses heavy, multi-minute test cascades (deep Pester DAGs, elevated integration test suites) during rapid interactive development and intermediate Review Decision checkpoints.
   - Syntax validation and fast unit checks still run, but deep testing is strictly deferred to the pre-push quality gate.
   - **Deferred Failure Protocol**: If deep testing encounters errors during pre-push validation, the push is immediately aborted and the failure automatically spawns a formal **`BUG`** proposal bundle in `DOIT` mode (`RULE-LCM-008`).
3. **Push Auto-Reset Invariant (Self-Healing Governance)**:
   - Neither `LCM OFF` nor `Testing OFF` may remain active after publication. Upon any push invocation (`PUSH`, `Invoke-LCM_Push.ps1`), both **LCM Mode** and **Testing Mode** `MUST` unconditionally reset to `ON` (`active`).

### RULE-LCM-007: Flat Lifecycle Continuum, Sync Points, Dispositions & CM Plan Archive Invariant
1. **Single-Dimensional "Flat" Status Continuum**:
   - Status is strictly single-dimensional. Multi-dimensional status architectures (such as conflicting `progress_state` vs `state` where internal state stalled on `approved` while physical progress moved secretly) are prohibited.
   - External status binds the internal state directly at **7 canonical Sync Points (Milestones)**. When identical, the single canonical name `MUST` be used across all rules, tools, and UI displays:
     `Suggested` $\rightarrow$ `Scoped` $\rightarrow$ `Decided` $\rightarrow$ `In_Progress` $\rightarrow$ `Verified` $\rightarrow$ `Committed` $\rightarrow$ `Published`.
2. **Canonical Sync Points (Milestones)**:
   - **`Suggested` (0)**: Initial proposal registration / intake. Proposal bundle scaffolded in `docs/Proposals/`; Gate 1 planning pause.
   - **`Scoped` (1)**: Proposal bound to target repository, primary app (`App: #`), and constituent manifest.
   - **`Decided` (2)**: Architecture, requirements, and plan ratified (`Approved` disposition); Gate 1 passed.
   - **`In_Progress` (3)**: Active implementation underway; continuous code modifications and unit tests executing.
   - **`Verified` (4)**: Implementation complete; minimal / automated tests passed; Gate 2 visual diff review stop dispatched.
   - **`Committed` (5)**: Gate 2 visual review accepted (`Approved` disposition); review receipt filed in `reviews/`; local Git commit created.
   - **`Published` (6)**: Walkthrough archived in CM; lockstep preflight verified; remotes synchronized (`Published` preferred over `Pushed`).
3. **Dispositions vs. Status**:
   Dispositions and Plan State are not part of any CM-flow rule as separate dimensions, but are conditions or markers resulting from status and actions:
   - **`BUG`**: A disposition (not a substitute term for CRP). When assigned to a proposal, it sets flow switches to force flow exceptions—specifically activating the **`-DOIT` switch** (`always-proceed = $true`), bypassing Gate 1 planning pauses, while halting at Gate 2 visual review (`RULE-LCM-008`).
   - **`HELD`**: An exceptional disposition suspending a proposal at its current Sync Point. There is NO `defer` action or status anymore—it is simply `HELD`. When `HELD`, active flow switches are paused. Cleared by the `resume` action.
   - **`Approved`**: A disposition recorded at sync points (specifically at `Decided` for Gate 1 plan approval, and `Committed` for Gate 2 review acceptance).
   - **`Completed`**: Disposition indicating completed review and commit prior to or at `Published`.
   - **`Cancelled`**: Terminal administrative disposition at Gate 1 indicating ticket withdrawal (proposal dropped, infeasible, or superseded during intake, scoping, or planning ratification). Involves **zero code reverts**, zero working-tree modifications, and zero rule modifications. Reaching `Cancelled` unconditionally turns **OFF** all active flow switches.
   - **`Rejected`**: Terminal implementation disposition at Gate 2 indicating rejection of physical modifications during visual diff review (`Verified` checkpoint). Actively triggers **rollback and removal of uncommitted working-tree modifications** introduced by the proposal back to the clean pre-CRP baseline (or full cohort rollback for batches). Reaching `Rejected` unconditionally turns **OFF** all active flow switches.
4. **Governed Flow Switches**:
   Flow switches modify execution behavior and velocity across sync points:
   - **`-DOIT`** (`always-proceed = $true`): Activated by `do` command or `BUG` disposition. Bypasses Gate 1 planning pause and executes continuously through `In_Progress` to `Verified`.
   - **`-Force`**: Authorizes only the Gate 2 visual-review exception under strict emergency criteria (`RULE-REV-001`).
   - **`-Immediately`**: A distinct, temporary quality-check deferral for an exact recovery cohort containing at least one `BUG-<id>`. It requires an operator-recorded reason describing a severity condition, repair deadlock, loop, race condition, or inability to self-remedy. It does not waive exact identity or Gate 2 review, and ends at the BCR/Gate 2 handoff.
   - **`-MinimalTests`**: Single-cycle execution switch restricting test DAG to fast regression checks (`RULE-LCM-023`).
   - **`-Coarse` / `-Tight`**: Granularity switch controlling single combined review stop per batch (`-Coarse`) vs. stop per proposal (`-Tight`) (`RULE-LCM-003`).
   - **`LCM OFF`**: Emergency escape switch suspending governance scaffolding and gating (`RULE-LCM-006`).
   - **`Testing OFF`**: Deferred deep testing switch suppressing heavy cascades during interactive development (`RULE-LCM-006`).
   - **`ADMINMODE`**: A per-tool design criterion recording whether a tool requires elevation. Setting a tool's Admin value off during redesign marks elevation as no longer required but does not remove any existing auto-elevation code; the redesign must remove obsolete elevation behavior and validate the result. It does not alter lifecycle transitions, testing obligations, review requirements, or rule-change authorization checks.
5. **Mandatory CM Plan & Walkthrough Archival**:
   - All Markdown implementation plans and execution walkthroughs `MUST` be persistently archived in the governed CM repository under:
     - `LCM_Inventory/data/proposals/plans/Proposal-{ID:03d}_{CR_ID}_Plan.md`
     - `LCM_Inventory/data/proposals/plans/Proposal-{ID:03d}_{CR_ID}_Walkthrough.md`
   - Explicit relative links `plan_path` and `walkthrough_path` `MUST` be recorded in `proposals.json`.
6. **Authoritative Flat Lifecycle Matrix & State Diagram**:

   #### A. Canonical Flat Lifecycle Matrix

   | Sync Point (Milestone) | Canonical Status Name | Operator Action | Dispositions at Sync Point | Active Flow Switches | CM Side Effect & Invariant |
   |:---|:---|:---|:---|:---|:---|
   | **0. Suggested** | `Suggested` | `suggest` | `BUG` (sets `-DOIT`) | Default | Bundle scaffolded in `docs/Proposals/`; Gate 1 pause. |
   | **1. Scoped** | `Scoped` | `scope` | — | Default | Bound to origin repo, primary app (`App: #`), and constituent manifest. |
   | **2. Decided** | `Decided` | `approve` / `Proceed` | `Approved` | Default | Gate 1 passed; architecture and plan ratified. |
   | **3. In_Progress** | `In_Progress` | `start` / `do` (sets `-DOIT`) | — | `-DOIT` (if `do`/`BUG`) | Active code modification; unit tests executing. |
   | **4. Verified** | `Verified` | `verify` / `bcr` | — | `-MinimalTests` (optional) | Implementation complete; tests pass; Gate 2 BC5 review dispatched. |
   | **5. Committed** | `Committed` | `reviewed` / `commit` / `COMPLETE` | `Approved`, `Completed` | `-Force` (if authorized) | Review accepted; receipt in `reviews/`; local Git commit created. |
   | **6. Published** | `Published` | `publish` / `push` | `Completed` | Auto-Reset (`ON`) | Walkthrough archived; lockstep preflight passed; remotes pushed. |
   | **[Condition] Held** | Current Sync Point | `hold` | `HELD` | Paused | Work suspended; reason recorded in CM ledger. Cleared by `resume`. |
   | **[Terminal] Cancelled** | Discarded (Gate 1) | `cancel` | `Cancelled` | Turned OFF | Administrative withdrawal at Gate 1; zero working-tree modifications; zero code reverts. |
   | **[Terminal] Rejected** | Discarded (Gate 2) | `reject` | `Rejected` | Turned OFF | Implementation rejection at Gate 2; working-tree modifications actively rolled back to pre-CRP baseline. |

   #### B. Canonical Flat Lifecycle State Diagram

   ```mermaid
   stateDiagram-v2
       direction TB

       [*] --> Suggested: Intake (suggest)
       Suggested --> Scoped: Scope (bind repo / app)
       Scoped --> Decided: Decide / Approve Plan (Gate 1 Passed)
       Decided --> In_Progress: Start / do (sets -DOIT)
       In_Progress --> Verified: Verify Tests Passed
       Verified --> Committed: Accept BC5 Review & Commit (Gate 2 Passed)
       Committed --> Published: Publish / Push to Remote
       Published --> [*]

       %% Exception Flow: HELD Suspension
       In_Progress --> Held: hold (sets HELD disposition)
       Scoped --> Held: hold
       Decided --> Held: hold
       Held --> In_Progress: resume (clears HELD disposition)

       %% Exception Flow: Gate 1 Administrative Withdrawal (Zero Reverts)
       Suggested --> Cancelled: cancel (Gate 1 withdrawal / zero reverts)
       Scoped --> Cancelled: cancel (Gate 1 withdrawal / zero reverts)
       Decided --> Cancelled: cancel (Gate 1 withdrawal / zero reverts)

       %% Exception Flow: Gate 2 Implementation Rejection (Rollback to Baseline)
       Verified --> Rejected: reject (Gate 2 review rejection / rollback to baseline)
       In_Progress --> Rejected: reject (aborted implementation / rollback to baseline)

       Cancelled --> [*]
       Rejected --> [*]
   ```

### RULE-LCM-008: BUG Disposition, DOIT Mode & Review Decision Non-Circumvention Baseline
1. **Flow Exception via `BUG` Disposition**: When a proposal is assigned the `BUG` disposition (whether reported by the operator or self-discovered during test execution), it sets flow switches to force flow exceptions. Specifically, it automatically activates the **`-DOIT` switch** (`always-proceed = $true`).
   - The agent scaffolds the proposal bundle (`docs/Proposals/BUG-<nnn>-[Slug]/`) and immediately executes code modifications, script adjustments, and unit verification tests continuously without pausing for a Gate 1 planning approval.
2. **Review Decision Non-Circumvention Baseline & Authorized Exceptions**:
   - By default, even a critical or urgent proposal with disposition `BUG` halts at the Review Decision checkpoint (Gate 2) upon reaching Sync Point `Verified`.
   - Once the fix is verified in the working tree and logged in `Walkthrough.md`, the agent dispatches the visual review session (`Invoke-BeyondCompareReview.ps1`) and awaits operator review disposition.
   - **Authorized Gating Exceptions (`RULE-REV-001`)**: Review gate confirmation may be bypassed only if:
     1. The user explicitly instructs (`IMMEDIATELY`, `FORCE`) to advance directly into implementation or commit.
     2. A critical system bug impedes the intended flow and leads to an unavoidable loop/recursion that the user cannot avoid or fix, bound strictly by the 2-attempt loop breaker (`RULE-LCM-017`).
     - In either case, the bypass justification `MUST` be logged in the proposal bundle and Configuration Management ledger.

### RULE-LCM-009: Scope and Version-Explicit CRP Naming Standard
1. **Canonical Directory Bundle Convention**: All Change Request Proposals (CRPs) `MUST` follow the standardized bundle directory structure:
   `docs/Proposals/CRP-<nnn>-[Slug]/` containing `Specification.md`, `Implementation_Plan.md`, and `Walkthrough.md`.
   - `nnn`: Universal monotonic sequence integer zero-padded to at least 3 digits (e.g. `018`, `119`), matching the proposal ledger `id` 1:1.
   - `[Slug]`: Descriptive kebab-case intent description.
2. **Mandatory Header Metadata**: Every CRP specification `MUST` include explicit metadata fields:
   - `Target Scope`: Explicit repository or subsystem boundary.
   - `Affected Version Range`: Semantic version or range.
   - `Impacted Repositories`: Array of modified repositories.
3. **Legacy Flat File Fallback**: Historical CRPs (e.g. `CRP-001` through `CRP-017`) authored as flat `.md` files remain valid and governed under `RULE-LCM-020` Mode 3 (Legacy Fallback).

### RULE-LCM-010: Mandatory Self-Discovered Bug Registration Invariant
1. **Mandatory Self-Discovery Reporting**: Whenever the AI agent discovers a bug, syntax defect, unhandled runtime exception, parser failure, or regression in a permanent tool, platform script, shared module, or web UI during development, testing, or tool execution (including deferred deep testing failures per `RULE-LCM-006`), the AI agent `MUST` formally register a Bug Report in `LCM_Inventory/data/proposals/proposals.json` and scaffold the accompanying proposal bundle.
2. **Immediate Remediation in `DOIT` Mode**: The self-discovered bug transitions directly into `DOIT` mode to diagnose and resolve the failure, but remains bound by the Review Decision Non-Circumvention Invariant (`RULE-LCM-008`).
3. **Prohibition of Silent In-Place Hotfixing**: The AI agent `MUST NOT` silently patch defects in permanent tools without registering a formal BUG entry in the Configuration Management ledger.

### RULE-LCM-011: Scope and Version-Explicit Bug Report Naming Standard
1. **Canonical Bug Bundle Directory Convention**: All formal Bug Reports `MUST` follow the standardized bundle structure:
   `docs/Proposals/BUG-<nnn>-[Slug]/` containing `Specification.md`, `Implementation_Plan.md`, and `Walkthrough.md`.
   - `nnn`: Universal monotonic sequence integer zero-padded to at least 3 digits (e.g. `024`, `092`), sharing the exact same sequence counter as CRPs and matching the proposal ledger `id` 1:1.
2. **Mandatory Frontmatter Metadata**: Every Bug Report `MUST` include explicit frontmatter fields:
   - `Bug-ID`: Sequential unique identifier sharing the sequence counter with CRPs (e.g. `BUG-024`, `BUG-092`).
   - `Scope`: Affected repository or subsystem boundary.
   - `Version`: Target release baseline (e.g. `10.0.0`).
   - `Affected-Repos`: Array of modified repositories.
   - `Severity`: Impact assessment (`Low`, `Medium`, `High`, `Critical`).
   - `Status`: Lifecycle status (`Open`, `In-Progress`, `Completed`).
   - `Root-Cause`: Concise explanation of failure mechanics.
3. **Legacy Flat File Fallback**: Historical Bug Reports (e.g. `BUG-024` through `BUG-094`) authored as flat `.md` files remain valid and governed under `RULE-LCM-020` Mode 3 (Legacy Fallback).

### RULE-LCM-012: Mandatory Scope-and-Version Explicit CRP Specification Generation Invariant
1. **Mandatory Standalone Specification**: Whenever proposing, designing, or implementing new features, tools, workflows, architectural enhancements, or governance policies, the AI agent `MUST` author a formal, standalone Scope-and-Version Explicit Change Request Proposal specification (`Specification.md`) within its proposal bundle in `LCM_Inventory/docs/Proposals/` before or alongside ledger registration.
2. **Prohibition of Orphan Feature Proposals**: Proposing or executing features or tool modifications without an authoritative, permanent proposal bundle in `LCM_Inventory/docs/Proposals/` is strictly prohibited. Every non-bug feature proposal in `proposals.json` `MUST` link to a valid `bundle_id` matching an existing CRP bundle.

### RULE-LCM-013: Mandatory Pre-Push Gemini AI & Knowledge Base Synchronization Invariant
1. **Mandatory Automated Pre-Push Execution**: Every `PUSH` operation executed via `Invoke-LCM_Push.ps1`, whether multi-repository or targeting a single repository (`-Repositories <repo>`), `MUST` automatically execute the `Update-Gemini.ps1` pipeline prior to pushing commits to remote Git repositories. Direct manual `git push` invocations that bypass `Invoke-LCM_Push.ps1` are prohibited.
2. **Context & Rules Mirroring Parity**: This guarantees that all 17 canonical LCM rules (`LCM_AI/docs/LCM_Rules_Gemini_Export.md`), plain-text `.txt` mirrors, tool catalogs, and full workspace knowledge base exports (`D:\GDrive\LCM`) are 100% synchronized with the pushed Git baseline at the moment of remote dispatch.
3. **Automated Export Commit**: If the `Update-Gemini` pipeline updates the consolidated rules export in `LCM_AI`, those changes `MUST` be staged and committed immediately before dispatching the push to `origin/main`.

### RULE-LCM-014: Dual-Gate Architecture & CRP Planning Gate Invariant
1. **CRP Birth in SUGGESTED State**: For any non-bug Change Request Proposal (`CRP`), the proposal `MUST` birth in the **`SUGGESTED`** state under the Normal Review Cycle.
2. **Gate 1 Planning Halt**: The AI agent `MUST` scaffold the Proposal Bundle directory, register the entry in `proposals.json`, present the plan, and `UNCONDITIONALLY HALT`. No source code, permanent script, configuration, or test file may be modified, created, or deleted while at Gate 1, unless explicitly instructed (`IMMEDIATELY`, `FORCE`) by the operator per `RULE-REV-001`.
3. **Gate 1 Activation Triggers**:
   - **`Proceed`**: Advances state from `SUGGESTED` $\rightarrow$ `IN_PROGRESS` in the Normal Review Cycle (interactive checkpoints if open questions or design alternatives exist).
   - **`do` / `do <ID>`**: Advances state to `IN_PROGRESS` and activates **`DOIT` Mode** (`always-proceed = $true`), executing planned modifications continuously until the Review Decision checkpoint is reached per `RULE-EFF-004`.
4. **Strict Dual-Gate Lifecycle**:
   - **Gate 1 (Planning Gate)**: Propose solution / Register proposal bundle & plan $\rightarrow$ `STOP` and await explicit operator direction (`Proceed` or `do`). (BUGs bypass Gate 1 into `DOIT` mode).
   - **Review Decision Checkpoint (BC5 Review / Gate 2)**: Implement approved changes $\rightarrow$ Present visual diffs / walkthrough / BC5 review $\rightarrow$ `STOP` and await operator review disposition. Mandatory for all proposals, subject strictly to the two authorized exceptions in `RULE-REV-001`.
5. **Specification Acceptance Authority**: At Gate 1, `Specification.md` is the authoritative proposal contract and the only bundle document requiring formal operator acceptance. `Implementation_Plan.md` and `Walkthrough.md` are supplementary design and evidence records; they neither withhold nor replace Specification acceptance. The ledger MUST retain the accepting operator, timestamp, accepted Specification path, and any stated acceptance scope.

### RULE-LCM-015: Strict Intake Classification Gate
1. **Intake Signal Classification**:
   - `CRP:` designator indicates a Change Request Proposal: enters `SUGGESTED` state and halts at Gate 1.
   - `BUG:` designator indicates a Defect Report: enters `DOIT` mode immediately and executes directly to the Review Decision checkpoint.
2. **Priority Ordering**: Numeric priority from $0$ through $10$ affects execution order in batch queues; equal-priority items may receive an advisory technical sequence. Priority never authorizes bypassing the Review Decision checkpoint.

### RULE-LCM-016: Deterministic Lifecycle Command Invariants
1. **`Proceed` / `Proceed <ID>`**:
   - Deterministic single-status pulse: advances the target proposal forward by exactly **one discrete state**.
   - Gate 1: `SUGGESTED` $\rightarrow$ `IN_PROGRESS`.
   - Review Decision: `REVIEW` $\rightarrow$ `COMMITTED` (satisfies review, records audit disposition, increments SemVer, and commits to local Git).
2. **`do <ID>` / `do <batch>`**:
   - Activates **`DOIT` Mode** (`always-proceed = $true`), running all planned tool operations continuously from Gate 1 to the Review Decision checkpoint.
3. **`COMPLETE <CRP-ID|BUG-ID|repository|cohort>` / `COMPLETE ALL`**:
   - Records review completion, creates a local commit, and transitions the exact staged proposal,
     resolved repository scope, or declared cohort to `COMPLETED`.
   - The staging manifest MUST identify the resolved CRP/BUG, repository, or cohort. Completion
     MUST refuse only when that scope is unresolved or ambiguous.
   - Before committing, the operator-facing result MUST list the exact changed files and disclose
     any scope amendment, linked BUG, or cohort membership.
   - Never invokes a remote push.
4. **`PUSH`**:
   - Pushes only `COMPLETED` proposal repositories in a preflighted cohort with `LCM_Inventory`.
   - A cohort member that is missing, lacks a remote, or is not ahead blocks all remote dispatch.
   - Enforces the Push Auto-Reset Invariant (`RULE-LCM-006`): resets `LCM Mode` and `Testing Mode` to `ON`.iew.

### RULE-LCM-017: Autonomous System Exception Boundary & 2-Attempt Loop Breaker
1. **Autonomous Exception Scope**: As a sole exception to `RULE-LCM-016`, the AI agent is permitted to assume an implicit `PROCEED` to immediately remediate a self-discovered or runtime-generated `BUG` `ONLY IF` all of the following conditions are simultaneously met:
   - **Critical System/Transport Behavior**: The defect represents a severe runtime blocker directly disrupting operations (e.g., REST daemon socket drops on Port 9876, IPC transport failures, or blocking background daemon aborts).
   - **Within Agent Capability**: The root cause is definitively identified and remediable within the agent's direct operational scope.
   - **No Architectural Redesign**: The fix requires no architectural redesign, schema changes, or breaking API alterations.
   - **Net Positive Impact**: The fix will not create cascading side-effects or regressions exceeding the problem being solved.
2. **Mandatory 2-Attempt Loop Breaker**:
   - If two (2) consecutive attempts to fix a runtime defect or launch an operational action fail, the autonomous `PROCEED` exception is **immediately and irrevocably revoked**.
   - When an operational command, tool dispatch, or GUI launch fails on Attempt 1, at most ONE direct alternative may be attempted (Attempt 2). If Attempt 2 also fails, the agent `MUST HALT` immediately, report the exact raw diagnostic evidence to the operator, and await explicit instructions.
   - Cascading through speculative launch mechanisms (such as background tasks, CIM process creation, cmd start wrappers, or ad-hoc scheduled tasks) is strictly prohibited.
   - The agent `MUST` mark the blocked item in the ledger, document the failure telemetry, and yield full control back to the operator.

### RULE-LCM-018: Credit Exhaustion & Batch Execution Granularity Guard
1. **Batch Size Safety**: Multi-item batches `MUST` be segmented into manageable, verifiable increments to prevent credit, context, and token exhaustion.
2. **Discrete Review Boundaries**: Each approved proposal or tight batch `MUST` reach a stable, verifiable state before proceeding to subsequent items, guaranteeing that uncommitted or partially modified code never leaves the workspace in an unrecoverable state.

### RULE-LCM-019: Active App Context Inheritance & Automated Tripartite Synthesis on COMPLETE
1. **Active Context Inheritance (`Workon:`)**:
   - When an active App context is set via `Workon: A<#>` (e.g. `Workon: A1`), all subsequent Change Request Proposals (`crp: ...`), Bug Reports (`bug: ...`), and tasks generated during this focus `MUST` automatically inherit the active `app_id` (e.g. `"App: 1"`) in `proposals.json`.
   - When set to `Workon: Architecture` or cleared (`Workon: Base`), proposals are recorded with `app_id: $null` (foundational system scope).
2. **Automated Tripartite Synthesis upon `COMPLETE`**:
   - The `COMPLETE <id>` command serves as the authoritative local lifecycle trigger that concludes an App increment.
   - Upon `COMPLETE`, the conclusive architecture decisions, technical requirements, and code manifests associated with the proposal `MUST` be synthesized into the repository's tripartite documentation under the designated `App: #` section:
     - Architectural summary $\rightarrow$ `Architecture.md` under `## App: #`
     - Normative invariants $\rightarrow$ `Requirements.md` under `## App: #`
     - Manifest table $\rightarrow$ `Implementation.md` under `## App: #`
3. **Multi-App Problem Resolution Gating**:
   - For multi-App bugs (`BUG-###`), the proposal `MUST` explicitly declare `primary_app` (root cause) and `affected_apps` (blast radius).
   - The bug cannot be marked `completed` or `committed` until the unit tests of the primary App *and* the integration tests of all affected Apps pass 100%.
   - On `COMPLETE`, documentation updates are synthesized across all affected App sections in a single atomic step.

### RULE-LCM-020: Proposal Bundle Directory Architecture, Dual Lifecycle & Git Object Document Retrieval
1. **Self-Contained Proposal Directory Bundles**:
   - Every proposal across the workspace (whether LCM core or child repository feature) `MUST` be stored in a dedicated proposal bundle directory:
     `docs/Proposals/CRP-<nnn>-[Slug]/` (or `BUG-<nnn>-[Slug]/`).
   - Each proposal bundle directory `MUST` contain three standardized Markdown documents:
     - `Specification.md` (Domain intent, problem statement, requirements, architectural tradeoffs, and metadata header)
     - `Implementation_Plan.md` (Technical file diff breakdown, component plans, and verification strategy)
     - `Walkthrough.md` (Execution receipts, test execution logs, before/after evidence, and operational verification)
2. **Pre-Push Working Tree Lifecycle**:
   - During proposal authoring, implementation planning, active coding, and review gating, the proposal bundle directory lives in the local repository working tree and is directly queryable by developers, CLI tools, and the CM Control Hub.
3. **Post-Push Working Tree Purge Invariant**:
   - Upon `Invoke-LCM_Push.ps1` (or push workflow execution):
     - The target repository head commit SHA `MUST` be captured and recorded in `proposals.json` (`commit_sha: "<SHA>"`).
     - The remote GitHub tree link `MUST` be generated and recorded (`github_url: "<URL>"`).
     - The completed local proposal bundle directory `MUST` be purged from the working tree, ensuring 0 dead or redundant proposal directories remain in the working tree.
4. **Dual-Mode Document Retrieval Protocol (`Get-LcmProposalDocument`)**:
   - Tools, scripts, and dashboards `MUST` resolve proposal documents using the dual-mode resolution protocol:
     - **Mode 1 (Live Disk)**: If the bundle directory exists on disk (`Test-Path`), read content directly from the working tree.
     - **Mode 2 (Git Object Extraction)**: If the local directory has been purged, extract document content directly from the local repository Git object store using `git -C <RepoPath> show "<commit_sha>:<bundle_dir>/<file>"`.
     - **Mode 3 (Legacy Fallback)**: For pre-CRP-162 historic proposals, fall back to flat `plan_path` and `walkthrough_path` targets.

### RULE-LCM-021: Tool & Macro Synchronization Invariant
1. **Synchronous Macro Maintenance**: Whenever any tool, trampoline command (`.cmd`), alias, or CLI parameter interface is added, renamed, refactored, or deprecated across the workspace:
   - The authoritative macro reference in `macro-definitions.md` (`.agents/rules/macro-definitions.md`) `MUST` be updated synchronously within the same proposal or commit increment to reflect accurate tool names, current aliases, and available parameters.
   - Obsolete tool references (such as deprecated script paths or legacy trampolines) `MUST NOT` be retained as primary commands.
2. **Antigravity IDE Bare-Word Precedence**:
   - In Antigravity IDE environments, bare-word command invocations (`ToolExplorer`, `ShowTools`, `tools`, `ar`, `bcr`, `COMPLETE`, `PUSH`, `DO <#>`) `SHALL` be documented as the primary macro syntax to prevent collisions with the IDE's interactive context attachment menu triggered by `@`.
   - The `@` prefix remains recognized as a backward-compatible alias.

### RULE-LCM-022: Atomic Edit Consolidation & Editor Review Safety Invariant
1. **Single-Edit Atomic Consolidation**:
   - The AI agent `MUST` consolidate all modifications to any single target file into **one single comprehensive edit per user turn**.
   - The AI agent `MUST NOT` issue rapid back-to-back sequential edits to the same file across consecutive tool calls or turns without explicit user review and confirmation.
   - When updating multiple non-contiguous blocks of a file, the agent `MUST` use `multi_replace_file_content` in a single unified tool call rather than multiple separate calls.
2. **Editor Review Queue Non-Stacking Invariant**:
   - To prevent stacked diff review decorations and ambiguous chronological review banners in the IDE, the AI agent `MUST NOT` re-modify a file that has an unreviewed pending diff in the editor.
   - Prior to modifying any file that was touched in the preceding turn, the agent `MUST` verify that the user has accepted or dismissed the review.
3. **Buffer Clobber Prevention**:
   - The agent `MUST` ensure `"files.autoSave": "off"` is maintained in workspace settings (`.vscode/settings.json`), preventing the IDE from auto-saving stale in-memory editor buffers over freshly written disk files.

### RULE-LCM-023: Minimal Tests Single-Cycle Execution Switch & State Reflection Invariant
1. **Single-Cycle Ephemeral Scope**:
   - The `-MinimalTests` switch provides a single-cycle execution mode restricting the Test Readiness gate to fast hygiene checks (PowerShell AST parsing, Python compilation, UTF-8/CRLF validation, and English language checks).
   - Heavy test cascades (elevated integration suites, Session 0 harnesses, deep subsystem DAGs) are skipped during the single active proposal or declared batch execution.
   - Upon completion of the target item's readiness check, review submission, or turn conclusion, testing scope unconditionally auto-resets to standard full verification (`full`). Minimal testing `MUST NOT` persist as an ambient workspace state.
2. **Authoritative State Field Representation**:
   - When an item is verified and completed under `-MinimalTests`, its authoritative **`state`** (not status) attribute in `LCM_Inventory/data/proposals/proposals.json` `MUST` explicitly record `"state": "completed [minimal-tests]"`, with metadata attribute `"test_scope": "minimal"`.
   - The CM Control Hub and status displays render this state with distinct indicator chips (`COMPLETED ⚠️ MINIMAL`) to provide transparent operator visibility into verification depth.
3. **Audit Ledger & Review Evidence**:
   - Every activation of Minimal Tests `MUST` record an entry in `LCM_Inventory/logs/cm_activity.log` and capture `"test_scope": "minimal"` in the generated review receipt (`LCM_Inventory/data/reviews/review_*.json`).

---

### RULE-LCM-024: Mandatory Pre-Handoff Verification & Zero-Assumption Testing Invariant
1. **Pre-Handoff Verification Gate**: Before advancing any proposal to `Verified`, proposing Gate 2 visual review, or handing the turn back to the operator:
   - The AI agent `MUST` validate every created or modified script, module, or configuration file using its language's native AST parser or compiler (`[System.Management.Automation.Language.Parser]::ParseInput()` for PowerShell, `python -m py_compile` for Python, `ConvertFrom-Json` for JSON). Zero syntax errors or parse warnings are tolerated.
   - The AI agent `MUST` execute the relevant unit test suites (Pester, pytest, or readiness scripts).
2. **Zero-Assumption Testing Invariant**:
   - The AI agent `MUST NOT` skip tests or assert that code is valid, ready, or functional based on visual inspection alone.
   - Declaring or reporting completion, review readiness, or success without executing mechanical verification is strictly prohibited.

### RULE-LCM-025: Temporary Specification Absorption and Semantic-Delta Restart
1. CRP/BUG bundles are temporary active specifications. On push, delivered behavior is absorbed
   into the affected repository baseline documentation while ledger and history evidence remain
   retained.
2. When further work is needed after push, the same identifier MUST reopen at `suggested` with a
   forward-only revision event; creating a replacement CRP solely to revise the prior work is not
   required.
3. A semantic change to an active specification MUST restart each affected CRP at `suggested`,
   record the declared semantic delta, and require review/testing only for that delta. Previously
   valid, unaffected evidence remains historical evidence.
4. `ShowCM` is both the lifecycle overview and requested state-navigation surface. It MUST expose
   state-appropriate accept/reject actions and repository, cohort, and complete forms. Managed
   lifecycle hooks remain retained for governed transitions.

### RULE-LCM-026: Explicit Control-Hub Target and Cohort Action Invariant
1. **Explicit Target Identity**: A Control Hub operation `MUST` identify exactly one target before it is previewed or executed. The target kind is `CRP`, `COH`, or `workspace`; the interface `MUST NOT` infer it from a visible row, previously inspected proposal, or an implicit multi-selection.
2. **Target-Scoped Actions**: CRP actions operate on one CRP. Cohort actions operate on the declared cohort and its current members. Workspace maintenance actions are outside the current CRP/cohort target and `MUST` be visibly separated from lifecycle controls.
3. **Atomic Cohort Lifecycle Actions**: A lifecycle action on a cohort `MUST` evaluate every current member before any mutation. If one member is ineligible, the request `MUST` fail with member-specific reasons and leave every member unchanged. A successful request applies the same permitted transition to all members and records the cohort identity in the audit trail.
4. **Cohort Membership Proposals**: A declared `COH-<prime>` is anchored by its immutable head/prime CRP and may contain that sole head; no minimum number of CRPs applies. Adding or removing non-head members `MUST` preview the complete membership delta and pass all head/prime, open-cohort, identity, and cross-repository validations before mutation. At most one open cohort may exist; Add `MUST` resolve it automatically rather than offer a cohort choice. Creation remains available when an open cohort exists, but creates an inactive cohort; only opening or reopening an inactive cohort is rejected while another cohort is open. Adding when no open cohort exists is rejected. The backend `MUST` recheck this invariant immediately before persistence. Closed cohorts are irrelevant, and inactive does not mean closed. Partial membership changes are prohibited.
5. **FIX Presentation Boundary**: A Control Hub `FIX` action group may provide a unified operator entry point for review-confirmation exceptions, emergency quality deferrals, retirement, and supersession. `-Force` and `-Immediately` retain their distinct eligibility, reason, exact-identity, review, and termination requirements; a common label `MUST NOT` broaden either mechanism.

---

### RULE-LCM-027: Strict Proposal Scope Boundary & Anti-Scope-Creep Invariant
1. **Strict Scope Fence**: When implementing, refining, or bug-fixing any proposal (BUG-#, CRP-#), the AI agent `MUST` strictly confine modifications to the explicit clauses declared in the accepted Gate 0 Contract (`Specification.md`).
2. **Prohibition of Incidental Refactoring**: The AI agent `MUST NOT` refactor, replace, or "improve" adjacent, pre-existing mechanisms (such as process launchers, window dispatchers, GUI hooks, or external service bridges) that lie outside the accepted scope, even if the agent perceives them as sub-optimal.
3. **Deficiency Isolation Protocol**: If an adjacent pre-existing subsystem is encountered that is deficient or unsuited for the task, the agent `MUST NOT` modify it in-flight under the active proposal. Instead, the agent `MUST` either:
   - Use documented existing interfaces without altering their implementation, OR
   - Formulate and present an independent, separate proposal (BUG/CRP) to address the adjacent defect after current work is completed or stopped.
4. **Prohibition of Unwarranted Test Cascades**: The agent `MUST NOT` trigger repetitive, speculative test suites (e.g. executing heavy Pester integration runs repeatedly) while debugging minor local issues. Testing must remain targeted, minimal, and proportional to the changes made.

---

### RULE-LCM-028: Question Response & Anti-Overreaction Invariant
1. **Inquiry vs. Instruction Distinction**: When the operator poses a question, it `MUST NOT` cause the AI to do anything except answer.
2. **Prohibition of Implicit Action on Query**: An inquiry—whether exploratory, technical, critical, explanatory (e.g. *"X does not justify Y"*), or rhetorical—is an inquiry for explanation, alignment, or clarification. It `MUST NEVER` be treated as an implicit command to alter code, revert changes, delete files, abandon ongoing tasks, or execute workspace mutations.
3. **Requirement for Explicit Direction**: State mutations, code modifications, rollbacks, and file reversions `MUST ONLY` be executed when accompanied by an explicit, affirmative instruction (e.g. *"Are you kidding? Fix/correct this like that...!"*).

---

### RULE-LCM-029: Boundary Ambiguity & Alternatives Invariant
1. **Mandatory Pause on Ambiguous Boundaries**: Wherever the operational boundary, scope, or resolution path is not explicit or given by the goal contract, the AI agent `MUST` halt autonomous execution immediately.
2. **Presentation of Alternatives**: The AI agent `MUST` present clear, concrete alternatives (with their respective trade-offs) and **WAIT FOR CONFIRMATION** before modifying any workspace files or advancing lifecycle state.
3. **Prohibition of Speculative Extrapolation**: The AI agent `MUST NOT` guess, speculate, or unilaterally assume a boundary (whether leaning toward sweeping maximalist execution or complete abandonment). The operational boundary remains frozen until explicitly confirmed by the operator.

---

### RULE-LCM-030: Session Quiescence & GoodNight / GoodMorning Protocol Invariant
1. **Quiescent State Invariant**:
   - Following the execution of an end-of-day sequence (`GoodNight`, `goodnight`, `SaveAll`), the workspace enters a **Quiescent State**.
   - While in a Quiescent State, if an automated or synthetic turn is triggered (such as platform context compaction, background message, or schedule wakeup) without a new, explicit `<USER_REQUEST>` from the operator, the AI agent `MUST REMAIN SILENT`. It `MUST NOT` proactively emit greetings, status summaries, or initiate unprompted workflows.
2. **GoodNight Terminal Message Protocol**:
   - The final output line/message of a GoodNight sequence `MUST` display the completion timestamp:
     `🌙 Good Night completed at YYYY-MM-DD HH:mm:ss. Session is Quiescent.`
3. **GoodMorning Resumption Response Protocol**:
   - When the operator initiates the next session with a morning greeting or command (`GoodMorning`, `goodmorning`, `ShowTools`, etc.), the **FIRST MESSAGE RESPONSE** from the AI agent `MUST` explicitly state the resumption and reference the preceding GoodNight timestamp:
     `☀️ Good Morning! Resuming from Good Night at YYYY-MM-DD HH:mm:ss (Gap: X.X h).`

---

### RULE-LCM-031: Context Absorption, Reverse-Ticket Invariant & Guaranteed Learned-Advice Retirement
1. **Reverse-the-Ticket Invariant (Authoritative CRP Ownership)**:
   - When operational items, operator remarks, or learned guidance are taken up for execution, the proposal (CRP/BUG) is the authoritative lifecycle owner.
   - The CRP specification (`Specification.md`) `MUST` incorporate the verbatim original text of the absorbed item in a dedicated section (`## Absorbed Operator Remarks` or `## Recognized Learned Advice`).
   - **Contradiction Pre-Check**: The absorbed text `MUST` be evaluated against the CRP's target state, purpose, and invariants. If an incompatibility or contradiction exists, the CRP intake `MUST` fail closed or document an explicit reconciliation before proceeding.
2. **Immediate Source Uncluttering for Operator Remarks (`ACTIVE_CONTEXT.md`)**:
   - The moment an operator remark from `.agents/ACTIVE_CONTEXT.md` is absorbed into an active CRP specification, it has graduated to a governed lifecycle artifact.
   - The remark `MUST` be removed immediately from `.agents/ACTIVE_CONTEXT.md`.
   - No historical archive, lingering notes, or pseudo-states (`DONE:`, `RESOLVED:`) `MAY` remain in `ACTIVE_CONTEXT.md`. Historical provenance is preserved via Git history and the CRP proposal bundle.
3. **Two-Stage Lifecycle & Guaranteed Retirement for Learned Advice (`LEARNED_ADVICE.md`)**:
   - Because `.agents/LEARNED_ADVICE.md` contains binding operational invariants for all AI agents, it `MUST NOT` be prematurely deleted merely because a CRP was created or is in progress.
   - **Stage 1 (Recognized Status)**: Upon intake into an active CRP, the advice entry is annotated as `[RECOGNIZED: CRP-XXX]`. It remains 100% active, binding, and enforceable. It `MUST NEVER` be marked `done` or deleted during implementation.
   - **Stage 2 (Guaranteed Retirement)**: Deletion from `LEARNED_ADVICE.md` is unlocked `ONLY` when the CRP's goals—specifically including the issue governed by the learned advice—are **guaranteed to be met** by the test harness (e.g. passing Pester test, automated readiness gate, or formal policy codification in `.agents/rules/`).
   - Only upon verified passage of the guarantee at `verify` / `in_review` / `complete` is the advice entry safely purged from `LEARNED_ADVICE.md`.

