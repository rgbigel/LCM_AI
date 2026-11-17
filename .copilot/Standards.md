# STANDARDS-METADATA

> Status 2026-11-16: legacy VS Code Copilot profile (10.2.0); not loaded by Copilot's standard discovery. Authoritative rules: `.agents/rules/` (RULE-AUTH-001); where this file differs from them, the rules win.

# version: 10.2.0
# scope: durable-memory
# location: Standards.md
# update-policy: manual
# FORMAT: ascii-only, technical, deterministic

STANDARDS
- naming: ascii-only, deterministic
- structure: sections, lists, code blocks
- documentation: reproducible, rule-driven
- modules: versioned, deterministic headers
- durable-memory: strict versioning required
- variable-memory: patch-only versioning

VERSIONING-STANDARDS
- MAJOR: breaking change, structural change
- MINOR: new feature, new durable-memory file
- PATCH: corrections, additions, revision-cycle
- durable-memory: increment on any change
- variable-memory: increment PATCH only
- version-parity: all control files share MAJOR
- version-format: MAJOR.MINOR.PATCH
