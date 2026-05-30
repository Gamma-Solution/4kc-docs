# srv120 Backup Implementation Plan

> **For Hermes:** Dieser Plan ist eine technische Umsetzungsplanung. Noch keine produktiven Backup-Jobs erstellen und keine produktiven Systeme ändern, bevor Igi den jeweiligen Schritt freigibt.

**Goal:** Backrest/Restic-Backups für `srv120` so vorbereiten, dass MariaDB, Coolify/Docker-Daten, Laravel Storage, Redis und Restore-Tests sauber, nachvollziehbar und ohne Secret-Leaks umgesetzt werden können.

**Architecture:** Backrest läuft auf Unraid als zentrale Backup-Steuerung. `srv120` wird per separatem Backup-SSH-User mit minimalen Rechten angebunden. MariaDB wird über konsistente Dumps gesichert; Coolify-/Docker-Volumes, Laravel Storage und relevante Host-Konfigurationen werden verschlüsselt in Restic gesichert und anschließend zur Synology RS422+ repliziert.

**Tech Stack:** Ubuntu 24.04, Docker, Coolify, MariaDB, Redis, Laravel Storage, Backrest, Restic, Unraid, Synology RS422+, SSH, sudoers Minimalrechte.

---

## Scope

Dieser Plan beschreibt die technische Umsetzung für:

1. Backrest auf Unraid
2. Backup-User auf `srv120`
3. MariaDB Dump Scripts
4. Coolify Daten
5. Laravel Storage
6. Restore-Test

## Nicht Teil dieses Plans

- keine produktiven Backup-Jobs anlegen
- keine Backrest-Jobs aktivieren
- keine Reboots
- keine Updates
- keine Container-Restarts
- keine Production-Migrationen
- keine produktiven Daten löschen oder verändern
- keine Secrets in GitHub, `4kc-docs` oder Chat-Ausgaben dokumentieren

## Freigabe-Gates

Jede Phase wird separat freigegeben:

```text
Gate 1: Backrest auf Unraid vorbereiten
Gate 2: Backup-User auf srv120 anlegen
Gate 3: Dump-/Read-Scripts auf srv120 installieren
Gate 4: Backrest Repositories und Quellen konfigurieren
Gate 5: Testlauf ohne Retention/Prune
Gate 6: Restore-Test
Gate 7: produktive Zeitpläne aktivieren
```

Bis Gate 7 bleiben Backups manuell/testweise und nicht als produktiver Dauerjob aktiv.

---

## Zielbild

```text
Unraid
└── Backrest
    ├── Restic Repository: srv120-primary
    ├── Quelle: srv120 via SSH
    ├── Pre-Backup Hooks: MariaDB Dumps / Manifest
    ├── Backup Sets:
    │   ├── mariadb-production
    │   ├── mariadb-staging
    │   ├── coolify-state
    │   ├── laravel-storage
    │   ├── redis-snapshots
    │   └── host-config
    └── Repository-Replikation zur Synology RS422+

srv120
└── backrest-backup User
    ├── minimaler SSH-Zugriff
    ├── sudo nur für definierte Scripts
    ├── Dump-Staging: /var/backups/srv120/
    └── keine Rechte für Updates/Reboot/Restart/Prune
```

---

## Phase 1: Backrest auf Unraid planen

### Task 1.1: Unraid-Zielpfade festlegen

**Objective:** Speicherorte für Backrest-Konfiguration und Restic-Repositories auf Unraid definieren.

**Zu dokumentieren:**

```text
Backrest Appdata:
/mnt/user/appdata/backrest

Primäres Restic Repository:
/mnt/user/backups/restic/srv120-primary

Restore-Test Arbeitsbereich:
/mnt/user/backups/restore-tests/srv120

Temporäre Restore-Dumps:
/mnt/user/backups/restore-tests/srv120/tmp
```

**Akzeptanzkriterien:**

- Pfade existieren oder sind als Zielpfade freigegeben.
- Repository-Pfad liegt auf geschütztem Unraid Storage.
- Restore-Test-Pfad ist getrennt vom produktiven Repository.
- Keine Secrets werden in Pfadnamen verwendet.

### Task 1.2: Backrest Container-Konzept definieren

