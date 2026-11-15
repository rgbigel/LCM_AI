# File: NOTE-LineEndings.md

Module: .claude/translation/NOTE-LineEndings.md  
Purpose: Impact note for revising the LCM line-ending policy (CRLF today) towards LF; facts measured on disk, options, affected rules and tools, recommendation. Input for a later CRP.  
Path: LCM_AI/.claude/translation/NOTE-LineEndings.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-15 15:17:03

---

## 1. Problem

The operator chose CRLF as the Windows convention (INVARIANT-RULES newline-crlf). Git, VS Code and the AI hosts (Antigravity, Claude's Write tool) produce LF natively, so LF files keep appearing and every host has to normalize. The question is whether LCM should switch to LF, and what that would affect.

## 2. Facts (measured 2026-11-14)

### 2.1 Configuration

| Item | State |
|:---|:---|
| `.gitattributes` | Root, `LCM_AI`, `LCM_Inventory`: `* text=auto eol=crlf` plus explicit `eol=crlf` per type. `LCM_Shared`, `LCM_Supervision`, `LCM_Tools`: none. |
| `core.autocrlf` | `false` in every repository (local), `false` global, `true` system (overridden). |
| Effect | In the three repos with `.gitattributes`, Git already stores text files as **LF** in the object store and checks them out as CRLF. In the three repos without it, files are stored exactly as written (mixed). |
| VS Code | `files.eol: "\r\n"` in root and `LCM_AI` settings: applies only to new files; existing files keep their EOL. No `.editorconfig` anywhere. |

### 2.2 Actual line endings in LCM_* working trees (excluding `.git`, proposals, archives)

| Type | CRLF | LF | Mixed |
|:---|---:|---:|---:|
| `*.cmd` / `*.bat` | 783 | 18 | 3 |
| `*.ps1` / `*.psm1` / `*.psd1` | 328 | 71 | 6 |
| `*.json` | 317 | 90 | 0 |
| `*.md` | 248 | 134 | 12 |
| `*.py` | 10 | 19 | 0 |
| `*.go` | 0 | 5 | 0 |
| `*.html` / `*.css` / `*.js` | 30 | 3 | 1 |
| `*.sql` | 0 | 2 | 1 |

Today's policy is already violated in about 20 % of text files.

### 2.3 Tooling

- **Readers are EOL-tolerant.** Every split found in `LCM_Inventory` tools and modules uses `\r?\n`; no reader depends on CRLF.
- **Writers emit CRLF.** 25 tool/module files hard-code `` `r`n `` (e.g. `Update-ToolCatalog.ps1` trampoline generation, `Save-AllSessionMemory.ps1`, `Sync-LcmCatalogMacros.ps1`, `Invoke-LearnedAdviceReview.ps1`, `Link-LcmLearnedAdvice.ps1`, `Absorb-LcmContextRemark.ps1`, `Fix-Documentation.ps1`). About 110 files write text; PowerShell's `Set-Content` / `Out-File` / `Add-Content` use CRLF on Windows by default.
- **Checkers enforce CRLF.** `Test-LCMIncrementalGovernance.ps1` raises `NEWLINE-CRLF` for JSON; `LCM_QualityGates.psm1` normalizes to CRLF; RULE-LCM-023 minimal tests include a UTF-8/CRLF check.
- **No Authenticode-signed scripts** were found (a signature would break on any EOL change).

## 3. Hard Constraint

`*.cmd` / `*.bat` must stay CRLF under every option: `cmd.exe` mis-parses LF-only batch files (labels, `goto`, `call :label` fail near 512-byte block boundaries). 18 trampolines are LF today and are at risk now.

## 4. Options

| | A: Keep CRLF, enforce it | B: Switch to LF (except CMD/BAT) | C: EOL-agnostic |
|:---|:---|:---|:---|
| Rule | newline-crlf unchanged | newline-lf; `*.cmd`/`*.bat` CRLF | "preserve a file's EOL; new files per `.gitattributes`; CMD/BAT CRLF" |
| `.gitattributes` | add to the 3 missing repos | `* text=auto eol=lf`, `*.cmd`/`*.bat` `eol=crlf`, in all 6 repos + root | as B or A, only for new files |
| VS Code | add `.editorconfig` (`end_of_line = crlf`) | `files.eol: "\n"` + `.editorconfig` | `.editorconfig` per type |
| Writers (25 hard-coded + `Set-Content` defaults) | unchanged | change to LF (or to "keep existing EOL") | change to "keep existing EOL" |
| Checkers | keep; extend to all types | flip `NEWLINE-CRLF` to `NEWLINE-LF` (CMD/BAT stay CRLF) | check CMD/BAT only; others "no mixed EOL" |
| One-time conversion | ~400 LF/mixed files to CRLF | ~1,000 CRLF files to LF | none |
| AI hosts | must keep normalizing to CRLF (friction stays) | native output already LF (friction mostly gone) | no normalization needed |
| Git blobs | unchanged (already LF where `.gitattributes` exists) | unchanged in those repos; only working copies change | unchanged |

## 5. Rules Affected by B (or C)

- INVARIANT-RULES `newline-crlf` (and its Claude adapter note), JsonRules `newline-crlf`, PowerShellRules `newline-crlf`, CMDRules `newline-crlf` (stays, made explicit as exception), RULE-LCM-023 (minimal-test hygiene check), RULE-DOC-003 / DOX templates if they mention CRLF, `New-RepositoryDocumentation.ps1` template text ("CRLF line endings").
- RULE-REV-001.5 already says line-ending differences must not create review candidates; BCR must have "ignore line endings" set as unimportant, otherwise a conversion floods the review.

## 6. Review and History Effects

- A one-time conversion changes many working-tree files at once. With `.gitattributes` in place, Git shows no content change for repos whose blobs are already LF; repos without `.gitattributes` would show full-file diffs.
- BCR against a Macrium baseline shows every converted file unless line-ending differences are classified unimportant in the `_LCM` profile.
- Do the conversion as its own commit, separate from content changes.

## 7. Recommendation

Option **B** (LF everywhere, CRLF only for `*.cmd` / `*.bat`): it matches what Git already stores, what VS Code and all AI hosts produce, and what every LCM reader already accepts; the remaining work is bounded (one `.gitattributes` template, `.editorconfig`, 25 writer files plus `Set-Content` defaults, two checkers, five rule lines, one conversion commit). Option C is the cheapest short-term fallback if a conversion commit is not wanted now.

## 8. Decisions Needed

1. Option A, B or C.
2. If B: convert existing files in one commit now, or let files convert as they are touched (mixed period).
3. Confirm the BCR `_LCM` profile ignores line-ending differences before any conversion.

## 9. Decision (2026-11-15)

- Operator: **Option A** - CRLF everywhere, no mixed setup. Claude's recommendation B is rejected.
- Cause of LF on disk clarified: not GitHub; Git converts only at commit and checkout; LF comes from whole-file writes of hosts/tools after checkout.
- Enforcement: CRP-332 (`LCM_Inventory/docs/Proposals/CRP-332-Workspace-CRLF-Line-Ending-Enforcement/Specification.md`), for Antigravity.
- LF found in third-party writes: Claude converts to CRLF without involving the operator.
