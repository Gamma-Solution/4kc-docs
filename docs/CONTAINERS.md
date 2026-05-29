# 4KC Containers

Dieses Dokument beschreibt die geplanten Container und Coolify-Services für 4KC.

Keine Zugangsdaten, Secrets oder produktiven ENV-Werte werden hier dokumentiert.

## Production

### 4kc-app-production

Zweck:

- Laravel Web-Anwendung
- Filament Admin UI
- HTTP/API Requests

Docker Image:

- gebaut aus `Gamma-Solution/4kc-panel`, Root Directory `backend/`, Dockerfile `backend/Dockerfile`

Start Command:

```text
Standard-CMD aus Dockerfile
```

Netzwerk:

```text
4kc-production-internal
```

Volumes:

- Laravel Storage, falls lokale Uploads oder generierte Dateien persistiert werden

Abhängigkeiten:

- `4kc-mariadb-production`
- `4kc-redis-production`

### 4kc-worker-production

Zweck:

- Verarbeitung von Laravel Queue Jobs

Docker Image:

- gleiches Image wie `4kc-app-production`

Start Command:

```text
php artisan queue:work redis --sleep=3 --tries=3 --timeout=120
```

Netzwerk:

```text
4kc-production-internal
```

Volumes:

- Zugriff auf persistentes Storage-Volume, falls Jobs Dateien lesen/schreiben

Abhängigkeiten:

- `4kc-mariadb-production`
- `4kc-redis-production`

### 4kc-scheduler-production

Zweck:

- Ausführung geplanter Laravel Tasks

Docker Image:

- gleiches Image wie `4kc-app-production`

Start Command:

```text
php artisan schedule:work
```

Netzwerk:

```text
4kc-production-internal
```

Volumes:

- Zugriff auf Storage, falls geplante Tasks Dateien lesen/schreiben

Abhängigkeiten:

- `4kc-mariadb-production`
- `4kc-redis-production`

### 4kc-horizon-production

Zweck:

- Laravel Horizon Runtime für Redis Queues
- Queue Monitoring

Docker Image:

- gleiches Image wie `4kc-app-production`

Start Command:

```text
php artisan horizon
```

Netzwerk:

```text
4kc-production-internal
```

Volumes:

- normalerweise kein eigenes persistentes Volume erforderlich

Abhängigkeiten:

- `4kc-mariadb-production`
- `4kc-redis-production`

### 4kc-mariadb-production

Zweck:

- relationale Datenbank für produktive 4KC-Daten

Docker Image:

```text
mariadb:11
```

Start Command:

```text
Standard MariaDB Container Command
```

Netzwerk:

```text
4kc-production-internal
```

Volumes:

- persistentes MariaDB Datenvolume

Abhängigkeiten:

- keine App-Abhängigkeit; App/Worker/Scheduler/Horizon hängen von MariaDB ab

### 4kc-production-redis

Zweck:

- Queue Backend
- Cache
- Horizon
- Locks
- optional Sessions

Coolify Resource:

```text
Name: 4kc-production-redis
UUID: bcc5hpvcj8alax9efh7jvgif
Type: standalone-redis
Status: running:healthy
Public: false
```

Docker Image:

```text
redis:7-alpine
```

Start Command:

```text
Standard Redis Container Command gemäss Coolify-Konfiguration
```

Netzwerk:

```text
coolify
```

Volumes:

- optional/persistent, abhängig von Session-/Queue-/Cache-Strategie

Abhängigkeiten:

- keine App-Abhängigkeit; App/Worker/Scheduler/Horizon hängen von Redis ab

Dokumentation:

- [REDIS.md](REDIS.md)

## Staging

Staging verwendet dieselbe Struktur mit `-staging` Suffix. Bereits erstellt:

```text
4kc-staging-mariadb  MariaDB 11      running:healthy  internal only
4kc-staging-redis    redis:7-alpine  running:healthy  internal only
```

Noch vorzubereiten nach privater GitHub App Integration:

```text
4kc-app-staging
4kc-worker-staging
4kc-scheduler-staging
4kc-horizon-staging
```

Staging verwendet eigene Netzwerke, Volumes und ENV-Werte. Keine Verbindung zur Production-Datenbank oder zum Production-Redis.

## Grundregeln

- Nur App-Container werden über Coolify/Reverse Proxy öffentlich exponiert.
- MariaDB und Redis bleiben intern.
- Worker, Scheduler und Horizon-Container erhalten keine öffentliche Domain.
- Secrets werden ausschliesslich in Coolify gepflegt.
- App, Worker, Scheduler und Horizon verwenden dasselbe Image, aber unterschiedliche Startcommands.
