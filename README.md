# TODO

https://github.com/homarr-labs/homarr

https://github.com/Wh1rr/ultimate-jellyfin-stack







# Local Media Stack (LMS)

![Docker Compose](https://img.shields.io/badge/docker-compose-2496ED?logo=docker&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-lightgrey)
![Status](https://img.shields.io/badge/status-self--hosted-informational)
![License](https://img.shields.io/badge/license-private-red)

Локальный self-hosted стек для автоматизации загрузки и просмотра медиа в LAN на базе Jellyfin + *arr.

## Оглавление

- [Возможности](#возможности)
- [Архитектура](#архитектура)
- [Требования](#требования)
- [Быстрый старт](#быстрый-старт)
- [Сервисы](#сервисы)
- [Первичная настройка](#первичная-настройка)
- [Управление](#управление)
- [Структура данных](#структура-данных)
- [Troubleshooting](#troubleshooting)

## Возможности

- Единая точка запросов контента через Seerr
- Автоматизированная цепочка поиска и загрузки (Prowlarr -> Radarr/Sonarr -> qBittorrent)
- Автоматическое пополнение библиотек Jellyfin
- Хранение конфигов и медиа на хосте через volumes

## Архитектура

Поток данных:

1. Пользователь отправляет запрос в Seerr.
2. Seerr создает задачу в Radarr/Sonarr.
3. Radarr/Sonarr отправляют задание в qBittorrent.
4. После завершения контент перемещается в `/media/*`.
5. Jellyfin индексирует и показывает контент в библиотеке.

## Требования

- Docker Engine
- Docker Compose (plugin `docker compose`)
- Доступ к LAN
- Достаточный объем диска для `data/` и `media/`

## Быстрый старт

1. Создайте структуру каталогов:

```bash
mkdir -p data/{jellyfin/config,jellyfin/cache,seerr,radarr/config,sonarr/config,prowlarr/config,qbittorrent/config,downloads,media/movies,media/tv,media/anime}
```

2. Запустите стек:

```bash
make up
```

3. Проверьте статус контейнеров:

```bash
make ps
```

## Сервисы

| Сервис | URL | Назначение |
|---|---|---|
| Jellyfin | http://localhost:8096 | Медиасервер и просмотр |
| Seerr | http://localhost:5055 | Запросы контента |
| Radarr | http://localhost:7878 | Управление фильмами |
| Sonarr | http://localhost:8989 | Управление сериалами/аниме |
| Prowlarr | http://localhost:9696 | Индексеры |
| qBittorrent | http://localhost:8080 | Загрузчик |

## Первичная настройка

### 1. Jellyfin

- Создайте администратора.
- Добавьте библиотеки:
  - `/media/movies`
  - `/media/tv`
  - `/media/anime`

### 2. qBittorrent

- Смените пароль `admin`.
- Укажите каталоги:
  - `/downloads/incomplete`
  - `/downloads/complete`

### 3. Radarr

- `Root Folder`: `/media/movies`
- `Download Client`: `qbittorrent:8080`
- Category: `radarr`

### 4. Sonarr

- `Root Folders`: `/media/tv`, `/media/anime`
- `Download Client`: `qbittorrent:8080`
- Category: `sonarr`

### 5. Prowlarr

- В `Settings -> Apps` добавьте Radarr и Sonarr.
- В `Indexers` добавьте нужные индексеры.

### 6. Seerr

- Jellyfin: `http://jellyfin:8096`
- Radarr: `http://radarr:7878`
- Sonarr: `http://sonarr:8989`

### 7. Проверка цепочки

1. Создайте запрос фильма или сериала в Seerr.
2. Проверьте появление задачи в Radarr/Sonarr.
3. Убедитесь, что началась загрузка в qBittorrent.
4. После завершения проверьте контент в Jellyfin.

## Управление

Запуск:

```bash
make up
```

Остановка:

```bash
make down
```

Перезапуск:

```bash
make restart
```

Статус:

```bash
make ps
```

Логи всего стека:

```bash
make logs
```

Список лог-файлов на диске:

```bash
make logs-list
```

Очистка лог-файлов (без удаления `*.db`):

```bash
make logs-clean
```

Обновление образов:

```bash
make update
```

## Структура данных

- `data/jellyfin/*` — конфиг и кэш Jellyfin
- `data/seerr/*` — конфиг Seerr
- `data/radarr/*` — конфиг Radarr
- `data/sonarr/*` — конфиг Sonarr
- `data/prowlarr/*` — конфиг Prowlarr
- `data/qbittorrent/*` — конфиг qBittorrent
- `data/downloads/*` — промежуточные и завершенные загрузки
- `data/media/movies/*` — фильмы
- `data/media/tv/*` — сериалы
- `data/media/anime/*` — аниме

## Troubleshooting

`Permission denied` в контейнерах:

- Проверьте UID/GID пользователя хоста: `id -u` и `id -g`
- Убедитесь, что `PUID`/`PGID` в compose совпадают с владельцем `data/`

Сервис недоступен по порту:

- Проверьте `docker compose ... ps`
- Проверьте логи контейнера: `docker logs <container_name> --tail 200`
- Убедитесь, что порт не занят другим процессом

Контент не появляется в Jellyfin:

- Проверьте root folders в Radarr/Sonarr
- Проверьте категории загрузки в qBittorrent
- Убедитесь, что в Jellyfin подключены правильные библиотеки
