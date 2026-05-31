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
[~] Backup Automatisierung
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
[~] Domains
[ ] Billing
[ ] Tickets
[ ] Customer Portal
[~] API
```

## Runtime Services

```text
[ ] 4kc-app-production
[ ] 4kc-worker-production
[ ] 4kc-scheduler-production
[ ] 4kc-horizon-production
[✓] 4kc-mariadb-production
[✓] 4kc-production-redis
[✓] 4kc-app-staging
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
[~] Backup Provider
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
[✓] Dockerfile validation in Coolify
[~] InterNetX single-domain read-only validation
[ ] Backup and Restore validation
[ ] T02 Backrest SSH-Key vorbereiten
[~] Weekly read-only srv120 Monitoring: Host erreichbar, Ubuntu ohne ausstehende Updates, Disk/RAM/CPU unauffällig; Docker-/Container-/DB-/Redis-Status aktuell durch fehlende Docker-Socket-Leserechte des Monitoring-Users nicht prüfbar; srv120-Hostname liefert Traefik-Default-Zertifikat.


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

## 2026-05-29 Operating Roles and Production Guardrails

Status:

- Rollenmodell bestätigt: Igi ist Product Owner und trifft finale Freigaben.
- Hermes ist Infrastruktur- und Deployment-Agent für Staging, Coolify, Docker, Build-Analyse, Dokumentation und Deployment-Vorbereitung.
- ChatGPT übernimmt Architekturreview, Gegenprüfung, Strategie, Sicherheitsreview und Qualitätskontrolle.
- Production bleibt grundsätzlich blockiert, bis Igi eine explizite Freigabe erteilt.

Hermes darf selbständig vorbereiten:

- Staging-Aufbau
- Build-Log-Analyse
- Dockerfile-Anpassungen
- GitHub-Integration vorbereiten
- Redis/MariaDB Staging verwalten
- `4kc-docs` aktualisieren
- Deployment-Prozesse vorbereiten

Nicht ohne Freigabe:

- Production Deployment
- Migrationen
- Änderungen an Production-Datenbanken
- Ubuntu/Docker/Coolify-Basisänderungen
- Secrets lesen oder speichern
- Ressourcen löschen

Arbeitsreihenfolge:

1. Staging
2. Build validieren
3. Dockerfile validieren
4. Healthchecks
5. Review
6. Production

## 2026-05-30 srv120 Backup Architecture

Status:

- Backup-Zielarchitektur definiert: Backrest auf Unraid, `srv120` per dediziertem SSH-Backup-User, Restic als verschlüsseltes Repository, Synology RS422+ als zweite Sicherung.
- MariaDB Production und Staging sollen über kontrollierte konsistente Dumps gesichert werden, nicht durch blindes Kopieren laufender Datenbankdateien.
- Laravel Storage wird ab produktiver Dateinutzung als kritischer Backup-Bestandteil behandelt.
- Coolify persistente Daten, Redis-Snapshots und relevante Host-Konfiguration sollen in die verschlüsselten Snapshots aufgenommen werden.
- Backup bleibt operativ gelb, bis Backrest/Restic eingerichtet und ein Restore-Test erfolgreich dokumentiert ist.

Nicht durchgeführt:

- keine Backup-Pläne erstellt
- keine Backrest-Jobs angelegt
- keine Änderungen auf `srv120`
- keine Secrets dokumentiert

## 2026-05-30 srv120 Backup Implementation Plan

Status:

- Technischer Umsetzungsplan für Backrest/Restic erstellt: `docs/BACKUP_IMPLEMENTATION_PLAN.md`.
- Der Plan beschreibt Backrest auf Unraid, separaten Backup-User auf `srv120`, MariaDB Dump-Scripts, Coolify-Daten, Laravel Storage, Redis-Snapshots, Retention und Restore-Test.
- Umsetzung ist in freigabepflichtige Gates/Tickets T01-T15 gegliedert.
- Produktive Backup-Jobs bleiben bis nach Review, manuellem Testlauf und Restore-Test deaktiviert.

Nicht durchgeführt:

- keine Backrest-Jobs erstellt
- keine produktiven Backup-Schedules aktiviert
- keine Änderungen auf `srv120`
- keine Secrets dokumentiert

## 2026-05-30 srv120 Backup T01 Backrest Unraid Prep

Status:

