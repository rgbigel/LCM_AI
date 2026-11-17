# How I Would Enforce LCM

Module: .claude/books/How-I-Would-Enforce-LCM.md  
Purpose: Book 3 - Claude's assessment of the Gemini proposal "Proposals for LCM Enforcements" (moving enforcement from rule prose to hooks, owned tools and ACP) against the current LCM setup, with a recommendation for the future enforcement CRP.  
Path: LCM_AI/.claude/books/How-I-Would-Enforce-LCM.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.7.4
Status: Draft (recommendation, no implementation)  
Date: 2026-11-16 17:57:18

---

## Reading Contract

- Commissioned 2026-11-16 by the operator during the baseline review: "a document that describes a future huge CRP ... formulate a recommendation document (another book)".
- Source: `D:\OneDrive\Documents\AI\Proposals for LCM Enforcements.pdf` (4 pages, printed 2026-11-15 12:58; a Gemini conversation with three operator prompts: terminology, better enforcement of DOX-based LCM with own tools, ACP/AHP).
- Yardstick: the operator's stated goal in that conversation - "use my own logic via my own tools to save AI involvement where this is a choice" - plus the decisions already taken (CRP-332 option B, CRP-339 compact rule set, D-21 SQLite authority, D-31 deferred absorption).
- Checked against the live setup (observed 2026-11-16 17:40): rule files, `.agents/` layout, `.claude/settings.json`, existence of the named gate tools, the Go source of `do.exe`. Claims I could not check are marked **unverified**.
- No code read beyond existence checks; no tool run besides read-only listings.

---

## Chapter 1 - The Proposal in One Paragraph

The model enforces deterministic rules through prose, and that wastes context and turns. Move every binary check (encoding, line endings, DOX `Date:`, forbidden commands, elevation routing, scope fences) into harness lifecycle hooks (PreToolUse / PostToolUse / Stop) served by one compiled Go router (`lcm-hook.exe`) that reads `proposals.db` / `tools.db` directly. Let the CLI and Control Hub own all state transitions and SemVer bumping. Keep only judgment invariants as rules (60-70 % smaller), move occasional procedures into skills, and optionally expose the databases through a small MCP server. In a second step, put an ACP proxy (`lcm-acp-proxy.exe`) between IDE and agent, or let the daemon itself be the ACP client for headless DOIT runs, so governance becomes vendor-neutral.

**How I understand it:** the right diagnosis with the enforcement point placed one layer too high. The proposal makes the AI harness the place where guarantees live. LCM already owns better places for guarantees: the commit, the push and the daemon.

---

## Chapter 2 - What the Proposal Gets Right

- **P-1 Prose cannot guarantee.** "A system prompt is a request; a harness hook is a guarantee." Correct, and it matches the operator's goal exactly. Several LCM rules exist only because an earlier prose rule was not kept (loop breaker, four-dimension FIXED, zero-assumption testing).
- **P-2 Take metadata away from the AI.** DOX `Date:` stamps and SemVer increments are pure functions of "which files changed in this commit cycle". The AI should never compute them. This is the single most valuable idea in the document.
- **P-3 State transitions belong to the CLI.** `BCR`, `COMPLETE`, `PUBLISH`, cohort actions and the two session macros are already tools; the proposal only says out loud that the chat should not be the transport.
- **P-4 Rules shrink to judgment.** Same direction as CRP-339 (D-30): one MUST/MUST NOT line per rule, rationale in `docs/`.
- **P-5 Self-modification loophole.** An agent trying to pass a failing gate can edit the gate, the hook config or the rules. A real gap; ADMINMODE (RULE-REV-011) is the existing anchor for closing it.
- **P-6 No pwsh in hot hooks.** PowerShell cold start per tool call is costly. Observed: Claude's current PostToolUse CRLF hook starts `pwsh` on every Write/Edit (already scheduled for removal by CRP-332).
- **P-7 Read-only DB access in process.** SQLite reads from Go cost milliseconds and do not depend on the daemon being up.

---

## Chapter 3 - Where I Disagree or Would Correct

