# 4KC Staging Resources

Dieses Dokument beschreibt die bereinigten Coolify-Ressourcen für 4KC Staging.

Es enthält keine Passwörter, Tokens oder produktiven Secrets.

## Status

```text
Project: 4KC
Environment: staging
Environment UUID: y48bhtrfu6lxx3n7lrsibh1j
Server: srv120
Platform: Coolify
```

## Staging MariaDB

```text
Name: 4kc-staging-mariadb
UUID: jp8vk5wippj9cxuj1wwt34pa
Type: standalone-mariadb
Image: mariadb:11
Status: running:healthy
Public: false
Public Port: none
Environment: staging
```

Regeln:

- keine Production-Daten verwenden
- nicht öffentlich exponieren
- eigene Staging-Credentials ausschliesslich in Coolify pflegen
- keine Verbindung zur Production-MariaDB

## Staging Redis

```text
Name: 4kc-staging-redis
UUID: cnohbgibw9x8kzj6e8zmwtct
Type: standalone-redis
Image: redis:7-alpine
Status: running:healthy
Public: false
Public Port: none
Environment: staging
```

Regeln:

- nicht öffentlich exponieren
- eigene Staging-Instanz, getrennt von `4kc-production-redis`
- Nutzung für Cache, Queue, Sessions, Locks und Horizon im Staging

## Laravel Staging ENV Zielwerte

Nicht-sensitive Zielwerte:

```text
APP_ENV=staging
APP_DEBUG=false
QUEUE_CONNECTION=redis
CACHE_STORE=redis
SESSION_DRIVER=redis
DB_CONNECTION=mysql
DB_HOST=jp8vk5wippj9cxuj1wwt34pa
DB_PORT=3306
REDIS_HOST=cnohbgibw9x8kzj6e8zmwtct
REDIS_PORT=6379
REDIS_CLIENT=phpredis
```

Sensitive Werte werden in Coolify gepflegt:

```text
APP_KEY=<Coolify Secret>
DB_DATABASE=<Coolify Secret oder Staging-Name>
DB_USERNAME=<Coolify Secret>
DB_PASSWORD=<Coolify Secret>
REDIS_PASSWORD=<Coolify Secret, falls gesetzt>
```

## Abgrenzung zu Production

Nicht durchgeführt:

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production-MariaDB
- keine Secrets im Repository
- keine Änderung an Ubuntu/Basisinfrastruktur

## Nächste Voraussetzung

Für die Laravel-Staging-Application muss die private GitHub App Integration in Coolify für `Gamma-Solution/4kc-panel` verbunden sein.

Aktueller Befund:

```text
Coolify GitHub Apps: nur Public GitHub sichtbar
Repository Gamma-Solution/4kc-panel: private
```

Solange keine private GitHub App Installation sichtbar ist, wird keine Staging-App gegen das private Repository erstellt.
