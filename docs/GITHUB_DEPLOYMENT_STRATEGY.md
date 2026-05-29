# 4KC GitHub Integration and Deployment Strategy

Dieses Dokument beschreibt die empfohlene GitHub-Integration und Deployment-Strategie für das bestehende Repository `Gamma-Solution/4kc-panel`.

Es ist eine Vorbereitung. Production Deployments werden erst nach Review ausgeführt.

## Repository

```text
Gamma-Solution/4kc-panel
```

Laravel liegt im Unterordner:

```text
backend/
```

## Empfohlene Coolify GitHub Integration

Empfohlen ist eine private GitHub App Integration für die Organisation `Gamma-Solution`.

Aktueller Befund in Coolify:

```text
Sichtbar: Public GitHub
Private GitHub App für Gamma-Solution/4kc-panel: noch nicht sichtbar
Repository Gamma-Solution/4kc-panel: private
```

Damit ist die Laravel-Staging-App noch nicht sauber gegen das private Repository anlegbar. Die GitHub App muss in Coolify/GitHub interaktiv installiert bzw. autorisiert werden; die API alleine stellt diese Browser-/GitHub-Autorisierung nicht her.

Begründung:

- Zugriff kann auf ausgewählte Repositories begrenzt werden.
- Kein persönlicher PAT als langfristiger Produktionszugang.
- Webhooks und Deployments sind sauber an Coolify gekoppelt.
- Zugriff kann zentral in GitHub widerrufen werden.

## Repository-Zugriff

Die GitHub App soll nur Zugriff auf folgende Repositories erhalten:

```text
Gamma-Solution/4kc-panel
```

Optional für Dokumentationsautomation separat:

```text
Gamma-Solution/4kc-docs
```

Für den 4KC App-Deploy ist `4kc-docs` nicht erforderlich.

## Coolify Application Zielkonfiguration

```text
Project: 4KC
Environment: staging zuerst, production später
Source: GitHub App
Repository: Gamma-Solution/4kc-panel
Branch staging: staging
Branch production: main
Base Directory: backend
Build Type: Dockerfile
Dockerfile: backend/Dockerfile
Public Port: App-intern gemäss Dockerfile
Healthcheck: /up
```

Hinweis:
Wenn Coolify bei `Base Directory=backend` den Dockerfile-Pfad relativ interpretiert, ist `Dockerfile` als `Dockerfile` zu setzen. Wenn Coolify den Pfad vom Repository-Root erwartet, ist `backend/Dockerfile` zu setzen. Dies wird zuerst in Staging validiert.

## Dockerfile-Strategie

Langfristige Strategie:

- eigenes Dockerfile im Laravel-Unterordner `backend/`
- kein Nixpacks als Produktionsstandard
- reproduzierbarer Build
- keine Datenbankverbindung während des Image-Builds
- keine Migrationen im Dockerfile
- keine Secrets im Image

Empfohlene Runtime-Trennung:

```text
4kc-app-*        HTTP App Runtime
4kc-worker-*     php artisan queue:work redis
4kc-scheduler-*  php artisan schedule:work
4kc-horizon-*    php artisan horizon
```

Alle Runtime-Container verwenden dasselbe Image, aber unterschiedliche Startcommands.

## Deployment Flow

Staging:

```text
Push/Merge nach staging
↓
Coolify Staging Build
↓
Staging Container starten
↓
Migrationen in Staging kontrolliert ausführen
↓
Smoke-Test
```

Production:

```text
Review + Freigabe
↓
Merge nach main
↓
Backup/Restore-Pfad prüfen
↓
Coolify Production Build
↓
Migrationen kontrolliert ausführen
↓
App/Worker/Scheduler/Horizon aktualisieren
↓
Healthcheck + Admin Smoke-Test
```

## ENV Strategie

Secrets werden ausschliesslich in Coolify gepflegt.

Nicht ins Repository:

- `.env`
- `APP_KEY`
- Datenbankpasswörter
- Redis-Passwörter
- Mail/API/Webhook Secrets
- Coolify Tokens
- SSH Keys

Vorbereitete ENV-Bereiche:

- Laravel App Basis (`APP_ENV`, `APP_URL`, `APP_DEBUG=false`)
- MariaDB (`DB_CONNECTION=mysql`, Host/Port/Database/User/Password)
- Redis (`REDIS_HOST`, `REDIS_PORT`, optional `REDIS_PASSWORD`)
- Queue/Cache/Session (`QUEUE_CONNECTION=redis`, `CACHE_STORE=redis`, `SESSION_DRIVER=redis`)
- Mail/Notifications später separat

## Deployment Guardrails

Bis zur expliziten Production-Freigabe gilt:

- kein Production Deployment
- keine Production Migrationen
- keine MariaDB-Änderungen
- keine Basisinfrastruktur-Änderungen auf Ubuntu
- keine Secrets in GitHub oder Docs
- zuerst Staging validieren
