---
name: goodnight
description: 'Claude''s own session close (host close per RULE-LCM-030 (5)). Updates only the "Host: Claude Code" block of .agents/ACTIVE_SESSION.md and the Claude WORKPLAN; runs the workspace GoodNight (Invoke-LCM_GoodNight.ps1 [-Push]) only when the operator asks for it.'
disable-model-invocation: true
---
# File: SKILL.md

Module: .claude/skills/goodnight/SKILL.md  
Purpose: Claude host close per RULE-LCM-030 (1), (5), (6) and WORKPLAN D-26 / D-37.  
Path: LCM_AI/.claude/skills/goodnight/SKILL.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.7.4  
Status: Draft  
Date: 2026-11-17 15:40:19

---

Trigger: the operator types `/goodnight` or "good night". The workspace GoodNight (step 4) runs only when the operator asks for it in the same instruction (e.g. `/goodnight GoodNight -Push`, "good night, run GoodNight").

Steps (in this order):

1. Get the current time with a tool call (`yyyy-MM-dd HH:mm:ss`).
2. Update ONLY the `### Host: Claude Code` block of `D:\Git_Repositories\.agents\ACTIVE_SESSION.md`, with the full field list of RULE-LCM-030 (5):
   - `Status`: `Closed (<timestamp>)` (never `Quiescent` or `good-night`)
   - `Session ID`, `Last Activity`: the timestamp
   - `Current Task`: what was finished
   - `Next Step`: what the next session starts with
   - `Open Operator Decisions`, `Attention Items`
   - Keep the file's line endings and UTF-8 without BOM; do not touch section 1 or another host's block.
3. Update `LCM_AI/.claude/translation/WORKPLAN.md` if decisions were taken in this session (new `D-nn` rows, answered questions).
4. Only on operator request: run `pwsh -NoProfile -File D:\Git_Repositories\LCM_Inventory\tools\Invoke-LCM_GoodNight.ps1` (with `-Push` if asked). It records the workspace GoodNight in section 1; its review, commit and push gates apply unchanged. Never raw `git commit` / `git push`.
5. Reply with: the timestamp, the files written, the GoodNight result if run (its final line `Good Night completed at <ts>. Session is Quiescent.`), and a final line `Next step: ...`. After a workspace GoodNight the workspace is Quiescent (RULE-LCM-030 (2)): no unprompted messages.
