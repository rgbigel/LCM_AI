---
name: PowerShellRules
description: Authoritative governance rule mirror for PowerShellRules
globs: "*"
---
<!-- ===================================================================== -->
<!-- ANTIGRAVITY RULE MIRROR                                               -->
<!-- Source Authority: LCM_AI/.agents/rules/PowerShellRules.md  -->
<!-- Activation: Workspace Automatic                                       -->
<!-- ===================================================================== -->
# File: PowerShellRules.md

Module: PowerShellRules
Purpose: Authoritative rules for PowerShell script generation and normalization.
Path: .agents/rules/PowerShellRules.md
Authors: Rolf
Version: 10.2.1
Changelog:
- 2026-11-06: Added prohibition of implicit confirmation & SupportsShouldProcess over-engineering (RULE-PS-024) mandating bare [CmdletBinding()] and explicit in-code confirmation.
- 2026-11-06: Added null-on-left-in-comparisons invariant (RULE-PS-023) enforcing $null on the left side of equality comparisons ($null -eq / $null -ne) per PSScriptAnalyzer PSPossibleIncorrectComparisonWithNull.
- 2026-10-13: Added no-posix-backslash-escapes invariant (BUG-264) prohibiting POSIX/Bash-style backslash escaping in PowerShell intermediate commands and scripts.
- 2026-10-13: Added mandatory-ast-syntax-gate and zero-assumption-testing invariants to enforce pre-handoff AST validation and prohibit unvalidated completion claims.
- 2026-10-13: Added inline-single-quotes invariant and colon-safe-interpolation rule to eliminate host shell pre-expansion and parsing errors.
- 2026-10-13: Standardized on PS7 (pwsh) runtime exclusively; parity for intermediate code.
- 2026-10-13: Split unified rule file; clarified ASCII constraints; stabilized PS rules.

POWERSHELL-RULES
- ps7-exclusive: pwsh (PS7) is mandatory workspace-wide; legacy powershell.exe (5.1) is forbidden
- intermediate-parity: rules apply equally to permanent scripts and inline pwsh -Command blocks
- inline-single-quotes: inline pwsh -Command blocks MUST use single-quoted script blocks '& { ... }' or here-strings to prevent outer shell variable pre-expansion ($var)
- colon-safe-interpolation: variables followed by colons MUST use explicit braces (${var}:)
- mandatory-ast-syntax-gate: every created or modified *.ps1, *.psm1, *.psd1 MUST undergo explicit AST parser validation ([System.Management.Automation.Language.Parser]::ParseInput) before handoff
- zero-assumption-testing: no tool, script, or proposal may be claimed ready without running either its unit tests or an explicit syntax parse first
- ascii-default: ASCII required; umlauts allowed in literal strings and comments
- utf8-without-bom: scripts must be UTF-8 without BOM
- newline-crlf: scripts must end with CRLF
- no-backticks: forbidden
- no-posix-backslash-escapes: backslash (\) is strictly a filesystem path separator, never an escape character; \$ and \" escaping are forbidden
- null-on-left-in-comparisons: $null MUST always be placed on the left side of equality comparisons ($null -eq $var, $null -ne $var); placing $null on the right ($var -eq $null) is forbidden per RULE-PS-023
- no-implicit-confirmation: custom scripts and functions MUST NOT use SupportsShouldProcess = $true or ConfirmImpact; use bare [CmdletBinding()] and explicit in-code confirmations per RULE-PS-024
- no-interpolated-calls: forbid method calls inside interpolated strings
- assign-$_-first: always assign $_ to a variable before use
- no-non-ascii-identifiers: identifiers must be ASCII-only
- no-hidden-state: forbid hidden pipeline or implicit variable usage
- deterministic-output: identical input → identical output

POWERSHELL-METADATA
- scope: durable-memory
- location: .agents/rules/PowerShellRules.md


