# Parent Workspace: Solution.code-workspace

**Mirrored From**: `D:\VSCode-Workspaces\Solution.code-workspace`
**Mirrored At**: 2026-09-04
**LCM Version**: V10.0.0
**Purpose**: Authoritative mirror of the parent VS Code workspace configuration into LCM documentation hierarchy for governance transparency and session context recovery.

---

## 1. Workspace File Location

| Property | Value |
| :--- | :--- |
| **File Path** | `D:\VSCode-Workspaces\Solution.code-workspace` |
| **Type** | VS Code Multi-Root Workspace |
| **Governance Role** | Parent infra container — references `D:\Git_Repositories` as primary root |

---

## 2. Workspace Folder Structure

The workspace registers the following root folders:

| # | Path | Role |
| :-- | :--- | :--- |
| 1 | `D:/Git_Repositories` | **Primary** — LCM workspace root; all governed repositories, `LCM_Inventory/`, `.agents/`, tooling. |
| 2 | `D:/OneDrive/cmd` | **Supplementary** — OneDrive-synced CLI scripts and user-level command files. |
| 3 | `C:/Temp` | **Transient** — Temporary scratch space; not governance-tracked. |
| 4 | `../OneDrive/cmd/runtimes` | **Runtimes** — Relative reference to OneDrive-synced runtime binaries. |

---

## 3. Workspace Settings (Relevant Excerpt)

```json
{
  "folders": [
    { "path": "D:/Git_Repositories" },
    { "path": "D:/OneDrive/cmd" },
    { "path": "C:/Temp" },
    { "path": "../OneDrive/cmd/runtimes" }
  ],
  "settings": {
    "chat.tools.terminal.autoApprove": {
      "...regex patterns for pre-approved terminal commands...": {
        "approve": true,
        "matchCommandLine": true
      }
    }
  }
}
```

> [!NOTE]
> The `chat.tools.terminal.autoApprove` settings contain regex patterns for specific pre-approved command sequences. These are omitted here for brevity but are present in the source file and control interactive terminal authorization in VS Code's Copilot/Chat tooling.

---

## 4. Governance Alignment Notes

### 4.1 Version Invariant
- The canonical LCM version is **`V10.0.0`**, tracked in:
  - [`.agents/ACTIVE_CONTEXT.md`](file:///D:/Git_Repositories/.agents/ACTIVE_CONTEXT.md) — `Governance Framework: Lifecycle Model (LCM V10.0.0)`
  - [`.agents/ACTIVE_SESSION.md`](file:///D:/Git_Repositories/.agents/ACTIVE_SESSION.md) — `LCM Version: V10.0.0`
- Header-level version metadata in `.ps1` files is left to quality-management (`QM`) tools and is **not** directly bumped during workspace-level version increments.

### 4.2 Pre-Push Enforcement
- The pre-push pipeline via [`Workspace_Inventory/tools/Invoke-WorkspacePush.ps1`](file:///D:/Git_Repositories/Workspace_Inventory/tools/Invoke-WorkspacePush.ps1) enforces that all LCM subsystems are pushed **simultaneously** ([RULE-LCM-005](file:///D:/Git_Repositories/.agents/rules/ProposalReviewFlowPolicy.md)).
- The `Update-Gemini` pipeline is triggered automatically as Step 0 before push ([RULE-LCM-013](file:///D:/Git_Repositories/.agents/rules/ProposalReviewFlowPolicy.md)).

### 4.3 Parent Workspace Metadata Alignment
- This `LCM_AI/docs/Parent_Workspace_Solution.md` document must be updated whenever `Solution.code-workspace` changes its `folders` array or registers new pre-approved terminal patterns.
- Tooling update: `Sync-LCMResearchSnapshot.ps1` mirrors the `docs/Architecture/` directory to `D:\GDrive\LCM` for cloud-accessible context.

---

## 5. Related Architecture Documents

| Document | Path |
| :--- | :--- |
| LCM Subsystem Architecture | [`LCM_AI/docs/LCM_Subsystem_Architecture.md`](file:///D:/Git_Repositories/LCM_AI/docs/LCM_Subsystem_Architecture.md) |
| Active Context | [`.agents/ACTIVE_CONTEXT.md`](file:///D:/Git_Repositories/.agents/ACTIVE_CONTEXT.md) |
| Active Session | [`.agents/ACTIVE_SESSION.md`](file:///D:/Git_Repositories/.agents/ACTIVE_SESSION.md) |
| Proposal Review Flow Policy | [`.agents/rules/ProposalReviewFlowPolicy.md`](file:///D:/Git_Repositories/.agents/rules/ProposalReviewFlowPolicy.md) |
