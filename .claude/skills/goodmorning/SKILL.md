---
name: goodmorning
description: 'Claude''s own session resumption (host good-morning per RULE-LCM-030 (4)-(6) and RULE-CTX-006). Runs Invoke-LCM_GoodMorning.ps1 -Force -NoBaseline on the operator''s /goodmorning, reads the continuity layer, checks the rule baseline, reports gaps and attention items, then waits.'
---
# File: SKILL.md

Module: .claude/skills/goodmorning/SKILL.md  
Purpose: Claude host good-morning (session resumption) per RULE-LCM-030 (4)-(6), RULE-CTX-006 and WORKPLAN D-27 / D-37.  
Path: LCM_AI/.claude/skills/goodmorning/SKILL.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.7.4  
Status: Draft  
Date: 2026-11-17 15:40:19

---

Trigger: the operator types `/goodmorning` or "good morning" (this is the explicit operator instruction RULE-CTX-006 requires).

Steps:

1. Run `pwsh -NoProfile -File D:\Git_Repositories\LCM_Inventory\tools\Invoke-LCM_GoodMorning.ps1 -Force -NoBaseline`. It reports the workspace GoodNight (section 1 `GoodNight Timestamp`), the workspace gap, every host block with its own gap, the DO front-end (and starts it when it does not answer), work in between, versions, context and learned advice. It records `Status: Active (...)` and `Resumption Timestamp` in section 1. Exit code 3 = attention items to report. Use `-NoBaseline` unless the operator asks for the Macrium baseline preparation.
2. Read `D:\Git_Repositories\.agents\ACTIVE_SESSION.md`, `.agents/ACTIVE_CONTEXT.md`, `.agents/LEARNED_ADVICE.md` and `LCM_AI/.claude/translation/WORKPLAN.md`.
3. Baseline check (RULE-ANA-000 for the Claude adapter):
   - `git -C D:\Git_Repositories\LCM_AI log -1 --format='%h %ci'` and working-tree status of `.agents/rules`.
   - Compare the SHA-256 (first 16 hex) of every `.agents/rules/*.md` with `LCM_AI/.claude/translation/CANONICAL_HASHES.md`; list changed files (do not re-map yet).
   - Result: `Check 0: OK` or `Check 0: mismatch` (list files; convergence per D-18 / D-22 / D-23 is needed).
4. First reply line, exactly: `Good Morning! Resuming from Good Night at <section 1 GoodNight Timestamp> (Gap: X.X h).` (in `technical` mode: `[GOODMORNING] ...`). Then, briefly:
   - Claude's own last close (`Closed (<ts>)` in its block) and next step, reported separately from the workspace GoodNight.
   - Other hosts' status, last activity, host gap and attention items; schema findings from the script.
   - DO front-end state, Check 0 result.
   - Open operator decisions and stale or contradictory context entries; any LEARNED_ADVICE entry Claude cannot follow, with the reason.
5. Update ONLY the `### Host: Claude Code` block: `Status: Active`, `Session ID`, `Last Activity: <timestamp>` (UTF-8 without BOM, keep line endings).
6. Start no other work; end with `Next step: ...` and wait for the operator's direction.
