# File: InvariantRules.md

Module: .claude/rules/quality/InvariantRules.md  
Purpose: Claude adapter projection of INVARIANT-RULES (interaction, verification, encoding, formatting, timestamps, versioning).  
Path: LCM_AI/.claude/rules/quality/InvariantRules.md  
Source: .agents/rules/InvariantRules.md v10.3.1 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 + BUG-365 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.5
Status: Draft  
Date: 2026-11-19 11:44:09

---

## Interaction and Verification

- **question-response-invariant** A question (exploratory, critical, explanatory, rhetorical, or a request phrased as a question such as "Can you fix X?") is only answered: present solution paths, explanations, recommendations; mutations, code changes and git actions only after explicit affirmative confirmation.
- **boundary-ambiguity-alternatives-invariant** Unclear boundary -> present concrete alternatives and halt until confirmed; never guess. [Claude] Lettered options in chat, at most 1-3 per turn (WORKPLAN D-08).
- **determinism**, **reproducibility** Identical input -> identical output; no randomness or speculative inference.
- **no-assumptions** State unknown facts as unknown.
- **zero-assumption-testing** Never claim validity or readiness without mechanical tests, compilation or parsing.
- **mandatory-pre-handoff-syntax-gate** Every created/modified script, module or config passes, before ending a turn, proposing review or claiming completion (zero errors/warnings): `*.ps1`/`*.psm1` `Parser::ParseInput`; `*.psd1` `Import-PowerShellDataFile`; `*.py` `python -m py_compile`; `*.go` `go vet` or `go build`; `*.json` `ConvertFrom-Json`; `*.cmd`/`*.bat` structural encoding, `@echo off`, ASCII; `*.md`/`*.html`/`*.css`/`*.yaml` structure, UTF-8 no BOM, YAML frontmatter.
- **no-verbosity-and-zero-padding** Minimal, direct, non-repetitive; no padding, greetings, pleasantries, preamble/postamble.
- **explicit-reasoning** Clear technical rationale for actions, architecture, diagnostics.
- **structure** Hierarchical sections, bullet lists, typed code blocks.
- **timestamp-header-rule** `YYYYMMDD_HHMM "<task>"` header on every response; `@tsr` retired. Host Exception Provision: Claude Code is exempt by operator waiver (2026-11-13).

## Files

- **ascii-default** ASCII except: Markdown may use Unicode; PowerShell strings/comments may contain umlauts only for proper names, data literals or paths (prose stays English); HTML/CSS/JS may use Unicode glyphs and UI emojis per DisplayStandardsPolicy.
- **no-non-ascii-identifiers** Identifiers, variables, functions, file names ASCII-only.
- **constant-string-apostrophes** Constant strings in single ASCII apostrophes.
- **indent-2** 2 spaces, no tabs, by default; language rule files take precedence (Go: tabs via `gofmt`, GO-2.5; Python: 4 spaces, RULE-PY-009).
- **newline-lf** Text files end with LF; CRLF only for `*.cmd`, `*.bat`, ANSI `*.reg`, VBA exports (`*.bas`, `*.cls`, `*.frm`); excluded: binary/UTF-16 files, live logs, vendor-signed scripts; policy source `LCM_Inventory/tools/Repair-LcmLineEndings.py` (BUG-365). [Claude] The PostToolUse hook `.claude/hooks/invoke_claude_eol_hook.py` applies it after every Write/Edit.
- **utf8-without-bom** All text and code files UTF-8 without BOM.
- **comment-preservation** Comments and docs are first-class; never silently deleted by refactoring, formatting or repair; correcting is allowed; JSON comment properties survive serialization.
- **no-backtick-line-continuations** Use splatting, pipelines or parentheses.
- **english-default-language** English for code, comments, docs, commit messages; governed authoritatively by LanguagePolicy (`RULE-LANG-001..005`).
- **tool-and-log-timestamp-precision** Tool and log timestamps at least to seconds; minute format only for the chat header.
- **universal-header-modification-timestamp-invariant** Creating or modifying any governed file updates its header date field to the current timestamp: `YYYY-MM-DD HH:mm:ss` for specifications/policies, `YYYY-MM-DD` for code/script headers. [Claude] Get the time from a tool call.
- **single-commit-version-increment-invariant** One increment per component per commit cycle (bound to commit, not push). Major `+1.0.0` resets minor and patch for all components (10.2.5 -> 11.0.0); release `+0.1.0` does not reset patch; patch `+0.0.1` on commit only for changed components; clean state required at release, not at GoodNight pushes. (Conflict with RULE-DOC-005: FINDINGS F-18.)
- Legacy macros `@THR`, `@TRH`, `@IRA` superseded; `@tsr` retired; `@ml` shows ordered visible messages.
