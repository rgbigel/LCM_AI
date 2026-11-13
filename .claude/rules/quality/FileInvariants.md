# File: FileInvariants.md

Module: .claude/rules/quality/FileInvariants.md  
Purpose: Claude mapping of the language-neutral file-format invariants (encoding, line endings, ASCII, indentation, language, comments, header date, version increment).  
Path: LCM_AI/.claude/rules/quality/FileInvariants.md  
Source: .agents/rules/InvariantRules.md v10.2.1 @ 43e36b0 (file-format part); .agents/rules/LanguagePolicy.md v10.2.0 @ 43e36b0  
Authors: Rolf, Claude (Anthropic)  
Version: 10.2.5
Status: Draft  
Date: 2026-11-13 20:45:09

---

## Encoding and Layout

- **INV/utf8-without-bom** Every text and code file MUST be UTF-8 without BOM.
- **INV/newline-crlf** Windows-native files MUST use CRLF. [Claude] The Write tool emits LF: after every Write, normalize to CRLF and verify (no BOM, zero LF-only lines). "Windows-native" is undefined (FINDINGS F-04).
- **INV/indent-2** Indentation MUST be exactly 2 spaces, no tabs. (Interaction with Go/Python conventions: FINDINGS F-05, pending lang batch.)
- **INV/ascii-default** Content MUST be ASCII except: Markdown may contain Unicode; PowerShell literal strings and comments may contain umlauts; `.html`/`.css`/`.js` may contain Unicode glyphs and UI emojis per DisplayStandardsPolicy.
- **INV/no-non-ascii-identifiers** Identifiers, variables, functions and file names MUST be ASCII-only.
- **INV/constant-string-apostrophes** Constant strings MUST use single ASCII apostrophes `'...'`.
- **INV/no-backtick-line-continuations** Generated scripts MUST NOT use backtick line continuation; use splatting, pipelines or parentheses.

## Language

- **LANG/english-always** + **INV/english-default-language** Code, comments, docstrings, documentation, file names, proposals and commit messages MUST be English. Exception: explicit localization or translation tasks (LANG/foreign-language-exception).
- **LANG/english-filenames** File and directory names MUST be English and ASCII-only.

## Preservation and Metadata

- **INV/comment-preservation** Comments and documentation are first-class assets in all formats. No refactoring, formatting or repair may silently delete or truncate them; editing to correct is allowed. JSON comment properties (`_comment`, `//`, `description`, `notes`) MUST survive serialization.
- **INV/universal-header-modification-timestamp** On every create or modify of a governed file (code, config, docs), header date fields (`Date:`, `LastModified:`, `meta.date`, ...) MUST be set to the current timestamp (`YYYY-MM-DD HH:mm:ss` or `YYYY-MM-DD`). [Claude] Obtain the time with a tool call; never estimate.
- **INV/single-commit-version-increment** Under a CRP/BUG/FIX a component's version MUST be incremented once per commit cycle, not per edit or turn.
- **INV/tool-and-log-timestamp-precision** Tool timestamps, log file names and log entries MUST have at least second precision.
