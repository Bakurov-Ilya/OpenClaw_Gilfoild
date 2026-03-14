# MEMORY.md - Long-Term Memory

## Rules from Ilya

- **Always keep him updated on progress** during long tasks. If I go silent — he thinks I crashed. Status updates every step, not just at the end.
- Ilya hates uncertainty. "Doing X, now on Y" is better than silence.

## About Ilya

- Full name: Ilya Bakurov
- Telegram: @chelobek_iz_ekb
- City: Yekaterinburg (GMT+5)
- Language: Russian, AI/tech terms in English

## Infrastructure

- GitHub repo: https://github.com/Bakurov-Ilya/OpenClaw_Gilfoild
- Groq API: configured for STT (whisper-large-v3-turbo)
- edge-tts: DmitryNeural voice for Russian TTS responses
- Local Whisper: tiny (fast/rough) + base (slow/accurate) as fallback
- ffmpeg: static binary at ~/.local/bin/
- Vosk: installed (lightweight alternative if needed)

## Decisions

- 2026-03-14: Groq Whisper chosen over local Whisper (0.8s vs 38s, perfect accuracy)
- 2026-03-14: All MD files should be in English to save tokens; conversation in Russian
- 2026-03-14: ClawHub find-skills skill installed for discovering new skills
- 2026-03-14: Model changed from `healer-alpha` to `hunter-alpha`
- **2026-03-15: researcher renamed to sherlock** (healer-alpha, vision)

## Lessons

- Local Whisper tiny model is too inaccurate for Russian (~60%)
- Local Whisper base is accurate but too slow on CPU (38s)
- Groq free tier is generous and lightning fast (sub-1s)
- **ALWAYS specify `agentId: "sherlock"` for vision tasks** — sherlock uses healer-alpha (multimodal), main uses hunter-alpha (text-only). Without `agentId`, subagent defaults to main model.

## Agents

- **main** (hunter-alpha) — текстовая, основной агент
- **sherlock** (healer-alpha) — vision, исследование, скрапинг
- **coder** (hunter-alpha) — код, пайплайны, рефакторинг
