---
paths:
  - "**/*.ps1"
  - "**/*.psm1"
  - "**/*.psd1"
---
# File: PowerShellStandardsPolicy.md

Module: .claude/rules/lang/PowerShellStandardsPolicy.md  
Purpose: Claude adapter projection of PowerShellStandardsPolicy (RULE-PS-001..025).  
Path: LCM_AI/.claude/rules/lang/PowerShellStandardsPolicy.md  
Source: .agents/rules/PowerShellStandardsPolicy.md v10.3.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-PS-001** Wrap anything that may be `$null`/scalar/array in `@(...)` before `.Count`, indexing or iteration (StrictMode).
- **RULE-PS-002** Exported functions use approved verbs (`Get-Verb`); legacy names only as `Set-Alias` + `Export-ModuleMember -Alias`.
- **RULE-PS-003** A variable followed by `:` in a double-quoted string or inline command uses `${var}:`, `$($var):`, concatenation or `-f`; linter pattern `\$[a-zA-Z0-9_]+:(?!\/\/|[a-zA-Z])`.
- **RULE-PS-004** Pester v5 hyphenated assertions only (`Should -Be`).
- **RULE-PS-005** Production scripts/modules start with `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'`.
- **RULE-PS-006** Assign `$_` to a named variable in complex pipelines; library functions suppress unneeded output (`$null =`, `[void]`, `| Out-Null`); CLI/user scripts exempt for intended output; ASCII identifiers.
- **RULE-PS-007** Admin-asserting tests check elevation in `BeforeAll`, skip or restrict to AST/schema checks when unprivileged (live runs via `Invoke-ElevatedTest.ps1`); `BeforeAll`/`AfterAll` only inside `Describe`/`Context`.
- **RULE-PS-008** Header fields Module, Purpose, Path, Authors, Version, Date in the canonical comment-based help block (`.SYNOPSIS`, `.DESCRIPTION` with `Implementation Choices (<CRP-ID>)`, `.NOTES` Caveats); update Date on every modification; one version increment per commit cycle.
- **RULE-PS-009** Mutating/diagnostic tools log to `<ToolName>-yyyyMMdd_HHmmss.log` in repo `logs/` or `LCM_Inventory/data/logs/lcm/` (fallback `$env:TEMP/lcm/logs/`), second precision, levels `[INFO] [WARN] [ERROR] [DEBUG] [ACTION] [SUMMARY]`, `[SUMMARY]` footer (tool, version, status, log path, timestamp), support `-ShowAll`/`-Detailed`.
- **RULE-PS-010** Standalone scripts declare `[Alias('h','?')][switch]$Help`, print full help and exit without mutation; declare admin dependencies (RULE-ELEV-007).
- **RULE-PS-011** GUI/browser/editor/explorer/console launches route through the DO gateway (`LCM_Inventory\DoT\do.exe "<command>"`, `-elevated` for admin) to the Session 1 daemon on port 9876, else `Start-Process`; never in-process `Start-Process -Verb RunAs`.
- **RULE-PS-012** No bare `(if ...)` in arguments: pre-assign, `$(if ...)`, or ternary.
- **RULE-PS-013** `Import-Module -Name <path>`, never `-LiteralPath`.
- **RULE-PS-014** NTFS permissions via inheritance on parent nodes; targeted `icacls`/`takeown` only where inheritance is broken, DENY exists, or `/L` is needed; no whole-volume recursion.
- **RULE-PS-015** Never `"$var:"`; brace-delimit, use `-f`, and use `$($obj.Prop)` for property access.
- **RULE-PS-016** Inline/intermediate `pwsh -Command` multi-line or path-bearing code in single-quoted here-strings `@' ... '@`.
- **RULE-PS-017** Read shared/synced files with `FileShare.ReadWrite`; write via `.tmp` + atomic move with >= 3 backoff retries.
- **RULE-PS-018** Delete junctions/links only after reparse check via `.Delete()`, LSE or `cmd /c rmdir`; never naive `Remove-Item -Recurse -Force`.
- **RULE-PS-019** PS-001..018 apply equally to inline code; `pwsh` 7 only, never `powershell.exe`; PS7 operators preferred. [Claude] Applies to every command Claude sends through its PowerShell tool.
- **RULE-PS-020** Dot-source class definition files before AST validation of scripts using custom types.
- **RULE-PS-021** Every created/modified `*.ps1`/`*.psm1`/`*.psd1`/test file passes `[System.Management.Automation.Language.Parser]::ParseInput()` with zero errors before handoff; no readiness claim without tests or parse.
- **RULE-PS-022** Never POSIX backslash escapes (`\$`, `\"`, `\n`); use single quotes, here-strings, `-f` or concatenation; `\$[a-zA-Z0-9_]`, `\$PSItem`, `\$_` fail gates.
- **RULE-PS-023** `$null` always on the left of `-eq`/`-ne`.
- **RULE-PS-024** Bare `[CmdletBinding()]`; no `SupportsShouldProcess`/`ConfirmImpact`; explicit logged in-code confirmation; remove lingering declarations when editing.
- **RULE-PS-025** Model-Atom-Controller: Models (`*State.psm1`, `*Data.psm1`) persistence only; Atoms (`*Atoms.psm1`, `LCM_Shared/`) pure/idempotent, unit-testable; Controllers (`Invoke-*.ps1`, `Show-*.ps1`) orchestrate only; files over 500 lines externalize blocks into atoms; every new/refactored atom module gets `tests/*Atoms.Tests.ps1` (Pester v5).
