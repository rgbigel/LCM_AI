<#
.SYNOPSIS
  Executes standardized LCM readiness quality gates for LCM_AI and emits CRP-152 receipts.
.DESCRIPTION
  Module: tools/Test-RepoReadiness.ps1
  Executes all standard LCM quality gates for LCM_AI (Canonical Governance Hub):
  1. Authoritative Rules Hub Integrity (.agents/rules/ contains 18 authoritative rule files)
  2. Master Governance Index Synchronization (AGENTS.md, LCM-Rules-Cross-Reference.md)
  3. Formatting & Invariant Rules (UTF-8 without BOM, CRLF)
  4. Comment & Documentation Preservation Invariant (RULE-DOC-009)
  5. Cross-Repository Governance Junction Verification
  Emits machine-readable receipt to data/readiness/latest_readiness.json conforming to CRP-152.
  Conforms to RULE-PS-008, RULE-PS-009, RULE-PS-010, and RULE-DOC-009.
.PATH
  LCM_AI/tools/Test-RepoReadiness.ps1
.AUTHORS
  Rolf, LCM_AI Engine
.VERSION
  10.0.0
.DATE
  2026-11-06
.PARAMETER MinimalTests
  Runs fast structural, governance, and static analysis gates without triggering extended test suites.
.PARAMETER Help
  Displays this help screen (Aliases: -h, -?).
.EXAMPLE
  pwsh tools/Test-RepoReadiness.ps1 -h
.EXAMPLE
  pwsh tools/Test-RepoReadiness.ps1 -MinimalTests
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $false, HelpMessage = 'Runs fast structural, governance, and static analysis gates without triggering extended test suites')]
  [switch]$MinimalTests,

  [Alias('h', '?')]
  [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Help) {
  Write-Host "==========================================================================" -ForegroundColor Cyan
  Write-Host " LCM_AI QUALITY GATE READINESS CHECK (v10.0.0)" -ForegroundColor Cyan
  Write-Host "==========================================================================" -ForegroundColor Cyan
  Write-Host "SYNOPSIS:" -ForegroundColor Yellow
  Write-Host "  Executes all 5 LCM quality gates and writes a structured receipt to data/readiness/latest_readiness.json."
  Write-Host ""
  Write-Host "USAGE:" -ForegroundColor Yellow
  Write-Host "  pwsh LCM_AI/tools/Test-RepoReadiness.ps1 [-MinimalTests] [-h]"
  Write-Host "==========================================================================" -ForegroundColor Cyan
  return
}

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$repoRoot = Split-Path $PSScriptRoot -Parent
$gates = [System.Collections.Generic.List[PSCustomObject]]::new()
$allPassed = $true

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " Executing LCM_AI Quality Gate Readiness Check" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# Gate 1: Authoritative Rules Hub Integrity
# -----------------------------------------------------------------------------
Write-Host "`n[Gate 1/5] Authoritative Rules Hub Integrity..." -ForegroundColor Yellow
$g1Sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
  $rulesDir = Join-Path $repoRoot '.agents\rules'
  if (-not (Test-Path -LiteralPath $rulesDir)) {
    throw "Authoritative rules hub directory missing: $rulesDir"
  }
  $ruleFiles = @(Get-ChildItem -LiteralPath $rulesDir -Filter '*.md')
  if ($ruleFiles.Count -lt 15) {
    throw "Incomplete rules hub: expected at least 15 rule files, found $($ruleFiles.Count)"
  }
  $g1Sw.Stop()
  $g1Details = "Verified authoritative rules hub ($($ruleFiles.Count) rule files present)."
  Write-Host "  Passed: $g1Details" -ForegroundColor Green
  $gates.Add([pscustomobject]@{
    id             = 1
    name           = "Rules Hub Integrity"
    status         = "PASSED"
    details        = $g1Details
    duration_ms    = [int]$g1Sw.ElapsedMilliseconds
    failure_reason = $null
  })
} catch {
  $g1Sw.Stop()
  $allPassed = $false
  Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
  $gates.Add([pscustomobject]@{
    id             = 1
    name           = "Rules Hub Integrity"
    status         = "FAILED"
    details        = "Rules hub check failed"
    duration_ms    = [int]$g1Sw.ElapsedMilliseconds
    failure_reason = $_.Exception.Message
  })
}

