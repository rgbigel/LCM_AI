---
name: macro-definitions
description: Authoritative governance rule mirror for macro-definitions
globs: "*"
---
<!-- ===================================================================== -->
<!-- ANTIGRAVITY RULE MIRROR                                               -->
<!-- Source Authority: LCM_Inventory/.agents/rules/macro-definitions.md -->
<!-- Activation: Workspace Automatic                                       -->
<!-- ===================================================================== -->
# macro-definitions.md
# version: 10.2.2
# date: 2026-11-10

# MACRO-DEFINITIONS-METADATA
# scope: durable-memory
# location: .agents/rules/macro-definitions.md
# update-policy: manual

## Syntax Convention: Antigravity IDE Bare-Word Standard
In the Antigravity IDE environment, typing the `@` character triggers the IDE's interactive context-attachment popup (`@Files`, `@Docs`, `@Git`). Therefore, bare-word command invocations (`ToolExplorer`, `ShowTools`, `tools`, `ar`, `bcr`, `COMPLETE`, `PUBLISH`, `DO <#>`, etc.) are the primary and preferred syntax. The `@` prefix remains supported as a backward-compatible alias.

MACRO: technical
- description: enforce strict technical, ascii-only, deterministic output
- syntax: technical | @technical
- rules:
  - no prose
  - no decoration
  - no emojis
  - no unicode
  - explicit structures only

MACRO: user
- description: normal user-facing mode
- syntax: user | @user
- rules:
  - allow brief explanations
  - allow minimal formatting
  - keep responses concise

MACRO: S
- description: system-aligned mode
- syntax: S | @S
- rules:
  - follow workspace rules
  - follow copilot profile
  - respect durable-memory files

MACRO: profile status
- description: report current copilot profile state
- syntax: profile status | @profile status
- rules:
  - summarize durable-memory presence
  - summarize test-suite presence
  - summarize version alignment

MACRO: GoodMorning
- description: full read-only session-start check (RULE-CTX-006, RULE-LCM-030): time gap, work in between, versions, context staleness, pending learned advice
- syntax: GoodMorning | goodmorning
- primary target: LCM_Inventory/tools/Invoke-LCM_GoodMorning.ps1 -Force
- rules:
  - the first line of the AI's response MUST reference the preceding GoodNight timestamp: "☀️ Good Morning! Resuming from Good Night at YYYY-MM-DD HH:mm:ss (Gap: X.X h)."
  - report every attention item to the operator before other work
  - confirm that ACTIVE_CONTEXT.md and LEARNED_ADVICE.md were read and can be followed
  - change nothing

MACRO: GoodNight
- description: comprehensive end-of-day workspace save, log archival, commit, optional push, and quiescence transition (RULE-LCM-030)
- syntax: GoodNight [-Push] | goodnight [-Push] | SaveAll
- aliases: goodnight, SaveAll
- primary target: LCM_Inventory/tools/Invoke-LCM_GoodNight.ps1 [-Push]
- rules:
  - scan working-tree cleanliness across all governed repositories
  - save session memory to ACTIVE_CONTEXT.md and record Quiescent state in ACTIVE_SESSION.md
  - archive daemon logs before any publish-owned maintenance can change them
  - commit governed repositories (and publish with -Push)
  - the final console banner and AI terminal message MUST show the completion timestamp: "🌙 Good Night completed at YYYY-MM-DD HH:mm:ss. Session is Quiescent."
  - after GoodNight completes, the workspace enters a Quiescent State; AI MUST NOT emit unprompted wakeups or greetings until operator speaks


MACRO: learn
- description: record something learned as a candidate for LEARNED_ADVICE.md (RULE-CTX-005)
- syntax: /learn <text> | learn <text>
- rules:
  - add the text as a candidate with Save-AllSessionMemory.ps1 -Learn "<text>" -Author <AI name>; do nothing else
  - candidates are reviewed with Invoke-LearnedAdviceReview.ps1 no later than push (push is refused while any are pending)

