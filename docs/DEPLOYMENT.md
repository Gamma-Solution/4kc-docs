# 4KC Deployment

## Ziel

Alle Deployments von 4KC erfolgen über Docker und Coolify auf der Zielplattform `srv120.4youhosting.ch`.

## Empfohlene Deployment-Strategie

Für Laravel + Filament + MariaDB + Redis wird ein eigenes Dockerfile empfohlen.

Empfohlen:

```text
backend/Dockerfile
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

## Nicht empfohlene Varianten als Dauerlösung

### Nixpacks

Geeignet für schnellen Smoke-Test, aber weniger ideal als dauerhafte Produktionsbasis.

Risiken:

- weniger explizite Kontrolle
- automatisches Erkennungsverhalten
- schwieriger zu debuggen bei PHP-Extensions, Vite oder Queue/Horizon-Themen

### Docker Compose

Geeignet für lokale Entwicklung oder Sonderfälle.

Für Coolify Production wird eine Service-Trennung bevorzugt:

- App als Deployment
- Worker als eigenes Deployment
- Scheduler als eigenes Deployment
- Horizon als eigenes Deployment
- MariaDB als Coolify Database Service
- Redis als Coolify Service

## Environments

Empfohlen:

```text
production
staging
```

Production:

- Branch: `main`
- eigene Datenbank
- eigener Redis
- eigene Volumes
- eigene ENV-Werte
- Deployment erst nach erfolgreichem Staging-Smoke-Test

Staging:

- Branch: `staging` oder `develop`
- eigene Datenbank
- eigener Redis
- eigene Volumes
- automatische Deployments möglich

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

Staging analog mit `-staging`.

## Startcommands

App:

```text
Webserver/PHP-FPM Startcommand gemäss Dockerfile
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

## Migrationen

Migrationen dürfen nicht im Dockerfile ausgeführt werden.

Richtig:

- Image bauen ohne Datenbankabhängigkeit
- Migrationen im kontrollierten Release-/Deploy-Schritt ausführen

Release-Schritt:

```text
php artisan migrate --force
```

Wichtig:

- `APP_KEY` einmalig pro Environment setzen und beibehalten
- `php artisan key:generate` nicht bei jedem Deployment ausführen
- Worker/Horizon/Scheduler nach Deployments neu starten

## Healthcheck

Empfohlen:

- Laravel `/up` oder eigener `/health` Endpoint
- Datenbank- und Redis-Checks getrennt betrachten
- Healthcheck öffentlich nur so weit wie nötig offenlegen

## GitHub-Anbindung

Empfohlen: Coolify GitHub App

Gründe:

- Least Privilege
- repo-spezifische Freigabe
- gute Webhook-Unterstützung
- besser wartbar als persönliche SSH Keys oder breit berechtigte Tokens

## ENV-Strategie

- `.env.example` im privaten Repository
- echte ENV-Werte nur in Coolify
- getrennte ENV-Werte pro Environment
- keine Secrets in GitHub
- keine Secrets in diesem öffentlichen Docs-Repository
