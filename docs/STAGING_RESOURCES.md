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

## GitHub App

Die private GitHub App für die Organisation `Gamma-Solution` ist in Coolify sichtbar.

```text
Name: gamma-solution
UUID: dvd2a6ejflgjw5bfd50lssmv
Organization: Gamma-Solution
Public: false
Repository Scope: Gamma-Solution/4kc-panel
```

## Laravel Staging App

```text
Name: 4kc-app-staging
UUID: zenvhebnteqtepn0ivzix7e2
Repository: Gamma-Solution/4kc-panel
Branch: staging
Base Directory: /backend
Build Pack: dockerfile
Dockerfile Location: /backend/Dockerfile
Ports Exposes: 8080
Healthcheck Path: /up
Auto Deploy: false
Generated Preview URL: http://zenvhebnteqtepn0ivzix7e2.62.116.178.120.sslip.io
Status nach Anlage: exited:unhealthy
```

Hinweis:

- Der Status `exited:unhealthy` ist vor dem ersten erfolgreichen Deployment erwartbar.
- Der erste Build wurde per API versucht, ist aber am aktuellen Coolify-Token gescheitert, weil die Permission `deploy` fehlt.
- Es wurden keine Production-Ressourcen verändert.
