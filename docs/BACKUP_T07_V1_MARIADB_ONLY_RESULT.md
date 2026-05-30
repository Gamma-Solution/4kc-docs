# Backup T07 v1 MariaDB-only Execution Result

Datum: 2026-05-30

## Scope

Freigegeben für T07 v1:

- MariaDB-only
- Production Dump: `DB_NAME=default`
- Staging Dump: `DB_NAME=staging`
- Zielpfad auf srv120: `/var/backups/srv120/mariadb`

Explizit nicht enthalten:

- keine Redis Backups
- keine Coolify Volume Backups
- keine Laravel Storage Backups
- keine Host Config Backups
- keine produktiven Backrest Jobs
- keine Schedules

## Vorbereiteter Script-Stand

Lokale, secret-freie Script-Vorlage:

```text
docs/templates/srv120-backup-mariadb-dumps.v1.sh
```

Lokale Syntaxprüfung:

```text
bash -n docs/templates/srv120-backup-mariadb-dumps.v1.sh: OK
sha256: 55e4a4eb33674916638298e58a55db3b648d061730eaef53864664ebc248ebcf
```

## Remote-Umsetzung srv120

Status: blockiert / nicht installiert

Grund:

- Verfügbarer Monitoring-Zugang `hermes-monitor` hat weiterhin nur read-only sudo auf `/usr/local/sbin/srv120-monitor-readonly`.
- Root-Login per vorhandenem SSH-Key ist nicht erlaubt.
- `backrest-backup` Login per lokal vorbereitetem T02-Key ist nicht erlaubt.
- Zusätzlich war SSH zu srv120 beim letzten Umsetzungsversuch über Port 22 zeitweise nicht erreichbar (`Connection timed out`).

Geprüfte Zugänge:

```text
hermes-monitor@srv120.4youhosting.ch mit /home/superadmin/.ssh/id_ed25519_github: OK, read-only
root@srv120.4youhosting.ch mit /home/superadmin/.ssh/id_ed25519_github: Permission denied
backrest-backup@srv120.4youhosting.ch mit /home/superadmin/backrest-t02/id_ed25519_backrest_srv120: Permission denied
```

## T07 v1 Checkliste

1. Script installieren: blockiert, benötigt admin/root oder funktionierenden `backrest-backup` mit erlaubtem sudo auf `/usr/local/sbin/srv120-backup-mariadb-dumps`.
2. Manuell ausführen: nicht durchgeführt, da Script nicht installiert werden konnte.
3. Dumps prüfen: nicht durchgeführt, da keine Dumps erzeugt wurden.
4. Checksums prüfen: nicht durchgeführt, da keine Dumps erzeugt wurden.
5. Manifest prüfen: nicht durchgeführt, da keine Dumps erzeugt wurden.
6. Ergebnis dokumentieren: erledigt mit diesem Dokument.

## Erforderliche serverseitige Voraussetzungen

Auf srv120 müssen durch Admin/root vorhanden sein:

```text
/usr/local/sbin/srv120-backup-mariadb-dumps
/var/backups/srv120/mariadb
/etc/srv120-backup/mariadb/production.env
/etc/srv120-backup/mariadb/staging.env
```

Die ENV-Dateien enthalten Secrets und werden nicht in GitHub dokumentiert. Erwartete nicht-geheime DB-Namen:

```text
production.env: DB_NAME=default
staging.env: DB_NAME=staging
```

Zusätzlich je Umgebung erforderlich:

```text
MARIADB_CONTAINER=<container-name-oder-id>
DB_USER=<backup-user>
DB_PASSWORD=<secret>
```

## Safety

- Keine Änderungen auf srv120 durchgeführt.
- Keine Dumps erzeugt.
- Keine Secrets gelesen oder dokumentiert.
- Keine Backrest Jobs erstellt.
- Keine Schedules aktiviert.
