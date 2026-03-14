# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## Runtime Environment

- OS: Ubuntu 22.04 in WSL2 on Windows 10
- Workspace: `/home/ilya/.openclaw/workspace/`
- Config: `/home/ilya/.openclaw/openclaw.json`
- Gateway port: 18789
- Node manager: `npm` (user install via `--prefix ~/.local`)

## WSL2 Notes

- GUI requires `DISPLAY` set or WSLg
- Windows drives: `/mnt/c/`, `/mnt/d/`
- Open files in IDE: `code <file>`
- **Never suggest** nano/vim for file editing — user uses VS Code

## TTS

- Engine: edge-tts (free, Microsoft Azure)
- Russian male voice: `ru-RU-DmitryNeural`
- Russian female voice: `ru-RU-SvetlanaNeural`
- Output: mp3 → ffmpeg convert to ogg for Telegram

## STT

- Primary: Groq Whisper (`whisper-large-v3-turbo`) — fast, accurate
- Fallback: local OpenAI Whisper (`base` model on CPU)
- Helper script: `scripts/groq-transcribe.sh`
- Languages: Russian primary, auto-detect others

## SSH / Network

- No SSH configured yet
- Dashboard: `http://172.28.34.175:18789/` (LAN bind, insecure auth enabled)

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes.
