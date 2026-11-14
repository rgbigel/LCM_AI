---
paths:
  - "**/*.html"
  - "**/*.css"
  - "**/*.js"
---
# File: DisplayStandardsPolicy.md

Module: .claude/rules/lang/DisplayStandardsPolicy.md  
Purpose: Claude adapter projection of DisplayStandardsPolicy (RULE-DSP-001..016).  
Path: LCM_AI/.claude/rules/lang/DisplayStandardsPolicy.md  
Source: .agents/rules/DisplayStandardsPolicy.md v10.2.0 @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-14 22:07:25

---

- Reference standard: `LCM_Inventory/assets/CM_CONTROL_HUB_IMPLEMENTATION_0.html`.
- **RULE-DSP-001** Fonts: IBM Plex Mono (technical), IBM Plex Sans (UI). Canonical light tokens: `--canvas #edf1ef`, `--surface #ffffff`, `--surface-soft #f6f8f7`, topbar `#132b33`, gold `#d8a840`, `--ink #172127`, `--muted #5d6b72`, `--line #ccd5d1`, `--line-strong #aab8b2`, blue/green/amber/red/violet with soft variants; no hardcoded colors.
- **RULE-DSP-002** Light mode default; Light/Dark switch persisted in `localStorage('lcm_theme')`, instant toggle in the topbar.
- **RULE-DSP-003** Topbar (slate, gold border, app switcher, live version pill, centered search, sync dot, theme/refresh/help/back); single control row; status rail `suggested -> in_progress -> verified -> in_review -> completed -> pushed` plus filter toggles for `held`, `withdrawn`, `rejected`, `superseded`.
- **RULE-DSP-004** Sticky headers; selected rows soft fill + 3px left indicator; optional two-row header (titles+sort / filters).
- **RULE-DSP-005** Lucide SVG icons with local bundle/fallback; 32px targets.
- **RULE-DSP-006** Tokenized search with `Column:value`, `Column:!value`, `!term` (`LcmTableEngine`); live match counter.
- **RULE-DSP-007** Print: `@page` margins, repeating `thead`, `break-inside: avoid`; headless Edge `--print-to-pdf`.
- **RULE-DSP-008** GUI dispatch to Session 1 via the DO gateway (`do.exe` / `do.cmd`, RULE-PS-011, RULE-ELEV-006); `Invoke-InteractiveDesktop.ps1` retired; no direct background `Start-Process`; artifacts container-agnostic (browser or IDE canvas); clean up own stale test windows, but never operator-owned Beyond Compare windows (`_LCM` profile, BCR sessions; RULE-REV-012).
- **RULE-DSP-009** WPF/WinForms dialogs mirror tokens; secret fields with show/hide; Escape closes; center on active monitor.
- **RULE-DSP-010** Tray apps: single-instance mutex, `Dispose()` on exit, STA thread.
- **RULE-DSP-011** Execution ledger timeline `suggested -> in_progress -> verified -> in_review -> completed -> pushed`; bulk cohort panel validates the whole selection.
- **RULE-DSP-012** Console tags `[INFO] [WARN] [ERROR] [ACTION] [SUMMARY]`; progress via `LCM_Shared/LcmProgressAtom.psm1`.
- **RULE-DSP-013** Keys: F5 refresh, Escape close, `/` or Ctrl+F focus search.
- **RULE-DSP-014** Per-Monitor DPI V2 for native GUIs; web min-width 1440px.
- **RULE-DSP-015** Static templates separate from JSON data; no large embedded blobs.
- **RULE-DSP-016** Show dual provenance `(LCM-Show: vX.Y.Z Template: vA.B.C)`; `v<M>.<m>.<p>` without `vv`; no static versions in templates; optional tool/SHA/mode context.
- [Claude] Claude does not publish LCM displays as claude.ai artifacts; displays are served via `127.0.0.1:9876`.
