"""
Module: .claude/hooks/invoke_claude_eol_hook.py
Purpose: Claude Code PostToolUse hook (Write|Edit): applies the LCM line-ending policy to the file just written.
Path: LCM_AI/.claude/hooks/invoke_claude_eol_hook.py
Authors: Rolf, Claude (Anthropic)
Version: 10.7.4
Date: 2026-11-19
Implementation Choices (BUG-365): replaces Invoke-ClaudeCrlfHook.ps1; the policy itself lives only in
  LCM_Inventory/tools/Repair-LcmLineEndings.py (LF, CRLF for Windows-native types), found by walking up from this
  file (works through the root .claude junction).
Caveats: never blocks the tool call; every error is swallowed and the hook exits 0.
"""

import importlib.util
import json
import os
import sys


def find_tool():
    here = os.path.dirname(os.path.abspath(__file__))
    while True:
        candidate = os.path.join(here, 'LCM_Inventory', 'tools', 'Repair-LcmLineEndings.py')
        if os.path.isfile(candidate):
            return candidate
        parent = os.path.dirname(here)
        if parent == here:
            return None
        here = parent


def main():
    try:
        payload = json.loads(sys.stdin.read() or '{}')
        path = (payload.get('tool_input') or {}).get('file_path')
        tool = find_tool()
        if not path or not tool:
            return 0
        spec = importlib.util.spec_from_file_location('repair_lcm_line_endings', tool)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        module.repair_file(path, apply=True)
    except Exception:  # noqa: BLE001 - a hook must never block the tool call
        pass
    return 0


if __name__ == '__main__':
    sys.exit(main())
