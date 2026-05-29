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

Das Repository ist privat. In Coolify ist aktuell nur `Public GitHub` sichtbar. Eine private GitHub App für `Gamma-Solution/4kc-panel` ist Voraussetzung für saubere Staging-Builds aus Coolify.

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
Branch: staging oder freigegebener Build-Validierungsbranch
Base Directory: backend
Build Pack: dockerfile
Dockerfile: backend/Dockerfile oder Dockerfile, abhängig von Coolify-Pfadauflösung
Ports Exposes: 8080
Healthcheck Path: /up
Auto Deploy: für Staging nach erster Validierung erlaubt
Production Deploy: deaktiviert
```

## Offene Punkte vor Coolify Build

1. Private GitHub App in Coolify für `Gamma-Solution/4kc-panel` verbinden.
2. Staging-Branch-Strategie finalisieren:
   - entweder `staging` Branch anlegen
   - oder temporär freigegebenen Validierungsbranch verwenden
3. Staging-App in Coolify anlegen.
4. Build ohne Migrationen auslösen.
5. `/up` Healthcheck prüfen.
6. Erst danach Migrationen für Staging separat planen.

## Guardrails

- kein Production Deployment
- keine Production Migrationen
- keine Änderung an Production-MariaDB
- keine Secrets in GitHub oder Docs
- keine Build-Secrets im Dockerfile
