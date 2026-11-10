# version: 10.2.0

Module: version-consistency-check.md
Purpose: Defines workspace documentation and operational rules for version-consistency-check.
Path: D:/Git_Repositories/LCM_AI/docs/version-consistency-check.md
Authors: Rolf
Version: 10.2.0
Changelog:
- 2026-10-13: Updated to LCM Version 10.0.0 with M.Y.Z Major Version Alignment Invariant (RULE-DOC-005).
- 2026-10-13: Bumped to LCM pre-release Version 4.1.0.
- 2026-10-13: Normalized Markdown metadata header.

CHECK: MAJOR-VERSION (LCM Solution-Wide Parity)
- .agents/rules/*.md
- .github/agents/Config.json
- .github/agents/agent.json
- .github/agents/copilot365-agent.json
- .vscode/settings.json
- LCM_AI/docs/*.md
- tools/README.md
- Child repos LCM_Inventory/config.json (absorbed_lcm_version)
EXPECT: identical MAJOR ($M = \text{LCM\_MAJOR}$)

CHECK: MINOR-VERSION
- durable-memory & component specs: preserve component-level evolution ($Y$)
EXPECT: non-breaking differences preserved across modules

CHECK: PATCH-VERSION
- revision-cycle: patch-only increments ($Z$)
EXPECT: patch increments preserved across modules

CHECK: VERSION-FORMAT
EXPECT: MAJOR.MINOR.PATCH (SemVer)

CHECK: VERSION-ORDER
EXPECT: no skipped major numbers upon workspace releases



