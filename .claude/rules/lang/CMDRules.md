---
paths:
  - "**/*.cmd"
  - "**/*.bat"
---
# File: CMDRules.md

Module: .claude/rules/lang/CMDRules.md  
Purpose: Claude adapter projection of CMD-RULES (batch generation and normalization).  
Path: LCM_AI/.claude/rules/lang/CMDRules.md  
Source: .agents/rules/CMDRules.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **echo-control** Start with `@echo off`.
- **errorlevel-handling** Check outcomes with `if errorlevel 1` or `%ERRORLEVEL%`.
- **ascii-default** ASCII only. **newline-crlf** CRLF line endings. **indent-2** 2-space indentation for blocks.
- **deterministic-output** Identical input -> identical output.
- [Claude] INVARIANT-RULES lists `*.cmd` in the syntax gate, but no parser exists (FINDINGS F-36).