MACRO: ToolExplorer
- description: generate and launch the authoritative LCM Tool Explorer interactive HTML application via Show-ToolsExplorer.ps1
- syntax: ToolExplorer [switches] | tools [switches] | ShowTools [switches]
- aliases: tools, ToolsExplorer, ShowTools
- primary target: LCM_Inventory/tools/Show-ToolsExplorer.ps1 (trampolines: LCM_Inventory/Cmd/ToolExplorer.cmd, ToolsExplorer.cmd)
- delivery: publish and open only through http://127.0.0.1:9876; pages, assets, data, and refreshes must not use file URLs or offline local-file fallbacks
- parameters:
  - -Audience <User|Dev|All>: pre-filter audience category (defaults to 'User')
  - -Group <Name>: pre-filter by group or subsystem (e.g. 'HaSSD06', 'LCM', 'SystemConfiguration')
  - -Subsystem <Name>: direct filter for specific subsystem (e.g. 'HaSSD06', 'LCM_Inventory')
  - -HaSSD06 (or -Ha): quick switch to filter directly to Home Assistant HaSSD06 tools
  - -Role <RoleName>: pre-filter by functional role (e.g. 'QualityGate', 'ReviewGate', 'Elevation', 'DesktopGUI')
  - -Tool <ToolName>: pre-select and highlight specific tool
  - -Env <PS1|CMD|PY|REG|LNK|All>: pre-filter by tool execution environment
  - -Filter <query>: initial text search keyword on startup (supports '!term' negation)
  - -NoBrowser (or -Cli, -Text): suppress browser and output catalog to terminal
  - -NoLaunch: generate HTML dashboard and cache without browser launch
  - -h (or -Help): display comprehensive parameter reference
- examples:
  - 'ToolExplorer' or 'tools' -> launches Tool Explorer filtered to Audience=User
  - 'ToolExplorer -Audience Dev' -> launches Tool Explorer filtered to internal developer tools
  - 'ToolExplorer -HaSSD06' -> launches Tool Explorer filtered to HaSSD06 subsystem
  - 'ToolExplorer -NoBrowser' -> renders tool catalog directly in console

MACRO: AnalyzeFailures
- description: investigate session failures and execution-purpose evidence, retain Markdown/JSON, and open the readable failure-analysis snapshot
- syntax: AnalyzeFailures -Number <item> | AnalyzeFailures -From <literal text>
- primary target: LCM_Inventory/tools/Invoke-FailureModeAnalysis.ps1 (trampoline: LCM_Inventory/Cmd/AnalyzeFailures.cmd)
- parameters:
  - -TranscriptPath <path>: analyze only the supplied offline transcript
  - -NoLaunch: retain reports and the viewer snapshot without opening a browser
- rules:
  - a missing requested anchor is an error; never silently substitute another session or selection
  - the viewer uses the existing port-9876 daemon only; opening a retained snapshot does not rerun the analysis

MACRO: ShowFailureAnalysis
- description: open a readable retained failure-analysis report without executing its producer
- syntax: ShowFailureAnalysis [-ReportPath <exact .md or .json path>] [-NoLaunch]
- primary target: LCM_Inventory/tools/Show-FailureAnalysis.ps1 (trampoline: LCM_Inventory/Cmd/ShowFailureAnalysis.cmd)
- parameters:
  - -ReportPath <path>: select the exact retained report
  - -SnapshotRoot <directory>: override the backend snapshot destination; a noncanonical destination requires -NoLaunch
  - -NoLaunch: build the snapshot without opening a browser
- rules:
  - pages, scripts, styles, and report data are delivered only by http://127.0.0.1:9876
  - retained source references and evidence limitations are preserved; context alone is not proof of authorization

MACRO: set-tool-audience
- description: configure whether a tool is User-exposed or Developer-only
- syntax: set-tool-audience | @set-tool-audience
- note: Tool audience, role, and metadata are maintained interactively directly within the ToolExplorer application (or via Update-ToolCatalog.ps1)

