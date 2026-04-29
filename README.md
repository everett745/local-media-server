# Media Stack

Локальный стек для предзагрузки и просмотра контента в LAN:
- Jellyfin (просмотр)
- Seerr (запросы/каталог)
- Radarr (фильмы)
- Sonarr (сериалы/аниме)
- Prowlarr (индексеры)
- qBittorrent (загрузчик)

## Быстрый старт

1. Подготовить папки:
```bash
mkdir -p data/{jellyfin/config,jellyfin/cache,jellyseerr,radarr/config,sonarr/config,prowlarr/config,qbittorrent/config,downloads,media/movies,media/tv,media/anime}
```

2. Поднять стек:
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

3. Открыть сервисы:
- Jellyfin: http://localhost:8096
- Seerr: http://localhost:5055
- Radarr: http://localhost:7878
- Sonarr: http://localhost:8989
- Prowlarr: http://localhost:9696
- qBittorrent: http://localhost:8080

## Обязательная первичная настройка

### 1. Jellyfin:
- создать admin
- добавить библиотеки:
  - `/media/movies`
  - `/media/tv`
  - `/media/anime`

### 2. qBittorrent:
- сменить admin password
- папки загрузки:
  - `/downloads/incomplete`
  - `/downloads/complete`

### 3. Radarr:
- root folder: `/media/movies`
- download client: `qbittorrent:8080`, category `radarr`

### 4. Sonarr:
- root folders: `/media/tv`, `/media/anime`
- download client: `qbittorrent:8080`, category `sonarr`

### 5. Prowlarr:
- добавить Sonarr/Radarr в `Settings -> Apps`
- добавить индексеры в `Indexers`

### 6. Seerr:
- подключить Jellyfin (`http://jellyfin:8096`)
- подключить Radarr (`http://radarr:7878`)
- подключить Sonarr (`http://sonarr:8989`)

## Проверка end-to-end

1. В Seerr запросить фильм/сериал.
2. Проверить, что заявка появилась в Radarr/Sonarr.
3. Проверить загрузку в qBittorrent.
4. После завершения файл должен появиться в Jellyfin библиотеке.

## Управление

Запуск:
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

Остановка:
```bash
docker compose -f infra/docker/docker-compose.yml down
```

Логи сервиса:
```bash
docker logs nts-jellyseerr --tail 100
```