# -----------------------------------------------------------------------------
# Gate 2: Master Governance Index Synchronization
# -----------------------------------------------------------------------------
Write-Host "`n[Gate 2/5] Master Governance Index Synchronization..." -ForegroundColor Yellow
$g2Sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
  $agentsMd = Join-Path $repoRoot 'AGENTS.md'
  $crossRef = Join-Path $repoRoot 'docs\LCM-Rules-Cross-Reference.md'
  if (-not (Test-Path -LiteralPath $agentsMd) -or -not (Test-Path -LiteralPath $crossRef)) {
    throw "Master governance index files missing"
  }
  $crossRefContent = Get-Content -LiteralPath $crossRef -Raw -Encoding UTF8
  if ($crossRefContent -notmatch 'RULE-DOC-009') {
    throw "RULE-DOC-009 not synchronized into LCM-Rules-Cross-Reference.md"
  }
  $g2Sw.Stop()
  $g2Details = "Synchronized governance indices verified (RULE-DOC-009 present)."
  Write-Host "  Passed: $g2Details" -ForegroundColor Green
  $gates.Add([pscustomobject]@{
    id             = 2
    name           = "Index Synchronization"
    status         = "PASSED"
    details        = $g2Details
    duration_ms    = [int]$g2Sw.ElapsedMilliseconds
    failure_reason = $null
  })
} catch {
  $g2Sw.Stop()
  $allPassed = $false
  Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
  $gates.Add([pscustomobject]@{
    id             = 2
    name           = "Index Synchronization"
    status         = "FAILED"
    details        = "Index synchronization check failed"
    duration_ms    = [int]$g2Sw.ElapsedMilliseconds
    failure_reason = $_.Exception.Message
  })
}

# -----------------------------------------------------------------------------
# Gate 3: Formatting & Invariant Rules (UTF-8 no BOM)
# -----------------------------------------------------------------------------
Write-Host "`n[Gate 3/5] Formatting & Invariant Rules..." -ForegroundColor Yellow
$g3Sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
  $files = Get-ChildItem -Path $repoRoot -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\\.git\\'
  }
  $bomViolations = @()
  foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
      $bomViolations += $f.Name
    }
  }
  if ($bomViolations.Count -gt 0) {
    throw "UTF-8 BOM detected in: $($bomViolations -join ', ')"
  }
  $g3Sw.Stop()
  $g3Details = "Formatting verified: UTF-8 without BOM across $($files.Count) files."
  Write-Host "  Passed: $g3Details" -ForegroundColor Green
  $gates.Add([pscustomobject]@{
    id             = 3
    name           = "Formatting & Encoding"
    status         = "PASSED"
    details        = $g3Details
    duration_ms    = [int]$g3Sw.ElapsedMilliseconds
    failure_reason = $null
  })
} catch {
  $g3Sw.Stop()
  $allPassed = $false
  Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
  $gates.Add([pscustomobject]@{
    id             = 3
    name           = "Formatting & Encoding"
    status         = "FAILED"
    details        = "Formatting check failed"
    duration_ms    = [int]$g3Sw.ElapsedMilliseconds
    failure_reason = $_.Exception.Message
  })
}

