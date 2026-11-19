# File: DocumentationStandardsPolicy.md

Module: .claude/rules/quality/DocumentationStandardsPolicy.md  
Purpose: Claude adapter projection of DocumentationStandardsPolicy (tripartite docs, audience scoping, DOX headers, install runbooks, versioning, retention, App slicing, preservation, timestamps, rationale, data design).  
Path: LCM_AI/.claude/rules/quality/DocumentationStandardsPolicy.md  
Source: .agents/rules/DocumentationStandardsPolicy.md v10.3.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-DOC-001** Every governed repo has `docs/Architecture.md` (end-user view, topology, Mermaid, entrypoints), `docs/Requirements.md` (normative constraints, prerequisites, MUST/MUST NOT), `docs/Implementation.md` (modules, cmdlets, signatures, schemas, test traceability).
- **RULE-DOC-002** No conceptual bleed: code paths and signatures only in Implementation; Requirements = what, Implementation = how; top-level `README.md` is the executive summary and index.
- **RULE-DOC-003** General docs begin with the DOX header (`# Title`, Module, Purpose, Path, Authors, Version `M.Y.Z`, Status, Date). Rule files: lines 1-5 YAML frontmatter (`name`, `description`, `globs`), then the DOX header. [Claude] Every file Claude produces carries a DOX header (WORKPLAN D-03). (Rule files deviating: FINDINGS F-33.)
- **RULE-DOC-003.1** Proposal/specification contracts follow GoalFirstDesignPolicy; docs keep traceability to the accepted Gate 0 target; the binding core invariant "Cause no havoc: ask rather than invent or infer, and avoid unnecessary complexity" applies.
- **RULE-DOC-004** Repos that deploy payloads keep `install/Installation.md` (7 phases: prerequisites, layout, preflight, deployment, verification, servicing, rollback/uninstall); complex installs may use numbered sub-documents; no `README.md` in `install/`; foreign repos only as prerequisite assertions.
- **RULE-DOC-005** A new major version (`+1.0.0`) resets minor and patch to 0 for all modules, specs, scripts and manifests (`NewVersion = M.0.0`, e.g. 10.2.5 -> 11.0.0; per RULE-REV-007); release `+0.1.0` keeps the patch level; GoodNight push `+0.0.1` only for changed components. Global baseline references (`.vscode/settings.json`, `.github/agents/Config.json`, agent profiles, DOX headers) point to the active baseline; common governance lives in `.agents/rules/`, subsystem specifics in repository `docs/`.
- **RULE-DOC-006** At major release M flush transient logs, scratch and `Deletions/` older than M-2; never prune permanent evolution history (`{nn}_{Era}-Evolution/`, `{nn}_{Subject}_{MilestoneType}.md`, `Classification: permanent-evolution-history`).
- **RULE-DOC-007** Optional `App: #` slicing with consistent sections across all three docs; split layout `docs/App#<N>-<Slug>/` directly under `docs/`; index table in root Architecture; Constituent Manifest Table per App; `App:` header annotation; `data/catalog/apps.json`; cross-App only via registered contracts (`data/catalog/contracts.json`); submodules are an App form; consolidation only by operator decision.
- **RULE-DOC-008** No spec/architecture document may be replaced, condensed or lose sections without operator approval; outdated content is updated in place with a status line; removals of more than a few lines are proposed first and named in the commit message; superseded content stays reachable.
- **RULE-DOC-009** Zero comment destruction across all file types incl. `*.go`; in-place correction allowed; JSON comment keys preserved; gates (`Test-LCMIncrementalGovernance.ps1`, `LCM_QualityGates.psm1`, `Test-ReviewCommitGate.ps1`) fail on deleted comment lines.
- **RULE-DOC-010** Any create/modify of a governed doc (`*.md`, `*.json`) updates its header `Date:` to the exact current `YYYY-MM-DD HH:mm:ss`; one version increment per commit cycle. (Date format variance: FINDINGS F-35.)
- **RULE-DOC-011** Components changed under a CRP/BUG/FIX record `Implementation Choices (<CRP-ID>):` or `Rationale:` in the header; system/elevation/IPC code documents caveats in `.NOTES`/`Caveats:`; comment-based help stays in sync with signatures; spec decisions are absorbed into the tripartite docs before `COMPLETE`.
- **RULE-DOC-012** Repos with structured persistent databases keep `docs/DataDesign-<Domain>.md` (or `DataDesign.md`): full DDL, types, keys, CHECK/unique/referential constraints, dual-state projection (`*.db` git-ignored, `*.sql` committed), indexes, views, tooling inventory.
