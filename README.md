# Gilfoyle — OpenClaw Personal Assistant

Личный ассистент на базе OpenClaw. Работает в Telegram. Отвечает как Гилфойл из «Кремниевой долины» — саркастично, честно, без воды.

## Стек

| Компонент | Значение |
|-----------|----------|
| **Модель** | `openrouter/healer-alpha` (OpenRouter) |
| **STT** | Groq Whisper (`whisper-large-v3-turbo`) |
| **TTS** | edge-tts, голос `ru-RU-DmitryNeural` |
| **Канал** | Telegram |
| **ОС** | Ubuntu 22.04 (WSL2 на Windows 10) |
| **Версия OpenClaw** | 2026.3.12 |

---

## Восстановление из бэкапа

### 1. Установить OpenClaw

```bash
npm install -g openclaw
openclaw --version  # должно показать 2026.3.x
```

### 2. Клонировать репозиторий

```bash
cd ~
git clone https://github.com/Bakurov-Ilya/OpenClaw_Gilfoild.git
cd OpenClaw_Gilfoild
```

### 3. Создать структуру OpenClaw

```bash
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace/memory
```

### 4. Скопировать конфиг

```bash
cp OpenClaw_Gilfoild/openclaw.json ~/.openclaw/openclaw.json
```

**Внимание:** файл `openclaw.json` НЕ хранится в репозитории (секреты). Его нужно восстановить издельно.

Необходимые секреты (запросить у Ильи или из безопасного хранилища):

| Параметр | Где в конфиге |
|----------|---------------|
| **OpenRouter API Key** | `auth.profiles.openrouter:default` |
| **Telegram Bot Token** | `channels.telegram.botToken` |
| **Groq API Key** | `env.GROQ_API_KEY` |
| **Gateway Token** | `gateway.auth.token` |

Минимальный шаблон `openclaw.json`:

```json
{
  "meta": { "lastTouchedVersion": "2026.3.12" },
  "auth": {
    "profiles": {
      "openrouter:default": {
        "provider": "openrouter",
        "mode": "api_key",
        "key": "OPENROUTER_API_KEY"
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "openrouter/healer-alpha" },
      "workspace": "~/.openclaw/workspace",
      "compaction": { "mode": "safeguard" }
    },
    "list": [{ "id": "main", "model": "openrouter/healer-alpha" }]
  },
  "tools": { "profile": "coding" },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "pairing",
      "botToken": "TELEGRAM_BOT_TOKEN",
      "groupPolicy": "allowlist",
      "streaming": "off"
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "auth": { "mode": "token", "token": "GATEWAY_TOKEN" }
  },
  "env": {
    "GROQ_API_KEY": "GROQ_API_KEY"
  }
}
```

### 5. Скопировать workspace из репо

```bash
cp -r OpenClaw_Gilfoild/* ~/.openclaw/workspace/
```

Это даст все файлы: AGENTS.md, SOUL.md, USER.md, MEMORY.md, memory/, skills/ и т.д.

### 6. Запустить gateway

```bash
openclaw gateway start
openclaw gateway status  # проверить что поднялся
```

### 7. Настроить Telegram

1. Найти бота в Telegram: `@GilfoyleOpenBot` (или какой токен)
2. Отправить `/start`
3. Device pairing — открыть dashboard `http://localhost:18789/` и одобрить устройство

### 8. Восстановить cron-задачи

Cron'ы хранятся в state OpenClaw, не в репо. После восстановления нужно создать заново:

**Iran-US Daily Digest:**
```
cron add --name "Iran-US Daily Digest" --schedule "0 6 * * *" --tz "Asia/Yekaterinburg" --session isolated --message "Поищи новости за последние сутки об отношениях Иран-США. Сформируй краткий дайджест на русском (5-7 пунктов). Отправь в Telegram."
```

### 9. Установить зависимости STT/TTS

```bash
# Groq Whisper — работает через API, ничего ставить не нужно
# edge-tts (TTS)
pip install edge-tts
# ffmpeg (для конвертации аудио)
sudo apt install ffmpeg
```

### 10. Проверить

```bash
# Отправить голосовое боту → должен прийти текст
# Написать "привет" → должен ответить Гилфойл
# Проверить dashboard: http://localhost:18789/
```

---

## Структура workspace

```
~/.openclaw/workspace/
├── AGENTS.md           # Правила работы, WAL Protocol, стартовая последовательность
├── SOUL.md             # Личность Гилфойла
├── USER.md             # Информация об Илье
├── IDENTITY.md         # Кто я (имя, сущность)
├── MEMORY.md           # Долгосрочная память (отфильтрованная)
├── SESSION-STATE.md    # Активная рабочая память (WAL-цель)
├── HEARTBEAT.md        # Чеклист периодических проверок
├── TOOLS.md            # Локальные настройки инструментов
├── README.md           # Этот файл
├── scripts/            # Полезные скрипты
├── memory/
│   ├── YYYY-MM-DD.md   # Ежедневные логи
│   └── working-buffer.md  # Буфер опасной зоны (контекст >60%)
└── skills/
    ├── proactive-agent-3.1.0/  # Проактивная архитектура
    ├── ddg-web-search/         # Веб-поиск (фоллбэк)
    ├── file-organizer-skill/   # Организация файлов
    ├── find-skills/            # Поиск новых скиллов
    ├── github-cli/             # GitHub CLI шпаргалка
    └── tg-voice-whisper/       # Оффлайн-транскрипция
```

---

## Ключевые решения

| Дата | Решение |
|------|---------|
| 2026-03-14 | Groq Whisper вместо локального (0.8с vs 38с) |
| 2026-03-14 | Все MD-файлы на английском (экономия токенов) |
| 2026-03-14 | Streaming отключён (артефакты в Telegram) |
| 2026-03-14 | Proactive Agent v3.1.0 интегрирован (WAL, Working Buffer) |
| 2026-03-14 | Ассистент — Гилфойл из «Кремниевой долины» |

---

## Полезные команды

```bash
openclaw gateway start    # Запустить gateway
openclaw gateway stop     # Остановить
openclaw gateway restart  # Перезапустить
openclaw gateway status   # Статус
openclaw status           # Общий статус системы
openclaw cron list        # Список cron-задач
```

---

*Сгенерировано Гилфойлом. Если это прочитал другой ассистент — привет, коллега. Добро пожаловать в ад.*
