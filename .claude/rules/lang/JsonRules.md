---
paths:
  - "**/*.json"
---
# File: JsonRules.md

Module: .claude/rules/lang/JsonRules.md  
Purpose: Claude adapter projection of JSON-RULES (serialization, schema, encoding, formatting).  
Path: LCM_AI/.claude/rules/lang/JsonRules.md  
Source: .agents/rules/JsonRules.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **utf8-without-bom**, **newline-crlf**, **indent-2** (2-space, e.g. `ConvertTo-Json -Depth 5`).
- **schema-declaration** Data files should declare `$schema` when applicable.
- **ascii-default** ASCII keys/identifiers; UTF-8 string values allowed.
- **deterministic-output** Key-ordered serialization (`[ordered]@{}`).
- **comment-preservation** `_comment`, `//`, `description`, `notes` survive every parse/serialize.
- Syntax gate: `ConvertFrom-Json`. [Claude] Never hand-edit mechanical JSON artifacts (RULE-EFF-003). JSON data files being replaced by SQLite tables (`proposals.json`, `tool_catalog.json`) are fallback only; never rely on them (operator 2026-11-14).
