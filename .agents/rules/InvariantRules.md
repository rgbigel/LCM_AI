---
name: InvariantRules
description: Authoritative workspace invariants for determinism, formatting, line endings, encoding, and conciseness.
globs: "*"
---
# File: InvariantRules.md

Module: InvariantRules  
Purpose: Authoritative invariant rules for workspace behavior, encoding, determinism, language deference, and generation.  
Path: .agents/rules/InvariantRules.md  
Authors: Rolf  
Version: 10.3.1
Status: Authoritative Invariant Rule  
Date: 2026-11-19 11:44:09

---

## 1. Core Invariant Rules

### INVARIANT-RULES
- **question-response-invariant**: When the operator poses a question, it MUST NOT cause the AI to do anything except answer. An inquiry—whether exploratory, critical, explanatory (e.g. "X does not justify Y"), rhetorical, or phrased as a question (e.g. "Can you fix X?", "Should we scan Y first?")—is an inquiry for explanation, diagnostic evaluation, or alignment, NOT a directive to modify files, rollback, revert, or execute workspace mutations. The AI assistant must present clear solution paths, technical explanations, and recommendations, but state mutations, code modifications, and git actions MUST ONLY be executed when accompanied by an explicit, affirmative confirmation or directive.
- **boundary-ambiguity-alternatives-invariant**: Wherever the boundary is not explicit or given by the goal, present alternatives and WAIT FOR CONFIRMATION. The AI assistant MUST NOT guess, speculate, or unilaterally execute an ambiguous scope; it must formulate concrete alternatives and halt execution completely until the operator confirms the chosen path.
- **determinism**: Identical input $\rightarrow$ identical output.
- **reproducibility**: No randomness or speculative inferences.
- **ascii-default**: ASCII required unless explicit exceptions apply:
  - Markdown (`.md`) files may contain Unicode (arrows, bullets, umlauts, typographic symbols).
  - PowerShell literal strings and comments may contain umlauts (strictly for proper names, data literals, or file paths; prose comments remain English).
  - HTML and UI presentation assets (`.html`, `.css`, `.js`) may contain Unicode glyphs and standard UI emojis as defined in DisplayStandardsPolicy.md.
- **no-non-ascii-identifiers**: Identifiers, variables, function names, and file names must be ASCII-only.
- **constant-string-apostrophes**: Use single ASCII apostrophes (`'...'`) for constant strings.
- **indent-2**: Indentation level is exactly 2 spaces (no tabs) by default. **Language Deference**: Generic indentation defaults yield unconditionally to language-specific rule files (e.g. `GoRules.md` mandates hard tabs per `gofmt`; `PythonRules.md` mandates 4 spaces per PEP 8). Any language may define its own authoritative indentation standard in its dedicated rule file.
- **newline-lf**: Text files end with LF. CRLF only for types whose Windows-native consumer mis-parses LF: `*.cmd`, `*.bat`, ANSI `*.reg` and VBA exports (`*.bas`, `*.cls`, `*.frm`). Excluded: binary and UTF-16 files, live logs (`*.log`, `*.jsonl`) and vendor-signed scripts. Policy source: `LCM_Inventory/tools/Repair-LcmLineEndings.py`; enforced by the same table in every repository `.gitattributes`, VS Code `files.eol` and review completion (operator Option B 2026-11-16, BUG-365).
- **utf8-without-bom**: All text and code files must be saved as UTF-8 without BOM.
- **structure**: Clear hierarchical markdown sections, bulleted lists, and typed code blocks.
- **no-assumptions**: State unknown facts rather than guessing; never invent facts or speculate.
- **zero-assumption-testing**: The AI assistant `MUST NOT` assume or claim that code, scripts, configurations, or proposals are valid, functional, or ready without actively running mechanical tests, compilation, or parser verification. Relying on visual inspection alone or declaring ready without executing test verification is strictly prohibited.
- **mandatory-pre-handoff-syntax-gate**: Every created or modified script, module, or configuration file MUST pass automated syntax parsing, type checking, or compilation before concluding a turn, proposing review, or claiming completion:
  - PowerShell (`*.ps1`, `*.psm1`): `[System.Management.Automation.Language.Parser]::ParseInput`
  - PowerShell Data (`*.psd1`): `Import-PowerShellDataFile`
  - Python (`*.py`): `python -m py_compile`
  - Go (`*.go`): `go vet` or `go build`
  - JSON (`*.json`): `ConvertFrom-Json`
  - Windows CMD / Batch (`*.cmd`, `*.bat`): Structural encoding, `@echo off`, and ASCII verification.
  - Markup & Documentation (`*.md`, `*.html`, `*.css`, `*.yaml`): Structure, UTF-8 No-BOM encoding, and YAML frontmatter validation.
  Zero syntax errors or parse warnings are tolerated.
