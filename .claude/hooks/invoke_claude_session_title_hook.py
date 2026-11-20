"""
File: invoke_claude_session_title_hook.py

Module: .claude/hooks/invoke_claude_session_title_hook.py
Purpose: SessionStart hook; names a newly started Claude Code session after its start timestamp.
Path: LCM_AI/.claude/hooks/invoke_claude_session_title_hook.py
Authors: Rolf, Claude (Anthropic)
Version: 10.7.4
Status: Draft
Date: 2026-11-20

Rationale: Claude Code accepts hookSpecificOutput.sessionTitle from a SessionStart
hook. Only source 'startup' is titled; resumed, cleared or compacted sessions
keep their existing name.
"""

import sys
sys.stdout.reconfigure(encoding='utf-8')

import datetime  # noqa: E402
import json  # noqa: E402


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (ValueError, OSError):
        payload = {}
    if payload.get('source', 'startup') != 'startup':
        return 0
    title = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    result = {
        'hookSpecificOutput': {
            'hookEventName': 'SessionStart',
            'sessionTitle': title,
        }
    }
    sys.stdout.write(json.dumps(result))
    return 0


if __name__ == '__main__':
    sys.exit(main())
