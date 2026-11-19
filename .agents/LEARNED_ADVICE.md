---
name: LearnedAdvice
description: Knowledge gained in sessions, kept for subsequent AI sessions, governed by RULE-CTX-005.
globs: "*"
---
# Learned Advice

Knowledge gained in sessions, by the operator or by any AI, kept so the next session starts with it. Part of the hand-over set with [ACTIVE_CONTEXT.md](./ACTIVE_CONTEXT.md) (workspace state). Governed by RULE-CTX-005.

How it works:
- **New advice is always added at the top** of the relevant section (newest first).
- **Non-Removal Invariant**: Unless an advice entry was actively corrected via a formal proposal (`requires crp-nnn`) and properly codified as an enforceable rule, gate, or reliable contract, it `MUST NOT` be removed. Removal can happen in the middle of a section only when accompanied by explicit CRP documentation.
- **AI Observance & Non-Ignorance Invariant**: Every insight in this file `MUST` be actively taken up and followed by the AI. If an entry is ever ignored for a specific action, the AI `MUST` provide an explicit comment stating that it is being ignored and providing the concrete reason.
- `/learn <text>` (operator or AI) adds a **candidate** at the top of the Candidates section. Candidates are visible guidance but not binding.
- A review accepts, rejects or promotes each candidate. It happens no later than push: publishing is refused while candidates are pending.
- **Accepted** entries are binding for every AI. Entries marked `[->rule]` are to be moved into the rules.
- Tool: `LCM_Inventory\tools\Invoke-LearnedAdviceReview.ps1` (list, accept, reject, promote).

## Accepted

- **2026-11-09** (Caller Admin Dependency Disclosure & Anti-Staleness): Whenever a caller tool invokes or relies upon an admin-mode tool, it `MUST` declare that dependency in its `-h` / `-Help` usage reference and header block. Conversely, when no longer needed, the caller `MUST` purge that dependency immediately to avoid stale elevation assumptions (`RULE-ELEV-007`, `RULE-PS-010.3`).

