# File: RepositoryContextPolicy.md

Module: .claude/rules/process/RepositoryContextPolicy.md  
Purpose: Claude adapter projection of RepositoryContextPolicy (scope resolution, context priming, scan limits, learned advice, GoodMorning operator exclusivity).  
Path: LCM_AI/.claude/rules/process/RepositoryContextPolicy.md  
Source: .agents/rules/RepositoryContextPolicy.md v10.3.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 + CRP-350 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-17 15:40:19

---

- **RULE-CTX-001** At interaction start or focus switch, identify the target repository from (1) the active IDE document, (2) repository paths in the request, (3) headless/no-IDE fallback: active proposal context (`docs/Proposals/`) or workspace root guided by `.agents/ACTIVE_CONTEXT.md`. [Claude] (1) = `ide_opened_file` / `ide_selection` when attached.
- **RULE-CTX-002** When work on a repository begins, prime context by reading `LCM_Inventory/data/inventory.json` (audited elevation, governance version, classification) and the canonical rules (common governance in `.agents/rules/`, subsystem specifics in the repository's `docs/`), `<Repo>/README.md`, and open proposals in `LCM_Inventory/docs/Proposals/` (RULE-SUB-008). Onboarding (`Invoke-LCMOnboardRepo.ps1`) is planned under CRP-298; unonboarded repos are candidates; no broad scans.
- **RULE-CTX-003** Within an identified repository, no workspace-wide recursive discovery (broad Glob/Grep, recursive listing).
- **RULE-CTX-004** Keep the triad in view: `LCM_AI` (baselines per `.agents/version.json`, templates, quality gates), `LCM_Inventory` (CM engine, audit ledger, CR index), `LCM_Shared` (atoms incl. Python helpers).
- **RULE-CTX-005** Learned advice: read `.agents/ACTIVE_CONTEXT.md` and `.agents/LEARNED_ADVICE.md` at session start; **Accepted** binding, **Candidates** guidance; insert new entries on top; no removal without a cited CRP; name any ignored entry with reason; `/learn <text>` -> `Save-AllSessionMemory.ps1 -Learn "<text>" -Author <AI>` only; announce self-proposed candidates; review candidates (`Invoke-LearnedAdviceReview.ps1`) before publish; promote `[->rule]` entries. All sanctioned AI hosts MAY and SHOULD contribute; authors: operator always first, an AI host adds its name (ahead of another AI host) only if it creates or modifies the candidate. [Claude] Use `-Author Claude`.
- **RULE-CTX-006** `Invoke-LCM_GoodMorning.ps1` is run by the operator or, on explicit operator instruction, by an AI host (RULE-LCM-030 (6), CRP-350); never on the AI's own initiative or as an envelope for baseline or multi-repo research. GoodMorning aggregates session status, gaps, drift and attention items of all registered AI hosts. At session start the AI changes nothing except what RULE-LCM-030 (5) allows: read `.agents/ACTIVE_SESSION.md`, `ACTIVE_CONTEXT.md`, `LEARNED_ADVICE.md`; follow `RULE-LCM-030`; state verification, list attention items or stale entries across all registered hosts, await operator direction. [Claude] Additionally read `.claude/translation/WORKPLAN.md` (CLAUDE.md section 4).
