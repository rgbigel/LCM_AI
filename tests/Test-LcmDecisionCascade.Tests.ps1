<#
.SYNOPSIS
  Unit and integration test suite for the Multi-Stage System-1 Decision Cascade (CRP-252).
.DESCRIPTION
  Module: tests/Test-LcmDecisionCascade.Tests.ps1
  Purpose: Verifies AST syntax, Stage 0 deterministic pre-gate rules, Stage 1 decider
           unconfigured/offline contracts, Stage 2 fallback execution, and Orchestrator
           end-to-end delegation per CRP-252 invariants.
  Path: LCM_AI/tests/Test-LcmDecisionCascade.Tests.ps1
  Authors: rgbig, LCM_AI Engine
  Version: 10.2.1
  Date: 2026-11-12 08:50:00
#>

[CmdletBinding()]
param(
  [Alias('h', '?')]
  [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path $PSScriptRoot -Parent
$toolsDir = Join-Path $scriptDir 'tools'
$passedCount = 0
$failedCount = 0

function Assert-Test([string]$Name, [bool]$Condition, [string]$FailureMessage = '') {
  if ($Condition) {
    Write-Host "  [OK] $Name" -ForegroundColor Green
    $script:passedCount++
  } else {
    Write-Host "  [FAIL] ${Name}: $FailureMessage" -ForegroundColor Red
    $script:failedCount++
  }
}

Write-Host '==========================================================================' -ForegroundColor Cyan
Write-Host ' MULTI-STAGE SYSTEM-1 DECISION CASCADE TEST SUITE (CRP-252)' -ForegroundColor Green
Write-Host '==========================================================================' -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. AST Syntax Gate
# ------------------------------------------------------------------------------
Write-Host "`n[1/5] Validating PowerShell AST Syntax across Stage 0-2 scripts..." -ForegroundColor Cyan
$scriptsToTest = @(
  'Test-LcmDeterministicGate.ps1',
  'Invoke-LcmSystemOneClient.ps1',
  'Invoke-LcmStageTwoFallback.ps1',
  'Invoke-LcmDecisionGate.ps1'
)

foreach ($s in $scriptsToTest) {
  $filePath = Join-Path $toolsDir $s
  $tokens = $null; $errors = $null
  $null = [System.Management.Automation.Language.Parser]::ParseFile($filePath, [ref]$tokens, [ref]$errors)
  Assert-Test -Name "AST Parse: $s" -Condition ($errors.Count -eq 0) -FailureMessage $(if ($errors.Count -gt 0) { $errors[0].Message } else { '' })
}

# ------------------------------------------------------------------------------
# 2. Stage 0 - Deterministic Pre-Gate Tests
# ------------------------------------------------------------------------------
Write-Host "`n[2/5] Testing Stage 0 Deterministic Pre-Gate..." -ForegroundColor Cyan
$stage0Script = Join-Path $toolsDir 'Test-LcmDeterministicGate.ps1'

# Test 2.1: Valid specification file
$validSpec = 'D:\Git_Repositories\LCM_Inventory\docs\Proposals\CRP-317-Eliminate-Git-Root-Escape-Fallback-Logic-for-Multi\Specification.md'
$s0Valid = & $stage0Script -ProposalPath $validSpec
Assert-Test -Name 'Stage 0 accepts valid specification' -Condition ($s0Valid.Passed -eq $true -and $s0Valid.ProposalId -eq 'CRP-317')

# Test 2.2: Non-existent file rejection
$s0Missing = & $stage0Script -ProposalPath 'D:\NonExistent\Spec.md'
Assert-Test -Name 'Stage 0 rejects missing file' -Condition ($s0Missing.Passed -eq $false -and $s0Missing.Errors.Count -gt 0)

# Test 2.3: Non-YAML markdown file rejection
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -LiteralPath $tempFile -Value '# Some random markdown without frontmatter'
$s0Invalid = & $stage0Script -ProposalPath $tempFile
Remove-Item -LiteralPath $tempFile -Force
Assert-Test -Name 'Stage 0 rejects missing frontmatter' -Condition ($s0Invalid.Passed -eq $false)

# ------------------------------------------------------------------------------
# 3. Stage 1 - System-1 Decider Client Tests
# ------------------------------------------------------------------------------
Write-Host "`n[3/5] Testing Stage 1 Decider Client..." -ForegroundColor Cyan
$stage1Script = Join-Path $toolsDir 'Invoke-LcmSystemOneClient.ps1'

# Test 3.1: Unconfigured URL returns Unconfigured and requires fallback
$s1Unconfigured = & $stage1Script -DeciderUrl ''
Assert-Test -Name 'Stage 1 handles unconfigured endpoint' -Condition ($s1Unconfigured.Availability -eq 'Unconfigured' -and $s1Unconfigured.RequiresFallback -eq $true)

# Test 3.2: Offline / unreachable endpoint within timeout
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$s1Offline = & $stage1Script -DeciderUrl 'http://127.0.0.1:19999' -TimeoutMs 500
$stopwatch.Stop()
Assert-Test -Name 'Stage 1 handles offline endpoint' -Condition ($s1Offline.Availability -eq 'Offline' -and $s1Offline.RequiresFallback -eq $true)
Assert-Test -Name 'Stage 1 respects strict timeout <= 1500ms' -Condition ($stopwatch.ElapsedMilliseconds -le 1500)

# ------------------------------------------------------------------------------
# 4. Stage 2 - System-2 Fallback Adapter Tests
# ------------------------------------------------------------------------------
Write-Host "`n[4/5] Testing Stage 2 Fallback Adapter..." -ForegroundColor Cyan
$stage2Script = Join-Path $toolsDir 'Invoke-LcmStageTwoFallback.ps1'

$s2Result = & $stage2Script -RepositoryPath 'D:\Git_Repositories\LCM_AI'
Assert-Test -Name 'Stage 2 returns valid structured contract' -Condition ($s2Result.Confidence -eq 1.0 -and -not [string]::IsNullOrWhiteSpace($s2Result.Decision))

# ------------------------------------------------------------------------------
# 5. Orchestrator Façade End-to-End Tests
# ------------------------------------------------------------------------------
Write-Host "`n[5/5] Testing Orchestrator Façade (Invoke-LcmDecisionGate)..." -ForegroundColor Cyan
$orchestratorScript = Join-Path $toolsDir 'Invoke-LcmDecisionGate.ps1'

# Test 5.1: Graceful fallback when decider unconfigured
$orchFallback = & $orchestratorScript -ProposalPath $validSpec -ForceFallback
Assert-Test -Name 'Orchestrator executes Stage2_Fallback cleanly' -Condition ($orchFallback.ExecutionPath -eq 'Stage2_Fallback')

# Test 5.2: Stage 0 deterministic failure halts before Stage 1/2
$orchInvalid = & $orchestratorScript -ProposalPath 'D:\NonExistent\Missing.md'
Assert-Test -Name 'Orchestrator halts at Stage 0 on structural failure' -Condition ($orchInvalid.ExecutionPath -eq 'Stage0_Deterministic' -and $orchInvalid.Status -eq 'FAILED')

# ------------------------------------------------------------------------------
# Final Summary
# ------------------------------------------------------------------------------
Write-Host "`n==========================================================================" -ForegroundColor Cyan
Write-Host " TEST RESULTS: $passedCount PASSED, $failedCount FAILED" -ForegroundColor $(if ($failedCount -eq 0) { 'Green' } else { 'Red' })
Write-Host '==========================================================================' -ForegroundColor Cyan

if ($failedCount -gt 0) {
  exit 1
} else {
  exit 0
}