- **C-1 Harness hooks as the primary layer (main correction).** Hooks are per host: three config formats, three event models, three sets of tool names, each changing with vendor releases. A hook only binds an agent that runs inside that harness with hooks enabled; a terminal, a script, Copilot in another mode or a human bypasses it. The operator already chose the opposite for CRP-332: "host-neutral, not host-specific; normalization runs incrementally at commit". The guarantee belongs at the choke points LCM owns: **commit** (`Submit-ReviewResult.ps1` + pre-commit gate), **push** (`Invoke-LCM_Push.ps1` + pre-push gate), **daemon** (`do.exe`). Harness hooks are then optional early feedback that saves a turn, never the guarantee.
- **C-2 PostToolUse `Date:` stamping on every edit.** It rewrites the header on each edit, adds diff noise in BCR and fights RULE-LCM-022 (one edit per file per turn). Stamping once at commit, for exactly the committed governed files, gives the same result with one write and fits "one increment per commit cycle".
- **C-3 Silent command rewriting (`updatedInput`).** Rewriting an admin command into `do.exe ... -elevated -sync` behind the agent's back makes the transcript lie about what ran. Deny with the exact replacement command costs one retry and stays traceable. I recommend deny-with-instruction on every host.
- **C-4 Antigravity "silent rule drop" claim - unverified, partly inapplicable.** Observed: all 21 rule files carry `name`, `description`, `globs: "*"` and no `trigger:` key, and they sit flat in `.agents/rules/` (the process/quality/lang tiers are logical only, so the nested-folder warning does not apply). Whether Antigravity ignores files without `trigger:` must be tested in Antigravity, not assumed; Antigravity has evidently been following these rules. CRP-339 already plans multiple frontmatter keys and can add `trigger:` cheaply if the test shows a need.
- **C-5 A second binary.** `do.exe` is already a Go program (`LCM_Inventory/src/do/`) with the gateway, catalog lookup and daemon. A `do.exe hook <event>` subcommand reuses its build, its `tools.db` access and its deployment path; a separate `lcm-hook.exe` doubles all three.
- **C-6 Stop hook running `Test-LCMIncrementalGovernance.ps1` each turn.** Too heavy per turn and again host-specific. The same check at commit (where it already belongs per RULE-DOC-009 gates) is enough; a turn-level check adds latency without adding a guarantee.
- **C-7 Scope fences "outside the active CRP".** Needs data that does not exist: a CRP declares `Affected-Repos`, not file paths. Repository-level fencing is possible now; path-level fencing needs a `scope_paths` field first.

---

## Chapter 4 - ACP and AHP

- **A-1 AHP:** agree with the proposal - VS Code internal, not cross-IDE; ignore.
- **A-2 ACP Pattern A (proxy between IDE and agent):** elegant on paper, three real limits named by the proposal itself: blind to tool calls of an agent in auto-approve mode, binary approve/deny only, and not spoken by native VS Code Copilot. A fourth for this workspace: Claude Code in VS Code runs its own harness, not an ACP agent behind the IDE (**unverified** whether the extension can be put behind ACP at all). It would not cover the two hosts the operator actually uses.
- **A-3 ACP Pattern B (daemon as ACP client for headless DOIT):** the interesting part. "Click DO CRP-nnn in the Control Hub, the daemon runs the agent with the Gate 0 spec, auto-decides permissions, runs readiness, stops at BCR" is a clean picture of DOIT. It is a large build (agent process lifecycle, permission policy engine, recovery) and depends on young protocol implementations (**unverified** maturity of `claude-agent-acp` / `gemini-cli` ACP modes on Windows).
- **Recommendation:** defer ACP until the owned choke points (Chapter 5, stages 1-3) exist. Then a time-boxed spike for Pattern B on one narrow headless job (for example a `-MinimalTests` BUG run), decided on evidence.

---

## Chapter 5 - Recommended Enforcement Architecture

Principle: **guarantee at the choke points LCM owns; give early feedback where it is cheap; leave only judgment to the AI.**