MACRO: log
- description: locate and open latest LCM log file and reveal full log history in File Explorer
- syntax: log [ToolName] | logs [ToolName]
- aliases: log, logs, lastlog
- rules:
  - 'log' or 'logs' -> executes 'pwsh -File tools/Show-LastLog.ps1'
  - 'log <ToolName>' -> executes 'pwsh -File tools/Show-LastLog.ps1 -ToolName <ToolName>'

MACRO: BCR
- description: launch Beyond Compare 5 visual review for an exact CRP/BUG, repository, or declared cohort
- syntax: bcr [CRP-ID|BUG-ID|repo|cohort] [commit] | BCR [CRP-ID|BUG-ID|repo|cohort] [commit]
- aliases: bcr, BCR, @bcr
- rules:
  - exact CRP/BUG, repository, and declared cohort forms are valid. Declared cohorts use `COH-<prime CRP/BUG number>` and contain their prime member.
  - when scope is omitted, the dispatcher resolves exactly one declared open cohort. If none exists, it constructs a bounded proposed cohort from open `in_progress`, `verified`, and `in_review` proposals.
  - the dispatcher records a cohort-resolution receipt before launch. `in_progress` members are reported as pending verification, `verified` members are review-ready, and `in_review` members refresh rather than duplicate a review session.
  - omitted or broadened scope requires an interactive confirmation. A scope that exceeds configured proposal or repository limits, has incompatible baselines, or has unresolved overlap/conflict evidence requires explicit operator selection; non-interactive or cancelled resolution fails closed.
  - only review-ready `verified` members may transition to `in_review`, and only after their review handoff succeeds.
  - the dispatcher executes `Invoke-BeyondCompareReview.ps1` against the resolved baseline and preserves the configured coarse or tight review granularity.
  - an optional baseline commit is accepted only when it matches the resolved review scope.
  - generated artifacts, scratch, data, logs, and routine test output require no review, but `BCR` may peek at them unfiltered and report non-blocking advice.

MACRO: cohort
- description: create and manage the one declared review cohort
- syntax: cohort <create|add|remove|hold|reopen|close> [CRP-ID|BUG-ID|list] | COHORT <create|add|remove|hold|reopen|close> [CRP-ID|BUG-ID|list]
- aliases: cohort, COHORT
- rules:
  - at most one declared cohort may be open. It is named `COH-<prime CRP/BUG number>` and must contain its prime member.
  - `hold` pauses the declared cohort without changing its members' lifecycle states; `reopen` restores one held cohort only when no cohort is open.
  - `create` uses the first selected proposal as the prime member; `add` and `remove` update the open cohort; `close` ends it without altering member lifecycle state.
  - a prime member cannot be removed; close the cohort instead. Cross-repository creation or membership changes require explicit confirmation and produce per-repository BCR baselines.

MACRO: ReOpen
- description: restore a held CRP, BUG, or declared cohort
- syntax: reopen <CRP-ID|BUG-ID> | ReOpen <CRP-ID|BUG-ID> | cohort reopen [COH-nnn]
- aliases: reopen, ReOpen, CONTINUE
- rules:
  - a held CRP or BUG restores its recorded `resume_state`; it re-enters OPEN only when that restored state is active.
  - `cohort reopen` restores a held declared cohort only when no cohort is open; it does not change any member lifecycle state.
  - `CONTINUE` remains a backward-compatible alias for `ReOpen`.

MACRO: COMPLETE
- description: submit a completed review result for an exact CRP/BUG, repository, declared cohort, or all eligible cohorts, then commit locally
- syntax: complete <CRP-ID|BUG-ID|repo|cohort|all> | COMPLETE <CRP-ID|BUG-ID|repo|cohort|all>
- aliases: complete, COMPLETE, completed
- rules:
  - completion supports exact CRP/BUG, repository, declared cohort, and `all` forms. `complete all` processes eligible cohorts stepwise and reports every cohort outcome; unresolved or ambiguous scope is invalid.
  - `complete COH-<nnn>` reads the matching BCR staging receipt, validates that every member is `in_review`, and commits once per affected repository. It then advances that repository's reviewed members together.
  - before staging, completion displays unreviewed live paths from the repository staging manifest and requires explicit operator inclusion; cancellation leaves every member in `in_review`.
  - cohort-resolution receipts remain under `LCM_Inventory\scratch\BC_Review\COH-<nnn>` until review completion; permanent commit receipts remain governed CM evidence.
  - automatically closes matching Beyond Compare review window
  - never invokes a remote push