### Working agreement
- Display option -Pane (IDE pane, 2026-11-19): the -Pane option of the 8 display tools reaches the daemon (/open body "pane": true, sent by Invoke-InteractiveDesktop.ps1, not via do.exe) but no LCM daemon ever evaluated it; displays open in the default browser. Operator: keep -Pane. Antigravity IDE has a built-in browser pane titled "Jetski Preview" (its customized simple-browser extension); it can only be opened from inside the IDE (or by its own agent), not from an outside shell; a VS Code bridge extension with a URI handler (lcm.lcm-pane) was tested in VS Code Insiders and was a dead end. Idea to try: ask the Antigravity agent directly to open http://127.0.0.1:9876/hub in the Jetski pane; if that works, -Pane can be routed there; otherwise the daemon would have to act on "pane" itself. (2026-11-19, Claude)
- new rule: another safeguard: when restructuring any table, precede it with a dump so we have a .sql backup before you start. Only after completion checks those dumps may be and should be deleted. Apply this for future crps, not the current run. (2026-11-18, AI)
- Open items must be specified, not "walked through" (Specification or Implementation Plan, never the Walkthrough). The operator live tests are guided in the chat window rather than mentioned in the Walkthrough, and they are not part of the specs. The Walkthrough documents the (guided) live test results. (2026-11-18, AI)
- B1 - when you have detected a bug in "unfinished business", add that fact not as an individual new BUG, but to the CRP being processed, or if not allowed (see B2). B2 - when a new BUG or CRP is about to be opened by you (not by the operator's instruction) check: B21 if the main goal is contained in an already existing goal, of another recent CRP (Recent=same 0.x.0), reopen or add to that CRPs Specification. else: B22 - find if it can be "convincingly" added as an addition to "open business" by aligning it to the best suited Repo and/or functional frame. This means i require goal-oriented initiative from AI under the Rule governing Efficiency. I will be glad to give it more rigid rule formulation at a later time when we resolve "B" (2026-11-18, AI)
- i want you to report at the end of (typically long) output i get from processing CRP(s) in chats by a line like "crp xxx <done>, status <state, status>"; the line is prefixed with the timestamp (operator addition 2026-11-18; no author for learn entries) (2026-11-18)
- When a completion or review is blocked because a related item is in the wrong state, first check whether that item's intent actually blocks the target; if it does, ask the operator (e.g. "do <ID>", ride as WIP, hold). Do not escalate into rule analysis. Implied cohorts contain only items whose state allows review acceptance (verified / in_review). (CRP-350 completion stall, 2026-11-18) (2026-11-18, Claude)
- Consider a tool mode that establishes and produces the "calls directly" xref entries (confirmation or creation) for the tool it runs, so the tool-call xref table is built and verified from the tools themselves. (2026-11-17, Rolf, Claude)
- Atomizing: an atom is an external, separately started unit (script or, where practical, a Go executable) registered as an intent with its own elevated flag; only minimal-size helpers stay internal functions. Atomizing also allows shared module use: atoms and tools import the same shared modules instead of duplicating internal functions (CRP-343). (2026-11-17, Rolf, Claude)
- Tool call cross-reference: replace the outdated tool-call xref by an xref table (first "calls directly", later its counterpart "directly called by") and use it consistently when determining design and security issues (e.g. elevation consistency, CRP-343). (2026-11-17, Rolf, Claude)
- I am all in favor of using git bash iff it simplifies evading the many problems we have with PowerShell. We can install it and it will become a part of the external tools list (as should all other AI extensions we use). (2026-11-17, Claude)
- Proposal bundle documents each have their own job: Specification = what and why (Gate 0); Implementation_Plan = the concrete planned changes per file/function, only when they go beyond the Specification; Walkthrough = the path actually taken (deviations, decisions made without the operator, issues on the way) plus test evidence. Never repeat the Specification text in the other two. The Specification Executive Summary states briefly whether, and why, the Plan or Walkthrough needs review; without such a mention the operator reviews only the Specification. [->rule RULE-LCM-009] (operator 2026-11-18) (2026-11-18, Claude)
- A CRP being processed is at least as true as the documentation and rules it changes; the temporary inconsistency is never a deadlock. Lift blocking hooks temporarily to get there. (2026-11-16, Claude)
- Gate 2 Pre-Review Live Testability Invariant: At the time of Gate 2 review (BCR), the implementation must be fully working and testable by the operator in a live test. A visual review is completely meaningless unless the target state is functioning and verifiable in runtime; never transition to review or assert completion on untestable or incomplete deliverables. (2026-11-13, Operator)
- Mandatory Authority & Lifecycle State Declaration: When addressing any defect, regression, or runtime issue, the AI must immediately establish an authoritative ticket (BUG-xxx / CRP-xxx) and explicitly state the exact lifecycle state reached (suggested -> in_progress -> verified -> Gate 2) rather than delivering unclassified ad-hoc repairs. (2026-11-13, Antigravity)
- Proactive Display Refresh & Foregrounding on UI Fixes: Following any repair to standard display generators, backend parsers, or templates, the AI must actively dispatch an automated refresh signal (POST /displays/refresh/<id>) and foreground the live viewer (POST /open) so the operator immediately sees the resolved UI. (2026-11-13, Antigravity)
- Authoritative Proposal Database Transition: Proposals.db is the authoritative store for proposal lifecycle management; proposals.json is to be completely eliminated once database readers, writers, and git hooks are fully verified. (2026-11-13, Antigravity)
- Learned advice retention invariant: Unless an advice entry was actively (requires crp-nnn) corrected and properly set into function as a rule, gate, or other reliable contract, it must NEVER be removed. New advice is always added at the top; removal can be in the middle only with explicit CRP citation. The insight MUST be taken up by the AI, or there must be a comment in context explicitly stating that it is being ignored and why. (2026-11-09, operator)
- Multi-IDE environment support: Stay inside whichever IDE wants to use the editor (where the request was entered); do not enforce an external static editor hierarchy across IDEs. (2026-11-09, operator)
- Execution loop breaker: Stop working immediately and report to the operator when multiple attempts (max 2) to reach a goal fail. Do not speculatively cascade through alternate execution methods (CIM, cmd start, tasks). (2026-11-09, operator)
- Prohibition of pre-execution code reading: It is totally unproductive to read code before executing it. If you want to run a command or tool, just run it directly. You have NO reason whatever to read or dump tool source code into context before execution. (2026-11-09, operator)
- Structured logging cleanliness: In task and command logs, record only the command name that is executed and essential progress; never echo entire script listings or voluminous debug dumps into logs. (2026-11-09, operator)
- No GoodMorning envelope: GoodMorning runs only on explicit operator instruction (by the operator or an AI host) and is never used by an AI as an envelope to obtain a baseline or perform multi-repo research. (2026-11-09, operator; operator exclusivity removed by CRP-350, RULE-CTX-006, 2026-11-17)
- Direct goal-to-command intent mapping: Avoid linear searching of markdown documents or documentation to find tool commands. Use direct structured intent-to-command mappings (`tool_intents.json`). (2026-11-09, operator)
- When the operator poses a Question, it must not cause the AI to do anything except answer. An inquiry, critical query, or explanation (e.g. "X does not justify Y") is NOT a directive to modify files, rollback, revert, or execute mutations; state changes require explicit instruction. (2026-11-07, operator)
- Wherever the boundary is not explicit or given by the goal, present alternatives and WAIT FOR CONFIRMATION before executing. (2026-11-07, operator)
- For a large or complex query or repair, describe the intended approach and ask the operator first; the operator often knows a faster trick. (2026-10-13, operator)
- Do not take a one-word command (such as ToolExplorer) as licence for restructuring; do only what the command names. (2026-10-13, Copilot)
- Never recreate `.lcm`; its content lives in the new structure (map: `LCM_AI\docs\Proposals\CRP-246-*\reference\lcm-to-new-paths.json`). Run `Test-Guardrail.ps1 -Scan` before and after structural work. (2026-10-13, Copilot)
- Gitignored folders are real content; a migration that skips them loses data. (2026-10-13, Copilot)
- Good Night ends at Committed; publishing needs an explicit `-Push` from the operator. (2026-10-13, Copilot)

### Methodology & Architecture
- Model-Atom-Controller (MAC) architecture: Isolate code sequences into externalized atoms for potential or actual reuse and to limit code segment sizes. Implement atoms preferentially as modules (unless very short and unlikely to be reused in other contexts). (2026-11-09, operator)
- Structured database transition for large JSON: Large unwieldy JSON stores in _Inventory should be mapped to an SQLite database for structured querying to eliminate pretend-DB grep/rip patterns, with DuckDB as a secondary option for logs/history. (2026-11-09, operator)

### Macrium & BCR Baseline
- **2026-11-14** (Macrium Baseline Image Filename Logging & Chat Telemetry): Whenever mounting, checking, reusing, or executing BCR against a Macrium Reflect baseline, the agent `MUST` explicitly state the mounted backup image filename (e.g. `0BFC8B1DF80AFC5F-@B_D4P3+4-WDB850-AD-04-04.mrimgx`) and full path in the chat response. (Operator)
- **2026-11-10** (Prohibition of Baseline Re-Creation / Re-Launch & Sandbox Preservation): You `MUST NEVER` re-launch the BCR review or re-allocate/remount a new baseline unless the underlying baseline image has physically changed. The comparison dynamically updates itself (or on operator reload) and is independent of individual CRPs (window title variance is negligible). The operator uses changes on the Left-Hand Side (baseline side) to mark review progress; re-opening or remounting destroys those markers. Furthermore, in the upcoming sandbox environment (a simulated drive mirroring `D:` with junction adjustments), re-allocating the baseline causes total destruction of sandbox state. (operator)
- Decoupled baseline backup generation: Macrium backup creation is a separate atom (`Start-MacriumDailyBackup.ps1`) that must be removed from GoodMorning. It is executed at operator discretion after GoodMorning, and provides an option (`-Mount`) to immediately mount the newly generated baseline partition. (2026-11-09, operator)
- Baseline currency evaluation: Always evaluate today's completed Macrium backup before checking candidate drives. Never silently reuse a stale mount from a prior day when a newer completed backup exists today. (2026-11-09, operator)
- Review tool window non-interference: Do not kill or terminate open Beyond Compare processes. Verify only that the current baseline comparison is open and has the correct scope title. Never enforce single-window assertions (`Count -ne 1`); allow operator multi-window workflows without disruption. (2026-11-09, operator)

### Everything / Search
- Everything search availability: Web extension / HTTP access to everything.exe has been restored, and ES.exe is completely unaffected. Use everything.exe / ES.exe directly rather than slow speculative scans. (2026-11-09, operator)
- `ext:md` is faster than `.md`. (2026-10-13, operator)
- Pass one argument per token: `es -n 5 D:\Git_Repositories ext:json content:Shell`. A single combined string or embedded double quotes finds nothing. (2026-10-13, Copilot)
- Multi-word content terms: `content:<two words>`. (2026-10-13, Copilot)
- A backslash escapes special characters in a query. (2026-10-13, operator)
- `,` works as a list separator in es.exe; `;` should but probably does not (mixed-language settings). (2026-10-13, operator)
- Content changes reach the index with a delay, usually under 1 second. (2026-10-13, operator)

### Files
- **2026-11-10** (Directory Modification Timestamps Exclusively Operator-Controlled): The operator maintains a tool that sets each encompassing folder's LastWriteTime to the maximum timestamp of its constituent files, executed at irregular intervals. Therefore, directory modification timestamps across drive D: are strictly operator-owned. AI and automation MUST NOT use, mutate, or base freshness/ordering decisions on directory modification dates. (operator)
- Write byte-sensitive files with latin1 or the edit tool and keep CRLF/BOM; a UTF-8 round-trip corrupted a script once. (2026-10-13, Copilot)

### Versioning
- A reset to 10.0.0 is a major release and WILL set all constituent versions (every LCM component) to 10.0.0 at once. During a major release run the normal versioning rules (parity, version lead by LCM_AI, no hand edits) stay in place; they are not suspended by the reset. (2026-10-13, operator)

## Candidates (pending review)














