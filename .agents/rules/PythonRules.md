---
name: PythonRules
description: Authoritative workspace rules and invariants for Python scripting, clean formatting, AST compliance, and linter standards.
globs: "*.py"
---
# File: PythonRules.md

Module: PythonRules  
Purpose: Authoritative rule definitions for Python code quality, import ordering, string formatting, and linter compliance.  
Path: .agents/rules/PythonRules.md  
Authors: Rolf, LCM_AI Engine  
Version: 10.2.1  
Status: Authoritative Invariant Rule  
Date: 2026-11-19 12:01:29

---

## 1. Core Python Rules

### PYTHON-RULES
- **no-redundant-fstrings** (`RULE-PY-001` / `F541`): Never use `f"..."` or `f'...'` prefix on strings that contain no variable interpolation or `{...}` placeholder expressions. Use standard string literals `"..."` or `'...'`.
- **explicit-import-order** (`RULE-PY-002`): Ensure all module imports (e.g. `import sys`, `import os`) occur before executing any methods or properties on them (e.g. `sys.stdout.reconfigure()`).
- **clean-unused-imports** (`RULE-PY-003` / `F401`): Never leave unused imported modules or functions in Python source files.
- **clean-unused-variables** (`RULE-PY-004` / `F841`): Avoid assigning local variables that are never read, referenced, or returned.
- **utf8-stdout-reconfigure** (`RULE-PY-005`): In standalone CLI tools and automation scripts targeting Windows environments, always configure `sys.stdout.reconfigure(encoding='utf-8')` immediately following the `import sys` block to prevent Unicode encoding faults.
- **exception-handling-cleanliness** (`RULE-PY-006`): Do not name unused exception variables in catch blocks (use `except Exception:` instead of `except Exception as e:` if `e` is not referenced in the block).
- **cross-repo-path-resolution** (`RULE-PY-007`): Scripts referencing shared modules or sibling repositories must resolve paths deterministically or configure `sys.path` dynamically relative to `__file__`.
- **template-interpolation-safety** (`RULE-PY-008`): When generating or emitting secondary languages (HTML, JavaScript, CSS, JSON, SQL, or shell scripts) from Python:
  1. **Escape & Collision Invariant**: Never mix raw f-strings (`f"""..."""`) with JavaScript or CSS code blocks containing `{...}` or `${...}` without complete double-brace escaping (`{{...}}` and `${{...}}`).
  2. **Safe Serialization**: When injecting Python data into JavaScript or HTML context, always serialize via `json.dumps()` (e.g., `const DATA = {json.dumps(obj)};`) rather than ad-hoc string formatting.
  3. **No Embedded Backtick Ambiguity**: When constructing dynamic paths or strings in generated JavaScript, use standard JavaScript string concatenation (`tabName + '_suffix.html'`) rather than backtick template literals (` `${tabName}_...` `) to avoid escape-stripping defects across string generation pipelines.
  4. **Ahead-of-Occurrence Verification**: Python scripts that generate web artifacts (HTML, JS, JSON) must perform pre-emission syntax validation (e.g. `json.loads()` on JSON payloads, or verifying no unexpanded Python expressions `{...}` remain in the emitted text).
- **python-indentation-standard** (`RULE-PY-009`): All Python source files MUST use 4 spaces per indentation level in accordance with PEP 8. In accordance with the Language Deference Hierarchy (`InvariantRules.md`), this Python language standard takes strict precedence over the workspace-wide 2-space default indentation.
- **interpreter-registry** (`RULE-PY-010`, CRP-366): The executable that runs LCM Python code comes from the registry table `runtimes` in `LCM_Inventory/data/tools/tools.db` (reader `LCM_Inventory/tools/Get-LcmRuntime.py`; PowerShell callers use `Get-LcmRuntimePath` from `LCM_Inventory/modules/LcmRuntimeAtoms.psm1`; DoT trampolines carry the resolved absolute path, written by `Update-ToolCatalog.ps1`). Never launch through a bare `python`, `py`, `python3` or `pyw` (PATH-, launcher- or Store-alias-dependent). Key `python` is the default for tools, gates and trampolines; `python-venv` only where its packages are needed, named explicitly. Bootstrap exceptions: the registry reader itself may be started by any Python; host hook commands (e.g. `.claude/settings.json`) hold the literal registered path. AI ad-hoc work keeps its logic in `.py` files started as `<runtimes.python> -I <script.py> <args>`: no inline `-c` code and no shell logic around the call.

---

## 2. Linter & Quality Verification
- All Python source files must pass `flake8` checks with zero `E9,F63,F7,F82,F401,F541,F841` violations.
- All Python files must compile cleanly with `py_compile.compile()` during repository readiness checks (`Test-RepoReadiness.ps1`).


