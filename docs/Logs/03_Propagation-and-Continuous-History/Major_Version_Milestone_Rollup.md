# Major Version Milestone Rollup & Consolidation Archive

Module: docs/Logs/03_Propagation-and-Continuous-History/Major_Version_Milestone_Rollup.md
Purpose: Consolidated archive of high-level milestones rolled up at major version boundaries.
Path: docs/Logs/03_Propagation-and-Continuous-History/Major_Version_Milestone_Rollup.md
Authors: Rolf, Workspace_AI Engine, Claude
Version: 10.7.4
Status: Authoritative Historical Ledger
Classification: permanent-evolution-history
Date: 2026-11-18 16:12:38

---

## 1. Major Version Milestone Ledger

This ledger records consolidated milestone rollups. At each major version release, granular operational steps from `Continuous_Governance_Ledger.md` are synthesized here, keeping active working logs streamlined.

---

### Milestone v4.1.0: LCM Pre-Release Baseline (2026-08-15)

* **Architecture**: Formalized the 2-level LCM Proposal architecture (`Requirements.md` and `Implementation-and-Tooling.md`) spanning 9 governance domains and 72+ requirements.
* **Lineage Sanitization**: Completed full purge of legacy crash recovery residue, eliminated obsolete `AI-` / `GC` / `AC` prefixes, and archived historical lineage under `docs/Logs/01_Pre-AI-Evolution/`.
* **Repository Inventory**: Audited all 33 child directories under `D:\Git_Repositories\`; aligned `git.ignoredRepositories` to the exact 10 non-git directories and compiled `LCM-Repository-Inventory.md`.
* **Onboarding Engine (`Invoke-LCMOnboardRepo`)**: Implemented modular 4-Phase onboarding and update engine (`tools/Onboarding/LCMOnboarding.psm1`) utilizing cross-drive NTFS directory junctions for `.agents/rules/core` and `.agents/rules/core`, plus hardlinks/fallbacks for root agent instructions.
* **Visual Link Tooling**: Designated Junction Link Magic as the approved interactive GUI tool for scanning and managing cross-repo junctions.
* **Quality Gates (`WorkspaceQualityGates.psm1`)**: Consolidated readiness assertions into unified, reusable gates executed by `Test-WorkspaceReadiness.ps1`.
* **Dual Governance Flows**: Codified separate control flows for upstream design iteration in `Workspace_AI` vs downstream repository onboarding and version synchronization.

---

### Pre-v1.0 Milestones (Historical Rollup)

* **v0.4.0 (2026-08-12)**: `Workspace_GC` multi-repo consistency sweeps and dry-run observation flow.
* **v0.3.0 (2026-08-01)**: Native PowerShell governance bridge and Markdown-first proposal queues.
* **v0.2.0 (2026-07-31)**: `Workspace_AC` S1/S2 rule atomization and invariant stabilization.
* **v0.1.0 (2026-07-15)**: Post-crash recovery scripts, system state restoration, and package source inventories.

---

## 2. Release Register (CRP-355)

First release of each major version; the cleanup (`LCM_Inventory/tools/Invoke-LcmMajorCleanup.ps1`) reads this table to compute "major M-2 and older". Dates are the first commit of the release (git tags are incomplete).

| Major | First release | Date | Evidence |
|:---|:---|:---|:---|
| 4 | 4.0.0 | 2026-08-13 | tag v4.0.0 (LCM_AI 5576337) |
| 5 | 5.0.0 | 2026-08-20 | tag v5.0.0 (LCM_AI 7d708c1) |
| 6 | 6.1.0 | 2026-08-29 | tag v6.1.0 (LCM_AI ee11ef6); no 6.0.0 tag |
| 7 | 7.0.0 | 2026-08-29 | LCM_AI 70ae8c5 (commit message) |
| 8 | 8.0.0 | 2026-09-26 | LCM_AI 7fcf8e7 (commit message) |
| 9 | - | - | never released |
| 10 | 10.0.0 | 2026-10-13 | LCM_AI c906f06 (commit message); tag v10.0.0 on 2026-10-20 |

---

## 3. Cleanup Runs (in-place log, CRP-355)

Each applied cleanup run appends one block here: run ID, time, current major M, cutoff, per store the deleted period, counts and bytes, the repository SHAs before deletion (retrieval: `git show <sha>:<path>` for tracked files), the protected items kept, and the deleted evidence that was not tracked by git (not recoverable).
