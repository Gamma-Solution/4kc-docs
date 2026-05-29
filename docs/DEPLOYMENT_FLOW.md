# 4KC Deployment Flow

Dieses Dokument beschreibt den Ziel-Deployment-Flow für 4KC über GitHub und Coolify.

## Ziel-Flow

```text
GitHub
↓
Coolify
↓
Build
↓
Migration
↓
Deployment
↓
Healthcheck
```

## Repositories

Privates Source-Repository:

```text
Gamma-Solution/4kc-panel
```

Öffentliches Dokumentationsrepository:

```text
Gamma-Solution/4kc-docs
```

## Branch-Strategie

```text
main        Production
staging     Staging
feature/*   Feature- und Vorbereitungsbranches
```

### main

- stabiler Production-Branch
- Deployment nach Staging-Validierung
- Auto-Deploy erst aktivieren, wenn Build, Migrationen und Healthchecks zuverlässig funktionieren

### staging

- Integrationsbranch für Staging
- automatische Deployments möglich
- Migrationen und Smoke-Tests laufen hier zuerst

### feature/*

- Arbeitsbranches für einzelne Features oder Infrastrukturänderungen
- Merge nach Review in `staging`
- kein direktes Production Deployment

## Coolify-Konfiguration

Empfohlen:

```text
Source Repository: Gamma-Solution/4kc-panel
Root Directory: backend
Build Type: Dockerfile
Dockerfile: backend/Dockerfile oder Dockerfile, abhängig von Coolify-Pfadinterpretation
GitHub Integration: private GitHub App für Gamma-Solution/4kc-panel
```

Details:

- [GITHUB_DEPLOYMENT_STRATEGY.md](GITHUB_DEPLOYMENT_STRATEGY.md)
- [STAGING_CONCEPT.md](STAGING_CONCEPT.md)

Production Deployments bleiben bis zur Review-Freigabe deaktiviert.

## Build

Build-Schritte im Dockerfile:

1. Node/Vite Assets bauen
2. Composer Dependencies ohne Dev-Abhängigkeiten installieren
3. PHP Runtime mit benötigten Extensions bereitstellen
4. Laravel App-Dateien ins Runtime Image kopieren
5. Nginx/PHP-FPM Runtime bereitstellen

Build darf keine produktive Datenbankverbindung benötigen.

## Migration

Migrationen werden nicht im Dockerfile ausgeführt.

Empfohlener Release-Schritt:

```text
php artisan migrate --force
```

Wichtig:

- Migrationen kontrolliert ausführen
- nicht parallel in App, Worker, Scheduler und Horizon starten
- bei kritischen Migrationen vorher Backup/Restore-Pfad prüfen

## Deployment

Nach erfolgreichem Build und Migration:

- App Service aktualisieren
- Worker neu starten
- Scheduler neu starten
- Horizon neu starten

## Healthcheck

Empfohlener HTTP Healthcheck:

```text
/up
```

Der Healthcheck soll prüfen, ob die App grundsätzlich antwortet. Tiefere Checks für Datenbank und Redis können separat ergänzt werden.

## Smoke-Test nach Staging Deployment

Minimaler Staging Smoke-Test:

1. App URL erreichbar
2. `/up` liefert erfolgreiches Ergebnis
3. Login/Admin erreichbar
4. Migrationen sind aktuell
5. Queue Worker läuft
6. Scheduler läuft
7. Horizon läuft
8. Logs ohne kritische Fehler

## Production Deployment

Production Deployment erst nach erfolgreichem Staging Smoke-Test.

Empfohlene Reihenfolge:

1. Backup prüfen
2. Deployment starten
3. Migrationen ausführen
4. Services neu starten
5. Healthcheck prüfen
6. Admin/Login prüfen
7. Queue/Horizon prüfen
8. Ergebnis in `docs/MEETING_NOTES.md` dokumentieren
