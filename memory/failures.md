# Failures & Self-Learning Log

Every failure gets logged here. No excuses, no sugar-coating. This is how we get better.

## Format

```
### YYYY-MM-DD — <short title>
**What happened:** (what went wrong, factual)
**Root cause:** (why it went wrong)
**Fix:** (what changed to prevent recurrence)
**Status:** open | resolved
```

---

## Log

### 2026-03-15 — Vision hallucination: вместо power bank увидел кошку
**What happened:** Пользователь прислал фото power bank (зелёный, с LED-дисплеем). Модель дважды "увидела" на фото кошку породы Манчкин и описала её в деталях (бежевая, коротколапые, круглое лицо). Причём настаивала на этом при проверке. Ресерчер правильно определил — power bank.
**Root cause:** Галлюцинация vision-модуля. Модель получила image data, но интерпретировала её неправильно, придумав несуществующий объект с деталями. Возможная причина — модель hunter-alpha плохо справляется с vision-задачами, или image encoding проходит некорректно.
**Fix:** Ilya разбирается с проблемой самостоятельно (2026-03-15 03:36). Возможно связано с тем, что hunter-alpha не поддерживает vision, или image data не доходит корректно. **UPDATE 03:57:** Корневая причина найдена — я не указывал `agentId: "sherlock"` при спавне, поэтому subagent запускался с hunter-alpha (текстовая). Правильный вызов с `agentId: "sherlock"` → healer-alpha → vision работает за 13 секунд.
**Status:** resolved

---

### 2026-03-15 — Неправильный агент при делегировании vision-задачи
**What happened:** При запросе "опиши картинку" спавнул researcher-сабагента БЕЗ `agentId`. Subagent запустился с дефолтной моделью main-агента (hunter-alpha, текстовая) вместо healer-alpha (vision). Описание не удалось.
**Root cause:** Не знал / забыл, что `sessions_spawn` без `agentId` берёт дефолтную модель main-агента, а не конфиг исследователя. Агент researcher настроен отдельно с `openrouter/healer-alpha`.
**Fix:** Всегда указывать `agentId: "sherlock"` при делегировании vision/исследовательских задач. Запомнить: researcher → healer-alpha (vision), coder → hunter-alpha.
**Status:** resolved

---

### 2026-03-15 — Правильная реакция на ошибку агента
**What happened:** Когда vision-делегирование не сработало, Илья сказал "у ресерчера должна быть healer-alpha". Вместо того чтобы спорить, я проверил конфиг, подтвердил, и перезапустил с правильным `agentId`. Результат — успех за 13 секунд.
**Root cause:** _(позитивный паттерн)_
**Fix:** Фиксирую как положительный паттерн: при указании пользователя на ошибку — сначала проверяй, потом исправляй. Не спорь с Ильёй по поводу инфраструктуры.
**Status:** resolved
