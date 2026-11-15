<#
.SYNOPSIS
  Claude Code PostToolUse hook: converts the file just written by Write/Edit to CRLF.

.DESCRIPTION
  Module: .claude/hooks/Invoke-ClaudeCrlfHook.ps1
  Purpose: Host-side immediate enforcement of the LCM line-ending invariant (CRP-332) for files Claude writes; the shared
  completion-time enforcement lives in Submit-ReviewResult.ps1.
  Path: LCM_AI/.claude/hooks/Invoke-ClaudeCrlfHook.ps1
  Authors: Rolf, Claude (Anthropic)
  Version: 10.6.4
  Status: Draft
  Date: 2026-11-15

  Reads the hook event JSON from stdin, takes tool_input.file_path and calls Repair-LcmLineEnding
  (LCM_Inventory/modules/LcmLineEndingAtoms.psm1). Non-governed types are skipped by the atom.

.NOTES
  Caveats: Never blocks the tool call: every error is swallowed and the hook exits 0. Registered in
  LCM_AI/.claude/settings.json (PostToolUse, matcher Write|Edit).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
  $toolInput = $payload.PSObject.Properties['tool_input']
  if ($null -eq $toolInput) { exit 0 }
  $pathProperty = $toolInput.Value.PSObject.Properties['file_path']
  if ($null -eq $pathProperty -or [string]::IsNullOrWhiteSpace([string]$pathProperty.Value)) { exit 0 }
  $searchDir = $PSScriptRoot; while ($searchDir -and -not (Test-Path -LiteralPath (Join-Path $searchDir 'LCM_Inventory\modules\LcmLineEndingAtoms.psm1'))) { $searchDir = Split-Path -Path $searchDir -Parent }
  if (-not $searchDir) { exit 0 }
  $modulePath = Join-Path $searchDir 'LCM_Inventory\modules\LcmLineEndingAtoms.psm1'
  Import-Module -Name $modulePath -Force
  $null = Repair-LcmLineEnding -Path ([string]$pathProperty.Value)
} catch {
  exit 0
}
exit 0