MACRO: FixDocumentation
- description: reconcile explicit CRP/BUG documentation payloads into the LCM tripartite documents
- syntax: FixDocumentation <CRP/BUG scope> [-Apply] | fixdocumentation <CRP/BUG scope> [-Apply]
- aliases: fixdocumentation, FixDocumentation
- rules:
  - default behavior is dry run and writes a reconciliation manifest without changing documents
  - `-Apply` writes only explicit `Documentation Updates` payloads declared by the selected bundles
  - conflicting or ambiguous payloads stop without modifying documentation
  - an applied update requires BCompare review before local commit
  - executes `pwsh -File LCM_Inventory/tools/Fix-Documentation.ps1 <scope>` (or `LCM_Inventory/Cmd/FixDocumentation.cmd`)

MACRO: PUBLISH
- description: publish a completed proposal cohort and LCM_Inventory to their remotes in lockstep
- syntax: publish [repo] | PUBLISH [repo]
- aliases: publish, PUBLISH, push, PUSH
- rules:
  - 'publish <repo>' or 'PUBLISH <repo>' -> executes 'pwsh -File LCM_Inventory/tools/Invoke-LCM_Push.ps1 -Repositories <repo>'
  - `push` and `PUSH` remain backward-compatible aliases.
  - requires every target proposal to be completed and LCM_Inventory to be ahead before any remote dispatch

<!-- MANAGED-SHOW-MACROS-START -->
## Managed Catalog Show* Command Macros (Auto-Synchronized by CRP-280)
<!-- The entries below are synchronized from config/tool_catalog.json. Do not edit directly. -->

