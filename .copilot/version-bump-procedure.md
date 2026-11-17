# VERSION-BUMP-METADATA

> Status 2026-11-16: legacy VS Code Copilot profile (10.2.0); not loaded by Copilot's standard discovery. Authoritative rules: `.agents/rules/` (RULE-AUTH-001); where this file differs from them, the rules win.

# version: 10.2.0
# scope: durable-memory
# location: .copilot/version-bump-procedure.md
# update-policy: manual
# FORMAT: ascii-only, technical, deterministic

BUMP-MAJOR
- condition: breaking structural change
- effect: MAJOR+1, MINOR=0, PATCH=0

BUMP-MINOR
- condition: new non-breaking feature
- condition: new durable-memory file
- effect: MINOR+1, PATCH kept (RULE-REV-007)

BUMP-PATCH
- condition: revision-cycle
- condition: corrections
- condition: metadata updates
- effect: PATCH+1

REVISION-CYCLE
- rule: patch-only increments
- rule: no MAJOR or MINOR changes

DURABLE-MEMORY
- rule: increment version on any change
- rule: maintain MAJOR parity with instructions.md

VARIABLE-MEMORY
- rule: patch-only increments
