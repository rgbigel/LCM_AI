# File: RepositoryContext.md

Module: .claude/rules/process/RepositoryContext.md  
Purpose: Claude mapping of repository context detection, context priming, scan limits, learned advice and session start.  
Path: LCM_AI/.claude/rules/process/RepositoryContext.md  
Source: .agents/rules/RepositoryContextPolicy.md v10.2.0 @ 43e36b0  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 20:45:09

---

## Rules

- **RULE-CTX-001** At interaction start or focus switch, Claude MUST identify the target repository from: (1) the active IDE document, (2) repository paths named in the request, (3) at workspace root, `.agents/ACTIVE_CONTEXT.md`. [Claude] (1) = the `ide_opened_file` / `ide_selection` context when present.
- **RULE-CTX-002** When work on a repository begins, Claude MUST prime context by reading: `<Repo>/LCM_Inventory/config.json`, `<Repo>/README.md`, open proposals in `<Repo>/docs/Proposals/`. If the config is missing, classify the repo as `unonboarded-candidate` and point to `Invoke-LCMOnboardRepo.ps1`; do not run broad scans. (Path exists in no repository: FINDINGS F-10.)
- **RULE-CTX-003** Within an identified repository Claude MUST NOT run workspace-wide recursive discovery (broad Glob/Grep, recursive listing).
- **RULE-CTX-004** Claude MUST keep the LCM triad in view: `LCM_AI` (baselines, templates, quality gates), `LCM_Inventory` (CM engine, audit ledger, CR index), `LCM_Shared` (reusable atoms).
- **RULE-CTX-005** Learned advice:
  1. At session start read `.agents/ACTIVE_CONTEXT.md` and `.agents/LEARNED_ADVICE.md`; **Accepted** entries are binding, **Candidates** are guidance.
  2. New entries go on top of their section.
  3. Entries MUST NOT be removed unless superseded by a cited CRP that made them enforceable.
  4. An ignored entry MUST be named with the reason.
  5. `/learn <text>` adds a candidate via `Save-AllSessionMemory.ps1 -Learn "<text>" -Author Claude`, nothing else; self-proposed candidates MUST be announced.
  6. Candidates MUST be reviewed (`Invoke-LearnedAdviceReview.ps1`) no later than publishing.
  7. `[->rule]` entries are promoted into the matching rule file.
  - [Claude] PENDING Q-04: writing to the shared `.agents` advice store vs. the separate Claude scheme (WORKPLAN D-11). Until answered, Claude reads but does not write `LEARNED_ADVICE.md`.
- **RULE-CTX-006** GoodMorning session start (`Invoke-LCM_GoodMorning.ps1 -Auto`, report attention items first, confirm ACTIVE_CONTEXT/LEARNED_ADVICE, read-only). [Claude] PENDING Q-01 (contradiction C1): Claude MUST NOT run GoodMorning until the operator decides.
