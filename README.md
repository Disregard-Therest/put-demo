# «Путь» — демо-презентация прототипа (AmeliSoul)

Интерактивная демка: живой мобильный фрейм + панель пояснений по каждому экрану.

**Live:** https://disregard-therest.github.io/put-demo/

- Диплинк на шаг: `?step=3` — открыть сразу шаг 3; `?v=N` — сброс кэша Telegram при повторной отправке ссылки.
- Контент (все тексты приложения и панелей): `lib/data/mock_content.dart`.
- Скриптованные ответы Компаса: там же, `compassReplies`; абстракция под реальный API — `lib/services/curator_service.dart`.

## Редеплой

```bash
flutter build web --release --base-href /put-demo/   # в Git Bash: MSYS_NO_PATHCONV=1 перед командой
cp -r build/web/* docs/
git add -A && git commit -m "deploy" && git push
```

Pages раздаёт `docs/` с ветки `master`, обновляется за 1–2 минуты.
