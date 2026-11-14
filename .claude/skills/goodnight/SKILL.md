---
name: goodnight
description: 'Claude''s own session close (host good-night per RULE-LCM-030). Updates only the "Host: Claude Code" block of .agents/ACTIVE_SESSION.md and the Claude WORKPLAN. Never runs Antigravity''s Invoke-LCM_GoodNight.ps1, never commits or pushes.'
disable-model-invocation: true
---
# File: SKILL.md

Module: .claude/skills/goodnight/SKILL.md  
Purpose: Claude host good-night (session close) per RULE-LCM-030 (1) and WORKPLAN D-25 / D-26.  
Path: LCM_AI/.claude/skills/goodnight/SKILL.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:33:48

---

Trigger: the operator types `/goodnight` or "good night".

Steps (in this order):

1. Get the current time with a tool call (`yyyy-MM-dd HH:mm:ss`).
2. Update ONLY the `### Host: Claude Code` block of `D:\Git_Repositories\.agents\ACTIVE_SESSION.md`:
   - `Status`: `Quiescent (good-night <timestamp>)`
   - `Last Activity`: the timestamp
   - `Current Task`: one line, what was finished
   - `Next Step`: one line, what the next session starts with
   - `Attention Items`: open operator decisions and pending gates
   - Keep the file's existing line endings and UTF-8 without BOM; do not touch any other host's block.
3. Update `LCM_AI/.claude/translation/WORKPLAN.md` if decisions were taken in this session (new `D-nn` rows, answered questions), then normalize it to CRLF, UTF-8 without BOM.
4. Do NOT run `Invoke-LCM_GoodNight.ps1`, `git commit` or `git push`; Antigravity's GoodNight commits the workspace (CRP-331 SC-5).
5. Reply with: the timestamp, the files written, and a final line `Next step: ...`. After this the Claude side is Quiescent (RULE-LCM-030 (2)): no unprompted messages.
