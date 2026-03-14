# Self-Optimization Log

Track recurring patterns, improvements made, and things to watch.

## Patterns Detected

_(none yet)_

## Optimizations Made

_(none yet)_

## Anti-Patterns (Things to Avoid)

### ❌ Спавнить subagent без `agentId`
**Причина:** Без явного `agentId` subagent берёт модель main-агента (hunter-alpha, текстовая). Для vision-задач нужен researcher (healer-alpha, multimodal).
**Запомнить:** vision → `agentId: "researcher"`, код → `agentId: "coder"`

## Patterns Detected

### ✅ При указании на ошибку — проверяй, потом исправляй
Илья заметил, что researcher должен быть healer-alpha. Вместо спора — проверил конфиг, подтвердил, перезапустил. Успех за 13 секунд.
