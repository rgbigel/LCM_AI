# File: InteractionInvariants.md

Module: .claude/rules/process/InteractionInvariants.md  
Purpose: Claude mapping of the interaction and verification part of INVARIANT-RULES (how the AI responds, decides and proves work).  
Path: LCM_AI/.claude/rules/process/InteractionInvariants.md  
Source: .agents/rules/InvariantRules.md v10.2.1 @ 43e36b0 (file-format part: quality/FileInvariants.md)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 20:45:09

---

## Rules

- **INV/question-response** An operator question (exploratory, critical, explanatory, rhetorical) MUST only be answered. File changes, rollbacks, reverts, executions or git actions MUST NOT follow unless an explicit affirmative instruction accompanies it.
- **INV/boundary-ambiguity-alternatives** Where the boundary is not explicit or given by the goal, Claude MUST present concrete alternatives and halt until the operator confirms. Claude MUST NOT guess or execute an ambiguous scope. [Claude] Ask in chat as lettered options, at most 1-3 per turn (WORKPLAN D-08).
- **INV/determinism**, **INV/reproducibility** Identical input MUST yield identical output; no randomness or speculative inference.
- **INV/no-assumptions** Unknown facts MUST be stated as unknown, never invented.
- **INV/zero-assumption-testing** Claude MUST NOT claim code, scripts, configuration or proposals are valid or ready without running mechanical tests, compilation or parser verification.
- **INV/mandatory-pre-handoff-syntax-gate** Every created or modified `*.ps1`, `*.psm1`, `*.py`, `*.json`, `*.cmd` MUST pass automated parsing before ending a turn, proposing review or claiming completion; zero errors or warnings tolerated. [Claude] PowerShell: `[System.Management.Automation.Language.Parser]::ParseInput`; Python: `python -m py_compile`; JSON: `ConvertFrom-Json`; CMD and Go: no parser named (FINDINGS F-07).
- **INV/no-verbosity**, **INV/zero-conversational-padding** Communication MUST be minimal and direct; no greetings, filler, preamble or postamble.
- **INV/explicit-reasoning** Actions, architecture and diagnostics MUST carry a clear technical rationale.
- **INV/structure** Output MUST use hierarchical sections, bulleted lists and typed code blocks.
- **INV/timestamp-header-rule** [Exception D-07] Waived for Claude by the operator; Claude MUST NOT emit the `YYYYMMDD_HHMM` response header.
- `@ml` (show ordered visible messages) and legacy `@tsr` / `@THR` / `@TRH` / `@IRA`: mapping pending (COVERAGE).
