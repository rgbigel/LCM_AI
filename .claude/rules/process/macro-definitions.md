# File: macro-definitions.md

Module: .claude/rules/process/macro-definitions.md  
Purpose: Claude adapter projection of macro-definitions (operator command words and their governed targets).  
Path: LCM_AI/.claude/rules/process/macro-definitions.md  
Source: .agents/rules/macro-definitions.md v10.3.2 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 + CRP-350 + CRP-346 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.5  
Status: Draft  
Date: 2026-11-18 16:02:15

---

## Convention

- Bare words are the primary syntax; `@` is a backward-compatible alias. [Claude] A macro typed in chat is an operator instruction to run its primary target exactly as listed (via `LCM_Inventory\DoT\do.exe` when `Admin: true`); nothing else. GoodMorning and GoodNight are run by Claude only on explicit operator instruction (CRP-350).
- Precedence: in `technical` mode, ASCII tags `[GOODNIGHT]` / `[GOODMORNING]` replace the protocol emojis of RULE-LCM-030.

## Macros

| Macro (aliases) | Primary target / meaning | Key rules |
|:---|:---|:---|
| `technical` | output mode | no prose, decoration, emojis, unicode; explicit structures |
| `user` | output mode | brief explanations, minimal formatting, concise |
| `S` | system-aligned mode | follow workspace rules, copilot profile, durable memory [Claude: no copilot profile] |
| `profile status` | report | durable memory, test suite, version alignment |
| `GoodMorning` | `LCM_Inventory/tools/Invoke-LCM_GoodMorning.ps1 -Force` | operator, or an AI host on operator instruction (RULE-CTX-006); AI's first reply references the GoodNight timestamp; report attention items; changes only per RULE-LCM-030 (5) |
| `GoodNight [-Push]` (`goodnight`, `SaveAll`) | `LCM_Inventory/tools/Invoke-LCM_GoodNight.ps1 [-Push]` | operator, or an AI host on operator instruction; ends Quiescent (RULE-LCM-030 (6)) |
| `learn <text>` (`/learn`) | `Save-AllSessionMemory.ps1 -Learn "<text>" -Author <AI>` | nothing else; review before push [Claude: allowed, `-Author Claude`] |
| `ToolExplorer` (`tools`, `ToolsExplorer`, `ShowTools`) | `LCM_Inventory/tools/Show-ToolsExplorer.ps1` | served only via `http://127.0.0.1:9876`; params `-Audience -Group -Subsystem -HaSSD06 -Role -Tool -Env -Filter -NoBrowser -NoLaunch -h` |
| `AnalyzeFailures` | `LCM_Inventory/tools/Invoke-FailureModeAnalysis.ps1` | missing anchor is an error; viewer via port 9876 |
| `ShowFailureAnalysis` | `LCM_Inventory/tools/Show-FailureAnalysis.ps1` | opens retained report, no rerun; port 9876 only |
| `set-tool-audience` | ToolExplorer / `Update-ToolCatalog.ps1` | metadata maintained interactively |
| `log` (`logs`, `lastlog`) | `tools/Show-LastLog.ps1 [-ToolName]` | |
| `BCR` (`bcr`) | BCR dispatcher for CRP/BUG, repo, `COH-<prime>` | omitted scope (primary form) resolves the one open cohort, else the implied cohort of `verified` / `in_review` items without confirmation, `in_progress` items named (do / WIP / hold) (CRP-346); only `verified` -> `in_review` after handoff; dispatcher runs `BCR.cmd` (`Invoke-MacriumBcrReview.ps1`); exempt paths peek-only |
| `cohort <create\|add\|remove\|hold\|reopen\|close>` | cohort management | one open cohort; prime member cannot be removed |
| `continue` (`CONTINUE`, `reopen`, `ReOpen`, `resume`) | restore held CRP/BUG/cohort to active flow | restores `resume_state`, clears `held`; `cohort reopen` only when no cohort is open |
| `COMPLETE` (`complete`, `completed`) | review completion + local commit | exact scope or `all`; shows unreviewed live paths; closes BC window; never pushes |
| `FixDocumentation` | `LCM_Inventory/tools/Fix-Documentation.ps1 <scope> [-Apply]` | dry run default; explicit payloads only; BCompare review before commit |
| `PUBLISH` (`publish`, `push`, `PUSH`) | `LCM_Inventory/tools/Invoke-LCM_Push.ps1 -Repositories <repo>` | completed targets only, `LCM_Inventory` ahead |
| Managed `Show*` macros (CRP-280, synced from `config/tool_catalog.json`) | e.g. `ShowCM` -> `Show-LcmControl.ps1`, `ShowDaemon`, `ShowLastLog`, `ShowActions`, `ShowRules`, `ShowRepos`, `ShowToolIntents`, `ShowSupervision`, `ShowPathPS`, ... | IDE-hosted display when supported; external browser only on explicit operator action |
| `ar` (`AR`, `AnalyzeReasoning`) | reasoning/trace analysis | needs a host transcript provider [Claude: none; FINDINGS F-31] |
| `tsr` | permanently retired workspace-wide | superseded by INV timestamp rules and RULE-DOC-010 |
