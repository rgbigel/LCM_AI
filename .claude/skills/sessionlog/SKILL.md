---
name: sessionlog
description: Analyze a Claude Code session with the shared LCM failure analysis (AnalyzeFailures / ShowFailureAnalysis); operator types /sessionlog [-Number n | -From "text"] [-Session <id>].
---
# File: SKILL.md

Module: .claude/skills/sessionlog/SKILL.md  
Purpose: Claude host session analysis: convert the Claude transcript to normalized events and run the shared LCM session failure analysis and viewer, symmetric to Antigravity.  
Path: LCM_AI/.claude/skills/sessionlog/SKILL.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-15 15:37:04

---

Trigger: the operator types `/sessionlog`, optionally with `-Number <n>`, `-From "<literal user text>"` or `-Session <session id>`.

Steps:

1. Convert: `pwsh -NoProfile -File D:\Git_Repositories\LCM_AI\.claude\tools\ConvertTo-LcmTranscript.ps1` (add `-SessionPath C:\Users\<user>\.claude\projects\d--Git-Repositories\<id>.jsonl` when `-Session` is given; default = current session). The last output line is the event file path.
2. Analyze and show: `pwsh -NoProfile -File D:\Git_Repositories\LCM_Inventory\tools\Invoke-FailureModeAnalysis.ps1 -TranscriptPath <event file> -OutputDirectory D:\Git_Repositories\LCM_Inventory\data\artifacts\claude-transcripts` plus `-Number` / `-From` exactly as given. Without a selector the analyzer anchors on the last item reference. The analyzer opens the viewer itself (ShowFailureAnalysis, port 9876); do not pass `-NoLaunch`.
3. Reply in chat with one line: findings count, unresolved count, report path. No report content in chat.
4. If an anchor is missing, the analyzer stops: report that in one line and ask for `-Number` or `-From`; no retry cascade.
