# dani-home-pc-sounds

Claude Code plugin that plays a sound when Claude stops writing:

- `sounds/done.wav` when a turn finishes.
- `sounds/needs-input.wav` when Claude needs you: a permission prompt, a
  question dialog, or a final message whose last paragraph asks a question.

## Install

```sh
claude plugin marketplace add relatively-okay/dani-home-pc-sounds && claude plugin install dani-home-pc-sounds@dani-home-pc-sounds
```

## Dependency

Needs `python3` and one of `pw-play`, `paplay` or `aplay`.
