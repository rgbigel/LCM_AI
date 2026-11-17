---
name: RepositoryContextPolicy
description: Authoritative rule for automatic repository context detection, fast-tier ingestion, candidate fallback, and zero-redundant scan governance.
globs: "*"
---
# File: RepositoryContextPolicy.md

Module: RepositoryContextPolicy  
Purpose: Defines automatic active-document repository detection, fast-tier context priming, candidate fallback, and scan optimization invariants.  
Path: .agents/rules/RepositoryContextPolicy.md  
Authors: Rolf, LCM_AI  
Version: 10.3.1
Status: Authoritative Invariant Rule  
Date: 2026-11-17 15:40:19

---

## 1. Context Ingestion Invariants

### `RULE-CTX-001` (Active Repository Scope Resolution)
At the start of every interaction or when switching focus, the agent `MUST` automatically identify the target repository from:
1. The currently active document / cursor file path in the IDE metadata.
2. Explicitly referenced repository paths in the user request.
3. Fallback for headless environments or absent IDE cursor metadata: Inspect the active proposal context (`docs/Proposals/`) or default to workspace root (`D:\Git_Repositories\`) guided by [.agents/ACTIVE_CONTEXT.md](file:///d:/Git_Repositories/.agents/ACTIVE_CONTEXT.md).

### `RULE-CTX-002` (Fast-Tier Repository Context Priming)
When active work begins on a specific repository (e.g. `VolumeInventory`, `BootEntryManager`, `HaSSD06`, `BackgroundModifier`), the agent `MUST` prime its working context in a single targeted tier by reading:
1. `LCM_Inventory/data/inventory.json` and canonical governance rules (common governance resides in `.agents/rules/` and subsystem specifics in repo `docs/`; repository elevation requirements, governance version, and classification are audited in `inventory.json`).
2. `<TargetRepo>/README.md` (for module purpose, exported functions/atoms, and prerequisites).
3. Any open Change Requests / proposals in `LCM_Inventory/docs/Proposals/` (or active proposal bundle per `RULE-SUB-008`).

> [!NOTE]
> **Repository Onboarding Status:**  
> Automatic per-repository onboarding via `Invoke-LCMOnboardRepo.ps1` is planned and governed under `CRP-298`; unonboarded repositories are classified as candidates without triggering broad recursive scans.

### `RULE-CTX-003` (Zero Redundant Scan Invariant)
The agent `MUST NOT` run multi-step recursive discovery scans (`list_dir`, broad grep) across the entire workspace when operating within the scope of an identified repository.

### `RULE-CTX-004` (Methodology Awareness)
The agent `MUST` remain aware of the global LCM triad at all times:
* **`LCM_AI`**: Governs release baselines (governed by [`.agents/version.json`](file:///d:/Git_Repositories/.agents/version.json)), templates, and quality gates.
* **`LCM_Inventory`**: Configuration Management engine, audit ledger, and cross-repo CR indexing.
* **`LCM_Shared`**: Reusable functional atom library (`Logging`, `VolumeAtoms`, `BcdAtoms`, Python helpers).

### `RULE-CTX-005` (Learned Advice)
1. **Binding Status**: At the start of a session the agent `MUST` read `.agents/ACTIVE_CONTEXT.md` and `.agents/LEARNED_ADVICE.md`. Entries under **Accepted** are binding; entries under **Candidates** are guidance only.
2. **Multi-Host Authorship & Contribution**: All sanctioned AI hosts (Antigravity, Claude Code) `MAY` and `SHOULD` contribute durable insights. Authorship follows the workspace standard: the operator is always named first (`Authors: Rolf, <AI-Host>`); an AI host adds its identifier (ahead of another AI host) only if it creates or modifies the candidate.
3. **Top-Insertion Ordering**: New learned advice entries and candidates `MUST` always be added at the top of the relevant section (newest first).
4. **Non-Removal Invariant**: Unless an advice entry was actively corrected via a formal proposal (`requires crp-nnn`) and properly set into function as an enforceable rule, quality gate, or reliable contract, it `MUST NOT` be removed. Removal can happen in the middle of a section only when accompanied by explicit CRP citation.
5. **AI Observance & Non-Ignorance Invariant**: The insights in `LEARNED_ADVICE.md` `MUST` be actively taken up and followed by the AI. If an entry is ever ignored for a specific action, the AI `MUST` provide an explicit comment stating that it is being ignored and explaining why.
6. **Intake Flow**: When the operator writes `/learn <text>` the agent `MUST` add the text as a candidate (`Save-AllSessionMemory.ps1 -Learn "<text>" -Author <AI name>`), without changing anything else. An agent `MAY` also propose a candidate on its own when it learns something durable; it `MUST` tell the operator.
7. **Review Gate**: Candidates `MUST` be reviewed (`Invoke-LearnedAdviceReview.ps1`: accept, reject, or promote to a rule) no later than publishing. `Invoke-LCM_Push.ps1` refuses to publish while candidates are pending.
8. **Rule Promotion**: Entries marked `[->rule]` are written into the matching rule file, after which the entry is replaced by a reference to that rule.

### `RULE-CTX-006` (GoodMorning Session Start)
1. **Day Routine Trigger**: `Invoke-LCM_GoodMorning.ps1` is run by the operator or, on explicit operator instruction, by any sanctioned AI host (`RULE-LCM-030` (6), CRP-350). An AI assistant `MUST NEVER` launch it on its own initiative, nor as an envelope to obtain a baseline or perform multi-repo research.
2. **Multi-Host Attention Aggregation**: `Invoke-LCM_GoodMorning.ps1` aggregates session status, time gaps, repository drift, and pending attention items across all registered AI hosts (Antigravity, Claude Code) into a unified report.
3. **AI Resumption Protocol**: At session start, the AI assistant changes nothing except what `RULE-LCM-030` (5) allows (its own host block `Active`, the GoodMorning section 1 fields, the DO front-end start):
   - Read `.agents/ACTIVE_SESSION.md`, `.agents/ACTIVE_CONTEXT.md`, and `.agents/LEARNED_ADVICE.md`.
   - Adhere to the Session Quiescence and GoodMorning Resumption Response Protocol per `RULE-LCM-030`.
   - State that active context and binding learned advice have been verified, identify any stated attention items or stale entries across all registered hosts, and await explicit operator direction.


