# dani-home-pc-sounds

Claude Code plugin that plays sounds for session events:

| Sound | Plays when |
|---|---|
| `done.wav` | a turn finishes |
| `needs-input.wav` | Claude needs you: a permission prompt, a question dialog, or a final message whose last paragraph asks a question |
| `idle.wav` | Claude has been waiting for your input for a while |
| `compact.wav` | the conversation is about to be compacted |
| `stop-failure.wav` | a turn ends in an API error instead of finishing |
| `session-end.wav` | the session ends |

## Install

```sh
claude plugin marketplace add relatively-okay/dani-home-pc-sounds && claude plugin install dani-home-pc-sounds@dani-home-pc-sounds
```

## Dependency

Needs `python3` and one of `pw-play`, `paplay` or `aplay`.