- T01 wurde gestartet und nicht-produktiv geprüft.
- Backrest UI ist von der Hermes-VM im LAN erreichbar.
- Sichtbare Backrest UI Build Version: `1.13.0`.
- Es wurden keine Backrest-Jobs erstellt.
- Es wurden keine Schedules aktiviert.
- Es wurden keine Restic-Repositories angelegt.
- Es wurden keine Änderungen auf `srv120` durchgeführt.
- T01-Details: `docs/BACKUP_T01_UNRAID_BACKREST_PREP.md`.

Offen:

- Backrest-/Unraid-Admin-Konfiguration nur nach expliziter Freigabe bzw. mit Betreiberzugang prüfen.
- Finaler Unraid Repository-Pfad und Secret-Ablage sind noch zu bestätigen.
- Nächster Schritt: T02 separaten Backrest SSH-Key vorbereiten.

## 2026-05-30 srv120 Backup T02-T09 Execution

Status:

- T02 vorbereitet: separater ED25519 SSH-Key erzeugt; Fingerprint dokumentiert; Private Key nicht dokumentiert.
- T03 blockiert: `backrest-backup` kann mit aktuellem read-only Zugang nicht angelegt werden; Admin/root benötigt.
- T04 vorbereitet, aber Installation blockiert: sudoers-Minimalregeln definiert; Admin/root und T03 benötigt.
- T05 blockiert: `/var/backups/srv120` fehlt; Anlegen benötigt Admin/root.
- T06 blockiert: MariaDB Backup-User benötigt DB-Admin/Secret-Handling durch Betreiber.
- T07 vorbereitet, aber Installation/Test blockiert: Dump-Script-Template erstellt; abhängig von T03-T06.
- T08 teilweise erledigt: Container-Inventar read-only erstellt; Volume-/Mount-Details fehlen im aktuellen Monitoring-Script.
- T09 blockiert/noch nicht anwendbar: keine laufenden Laravel App/Worker/Scheduler/Horizon Container sichtbar; Storage-Mounts nicht belastbar prüfbar.

Dokumentation:

- `docs/BACKUP_T02_T09_EXECUTION_STATUS.md`
- `docs/BACKUP_T08_COOLIFY_VOLUME_INVENTORY.md`
- `docs/BACKUP_T09_LARAVEL_STORAGE_VERIFICATION.md`
- `docs/templates/server-backup-mariadb-dumps.template.sh`

Nicht durchgeführt:

- keine produktiven Backrest-Jobs erstellt
- keine Schedules aktiviert
- keine Restic-Repositories angelegt
- keine Änderungen auf `srv120`
- keine Secrets dokumentiert

## 2026-05-31 InterNetX Single-Domain Preparation

Status:

- Staging-App `4kc-app-staging` läuft gesund nach Dockerfile/Coolify Deployment.
- Interne Admin-API zur manuellen Customer-Domain-Zuordnung ist auf Staging deployed.
- API-Route `POST /api/admin/customer-domains` ist geschützt und live erreichbar.
- Eine einzelne InterNetX-Testdomain ist in Staging einem bestehenden Kunden zugeordnet, damit der nächste Schritt als kontrollierter Read-only-Sync gegen den Registrar erfolgen kann.
- Der in Staging vorhandene InterNetX-Registrar-Datensatz ist ein Dummy/Smoke-Test-Datensatz; produktive Registrar-Secrets bleiben ausserhalb von GitHub und Docs.

Nicht durchgeführt:

- kein Production Deployment
- keine Production Migrationen
- keine Änderungen an Production-Datenbanken
- keine Registrar-Schreiboperationen
- keine Secrets dokumentiert

## 2026-05-31 InterNetX Single-Domain Read-only Smoke

Status:

- Staging-App wurde auf den Stand mit interner Registrar-Upsert-API und synchroner Domain-Info-Sync-API deployed.
- Die in Staging vorhandene InterNetX-Registrar-Konfiguration wurde anhand der bereits lokal funktionsfähigen Konfiguration aktiviert; Secrets wurden nicht dokumentiert.
- `4youvideo.ch` wurde in Staging synchron per Read-only-Info-Sync gegen InterNetX/AutoDNS validiert.
- Readback-Ergebnis: Domain aktiv, Ablaufdatum vorhanden, Auto-Renew aktiv, Cloudflare-Nameserver übernommen, DNS-Zone vorhanden, SOA vorhanden und zwei Resource Records erkannt.

Nicht durchgeführt:

- kein Production Deployment
- keine Production Migrationen
- keine Registrar-Schreiboperationen
- kein Massenimport
- keine Secrets dokumentiert

