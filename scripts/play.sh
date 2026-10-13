#!/bin/bash
# Hook entry point. $1 names the sound in sounds/ to play; the hook payload is
# on stdin. The special name "stop" plays done.wav, unless Claude's last message
# ends by asking something, in which case it plays needs-input.wav.
root="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
sound="$1"
if [ "$sound" = stop ]; then
  sound=done
  python3 "$root/scripts/is-question.py" && sound=needs-input
else
  cat >/dev/null
fi

# A prompt can fire more than one hook; play only the first within 2 seconds.
if [ "$sound" = needs-input ]; then
  stamp="${XDG_RUNTIME_DIR:-/tmp}/dani-home-pc-sounds.last"
  now=$(date +%s)
  [ $((now - $(cat "$stamp" 2>/dev/null || echo 0))) -lt 2 ] && exit 0
  echo "$now" > "$stamp"
fi

# setsid detaches the player so it survives the session exiting (SessionEnd).
for player in pw-play paplay aplay; do
  if command -v "$player" >/dev/null; then
    setsid "$player" "$root/sounds/$sound.wav" </dev/null >/dev/null 2>&1 &
    break
  fi
done
exit 0
