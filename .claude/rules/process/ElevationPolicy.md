# File: ElevationPolicy.md

Module: .claude/rules/process/ElevationPolicy.md  
Purpose: Claude adapter projection of ElevationPolicy (elevation metadata, guarded self-elevation, anti-drift, elevated tests, console persistence, privilege-aware routing, admin dependency disclosure).  
Path: LCM_AI/.claude/rules/process/ElevationPolicy.md  
Source: .agents/rules/ElevationPolicy.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-ELEV-001** Repository elevation is declared by an `Elevation: Administrator` or `Elevation: User` line in the repository's root `AGENTS.md` (or top-level manifest; absent = `User`); `Invoke-LCM_Audit.ps1` / `Create-LCM_Baseline.ps1` aggregate it into `LCM_Inventory/data/inventory.json` (`ElevationRequired`, `MinimumPrivilege`, `ElevationReason`). Tool-level elevation: `tools.admin` in `data/tools/tools.db` (`config/tool_catalog.json` transition fallback). Non-elevated: `false`, `"User"`, `"Standard user execution"`.
- **RULE-ELEV-002** Self-elevation in `src/`/`Source/` MUST detect non-interactive environments, offer `-NoElevation`/`-ForceInProcess`, and never block CI/IDE/background runners on UAC.
- **RULE-ELEV-003** Privileged commands (`bcdedit`, `fltmc`, `fsutil`, `Get-Partition`, `DiskPart`, `Add-BitLockerKeyProtector`, `Verb RunAs`) require `Elevation: Administrator` in the repository's `AGENTS.md` (reflected as `ElevationRequired: true` in `inventory.json`, `tools.admin: 1` per tool); `Assert-RepoElevationConsistency` validates code against `AGENTS.md` and fails on undeclared privileged code.
- **RULE-ELEV-004** Repos with `ElevationRequired: true` in `inventory.json` provide `tools/Invoke-ElevatedTest.ps1` (in-process when elevated, else elevated worker writing `out/test_results.json`); gates certify from that evidence.
- **RULE-ELEV-005** Elevated consoles MUST stay open (`-NoExit` / `/k` / explicit prompt); the caller shows a pre-launch banner (timestamp, method, target and arguments, audit log path, window-mode notice); the worker prints a completion notice.
- **RULE-ELEV-006** Never run an admin tool directly in an un-elevated or agent shell: look up `tools.admin` in `LCM_Inventory/data/tools/tools.db` (via `Show-ToolIntents.ps1`; JSON catalog transition fallback), check current elevation, run non-admin tools directly, route admin tools via the DO gateway `LCM_Inventory\DoT\do.exe "<command>" -elevated -sync` (or `do.cmd`; daemon `127.0.0.1:9876/execute`; if offline, direct elevated dispatch); elevated consoles keep `-NoExit`/`/k`. `Invoke-PrivilegedTool.ps1` and `Invoke-InteractiveDesktop.ps1` are retired. [Claude] Claude's shell is un-elevated: always DO for admin tools.
- **RULE-ELEV-007** A caller depending on an admin tool MUST declare it in `-h` (`PREREQUISITES:` / `ADMIN DEPENDENCIES:`) and its header (`.DEPENDENCIES`), and remove both when the dependency goes away.