**Objective:** Backrest auf Unraid als Container betreiben, ohne `srv120` direkt zu verändern.

**Empfohlene Container-Mounts:**

```text
/mnt/user/appdata/backrest:/config
/mnt/user/backups/restic:/repos
/mnt/user/backups/restore-tests:/restore-tests
/mnt/user/appdata/backrest/ssh:/ssh:ro
```

**Netzwerk:**

```text
Bridge oder eigenes Docker-Netz auf Unraid
Outbound SSH zu srv120:22 erlaubt
Kein öffentlicher Zugriff auf Backrest UI
```

**Akzeptanzkriterien:**

- Backrest UI ist nur intern/LAN erreichbar.
- SSH-Key für `srv120` liegt nicht im GitHub-Repo.
- Container hat keinen unnötigen Zugriff auf Unraid-Systempfade.

### Task 1.3: Restic Repository-Verschlüsselung planen

**Objective:** Restic Repository verschlüsselt anlegen.

**Secret-Regel:**

- Restic Repository Password wird von Igi verwaltet.
- Passwort wird nicht in `4kc-docs` gespeichert.
- Passwort wird nicht im Chat ausgegeben.
- Ablage nur in Backrest/Unraid Secret-Konfiguration.

**Repository-Namen:**

```text
srv120-primary
srv120-synology-copy optional später
```

**Akzeptanzkriterien:**

- Repository ist verschlüsselt.
- Passwort-Wiederherstellung ist organisatorisch geklärt.
- Ohne Passwort ist kein Restore möglich; deshalb muss Igi einen sicheren Offline-/Password-Manager-Eintrag pflegen.

### Task 1.4: Synology-Replikation planen

**Objective:** Zweite Sicherung zur Synology RS422+ definieren.

**Startempfehlung:**

```text
Backrest schreibt auf Unraid.
Unraid repliziert das verschlüsselte Restic Repository zur Synology.
Synology speichert nur verschlüsselte Repository-Daten.
```

**Mögliche Transportwege:**

```text
rsync over SSH
Synology Active Backup / Hyper Backup für Repository-Verzeichnis
Unraid User Script mit rsync
```

**Nicht empfohlen:**

```text
unverschlüsselte Dumps direkt zur Synology kopieren
Synology als einzige Backup-Kopie verwenden
```

**Akzeptanzkriterien:**

- Synology enthält nur verschlüsselte Restic-Daten.
- Replikation löscht nicht automatisch alte Daten ohne Retention-Konzept.
- Wiederherstellung von Synology wird separat getestet.

---

## Phase 2: Backup-User auf srv120 planen

### Task 2.1: Technischen User definieren

**Objective:** Eigenen Backup-User getrennt vom Monitoring-User verwenden.

**Empfohlener User:**

```text
backrest-backup
```

**Grund:**

- `hermes-monitor` bleibt read-only Monitoring.
- `backrest-backup` darf nur definierte Backup-Vorbereitungen ausführen.
- Rechte bleiben trennbar und auditierbar.

**Akzeptanzkriterien:**

- kein Root-Login
- SSH key-only
- keine Passwort-SSH-Anmeldung
- kein allgemeiner sudo-Zugriff

### Task 2.2: SSH-Key-Strategie festlegen

**Objective:** Separaten SSH-Key für Backrest verwenden.

**Empfehlung:**

- Key auf Unraid/Backrest erzeugen.
- Public Key in `authorized_keys` von `backrest-backup` auf `srv120` hinterlegen.
- Private Key bleibt nur auf Unraid/Backrest.

**Nicht verwenden:**

- kein GitHub-Key
- kein Hermes-Monitoring-Key
- kein persönlicher Admin-Key

**Akzeptanzkriterien:**

- Public Key ist eindeutig mit Kommentar versehen, z. B. `backrest-srv120-unraid`.
- Private Key wird nicht in GitHub, Docs oder Chat ausgegeben.

### Task 2.3: sudoers-Minimalrechte planen

**Objective:** `backrest-backup` darf nur definierte Scripts ausführen.

**Zieldatei:**

```text
/etc/sudoers.d/backrest-backup-srv120
```

**Geplante erlaubte Befehle:**

