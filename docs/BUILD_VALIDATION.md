# 4KC Build Validation

Dieses Dokument beschreibt den aktuellen Stand der Dockerfile- und Build-Validierung für 4KC Staging.

## Ziel

Validiert werden soll ausschliesslich das Staging-Deployment. Production bleibt bis Review blockiert.

## Repository-Stand

```text
Repository: Gamma-Solution/4kc-panel
Laravel-Pfad: backend/
Dockerfile: backend/Dockerfile
Build-Port: 8080
Healthcheck: /up
```

Das Repository ist privat. Die private GitHub App `gamma-solution` ist in Coolify sichtbar und auf die Organisation `Gamma-Solution` installiert.

## Dockerfile-Befund

Das vorhandene `backend/Dockerfile` ist für einen Laravel-Container vorbereitet:

- PHP 8.3 FPM Alpine Runtime
- Node 22 Asset Build Stage
- Composer 2 Vendor Stage
- Nginx + Supervisor Runtime
- PHP Extensions inkl. `pdo_mysql`, `redis`, `intl`, `gd`, `opcache`, `pcntl`, `zip`
- Runtime-Port `8080`
- Healthcheck gegen `http://127.0.0.1:8080/up`
- keine Migrationen im Dockerfile
- keine produktiven Secrets im Dockerfile

## Lokale Build-Prüfung

Eine lokale Docker-Build-Prüfung auf der Agent-Umgebung wurde versucht, konnte dort aber nicht ausgeführt werden:

```text
docker: command not found
```

Das ist kein Fehler der 4KC-Infrastruktur. Die Staging-Build-Validierung soll über Coolify auf `srv120` erfolgen, sobald die private GitHub App Integration aktiv ist.

## Coolify Staging Zielkonfiguration

```text
Project: 4KC
Environment: staging
Application Name: 4kc-app-staging
Repository: Gamma-Solution/4kc-panel
Branch: staging
Base Directory: /backend
Build Pack: dockerfile
Dockerfile: /backend/Dockerfile
Ports Exposes: 8080
Healthcheck Path: /up
Auto Deploy: für Staging nach erster Validierung erlaubt
Production Deploy: deaktiviert
```

## Build-Versuch 2026-05-29

Durchgeführt:

```text
GitHub App: gamma-solution / dvd2a6ejflgjw5bfd50lssmv
Staging Branch: staging
Branch Source: feature/4kc-coolify-dockerfile
Staging App: 4kc-app-staging / zenvhebnteqtepn0ivzix7e2
Repository: Gamma-Solution/4kc-panel
Base Directory: /backend
Dockerfile Location: /backend/Dockerfile
Ports Exposes: 8080
Healthcheck Path: /up
```

Ergebnis:

```text
Deploy Trigger: blockiert
API Response: Missing required permissions: deploy
Deployment Count: 0
Application Logs: nicht verfügbar, weil Application noch nicht läuft
```

Analyse:

- Die App-Erstellung über die private GitHub App funktioniert.
- Repository, Branch und Dockerfile-Konfiguration sind in Coolify gesetzt.
- Der erste Staging-Build konnte nicht gestartet werden, weil der verwendete API-Token keine `deploy` Permission besitzt.
- Build-Logs können daher noch nicht bewertet werden.

Nächster Schritt:

- Coolify API Token um `deploy` Permission erweitern oder einen temporären Token mit `read + write + deploy` verwenden.
- Danach `4kc-app-staging` erneut deployen und Build-Logs prüfen.
- Migrationen weiterhin separat und erst nach Build-/Healthcheck-Freigabe ausführen.

## Guardrails

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production-MariaDB
- keine Secrets in GitHub oder Docs
- keine Build-Secrets im Dockerfile
