#!/bin/bash
# Hook entry point. $1 is "stop" or "needs-input"; the hook payload is on stdin.
# "stop" plays done.wav, unless Claude's last message ends by asking something,
# in which case it plays needs-input.wav like the other hooks do.
root="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
sound=done
if [ "$1" = needs-input ]; then
  cat >/dev/null
  sound=needs-input
elif python3 "$root/scripts/is-question.py"; then
  sound=needs-input
fi

# A prompt can fire more than one hook; play only the first within 2 seconds.
stamp="${XDG_RUNTIME_DIR:-/tmp}/dani-home-pc-sounds.last"
now=$(date +%s)
[ "$sound" = needs-input ] && [ $((now - $(cat "$stamp" 2>/dev/null || echo 0))) -lt 2 ] && exit 0
[ "$sound" = needs-input ] && echo "$now" > "$stamp"

for player in pw-play paplay aplay; do
  if command -v "$player" >/dev/null; then
    "$player" "$root/sounds/$sound.wav" </dev/null >/dev/null 2>&1 &
    break
  fi
done
exit 0