```text
/usr/local/sbin/srv120-backup-preflight
/usr/local/sbin/srv120-backup-mariadb-dumps
/usr/local/sbin/srv120-backup-redis-snapshots
/usr/local/sbin/srv120-backup-manifest
/usr/local/sbin/srv120-backup-clean-staging
```

**Nicht erlaubt:**

```text
apt
systemctl restart
reboot
docker restart
docker compose up/down
rm -rf auf produktive Pfade
```

**Akzeptanzkriterien:**

- `sudo -l -U backrest-backup` zeigt nur die definierten Scripts.
- Kein `ALL=(ALL) NOPASSWD: ALL`.
- Scripts sind root-owned und nicht durch `backrest-backup` beschreibbar.

### Task 2.4: Staging-Verzeichnis planen

**Objective:** Ort für temporäre Dumps/Snapshots auf `srv120` definieren.

**Pfad:**

```text
/var/backups/srv120
├── mariadb
│   ├── production
│   └── staging
├── redis
│   ├── production
│   └── staging
└── manifests
```

**Rechte:**

```text
Owner: root:root oder root:backrest-backup
Schreibzugriff nur über freigegebene Scripts
Keine world-readable Secrets
```

**Akzeptanzkriterien:**

- Dumps landen nur in diesem Staging-Bereich.
- Staging-Bereich wird von Backrest gesichert.
- Cleanup löscht nur alte temporäre Dateien in diesem Bereich.

---

## Phase 3: MariaDB Dump Scripts planen

### Task 3.1: Datenbank-Container identifizieren

**Objective:** Production- und Staging-MariaDB-Container eindeutig erkennen.

**Quelle:**

- Coolify Resource-Liste
- Docker Container Labels
- bestehendes read-only Monitoring Script

**Zu dokumentieren:**

```text
Production MariaDB Container: <noch zu verifizieren>
Staging MariaDB Container: <noch zu verifizieren>
Production DB Name: nicht öffentlich dokumentieren
Staging DB Name: nicht öffentlich dokumentieren
```

**Akzeptanzkriterien:**

- Container werden nicht geraten.
- Keine Secrets werden ausgegeben.
- Container-IDs/Namen werden intern im Script gepflegt oder über Labels robust gefunden.

### Task 3.2: MariaDB Backup-User planen

**Objective:** Dedizierten DB-User für Dumps verwenden.

**Empfohlene Rechte:**

```sql
SELECT
SHOW VIEW
TRIGGER
EVENT
```

Optional nur falls technisch nötig:

```sql
LOCK TABLES
PROCESS
```

**Nicht erlaubt:**

```sql
DROP
ALTER
INSERT
UPDATE
DELETE
CREATE USER
GRANT OPTION
```

**Secret-Regel:**

- DB-Backup-Credentials werden nicht in GitHub dokumentiert.
- Ablage nur auf `srv120` in root-geschützter Konfiguration oder über Coolify/Secret Management.

### Task 3.3: Dump-Script definieren

**Objective:** Script für konsistente MariaDB-Dumps planen.

**Zielpfad:**

```text
/usr/local/sbin/srv120-backup-mariadb-dumps
```

**Script-Aufgaben:**

1. sichere Shell-Optionen setzen
2. Zielverzeichnisse prüfen/anlegen
3. Production Dump erstellen
4. Staging Dump erstellen
5. Checksums erzeugen
6. Dateigrößen prüfen
7. Manifest schreiben
8. Exit-Code != 0 bei Fehler

**Dump-Optionen:**

```text
--single-transaction
--quick
--routines
--triggers
--events
--default-character-set=utf8mb4
--hex-blob
```

**Ausgabe:**

```text
OK mariadb production dump created: <filename> <size> <sha256>
OK mariadb staging dump created: <filename> <size> <sha256>
```

**Keine Ausgabe:**

- keine Passwörter
- keine vollständigen DSNs
- keine ENV-Rohwerte

### Task 3.4: Dump-Verifikation planen

**Objective:** Dumps nach Erstellung technisch prüfen.

**Checks:**

```text
gzip -t <dump.sql.gz>
sha256sum <dump.sql.gz>
Dateigröße > Mindestwert
Header enthält MariaDB/MySQL Dump-Marker
```

**Optional im Restore-Test:**

```text
Import in temporäre MariaDB
Tabellenanzahl prüfen
Laravel migrations table prüfen
```

