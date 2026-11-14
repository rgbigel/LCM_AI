---
name: goodmorning
description: 'Claude''s own session resumption (host good-morning per RULE-LCM-030 (4) and RULE-CTX-006). Reads the continuity layer, checks the rule baseline, reports the gap and attention items, then waits. Never runs the operator-exclusive Invoke-LCM_GoodMorning.ps1.'
disable-model-invocation: true
---
# File: SKILL.md

Module: .claude/skills/goodmorning/SKILL.md  
Purpose: Claude host good-morning (session resumption) per RULE-LCM-030 (4), RULE-CTX-006 and WORKPLAN D-25 / D-27.  
Path: LCM_AI/.claude/skills/goodmorning/SKILL.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:36:18

---

Trigger: the operator types `/goodmorning` or "good morning".

Steps (read-only except step 5):

1. Get the current time with a tool call (`yyyy-MM-dd HH:mm:ss`).
2. Read `D:\Git_Repositories\.agents\ACTIVE_SESSION.md` (workspace state and ALL host blocks), `.agents/ACTIVE_CONTEXT.md`, `.agents/LEARNED_ADVICE.md`, and `LCM_AI/.claude/translation/WORKPLAN.md`.
3. Baseline check (RULE-ANA-000 for the Claude adapter):
   - `git -C D:\Git_Repositories\LCM_AI log -1 --format='%h %ci'` and working-tree status of `.agents/rules`.
   - Compare the SHA-256 of every `.agents/rules/*.md` with `LCM_AI/.claude/translation/CANONICAL_HASHES.md`; list changed files (do not re-map yet).
   - Result: `Check 0: OK` (no changes) or `Check 0: mismatch` (list files; convergence per D-18 / D-22 / D-23 is needed).
4. First reply line, exactly: `Good Morning! Resuming from Good Night at <workspace GoodNight timestamp from ACTIVE_SESSION.md> (Gap: X.X h).` (in `technical` mode: `[GOODMORNING] ...`). Then, briefly:
   - Claude's own last good-night timestamp and next step (from its host block).
   - Other hosts' status, last activity and attention items.
   - Check 0 result.
   - Open operator decisions and stale or contradictory context entries; any LEARNED_ADVICE entry Claude cannot follow, with the reason.
5. Update ONLY the `### Host: Claude Code` block of `.agents/ACTIVE_SESSION.md`: `Status: Active`, `Last Activity: <timestamp>` (keep line endings, UTF-8 without BOM).
6. Do NOT run `Invoke-LCM_GoodMorning.ps1` (operator-exclusive), do not start any other work; end with `Next step: ...` and wait for the operator's direction.
