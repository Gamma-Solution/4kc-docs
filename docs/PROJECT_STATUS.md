# 4KC Project Status

Dieses Dokument zeigt den öffentlichen, bereinigten Projektstand.

Legende:

```text
[✓] erledigt / vorhanden
[~] in Arbeit / teilweise vorhanden
[ ] geplant / offen
```

## Infrastructure

```text
[✓] srv120 als Zielplattform
[✓] Ubuntu 24.04.4
[✓] Docker
[✓] Coolify
[✓] SSL / DNS
[✓] MariaDB
[✓] Redis
[✓] Staging Environment
[ ] Production Deployment
[ ] Backup Automatisierung
[ ] Restore-Test
```

## Backend

```text
[✓] Laravel-Struktur unter backend/
[✓] Dockerfile vorbereitet
[✓] .dockerignore vorbereitet
[~] Authentication / RBAC
[~] Customers
[~] Packages / Products
[ ] Hosting
[ ] Domains
[ ] Billing
[ ] Tickets
[ ] Customer Portal
[ ] API
```

## Runtime Services

```text
[ ] 4kc-app-production
[ ] 4kc-worker-production
[ ] 4kc-scheduler-production
[ ] 4kc-horizon-production
[✓] 4kc-mariadb-production
[✓] 4kc-production-redis
[ ] 4kc-app-staging
[ ] 4kc-worker-staging
[ ] 4kc-scheduler-staging
[ ] 4kc-horizon-staging
[✓] 4kc-mariadb-staging
[✓] 4kc-redis-staging
```

## Integrations

```text
[~] InterNetX
[~] SWITCH EPP
[ ] PowerDNS
[~] Plesk
[ ] Mail Provider
[ ] Backup Provider
[ ] Monitoring
```

## Documentation

```text
[✓] Public documentation repository
[✓] Project context
[✓] Infrastructure documentation
[✓] Architecture documentation
[✓] Decisions overview
[✓] ADR structure
[✓] Meeting notes
[✓] Roadmap
[✓] Deployment documentation
[✓] Container documentation
[✓] Backup strategy
[✓] Restore procedure draft
[✓] Sync policy
```

## Current Priority

[~] GitHub App Integration for `Gamma-Solution`
[~] Laravel Deployment Preparation on Staging
[ ] Dockerfile validation in Coolify
[ ] Backup and Restore validation


## 2026-05-29 Staging App

Status:

- Private GitHub App `gamma-solution` in Coolify sichtbar.
- Staging Branch `staging` für `Gamma-Solution/4kc-panel` erstellt.
- Coolify Application `4kc-app-staging` angelegt.
- Konfiguration: `/backend`, Dockerfile `/backend/Dockerfile`, Port `8080`, Healthcheck `/up`.
- Staging ENV in Coolify gesetzt; Secrets bleiben ausserhalb von GitHub und Docs.
- Erster Deploy ist blockiert: API-Token hat keine `deploy` Permission.

Nicht durchgeführt:

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production MariaDB
- keine Host-Installationen auf Ubuntu


## 2026-05-29 Deploy Permission Blocker

Status:

- Staging Deploy fachlich freigegeben.
- Coolify API Deploy erneut versucht.
- Deploy bleibt blockiert: `Missing required permissions: deploy`.
- Build Logs liegen weiterhin nicht vor, weil kein Deployment gestartet wurde.

Guardrails eingehalten:

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production MariaDB
- keine Migrationen allgemein
- keine Secrets im Repository


## 2026-05-29 Staging Deploy Failure

Status:

- Deploy Permission ist vorhanden und Deploy Requests werden angenommen.
- `4kc-app-staging` schlägt beim Build/Start fehl und bleibt `exited:unhealthy`.
- Dockerfile Location wurde auf `/Dockerfile` korrigiert, passend zu `Base Directory=/backend`.
- Lokale Composer-/NPM-/Laravel-Checks für den Staging-Stand sind erfolgreich.
- Build Logs sind über die aktuelle API-Antwort nicht verfügbar, weil das Feld `logs` ohne sensitive-read ausgeblendet wird.

Guardrails eingehalten:

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production MariaDB
- keine Migrationen allgemein
- keine Secrets im Repository