| Layer | Owner | Holds | Guarantee |
|:---|:---|:---|:---|
| L0 Commit gate | `Submit-ReviewResult.ps1`, pre-commit (`Test-ReviewCommitGate.ps1`) | line-ending/encoding normalization (CRP-332 B), syntax gate, DOX `Date:` stamp, SemVer increment, comment-deletion and spec-truncation audit | Yes, for every committer |
| L0 Push gate | `Invoke-LCM_Push.ps1`, pre-push hook | lockstep, Gate 2A at push, refusal of pushes not made through the tool | Yes |
| L1 Control plane | `do.exe` daemon / Control Hub / CLI | all lifecycle transitions, cohort actions, elevation routing | Yes, by construction |
| L2 Harness hooks (thin) | `do.exe hook <event>` per host adapter | deny raw `git commit`/`git push`, raw `BCompare.exe`, `powershell.exe`, admin tools outside DO, writes to rules/hooks/gate scripts without ADMINMODE | Early feedback only |
| L3 Rules | CRP-339 compact set | judgment invariants (Gate 0, question-response, ambiguity, scope discipline, MAC, audience boundaries) | No; that is their nature |
| L4 Skills | `.agents/skills/`, `.claude/skills/` | occasional procedures (5-stage triage, App synthesis, subsystem mutation pipeline) | No; loaded on demand |
| L5 Data access (optional) | read-only MCP over `proposals.db` / `tools.db` | typed tool and proposal queries | No; reduces errors |

Link to CRP-339: every rule in the compact set gets an `Enforced-by:` marker (`L0 commit`, `L1 tool`, `L2 hook`, or `judgment`). Rules with a mechanical owner shrink to a pointer and need not sit in always-on context; the marker is also a test target (a rule that claims `L0` must have a failing test when violated).

---

## Chapter 6 - Proposed Decomposition of the "Huge CRP"

Not one CRP but a cohort (COH, operator decision C): each item small enough to be live-tested on its own (Learned Advice "Gate 2 Pre-Review Live Testability"); the cohort completes as a whole with one joint BCR, after all members are done. Order = dependency order. Opens only when no other cohort is open (one open cohort, RULE-LCM-002).

| # | Item | Depends on | Size |
|:---|:---|:---|:---|
| E-1 | Enforcement inventory: classify every rule `L0`/`L1`/`L2`/`judgment` (inside CRP-339 or right after it) | CRP-339 | S |
| E-2 | Commit-time DOX ownership: `Date:` stamp + SemVer increment + syntax gate in the commit path, extending the CRP-332 normalizer; remove the matching instructions from the rules | CRP-332, E-1 | M |
| E-3 | Push guard: pre-push hook accepting only pushes made by `Invoke-LCM_Push.ps1` | - | S |
| E-4 | `do.exe hook` subcommand + Claude adapter (deny list of C-1/L2, ADMINMODE write lock); Antigravity adapter only after its hook support is verified | E-1 | M |
| E-5 | Self-modification lock: rules, hook configs, gate scripts writable only under ADMINMODE with the paths listed in the active CRP | E-4 | S |
| E-6 | Read-only LCM MCP server (possibly a daemon route) | - | M |
| E-7 | ACP spike, Pattern B, one headless job | E-2..E-4 | Spike |

Expected gains: the AI stops computing dates, versions and line endings (the largest source of review noise); forbidden routes fail before they run; the always-on rule text shrinks for every host at once.

---

## Chapter 7 - Risks

- **R-1 Commit-time mutation surprises the reviewer.** Stamping and normalizing after BCR changes bytes the operator did not see. Mitigation: mutate before the BCR snapshot (at handoff to Gate 2), or restrict post-review mutation to header `Date:`/`Version:` lines and record them in the receipt.
- **R-2 Gate bypass by `--no-verify`.** Git hooks are skippable (GoodNight once used `--no-verify`, ACTIVE_CONTEXT 2026-10-20). Mitigation: the push gate re-checks what the commit gate should have done; a push of a commit without receipt is refused.
- **R-3 Hook failure blocks work.** A broken L2 hook stops every tool call. Mitigation: fail open with a loud warning for L2 (it is feedback only); fail closed only at L0.
- **R-4 Two sources for one check.** If a check lives in both L0 and L2, they drift. Mitigation: L2 calls the same Go function the gate uses, or only denies (never checks content).

---

## Chapter 8 - Open Operator Decisions

- **A - DECIDED 2026-11-16 (operator): at commit** for committed governed files (C-2). Note: RULE-DOC-010 wording "any create/modify updates Date:" must be aligned in E-2.
- **B - DECIDED 2026-11-16 (operator): separate hook handler** (`lcm-hook.exe`), overriding C-5; it may still share Go packages with `do.exe`.
- **C - DECIDED 2026-11-16 (operator): a cohort of CRPs** after CRP-339 (E-1 inside CRP-339); the last member completes only when all others are done.
