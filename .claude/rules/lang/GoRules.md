---
paths:
  - "**/*.go"
---
# File: GoRules.md

Module: .claude/rules/lang/GoRules.md  
Purpose: Claude adapter projection of LCM-RULE-GO-001 (Go header block and generation constraints).  
Path: LCM_AI/.claude/rules/lang/GoRules.md  
Source: .agents/rules/GoRules.md v10.3.0 (LCM-RULE-GO-001) @ LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted)  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4  
Status: Draft  
Date: 2026-11-14 22:07:25

---

- **GO-1 Header** Every `.go` file starts, before `package`, with the `/* === ... === */` block: FILE NAME, PACKAGE, DESCRIPTION, AUTHOR (`<author name>`), DATE CREATED, LAST MODIFIED, VERSION (`<MAJOR.MINOR.PATCH>`), GO VERSION (1.22+), ENCODING (UTF-8, no BOM), CHANGE LOG (`<YYYY-MM-DD> - <VERSION>: ...`).
- **GO-2.1 Errors** Never discard errors from I/O, OS, process or network calls; wrap with `fmt.Errorf("<context>: %w", err)`; never use results or defer cleanup before `err == nil`; no `panic()` outside package init.
- **GO-2.2 Resources** No `defer` inside loops; exit-time arguments in `defer func() { ... }()`.
- **GO-2.3 Memory/Types** Never `&item` of a range variable (use `&items[i]`); JSON arrays from `make([]T, 0)`; types with `sync.Mutex`/`RWMutex` use pointer receivers.
- **GO-2.4 Windows** Paths via `filepath.Join`; commands via `exec.CommandContext(ctx, name, args...)`; UTF-8 without BOM.
- **GO-2.5 Indentation** Hard tabs as enforced by `gofmt`; takes precedence over the 2-space default (language deference).
- Syntax gate (INVARIANT-RULES): `go vet` / `go build`.