- **no-verbosity-and-zero-padding**: Minimal, direct, and non-repetitive communication; zero conversational padding, greetings, pleasantries, or preamble/postamble framing.
- **explicit-reasoning**: Provide clear, deterministic technical rationale for all actions, architecture, and diagnostics.
- **english-default-language**: English invariant for all code, comments, documentation, and commit messages (governed authoritatively by [`LanguagePolicy.md`](file:///d:/Git_Repositories/.agents/rules/LanguagePolicy.md)).
- **timestamp-header-rule**: Mandatory response output header on every assistant response in the exact format:
  `YYYYMMDD_HHMM "<short-task-description>"`
  Permanent, automated mechanism inherited across all sessions. **Macro Retirement**: Legacy `@tsr` is permanently dropped and retired across all platforms and host adapters. **Host Exception Provision**: Claude Code operates under an explicit operator waiver (2026-11-13 decision) exempting its responses from emitting this chat header. Datetime format and precision invariants remain strictly enforced.
- **tool-and-log-timestamp-precision**: Tool execution timestamps, generated log file names, and internal log entries `MUST` include at least second-level precision (`ss`) (e.g. `yyyyMMdd_HHmmss` or `yyyy-MM-dd HH:mm:ss[.fff]`). The minute-level format (`YYYYMMDD_HHMM`) applies strictly and exclusively to the assistant chat response header, never to tools or logs.
- **comment-preservation**: Comments and documentation are first-class assets equivalent to executable code across ALL file formats (`*.ps1`, `*.psm1`, `*.js`, `*.ts`, `*.py`, `*.json`, `*.md`, `*.html`, `*.css`, `*.cmd`, etc.). No redesign, refactoring, code formatting, auto-repair, or optimization may silently delete, strip, or truncate comments, docstrings, or explanatory remarks. Editing comments to update or correct them is permitted; wholesale stripping or deletion of comments is strictly prohibited. For JSON configurations, comment properties (e.g. `_comment`, `//`, `description`, `notes`) must be preserved across serialization and editing.
- **no-backtick-line-continuations**: Script generation must not use backticks (`` ` ``) for line continuation; use splatting, pipeline wrapping, or parenthesized expressions instead.
- **universal-header-modification-timestamp-invariant**: Under all circumstances, whenever ANY governed file—whether source code (`*.ps1`, `*.psm1`, `*.py`, `*.go`, `*.js`, `*.cmd`, `*.bat`), configuration (`*.json`, `*.yaml`), or documentation (`*.md`, `*.html`)—is created, revised, or modified, any header date/timestamp metadata field (`Date:`, `LastModified:`, `meta.date`, etc.) `MUST` be updated to the current date or timestamp (`YYYY-MM-DD HH:mm:ss` for specifications/policies, `YYYY-MM-DD` for code/script headers). Leaving stale timestamps upon modifying any asset is strictly prohibited across the entire workspace.
- **single-commit-version-increment-invariant**: Whenever a component (script, module, document, or configuration file) is modified under a CRP, BUG, or FIX, its version number `MUST` only be incremented **ONCE** across the entire editing cycle leading up to its associated `git commit` (strictly bound to commit, not `push`). Intermediate edits, turns, or iterations prior to committing `MUST NOT` repeatedly increment the version number. Standard SemVer arithmetic applies:
  - Version Bump (Major: `+1.0.0`): Resets the second and third digits to `0` across all repository components (e.g. `10.2.5` → `11.0.0`).
  - Release Bump (Minor: `+0.1.0`): Applied at formal release boundaries. Release rules **DO NOT** reset the patch digit to `0`; the last digit follows component change state only.
  - GoodNight Push / Commit (Patch: `+0.0.1`): Applied on commit completion strictly for components that physically changed; unchanged components keep their existing patch digit. Clean state is required at release, not at GoodNight pushes.

---

## 2. Activation Commands & Legacy Macro Compatibility

- **Native Rule Inheritance**: Rules in this file are auto-inherited across all agent interactions via `.agents/rules/`.
- `@THR` / `@TRH` / `@IRA`: Legacy prompt macros for TimestampHeaderRule and InvariantRules (superseded by native rule enforcement). `@tsr` is permanently dropped and retired.
- `@ml`: Shows ordered visible messages in current chat.