---

## Phase 4: Coolify Daten planen

### Task 4.1: Coolify-Datenquellen identifizieren

**Objective:** Festlegen, welche Coolify-Daten gesichert werden.

**Zu sichern:**

```text
Coolify persistente Volumes
Coolify Datenbank/State gemäß Coolify-Installationslayout
Coolify Projekt-/Resource-/Environment-Konfigurationen
Proxy-/Traefik-Konfiguration, soweit persistent
```

**Nicht öffentlich dokumentieren:**

```text
ENV-Werte
Tokens
Passwörter
API-Rohresponses mit Secrets
```

**Akzeptanzkriterien:**

- Konkrete Volume-Namen werden vor Umsetzung read-only inventarisiert.
- Keine Secrets werden in `4kc-docs` übernommen.

### Task 4.2: Coolify Backup-Methode festlegen

**Objective:** Coolify-State konsistent sichern.

**Priorität:**

1. Coolify-eigene Backup-/Export-Funktion prüfen und bevorzugen, falls verfügbar.
2. Falls nicht ausreichend: persistente Coolify-Volumes via Restic sichern.
3. Zusätzlich bereinigtes Resource-Inventar ohne Secrets erzeugen.

**Geplantes Script:**

```text
/usr/local/sbin/srv120-backup-coolify-inventory
```

**Ausgabe:**

- Resource-Namen
- Status
- Domains
- Volume-Namen
- Container-Namen
- keine ENV-Werte
- keine Tokens

### Task 4.3: Docker Volume Backup planen

**Objective:** Nur persistente Volumes sichern, nicht Container Overlay oder Images.

**Zu sichern:**

```text
Coolify Volumes
MariaDB Dump-Staging, nicht rohe DB-Dateien als primäre Sicherung
Redis Snapshot-Staging, falls genutzt
Laravel Storage Volumes
```

**Nicht sichern:**

```text
Docker Images
Container Overlay FS
Build Cache
kurzlebige Container Logs
```

---

## Phase 5: Laravel Storage planen

### Task 5.1: Storage-Pfade pro Environment identifizieren

**Objective:** Production- und Staging-Storage eindeutig trennen.

**Zu inventarisieren:**

```text
4kc-app-production storage volume: <noch zu verifizieren>
4kc-app-staging storage volume: <noch zu verifizieren>
Public storage symlink / mount: <noch zu verifizieren>
```

**Zu sichern:**

```text
storage/app
storage/app/public
Uploads
Exporte
generierte Dokumente
Rechnungs-/PDF-Dateien, falls lokal gespeichert
```

**Nicht sichern:**

```text
storage/framework/cache
storage/framework/views
storage/logs, außer bewusst ausgewählt
node_modules
vendor
```

### Task 5.2: Storage-Backup Set definieren

**Objective:** Backrest Source Set für Laravel Storage planen.

**Tags:**

```text
srv120
production
staging
storage
laravel
```

**Akzeptanzkriterien:**

- Production und Staging sind unterscheidbar.
- Restore einzelner Storage-Pfade ist möglich.
- Dateirechte nach Restore sind prüfbar.

---

## Phase 6: Redis Snapshot Planung

### Task 6.1: Redis-Nutzung bewerten

**Objective:** Entscheiden, ob Redis als kritisch oder optional behandelt wird.

**Zu prüfen:**

```text
QUEUE_CONNECTION
SESSION_DRIVER
CACHE_STORE
Horizon Nutzung
```

**Bewertung:**

- Cache: nicht kritisch
- Sessions: Komfortverlust, meist nicht kritisch
- Queues: abhängig von Geschäftsprozessen relevant
- Horizon-Metadaten: hilfreich, aber nicht primäre Datenquelle

### Task 6.2: Redis Snapshot Script planen

**Objective:** Redis-Daten nur sichern, wenn technisch sauber und ohne Service-Störung möglich.

**Zielpfad:**

```text
/usr/local/sbin/srv120-backup-redis-snapshots
```

**Mögliche Methode:**

- vorhandene RDB/AOF-Dateien aus persistentem Volume sichern
- keine erzwungenen riskanten Redis-Kommandos ohne Review
- kein Container-Restart

**Akzeptanzkriterien:**