MACRO: ShowHaAuthDialog
- description: WPF desktop dialog for secure ephemeral credentials with password reveal (RULE-SUB-003).
- syntax: ShowHaAuthDialog [switches] | @ShowHaAuthDialog [switches]
- primary target: HaSSD06/tools/subsystem/Show-HaAuthDialog.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowHaInventoryApp
- description: Show-HaInventoryApp execution tool.
- syntax: ShowHaInventoryApp [switches] | @ShowHaInventoryApp [switches]
- primary target: HaSSD06_Inventory/tools/Show-HaInventoryApp.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowDaemon
- description: Displays live telemetry, runtime status, and log tailing for the LCM Desktop REST Bridge Daemon.
- syntax: ShowDaemon [switches] | @ShowDaemon [switches]
- primary target: LCM_Inventory/tools/Show-LcmDaemon.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowLastLog
- description: Displays the most recently updated audit log in the workspace with live tail and level filtering.
- syntax: ShowLastLog [switches] | @ShowLastLog [switches]
- primary target: LCM_Inventory/tools/Show-LastLog.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowCM
- description: Unified LCM Control Hub dashboard and proposal lifecycle manager.
- syntax: ShowCM [switches] | @ShowCM [switches]
- primary target: LCM_Inventory/tools/Show-LcmControl.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowCmdAnalysis
- description: Interactive HTML viewer analyzing all legacy batch scripts and modern PowerShell tool equivalents.
- syntax: ShowCmdAnalysis [switches] | @ShowCmdAnalysis [switches]
- primary target: LCM_Inventory/tools/Show-CmdFolderAnalysis.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowHaInventory
- description: Generates and launches the authoritative Home Assistant HaSSD06 Subsystem Viewer dashboard.
- syntax: ShowHaInventory [switches] | @ShowHaInventory [switches]
- primary target: LCM_Inventory/tools/Show-HaInventory.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowActions
- description: Fast lightweight terminal reader displaying recent operational actions and tool execution step summaries.
- syntax: ShowActions [switches] | @ShowActions [switches]
- primary target: LCM_Inventory/tools/Show-Actions.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowToolIndex
- description: Underlying generation engine for the interactive LCM Tool Explorer HTML application.
- syntax: ShowToolIndex [switches] | @ShowToolIndex [switches]
- primary target: LCM_Inventory/tools/Show-ToolIndex.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowFailureDiagnostic
- description: Show-LcmFailureDiagnostic execution tool.
- syntax: ShowFailureDiagnostic [switches] | @ShowFailureDiagnostic [switches]
- primary target: LCM_Inventory/tools/Show-LcmFailureDiagnostic.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowLcmActiveLauncher
- description: Show-LcmActiveLauncher execution tool.
- syntax: ShowLcmActiveLauncher [switches] | @ShowLcmActiveLauncher [switches]
- primary target: LCM_Inventory/tools/Show-LcmActiveLauncher.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowLcmAnalysisViewer
- description: Show-LcmAnalysisViewer execution tool.
- syntax: ShowLcmAnalysisViewer [switches] | @ShowLcmAnalysisViewer [switches]
- primary target: LCM_Inventory/tools/Show-LcmAnalysisViewer.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowLCMInventoryApp
- description: Show-LCM_InventoryApp execution tool.
- syntax: ShowLCMInventoryApp [switches] | @ShowLCMInventoryApp [switches]
- primary target: LCM_Inventory/tools/Show-LCM_InventoryApp.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowLCMReadiness
- description: Show-LCM_Readiness execution tool.
- syntax: ShowLCMReadiness [switches] | @ShowLCMReadiness [switches]
- primary target: LCM_Inventory/tools/Show-LCM_Readiness.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowRepos
- description: Show-Repos execution tool.
- syntax: ShowRepos [switches] | @ShowRepos [switches]
- primary target: LCM_Inventory/tools/Show-Repos.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowRules
- description: Show-Rules execution tool.
- syntax: ShowRules [switches] | @ShowRules [switches]
- primary target: LCM_Inventory/tools/Show-Rules.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowToolIntents
- description: Show-ToolIntents execution tool.
- syntax: ShowToolIntents [switches] | @ShowToolIntents [switches]
- primary target: LCM_Inventory/tools/Show-ToolIntents.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

MACRO: ShowSupervision
- description: Show-Supervision execution tool.
- syntax: ShowSupervision [switches] | @ShowSupervision [switches]
- primary target: LCM_Supervision/tools/Show-Supervision.ps1
- rules:
  - IDE-hosted display by default when supported by the host environment
  - does not automatically launch an external browser when IDE display is unavailable; reports local display URL
  - external browser launch requires explicit operator action

<!-- MANAGED-SHOW-MACROS-END -->

MACRO: tsr (Legacy / Automated)
- note: Superseded by persistent TimestampHeaderRule codified in InvariantRules.md. Automated on every turn; manual macro invocation is deprecated.

MACRO: ar
- description: generate retrospective execution trace and error triage diagnostics report analogous to BC5-Resolution-Analysis.md
- syntax: ar [offset] | AnalyzeReasoning [offset]
- aliases: ar, AR, AnalyzeReasoning
- rules:
  - In an active Copilot or Antigravity chat, 'ar -From <quoted text>' -> executes 'ar -Auto -From <quoted text>'; the active host exports only its own current session to a temporary JSONL source via its dedicated provider, invokes the analyzer, and deletes the source afterward.
  - 'ar -TranscriptPath <file> -From <quoted text>' -> analyzes an explicit offline JSON or JSONL export.
  - Legacy numeric offsets require an explicit transcript path and remain a fallback only.
  - generates a structured report in LCM_Inventory/data/logs/ containing Execution Trace, Error Triage & Avoidance Matrix, and Decision Rationale


