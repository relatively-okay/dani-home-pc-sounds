#!/usr/bin/env python3
"""Exit 0 if the Stop hook payload on stdin ends with Claude asking something.

"Asking" means the last paragraph of the final assistant message, ignoring
code blocks, contains a question mark.
"""
import json
import re
import sys


def last_message(payload):
    text = payload.get("last_assistant_message")
    if text:
        return text
    # Older payloads lack the field: fall back to the transcript.
    try:
        with open(payload["transcript_path"]) as f:
            lines = f.readlines()
    except (KeyError, OSError):
        return ""
    for line in reversed(lines):
        try:
            entry = json.loads(line)
        except ValueError:
            continue
        if entry.get("type") != "assistant":
            continue
        content = entry.get("message", {}).get("content", [])
        if isinstance(content, str):
            return content
        text = "\n".join(b.get("text", "") for b in content if b.get("type") == "text")
        if text.strip():
            return text
    return ""


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 1
    text = re.sub(r"```.*?```", "", last_message(payload), flags=re.S)
    text = re.sub(r"`[^`\n]*`", "", text)
    paragraphs = [p for p in re.split(r"\n\s*\n", text) if p.strip()]
    return 0 if paragraphs and "?" in paragraphs[-1] else 1


sys.exit(main())