- Redis Production/Staging bleiben healthy.
- Kein `FLUSH*`, kein Restart.
- Falls nicht sauber prüfbar, Redis als optional dokumentieren und nicht als Rot bewerten.

---

## Phase 7: Backrest Job-Struktur planen

### Task 7.1: Backup Sets definieren

**Objective:** Backrest-Jobs fachlich strukturieren, ohne sie jetzt anzulegen.

**Vorgeschlagene Sets:**

```text
srv120-mariadb-production
srv120-mariadb-staging
srv120-coolify-state
srv120-laravel-storage-production
srv120-laravel-storage-staging
srv120-redis-production
srv120-redis-staging
srv120-host-config
```

**Alternative:**

Ein gemeinsamer Job `srv120-nightly` mit Tags je Datenklasse.

**Empfehlung Start:**

```text
srv120-nightly
```

mit klaren Tags, damit Restore und Retention später differenziert werden können.

### Task 7.2: Tags definieren

**Tags:**

```text
srv120
production
staging
mariadb
redis
storage
coolify
host-config
daily
pre-deploy
```

### Task 7.3: Retention vorbereiten

**Production Start-Retention:**

```text
Daily:   14
Weekly:   8
Monthly: 12
Yearly:   3
```

**Staging Start-Retention:**

```text
Daily:    7
Weekly:   4
Monthly:  3
```

**Wichtig:**

Retention/Prune wird erst nach erfolgreichem Restore-Test produktiv aktiviert.

### Task 7.4: Preflight definieren

**Objective:** Vor jedem Backup prüfen, ob Voraussetzungen erfüllt sind.

**Script:**

```text
/usr/local/sbin/srv120-backup-preflight
```

**Checks:**

```text
Disk Space auf srv120 Staging-Bereich
Docker erreichbar, falls für Container-Dumps nötig
MariaDB Container healthy
Redis Container healthy, falls Redis-Backup aktiv
Zielverzeichnisse beschreibbar
keine alten Lockfiles
```

**Exit-Verhalten:**

- Exit 0: Backup darf laufen
- Exit != 0: Backup abbrechen, Alert erzeugen

---

## Phase 8: Restore-Test planen

### Task 8.1: Technischen Restore-Test definieren

**Objective:** Monatlichen Restore-Test als Pflichtnachweis planen.

**Testziel:**

```text
Unraid Restore-Test-Pfad, nicht Production
```

**Ablauf:**

1. letzten Snapshot in Restore-Test-Pfad wiederherstellen
2. MariaDB Production Dump in temporäre MariaDB importieren
3. MariaDB Staging Dump optional importieren
4. `gzip -t` und Checksums prüfen
5. Tabellenanzahl und zentrale Tabellen prüfen
6. Laravel Storage Stichproben prüfen
7. Restore-Protokoll schreiben

**Akzeptanzkriterien:**

- Import funktioniert.
- zentrale Tabellen sind vorhanden.
- Storage-Dateien sind lesbar.
- Ergebnis ist dokumentiert.

### Task 8.2: Applikations-Restore-Test definieren

**Objective:** Quartalsweise prüfen, ob 4KC lauffähig wiederhergestellt werden kann.

**Ablauf:**

1. isolierte Restore-/Staging-Umgebung verwenden
2. Code aus Git deployen
3. Secrets manuell aus sicherer Quelle setzen
4. DB-Dump importieren
5. Storage wiederherstellen
6. Laravel Checks durchführen:
   - `php artisan migrate:status`
   - `/up` Healthcheck
   - Admin Login
   - Kunden-/Domain-/Service-Listen
   - Queue/Redis soweit relevant
7. keine produktiven Webhooks oder Kundenmails auslösen
8. Ergebnis dokumentieren

### Task 8.3: Restore-Protokoll Vorlage definieren

**Zieldokument später:**

```text
private/internal restore log oder bereinigter Eintrag in docs/MEETING_NOTES.md
```

**Felder:**

```text
Datum
Tester
Snapshot-ID
Repository
Datenklassen
Restore-Ziel
DB Import Ergebnis
Storage Check Ergebnis
App Smoke-Test Ergebnis
Dauer
Auffälligkeiten
Nächste Maßnahmen
```

---

## Phase 9: Monitoring und Alerts planen

