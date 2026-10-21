# Requisites

Things the LCM workspace needs from the machine, declared as data.

| File | Purpose | Consumers |
|---|---|---|
| [external-tools.json](external-tools.json) | External tools, their install directories, whether they belong on the Machine PATH, and the Everything content-index settings | `LCM_Inventory/tools/Set-GitRoot.ps1` (applies PATH), `LCM_Inventory/tools/Test-ExternalTools.ps1` (verifies; called by the workspace readiness gate) |

Rules:
- The workspace root is read only from the Machine registry value `Git_Root`. Tools may then find everything else through PATH.
- To add an external tool: add an entry here, run `SetGitRoot` (elevated), then `Test-ExternalTools.ps1`.
