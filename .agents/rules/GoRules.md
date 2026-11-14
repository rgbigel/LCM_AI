---
name: GoRules
description: Automated code generation and refactoring rules for Go source files.
globs: "*.go"
---
# File: GoRules.md

Module: GoRules  
Purpose: Automated AI agent governance directive and strict coding constraints for Go source code generation and refactoring.  
Path: .agents/rules/GoRules.md  
Authors: Rolf, LCM_AI  
Version: 10.3.0
Status: Authoritative Invariant Rule  
Date: 2026-11-14 22:00:00

---

# Directive for AI Agents: Go Code Generation Standards

You are operating as an automated coding engine within this workspace. When generating, updating, or refactoring Go source files, you MUST strictly adhere to the following rules without exception.

## 1. Mandatory File Header Block
Every `.go` file generated must start with this exact comment structure prior to the `package` statement. Compute the filename, date (YYYY-MM-DD), and description accurately:

/*
================================================================================
FILE NAME      : <filename>.go
PACKAGE        : <packagename>
DESCRIPTION    : <precise description of file responsibility>
AUTHOR         : <author name>
DATE CREATED   : <YYYY-MM-DD>
LAST MODIFIED  : <YYYY-MM-DD>
VERSION        : <MAJOR.MINOR.PATCH>
GO VERSION     : 1.22+
ENCODING       : UTF-8 (No BOM)
================================================================================
CHANGE LOG:
<YYYY-MM-DD> - <VERSION>: Initial implementation.
================================================================================
*/

## 2. Automated Generation Constraints

### 2.1 Error Handling & Control Flow
- NEVER ignore returned errors. Discarding errors via `_ = fn()` is strictly forbidden for I/O, OS, processes, and network operations.
- ALWAYS wrap errors using `%w` when bubbling errors up boundaries:
  `return fmt.Errorf("<context>: %w", err)`
- NEVER access fields or defer cleanup methods on returned objects before validating that `err == nil`.
- NEVER generate `panic()` in application logic or libraries. Restrict panics solely to package-level initialization (`regexp.MustCompile`).

### 2.2 Resource Discipline
- NEVER generate `defer` statements inside loop iterations. Extract the loop body into an explicit helper function or handle close calls imperatively.
- Defer calls requiring dynamic or exit-time arguments MUST be enclosed in anonymous closures:
  `defer func() { ... }()`

### 2.3 Memory, Slices & Types
- NEVER take the address of the loop value variable (`&item`) in a `range` loop. Always index the slice directly: `&items[i]`.
- When generating structs that serialize to JSON arrays, initialize empty slices with `make([]T, 0)` so they serialize to `[]` instead of `null`.
- Structs containing `sync.Mutex` or `sync.RWMutex` MUST always use pointer receivers (`func (s *Service) ...`). Never pass mutexes by value.

### 2.4 Windows OS & Platform Rules
- NEVER concatenate filesystem paths with string operators (`+` or `fmt.Sprintf`). Always use `filepath.Join(...)`.
- NEVER pass unsanitized single-string command lines to shells. Always pass discrete argument slices using `exec.CommandContext(ctx, name, arg1, arg2, ...)`.
- All generated files must be UTF-8 without Byte Order Marks (BOM).

### 2.5 Indentation & Formatting
- All Go source code MUST use hard tabs for indentation in accordance with standard Go formatting enforced by `gofmt`.
- In accordance with the Language Deference Hierarchy (`InvariantRules.md`), this Go language standard takes strict precedence over the workspace-wide 2-space default indentation.
