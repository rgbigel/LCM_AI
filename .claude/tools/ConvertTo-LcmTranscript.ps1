<#
.SYNOPSIS
  Converts a Claude Code session transcript into the normalized event JSONL read by Invoke-FailureModeAnalysis.ps1.

.DESCRIPTION
  Module: .claude/tools/ConvertTo-LcmTranscript.ps1
  Purpose: Claude host transcript provider for the shared LCM session analysis (AnalyzeFailures / ShowFailureAnalysis); closes the missing host transcript provider of FINDINGS F-31 for Claude.
  Path: LCM_AI/.claude/tools/ConvertTo-LcmTranscript.ps1
  Authors: Rolf, Claude (Anthropic)
  Version: 10.6.4
  Status: Draft
  Date: 2026-11-15

  Reads a Claude Code session JSONL (one record per line) and emits one normalized event per content block:
    user/assistant text   -> user.message / assistant.message  (data.content)
    tool_use              -> tool.execution_start              (data.toolCallId, toolName, arguments)
    tool_result           -> tool.execution_complete           (data.toolCallId, success, result.content, result.isError)
  Thinking blocks and harness records (attachments, api-request, file-history, ...) are skipped.
  Each event keeps id (<record uuid>-<block index>), parentId and timestamp of its source record.

  Rationale: The shared tools already accept normalized events via -TranscriptPath, so the Claude side only
  needs this adapter-local converter; the shared LCM tools stay identical for all hosts (CRP-331 section 1).

.PARAMETER SessionPath
  Claude session JSONL. Default: the most recently written *.jsonl in the Claude project directory of the workspace root.

.PARAMETER OutputPath
  Target JSONL. Default: LCM_Inventory/data/artifacts/claude-transcripts/<session id>.jsonl (auto-accepted artifact, RULE-EFF-001).

.PARAMETER Help
  Prints usage and exits without writing.

.EXAMPLE
  pwsh -NoProfile -File ConvertTo-LcmTranscript.ps1
  pwsh -NoProfile -File ConvertTo-LcmTranscript.ps1 -SessionPath <session.jsonl> -OutputPath <events.jsonl>

.OUTPUTS
  The full path of the written event file (string).

.NOTES
  Caveats: The Claude transcript format is not a documented contract and may change between Claude Code versions;
  unknown record and block types are skipped, not failed. The current session is still being written while it is converted.
  Read-only on the source; writes only the output file. No elevation needed.
#>
[CmdletBinding()]
param(
  [string]$SessionPath,
  [string]$OutputPath,
  [Alias('h', '?')][switch]$Help
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$toolName = 'ConvertTo-LcmTranscript.ps1'
$toolVersion = '10.6.4'

if ($Help) {
  Write-Host ('{0} v{1}' -f $toolName, $toolVersion)
  Write-Host 'ConvertTo-LcmTranscript [-SessionPath <Claude session .jsonl>] [-OutputPath <events .jsonl>]'
  Write-Host '  Default session: newest *.jsonl in the Claude project directory of the workspace root.'
  Write-Host '  Default output : LCM_Inventory\data\artifacts\claude-transcripts\<session id>.jsonl'
  Write-Host '  Use the output with: Invoke-FailureModeAnalysis.ps1 -TranscriptPath <output>'
  return
}

$workspaceRoot = $PSScriptRoot
while ($workspaceRoot -and -not (Test-Path -LiteralPath (Join-Path $workspaceRoot 'LCM_Inventory'))) { $workspaceRoot = Split-Path -Path $workspaceRoot -Parent }
if (-not $workspaceRoot) { throw 'Workspace root (folder containing LCM_Inventory) not found above the script.' }
$projectKey = $workspaceRoot -replace '[:\\/_ ]', '-'

if ([string]::IsNullOrWhiteSpace($SessionPath)) {
  $projectDir = Join-Path $HOME (Join-Path '.claude\projects' $projectKey)
  if (-not (Test-Path -LiteralPath $projectDir)) { throw ('Claude project directory not found: {0}' -f $projectDir) }
  $newest = @(Get-ChildItem -LiteralPath $projectDir -Filter '*.jsonl' -File | Sort-Object -Property LastWriteTime -Descending)
  if ($newest.Count -eq 0) { throw ('No session transcript found in {0}' -f $projectDir) }
  $SessionPath = $newest[0].FullName
}
if (-not (Test-Path -LiteralPath $SessionPath)) { throw ('Session transcript not found: {0}' -f $SessionPath) }

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $sessionId = [IO.Path]::GetFileNameWithoutExtension($SessionPath)
  $OutputPath = Join-Path $workspaceRoot (Join-Path 'LCM_Inventory\data\artifacts\claude-transcripts' ($sessionId + '.jsonl'))
}
$outputDir = Split-Path -Path $OutputPath -Parent
if (-not (Test-Path -LiteralPath $outputDir)) { $null = New-Item -ItemType Directory -Path $outputDir -Force }