### Task 9.1: Monitoring um Backup-Status erweitern

**Objective:** Weekly srv120 Monitoring soll Backrest/Restic Status später auswerten.

**Aktueller Status:**

```text
Backup bleibt gelb, bis Backrest/Restic definiert, eingerichtet und Restore getestet ist.
```

**Spätere Checks:**

```text
letzter erfolgreicher Backup-Lauf
Alter des letzten Snapshots
Repository check Status
Synology Replikationsstatus
letzter Restore-Test
```

**Ampel:**

```text
Grün: letzter Backup-Lauf OK, Snapshot frisch, Restore-Test innerhalb Intervall
Gelb: Backup älter als erwartet, Restore-Test fällig, Synology-Replikation verzögert
Rot: Backup fehlgeschlagen, Repository beschädigt, Restore-Test fehlgeschlagen, kein aktueller Snapshot
```

---

## Phase 10: Umsetzungsreihenfolge nach Review

Nach Review und Freigabe empfiehlt sich diese Reihenfolge:

```text
T01: Backrest auf Unraid vorbereiten, ohne Jobs — gestartet/verifiziert, siehe `docs/BACKUP_T01_UNRAID_BACKREST_PREP.md`
T02: separaten SSH-Key für Backrest erzeugen — vorbereitet, Fingerprint dokumentiert, Private Key nicht dokumentiert
T03: Backup-User backrest-backup auf srv120 anlegen — blockiert, Admin/root benötigt
T04: sudoers-Minimalrechte vorbereiten — vorbereitet, Installation blockiert bis T03/Admin/root
T05: Staging-Verzeichnis /var/backups/srv120 vorbereiten — blockiert, Verzeichnis fehlt, Admin/root benötigt
T06: MariaDB Backup-User und Credentials sicher einrichten — blockiert, DB-Admin/Secret-Handling durch Betreiber benötigt
T07: MariaDB Dump Script installieren und manuell testen — Template vorbereitet, Installation/Test blockiert bis T03-T06
T08: Coolify/Volume Inventar read-only erstellen — teilweise erledigt, Container inventarisiert, Volume-/Mount-Liste offen
T09: Laravel Storage Pfade verifizieren — blockiert/noch nicht anwendbar, keine laufenden Laravel App-Container sichtbar
T10: Backrest Repository anlegen
T11: manueller Backrest Testlauf ohne Schedule
T12: technischer Restore-Test
T13: Synology-Replikation testen
T14: Monitoring-Report um Backup-Status erweitern
T15: erst danach produktive Zeitpläne aktivieren
```

Jedes Ticket wird einzeln freigegeben und verifiziert.

---

## Sicherheits-Checkliste vor produktiven Jobs

```text
[ ] Restic Passwort sicher bei Igi hinterlegt
[ ] Backrest UI nicht öffentlich erreichbar
[ ] separater SSH-Key nur für Backrest
[ ] backrest-backup hat kein allgemeines sudo
[ ] MariaDB Backup-User hat minimale Rechte
[ ] Dumps enthalten keine Klartext-Secrets in Logs
[ ] Repository verschlüsselt
[ ] Synology enthält nur verschlüsselte Daten
[ ] erster manueller Backup-Test erfolgreich
[ ] erster Restore-Test erfolgreich
[ ] Monitoring erkennt Backup-Fehler
[ ] Dokumentation aktualisiert
```

## Review-Fragen vor Umsetzung

1. Soll Backrest definitiv auf Unraid laufen?
2. Welcher Unraid-Pfad soll das primäre Restic Repository enthalten?
3. Soll die Synology-Kopie per Unraid-Replikation oder als zweites Backrest-Repository umgesetzt werden?
4. Ist `backrest-backup` als separater User freigegeben?
5. Soll Redis initial gesichert oder zunächst als optional markiert werden?
6. Soll Staging dieselbe Retention wie Production bekommen oder reduziert werden?
7. Wo wird das Restic Repository Password sicher hinterlegt?
8. Wann soll der erste Restore-Test stattfinden?

## Status

```text
Plan erstellt: 2026-05-30
Architektur freigegeben: ja
Produktive Backup-Jobs erstellt: nein
Backrest-Jobs aktiviert: nein
Änderungen auf srv120 durchgeführt: nein
```
