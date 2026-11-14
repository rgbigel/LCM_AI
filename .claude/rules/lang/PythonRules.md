---
paths:
  - "**/*.py"
---
# File: PythonRules.md

Module: .claude/rules/lang/PythonRules.md  
Purpose: Claude adapter projection of PYTHON-RULES (RULE-PY-001..008, linter gates).  
Path: LCM_AI/.claude/rules/lang/PythonRules.md  
Source: .agents/rules/PythonRules.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-PY-001** No `f`-prefix on strings without placeholders (F541).
- **RULE-PY-002** Imports before any use of the imported module.
- **RULE-PY-003** No unused imports (F401). **RULE-PY-004** No unused local variables (F841).
- **RULE-PY-005** Windows CLI scripts call `sys.stdout.reconfigure(encoding='utf-8')` right after `import sys`.
- **RULE-PY-006** No unused exception variable names.
- **RULE-PY-007** Cross-repo paths resolved deterministically relative to `__file__`.
- **RULE-PY-009** 4 spaces per indentation level (PEP 8); takes precedence over the 2-space default (language deference).
- **RULE-PY-008** Generating HTML/JS/CSS/JSON/SQL/shell: double-brace escaping in f-strings, inject data via `json.dumps()`, string concatenation instead of JS template literals, validate emitted output before writing.
- Gates: `flake8` zero `E9,F63,F7,F82,F401,F541,F841`; `py_compile` clean in `Test-RepoReadiness.ps1`. [Claude] Run Python with `-I` when reading untrusted data.