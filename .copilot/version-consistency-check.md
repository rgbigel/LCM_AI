# VERSION-CONSISTENCY-METADATA

> Status 2026-11-16: legacy VS Code Copilot profile (10.2.0); not loaded by Copilot's standard discovery. Authoritative rules: `.agents/rules/` (RULE-AUTH-001); where this file differs from them, the rules win.

# version: 10.2.0
# scope: durable-memory
# location: .copilot/version-consistency-check.md
# update-policy: manual
# FORMAT: ascii-only, technical, deterministic

CHECK: MAJOR-VERSION
- instructions.md
- config.json
- agent.json
- copilot365-agent.json
- macro-definitions.md
- MyTools.md
EXPECT: identical MAJOR

CHECK: MINOR-VERSION
- durable-memory: may differ
EXPECT: non-breaking differences allowed

CHECK: PATCH-VERSION
- revision-cycle: patch-only increments
EXPECT: patch increments only

CHECK: VARIABLE-MEMORY
- problems.md
- projects.md
- servicing-notes.md
EXPECT: patch-only versioning

CHECK: VERSION-FORMAT
EXPECT: MAJOR.MINOR.PATCH

CHECK: VERSION-ORDER
EXPECT: no skipped numbers
