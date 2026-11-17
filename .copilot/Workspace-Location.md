# WORKSPACE-LOCATION-METADATA

> Status 2026-11-16: legacy VS Code Copilot profile (10.2.0); not loaded by Copilot's standard discovery. Authoritative rules: `.agents/rules/` (RULE-AUTH-001); where this file differs from them, the rules win.

# version: 10.2.0
# scope: durable-memory
# location: .copilot/Workspace-Location.md
# update-policy: manual
# FORMAT: ascii-only, technical, deterministic

WORKSPACE-ROOT
- D:\Git_Repositories

COPILOT-DIRECTORY
- path: D:\Git_Repositories\.copilot\
- purpose: legacy Copilot profile files (rule authority: .agents/rules/, RULE-AUTH-001)
- rule: all profile behavior scoped to workspace-root

COPILOT-FILES
- instructions.md
- config.json
- agent.json
- copilot365-agent.json
- MEMORY.md
- macro-definitions.md
- MyTools.md
- InvariantRules.md
- Standards.md
- version-consistency-check.md
- version-bump-procedure.md
- problems.md
- projects.md
- servicing-notes.md

TEST-SUITE
- directory: .copilot/tests\
- file: profile-tests.md

WORKSPACE-RULES
- durable-memory must reside under workspace-root
- variable-memory must reside under workspace-root
- no external paths allowed
- ascii-only filenames
- english-only filenames

VS-CODE-INTEGRATION
- workspace-root must be opened directly in VS Code
- .copilot directory must be at workspace-root level