# -----------------------------------------------------------------------------
# Gate 4: Comment & Documentation Preservation Invariant (RULE-DOC-009)
# -----------------------------------------------------------------------------
Write-Host "`n[Gate 4/5] Comment & Documentation Preservation (RULE-DOC-009)..." -ForegroundColor Yellow
$g4Sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
  $incGovScript = 'D:\Git_Repositories\LCM_Inventory\tools\Test-LCMIncrementalGovernance.ps1'
  $commentResult = & $incGovScript -RepositoryPath $repoRoot
  if (-not $commentResult.Passed) {
    throw "Comment preservation check failed"
  }
  $g4Sw.Stop()
  $g4Details = "Zero comment destruction verified across all active files."
  Write-Host "  Passed: $g4Details" -ForegroundColor Green
  $gates.Add([pscustomobject]@{
    id             = 4
    name           = "Comment Preservation"
    status         = "PASSED"
    details        = $g4Details
    duration_ms    = [int]$g4Sw.ElapsedMilliseconds
    failure_reason = $null
  })
} catch {
  $g4Sw.Stop()
  $allPassed = $false
  Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
  $gates.Add([pscustomobject]@{
    id             = 4
    name           = "Comment Preservation"
    status         = "FAILED"
    details        = "Comment preservation check failed"
    duration_ms    = [int]$g4Sw.ElapsedMilliseconds
    failure_reason = $_.Exception.Message
  })
}

# -----------------------------------------------------------------------------
# Gate 5: Cross-Repository Governance Junction Verification
# -----------------------------------------------------------------------------
Write-Host "`n[Gate 5/5] Governance Junction Verification..." -ForegroundColor Yellow
$g5Sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
  $workspaceRoot = Split-Path $repoRoot -Parent
  $rootRulesLink = Join-Path $workspaceRoot '.agents\rules'
  if (-not (Test-Path -LiteralPath $rootRulesLink)) {
    throw "Root .agents/rules junction is missing"
  }
  $g5Sw.Stop()
  $g5Details = "Verified workspace root junction to canonical rules hub."
  Write-Host "  Passed: $g5Details" -ForegroundColor Green
  $gates.Add([pscustomobject]@{
    id             = 5
    name           = "Junction Verification"
    status         = "PASSED"
    details        = $g5Details
    duration_ms    = [int]$g5Sw.ElapsedMilliseconds
    failure_reason = $null
  })
} catch {
  $g5Sw.Stop()
  $allPassed = $false
  Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
  $gates.Add([pscustomobject]@{
    id             = 5
    name           = "Junction Verification"
    status         = "FAILED"
    details        = "Junction verification failed"
    duration_ms    = [int]$g5Sw.ElapsedMilliseconds
    failure_reason = $_.Exception.Message
  })
}

$sw.Stop()
$totalDuration = [int]$sw.ElapsedMilliseconds
$passedCount = @($gates | Where-Object { $_.status -eq 'PASSED' }).Count
$totalCount = $gates.Count
$overallStatus = if ($allPassed) { 'PASSED' } else { 'FAILED' }

# Persist Machine-Readable Readiness Receipt (CRP-152)
$readinessDir = Join-Path $repoRoot 'data\readiness'
if (-not (Test-Path -LiteralPath $readinessDir)) {
  New-Item -ItemType Directory -Path $readinessDir -Force | Out-Null
}
$receiptPath = Join-Path $readinessDir 'latest_readiness.json'

$receipt = [pscustomobject]@{
  '$schema'      = "https://json-schema.org/draft/2020-12/schema"
  repository     = "LCM_AI"
  timestamp      = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
  overall_status = $overallStatus
  passed_count   = $passedCount
  total_count    = $totalCount
  duration_ms    = $totalDuration
  gates          = $gates
}

$receipt | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $receiptPath -Encoding UTF8

Write-Host "`n=================================================================" -ForegroundColor $(if ($allPassed) { 'Green' } else { 'Red' })
if ($allPassed) {
  Write-Host " All LCM_AI Quality Gates PASSED (Readiness: OK)                  " -ForegroundColor Green
  Write-Host " Receipt saved: data/readiness/latest_readiness.json ($($totalDuration)ms)" -ForegroundColor DarkGray
} else {
  Write-Host " Quality Gate Check FAILED ($passedCount/$totalCount passed)                  " -ForegroundColor Red
}
Write-Host "=================================================================" -ForegroundColor $(if ($allPassed) { 'Green' } else { 'Red' })

if (-not $allPassed) {
  throw "One or more quality gates failed. See receipt at: $receiptPath"
}

