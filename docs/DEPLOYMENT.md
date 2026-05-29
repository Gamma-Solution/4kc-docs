# 4KC Deployment

## Ziel

Alle Deployments von 4KC erfolgen über Docker und Coolify auf der Zielplattform `srv120.4youhosting.ch`.

## Empfohlene Deployment-Strategie

Für Laravel + Filament + MariaDB + Redis wird ein eigenes Dockerfile verwendet.

```text
backend/Dockerfile
backend/.dockerignore
```

Coolify App Root:

```text
backend/
```

## Warum eigenes Dockerfile?

- kontrollierte PHP-Version
- kontrollierte PHP-Extensions
- reproduzierbares Build-Verhalten
- geeignet für Production und Staging
- gleiche Image-Basis für App, Worker, Scheduler und Horizon
- transparenter als Nixpacks für ein langfristiges Produktionssystem

## Coolify Build-Konfiguration

Empfohlen für alle Laravel-basierten Services:

```text
Source Repository: Gamma-Solution/4kc-panel
Root Directory: backend
Build Pack / Build Type: Dockerfile
Dockerfile: backend/Dockerfile
```

Production:

```text
Branch: main
Environment: production
Domain: produktive 4KC Domain
```

Staging:

```text
Branch: staging oder develop
Environment: staging
Domain: staging 4KC Domain
```

## Services

Production:

```text
4kc-app-production
4kc-worker-production
4kc-scheduler-production
4kc-horizon-production
4kc-mariadb-production
4kc-redis-production
```

Staging:

```text
4kc-app-staging
4kc-worker-staging
4kc-scheduler-staging
4kc-horizon-staging
4kc-mariadb-staging
4kc-redis-staging
```

## Startcommands

App:

```text
Standard-CMD aus Dockerfile
```

Worker:

```text
php artisan queue:work redis --sleep=3 --tries=3 --timeout=120
```

Scheduler:

```text
php artisan schedule:work
```

Horizon:

```text
php artisan horizon
```

## Runtime ENV

Produktive Werte werden ausschliesslich in Coolify gepflegt.

Wichtige Variablen:

```text
APP_NAME
APP_ENV
APP_KEY
APP_DEBUG
APP_URL
LOG_CHANNEL
LOG_LEVEL
DB_CONNECTION
DB_HOST
DB_PORT
DB_DATABASE
DB_USERNAME
DB_PASSWORD
REDIS_HOST
REDIS_PASSWORD
REDIS_PORT
CACHE_STORE
QUEUE_CONNECTION
SESSION_DRIVER
MAIL_MAILER
MAIL_HOST
MAIL_PORT
MAIL_USERNAME
MAIL_PASSWORD
MAIL_ENCRYPTION
MAIL_FROM_ADDRESS
MAIL_FROM_NAME
```

Keine echten Werte in dieses öffentliche Repository eintragen.

## Release-Schritte

Migrationen dürfen nicht im Dockerfile ausgeführt werden.

Richtig:

1. Image bauen
2. Container mit Coolify ENV starten
3. Migration kontrolliert ausführen
4. Caches optimieren
5. Worker/Horizon/Scheduler neu starten

Empfohlene Release Commands:

```text
php artisan migrate --force
php artisan optimize
```

Bei Problemen:

```text
php artisan optimize:clear
```

## Healthcheck

Empfohlen:

```text
/up
```

oder ein eigener Health Endpoint.

Datenbank- und Redis-Abhängigkeiten sollten getrennt geprüft werden, damit ein reiner HTTP-Healthcheck nicht unnötig instabil wird.

## Nicht empfohlene Varianten als Dauerlösung

### Nixpacks

Geeignet für schnellen Smoke-Test, aber weniger ideal als dauerhafte Produktionsbasis.

### Docker Compose

Geeignet für lokale Entwicklung oder Sonderfälle.

Für Coolify Production wird eine Service-Trennung bevorzugt:

- App als Deployment
- Worker als eigenes Deployment
- Scheduler als eigenes Deployment
- Horizon als eigenes Deployment
- MariaDB als Coolify Database Service
- Redis als Coolify Service

## GitHub-Anbindung

Empfohlen: Coolify GitHub App für Organisation `Gamma-Solution`.

Gründe:

- Least Privilege
- repo-spezifische Freigabe
- gute Webhook-Unterstützung
- besser wartbar als persönliche SSH Keys oder breit berechtigte Tokens