function Get-TranscriptProperty {
  param([object]$Object, [string]$Name)
  if ($null -eq $Object) { return $null }
  $property = $Object.PSObject.Properties[$Name]
  if ($null -eq $property) { return $null }
  return $property.Value
}

function Get-TranscriptResultText {
  param([object]$Content)
  if ($null -eq $Content) { return '' }
  if ($Content -is [string]) { return $Content }
  $parts = foreach ($part in @($Content)) { [string](Get-TranscriptProperty $part 'text') }
  return (@($parts) -join [Environment]::NewLine)
}

# Shared read: the current session file is open for writing by Claude Code (RULE-PS-017).
$stream = [IO.FileStream]::new($SessionPath, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
try {
  $reader = [IO.StreamReader]::new($stream, [Text.UTF8Encoding]::new($false))
  $raw = $reader.ReadToEnd()
} finally {
  $stream.Dispose()
}

$events = [Collections.Generic.List[string]]::new()
$skipped = 0
foreach ($line in ($raw -split '\r?\n')) {
  if ([string]::IsNullOrWhiteSpace($line)) { continue }
  try { $record = $line | ConvertFrom-Json } catch { $skipped++; continue }
  $kind = [string](Get-TranscriptProperty $record 'type')
  if ($kind -notin @('user', 'assistant')) { continue }
  $message = Get-TranscriptProperty $record 'message'
  $content = Get-TranscriptProperty $message 'content'
  $blocks = if ($content -is [string]) { @([pscustomobject]@{ type = 'text'; text = $content }) } else { @($content) }
  $uuid = [string](Get-TranscriptProperty $record 'uuid')
  $parentId = [string](Get-TranscriptProperty $record 'parentUuid')
  $timestamp = [string](Get-TranscriptProperty $record 'timestamp')
  $blockIndex = 0
  foreach ($block in $blocks) {
    $blockIndex++
    $blockType = [string](Get-TranscriptProperty $block 'type')
    $normalized = $null
    if ('text' -eq $blockType) {
      $eventType = if ('user' -eq $kind) { 'user.message' } else { 'assistant.message' }
      $normalized = [ordered]@{ type = $eventType; data = [ordered]@{ content = [string](Get-TranscriptProperty $block 'text') } }
    } elseif ('tool_use' -eq $blockType) {
      $normalized = [ordered]@{
        type = 'tool.execution_start'
        data = [ordered]@{
          toolCallId = [string](Get-TranscriptProperty $block 'id')
          toolName = [string](Get-TranscriptProperty $block 'name')
          arguments = (Get-TranscriptProperty $block 'input')
        }
      }
    } elseif ('tool_result' -eq $blockType) {
      $isError = $true -eq (Get-TranscriptProperty $block 'is_error')
      $normalized = [ordered]@{
        type = 'tool.execution_complete'
        data = [ordered]@{
          toolCallId = [string](Get-TranscriptProperty $block 'tool_use_id')
          success = (-not $isError)
          result = [ordered]@{ content = (Get-TranscriptResultText (Get-TranscriptProperty $block 'content')); isError = $isError }
        }
      }
    }
    if ($null -eq $normalized) { continue }
    $normalized.id = ('{0}-{1}' -f $uuid, $blockIndex)
    $normalized.parentId = $parentId
    $normalized.timestamp = $timestamp
    $events.Add(($normalized | ConvertTo-Json -Depth 30 -Compress))
  }
}

if ($events.Count -eq 0) { throw ('No convertible events in {0}' -f $SessionPath) }
[IO.File]::WriteAllText($OutputPath, (($events -join "`r`n") + "`r`n"), [Text.UTF8Encoding]::new($false))
Write-Host ('[SUMMARY] Tool={0} Version={1} Status=Succeeded Events={2} SkippedLines={3} Source={4} Output={5} Time={6}' -f $toolName, $toolVersion, $events.Count, $skipped, $SessionPath, $OutputPath, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
Write-Output $OutputPath
