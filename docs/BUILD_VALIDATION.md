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


## Deploy-Versuch 2026-05-29T15:23:51Z

Freigabe lag vor für Staging Deploy, Build-Log-Analyse, Dockerfile-/Pfadkorrekturen, `/up` Healthcheck und Dokumentation.

Ergebnis:

```text
Application: 4kc-app-staging / zenvhebnteqtepn0ivzix7e2
Deploy Trigger: blockiert
API Response: Missing required permissions: deploy
```

Analyse:

- Die fachliche Freigabe ist vorhanden.
- Coolify verweigert den Deploy weiterhin, weil der aktuell verwendete API-Token keine `deploy` Permission hat.
- Es wurde kein Build gestartet; daher gibt es weiterhin keine Build Logs.
- Es wurden keine Migrationen ausgeführt.
- Es wurden keine Production-Ressourcen verändert.

Benötigt für Fortsetzung:

- Bestehenden Coolify API-Token um `deploy` Permission erweitern oder temporären Token mit `read + write + deploy` bereitstellen.


## Deploy-Versuche 2026-05-29T15:50:17Z

Mit einem deploy-fähigen Coolify API Token konnte der Staging Deploy ausgelöst werden.

Durchgeführt:

```text
Application: 4kc-app-staging / zenvhebnteqtepn0ivzix7e2
Branch: staging
Commit: dd02a15e4ac5d3e205491186e79c525eee926312
Initial Dockerfile Location: /backend/Dockerfile
Korrigierte Dockerfile Location: /Dockerfile
Base Directory: /backend
Healthcheck: /up
```

Ergebnis:

```text
Deploy fpqzxtuj9p7n792uolpq9y75: failed
Deploy eycqh36qpkseo9n9aj0uves2: failed
Deploy mmnfkv6n2lhe8alelzhzo2nw: failed
Start/Retry hyfuu5s6a1z4nqyr9wx2qjt8: failed
Application Status: exited:unhealthy
```

Analyse:

- Die Permission `deploy` funktioniert; Deployment Requests werden angenommen und gequeued.
- Die erste Pfadannahme `/backend/Dockerfile` scheitert sehr früh.
- Mit `Base Directory=/backend` ist in Coolify die Dockerfile Location `/Dockerfile` die passendere Pfadangabe.
- Auch mit korrigierter Dockerfile Location schlägt der Build/Start aktuell fehl.
- Application Logs via `/applications/{uuid}/logs` sind nicht verfügbar, weil die Application nicht läuft.
- Deployment Logs werden in der aktuellen API-Antwort ohne sensitive-read Permission nicht ausgeliefert; die API blendet das Feld `logs` aus.
- Lokal geprüft: `composer install --no-dev --no-scripts`, `npm ci`, `npm run build` und Laravel `/up` via `php artisan serve` funktionieren im ausgecheckten `staging` Stand.

Offen:

- Für echte Build-Log-Analyse wird entweder ein temporärer Coolify Token mit read-sensitive/log Zugriff oder ein bereinigter Auszug der Deployment Logs aus der Coolify UI benötigt.
- Keine Migrationen ausführen, bis separat freigegeben.
