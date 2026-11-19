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
Implementation Choices (BUG-370): every error and every 'failed' result of repair_file is appended to
  LCM_Inventory/logs/claude-eol-hook.log (timestamp, file, reason); the hook still exits 0, so a line-ending problem
  never interrupts the tool call and nothing is shown in chat. LCM_EOL_HOOK_LOG overrides the log path (tests).
Caveats: never blocks the tool call (exit 0). Only a failure to write the log itself stays unrecorded; the log is a
  mechanical artifact (RULE-EFF-001, logs/*.log).
"""

import datetime
import importlib.util
import json
import os
import sys
import traceback


def find_upward(*parts):
    """Walks up from this file until <dir>/<parts...> exists; returns that path or None."""
    here = os.path.dirname(os.path.abspath(__file__))
    while True:
        candidate = os.path.join(here, *parts)
        if os.path.exists(candidate):
            return candidate
        parent = os.path.dirname(here)
        if parent == here:
            return None
        here = parent


def log_error(path, reason):
    log_path = os.environ.get('LCM_EOL_HOOK_LOG')
    if not log_path:
        inventory = find_upward('LCM_Inventory')
        if not inventory:
            return
        log_path = os.path.join(inventory, 'logs', 'claude-eol-hook.log')
    try:
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        stamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(log_path, 'a', encoding='utf-8', newline='\n') as handle:
            handle.write('[' + stamp + '] [ERROR] ' + str(path) + ' | ' + ' '.join(str(reason).split()) + '\n')
    except OSError:
        pass  # the one case that stays unrecorded (see Caveats)


def main():
    path = None
    try:
        payload = json.loads(sys.stdin.read() or '{}')
        path = (payload.get('tool_input') or {}).get('file_path')
        if not path:
            return 0
        tool = find_upward('LCM_Inventory', 'tools', 'Repair-LcmLineEndings.py')
        if not tool:
            log_error(path, 'Repair-LcmLineEndings.py not found above ' + os.path.abspath(__file__))
            return 0
        spec = importlib.util.spec_from_file_location('repair_lcm_line_endings', tool)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        result = module.repair_file(path, apply=True)
        if result.get('status') == 'failed':
            log_error(path, 'repair failed: ' + result.get('reason', ''))
    except Exception:  # noqa: BLE001 - a hook must never block the tool call; the error is logged instead
        log_error(path, traceback.format_exc(limit=3))
    return 0


if __name__ == '__main__':
    sys.exit(main())
