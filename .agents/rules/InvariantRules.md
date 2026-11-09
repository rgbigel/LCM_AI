---
name: InvariantRules
description: Authoritative workspace invariants for determinism, formatting, line endings, encoding, and conciseness.
globs: "*"
---
# File: InvariantRules.md

Module: InvariantRules  
Purpose: Authoritative invariant rules for workspace behavior, encoding, determinism, and generation.  
Path: .agents/rules/InvariantRules.md  
Authors: Rolf  
Version: 10.0.1
Status: Authoritative Invariant Rule  
Date: 2026-11-08 12:22:00

---

## 1. Core Invariant Rules

### INVARIANT-RULES
- **question-response-invariant**: When the operator poses a question, it MUST NOT cause the AI to do anything except answer. An inquiry—whether exploratory, critical, explanatory (e.g. "X does not justify Y"), or rhetorical—is an inquiry for explanation or alignment, NOT a directive to modify files, rollback, revert, or execute mutations. State mutations, code modifications, or git actions MUST ONLY be executed when accompanied by an explicit, affirmative instruction (e.g. "Are you kidding? Fix/correct this like that...!").
- **boundary-ambiguity-alternatives-invariant**: Wherever the boundary is not explicit or given by the goal, present alternatives and WAIT FOR CONFIRMATION. The AI assistant MUST NOT guess, speculate, or unilaterally execute an ambiguous scope; it must formulate concrete alternatives and halt execution completely until the operator confirms the chosen path.
- **determinism**: Identical input $\rightarrow$ identical output.
- **reproducibility**: No randomness or speculative inferences.
- **ascii-default**: ASCII required unless explicit exceptions apply:
  - Markdown (`.md`) files may contain Unicode (arrows, bullets, umlauts, typographic symbols).
  - PowerShell literal strings and comments may contain umlauts.
  - HTML and UI presentation assets (`.html`, `.css`, `.js`) may contain Unicode glyphs and standard UI emojis as defined in DisplayStandardsPolicy.md.
- **no-non-ascii-identifiers**: Identifiers, variables, function names, and file names must be ASCII-only.
- **constant-string-apostrophes**: Use single ASCII apostrophes (`'...'`) for constant strings.
- **indent-2**: Indentation level is exactly 2 spaces (no tabs).
- **newline-crlf**: Windows-native files must end with CRLF.
- **utf8-without-bom**: All text and code files must be saved as UTF-8 without BOM.
- **structure**: Clear hierarchical markdown sections, bulleted lists, and typed code blocks.
- **no-assumptions**: State unknown facts rather than guessing; never invent facts or speculate.
- **zero-assumption-testing**: The AI assistant `MUST NOT` assume or claim that code, scripts, configurations, or proposals are valid, functional, or ready without actively running mechanical tests, compilation, or parser verification. Relying on visual inspection alone or declaring ready without executing test verification is strictly prohibited.
- **mandatory-pre-handoff-syntax-gate**: Every created or modified script, module, or configuration file (`*.ps1`, `*.psm1`, `*.py`, `*.json`, `*.cmd`) `MUST` pass automated syntax parsing or compilation (`ParseInput` for PowerShell, `py_compile` for Python, `ConvertFrom-Json` for JSON) before concluding a turn, proposing review, or claiming completion. Zero syntax errors or parse warnings are tolerated.
- **no-verbosity**: Minimal, direct, and non-repetitive communication; zero conversational padding or pleasantries.
- **zero-conversational-padding**: Prohibit conversational filler, greetings, pleasantries, or preamble/postamble framing.
- **explicit-reasoning**: Provide clear, deterministic technical rationale for all actions, architecture, and diagnostics.
- **english-default-language**: English invariant for all code, comments, documentation, and commit messages.
- **timestamp-header-rule**: Mandatory response output header on every assistant response in the exact format:
  `YYYYMMDD_HHMM "<short-task-description>"`
  Permanent, automated mechanism inherited across all sessions (replaces manual `@tsr` / `@THR` / `@TRH` prompting).
- **tool-and-log-timestamp-precision**: Tool execution timestamps, generated log file names, and internal log entries `MUST` include at least second-level precision (`ss`) (e.g. `yyyyMMdd_HHmmss` or `yyyy-MM-dd HH:mm:ss[.fff]`). The minute-level format (`YYYYMMDD_HHMM`) applies strictly and exclusively to the assistant chat response header, never to tools or logs.
- **comment-preservation**: Comments and documentation are first-class assets equivalent to executable code across ALL file formats (`*.ps1`, `*.psm1`, `*.js`, `*.ts`, `*.py`, `*.json`, `*.md`, `*.html`, `*.css`, `*.cmd`, etc.). No redesign, refactoring, code formatting, auto-repair, or optimization may silently delete, strip, or truncate comments, docstrings, or explanatory remarks. Editing comments to update or correct them is permitted; wholesale stripping or deletion of comments is strictly prohibited. For JSON configurations, comment properties (e.g. `_comment`, `//`, `description`, `notes`) must be preserved across serialization and editing.
- **no-backtick-line-continuations**: Script generation must not use backticks (`` ` ``) for line continuation; use splatting, pipeline wrapping, or parenthesized expressions instead.
- **universal-header-modification-timestamp-invariant**: Under all circumstances, whenever ANY governed file—whether source code (`*.ps1`, `*.psm1`, `*.py`, `*.go`, `*.js`, `*.cmd`, `*.bat`), configuration (`*.json`, `*.yaml`), or documentation (`*.md`, `*.html`)—is created, revised, or modified, any header date/timestamp metadata field (`Date:`, `LastModified:`, `meta.date`, etc.) `MUST` be updated to the exact current timestamp (`YYYY-MM-DD HH:mm:ss` or `YYYY-MM-DD`). Leaving stale timestamps upon modifying any asset is strictly prohibited across the entire workspace.
- **single-commit-version-increment-invariant**: Whenever a component (script, module, document, or configuration file) is modified under a CRP, BUG, or FIX, its version number `MUST` only be incremented **ONCE** across the entire editing cycle leading up to its associated `git commit` (strictly bound to commit, not `push`). Intermediate edits, turns, or iterations prior to committing `MUST NOT` repeatedly increment the version number. A component's version number is incremented again `ONLY IF` that component is modified again in a subsequent, separate commit cycle after a commit has taken place (which must also correspond to an incremented CRP/proposal version).

---

## 2. Activation Commands & Legacy Macro Compatibility

- **Native Rule Inheritance**: Rules in this file are auto-inherited across all agent interactions via `.agents/rules/`.
- `@tsr` / `@THR` / `@TRH` / `@IRA`: Legacy prompt macros for TimestampHeaderRule and InvariantRules. Now superseded by persistent, native rule enforcement.
- `@ml`: Shows ordered visible messages in current chat.



