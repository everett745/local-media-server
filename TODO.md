# TODO

## A. Обязательное для Phase 1
- [ ] Утвердить финальные API-контракты (`auth`, `titles`, `import-by-url`, `preload`, `availability`).
- [ ] Подготовить Dockerfile для `web`, `api`, `worker`.
- [ ] Поднять docker-compose для `web/api/worker/postgres/redis`.
- [ ] Поднять media-stack (`jellyfin/jellyseerr/radarr/sonarr`, опционально `prowlarr`).
- [ ] Добавить healthchecks и порядок запуска контейнеров.
- [ ] Проверить запуск в чистом окружении одной командой `docker compose up -d`.
- [ ] Настроить интеграцию API -> Jellyseerr.
- [ ] Реализовать sync статусов загрузки в БД.
- [ ] Сделать UI кнопки `Предзагрузить` и статусов.
- [ ] Добавить переход к просмотру в Jellyfin (LAN URL).
- [ ] Настроить мониторинг ошибок очереди и интеграций.
- [ ] Написать smoke/e2e для ключевого потока:
  - поиск тайтла,
  - preload,
  - появление статуса `available`.

## B. Технический долг
- [ ] Кэширование популярных тайтлов.
- [ ] Идемпотентность `preload` запросов.
- [ ] Dead-letter queue для неуспешных sync-задач.
- [ ] Админ-инструмент merge дублей тайтлов.

## C. Phase 2 (optional, Yamtrack)
- [ ] Принять решение: `Yamtrack` или свой трекинг.
- [ ] Если Yamtrack: определить модель интеграции (SSO/sync).
- [ ] Сделать mapping users и titles по external IDs.
- [ ] Добавить feature flag `yamtrack_integration_enabled`.
- [ ] Реализовать reconciliation статусов между системами.
- [ ] Добавить rollback-план отключения интеграции.
