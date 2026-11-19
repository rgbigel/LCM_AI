# File: SubsystemGovernancePolicy.md

Module: .claude/rules/process/SubsystemGovernancePolicy.md  
Purpose: Claude adapter projection of SubsystemGovernancePolicy (subsystem classification, subsystem inventories, hardware interlocks, JIT authentication, log segregation, update gate, registry non-mutation, LCM_Inventory exclusivity).  
Path: LCM_AI/.claude/rules/process/SubsystemGovernancePolicy.md  
Source: .agents/rules/SubsystemGovernancePolicy.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **RULE-SUB-001** A `subsystem` (classified in `data/inventory.json`) implements tripartite docs and `install/Installation.md`; root inventory tracks it at Git level only.
- **RULE-SUB-002** Subsystems keep `data/subsystem_inventory.json` and `docs/SUBSYSTEM_DASHBOARD.md`, reconciled by `tools/Update-<Subsystem>Inventory.ps1`; telemetry runs are auto-accepted (RULE-EFF-001).
- **RULE-SUB-003** Physical disk operations target only disks validated by serial and model declared in the subsystem's `docs/Requirements.md`, run `Assert-DiskTargetSafety` (never Boot/System/PageFile), and need elevation plus explicit operator confirmation.
- **RULE-SUB-004** Read-only auditor credentials in git-ignored `LCM_Inventory/secrets.json`; write access only via JIT ephemeral sessions held in RAM, never on disk or in logs; mutations via the 5-stage pipeline (snapshot -> BC visual payload gate -> atomic API dispatch -> tiered health polling -> rollback on failure). [Claude] Claude never reads or prints `secrets.json` contents.
- **RULE-SUB-005** `cm_activity.log` gets macro milestones only; granular events in `<Subsystem>/logs/subsystem_activity.log` and `api_traffic.log`; regex-redact auth headers, tokens, passwords.
- **RULE-SUB-006** Update engine extracts breaking changes and creates risk-ordered CRPs in `data/proposals/`; accepted CRPs form `data/bundles/BUNDLE-YYYYMMDD.json`; mandatory pre-update backup (abort on failure); execute under JIT auth with tiered polling and rollback.
- **RULE-SUB-007** Subsystem internal registries (e.g. HA `.storage/`) are never mutated from outside; CM tools are read-only observers; corrections only by the operator in the subsystem UI. [Claude] Home Assistant MCP access is read-only and stays so.
- **RULE-SUB-008** Proposals about governed `LCM_*` repos live only in `LCM_Inventory`; no `Proposals/`, `DoT/`, `scratch/` in other `LCM_*` repos; governed list `LCM_AI`, `LCM_Inventory`, `LCM_Shared`, `LCM_Supervision`, `LCM_Tools`; disjunct subsystems (e.g. `HaSSD06` with `HaSSD06_Inventory`, `SystemConfiguration`) may keep their own stores.
