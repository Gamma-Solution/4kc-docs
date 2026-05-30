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

## Durchgeführt

### ENV-Konfiguration

Verifiziert ohne Secret-Ausgabe:

```text
production.env:
DB_NAME=default
MARIADB_CONTAINER=pcamvbtbrzief6cxc0uyb4jc
production.cnf: vorhanden, root:root, mode 600, password key vorhanden

staging.env:
DB_NAME=staging
MARIADB_CONTAINER=jp8vk5wippj9cxuj1wwt34pa
staging.cnf: vorhanden, root:root, mode 600, password key vorhanden
```

### Script-Korrektur

Installiertes Script:

```text
/usr/local/sbin/srv120-backup-mariadb-dumps
```

Korrekturen:

- `MARIADB_CONTAINER` kann aus `DB_HOST` übernommen werden.
- Secrets werden bevorzugt aus den root-geschützten `.cnf` Dateien gelesen.
- Technisch erfolgreiche kleine Dumps werden akzeptiert.
- Leere Datenbanken werden nicht mehr als Fehler gewertet.
- Manifest enthält `table_count`, `validation_status` und `validation_note`.
- `gzip -t` und `sha256sum -c` bleiben Pflichtprüfungen.

Aktuelle lokale Script-Vorlage:

```text
docs/templates/srv120-backup-mariadb-dumps.v1.sh
sha256: 3c520e7536ac55603ee9bf7b32de9de2ce72f29e6f02210f5df7e149898e6a2d
bash -n: OK
```

Die korrigierte Version mit SHA256 `3c520e7536ac55603ee9bf7b32de9de2ce72f29e6f02210f5df7e149898e6a2d` wurde nach srv120 übertragen und dort mit `bash -n` verifiziert.

### Production Dump

Scriptlauf erzeugte erfolgreich einen Production-Dump:

```text
/var/backups/srv120/mariadb/production/dumps/production-default-20260530T113229Z.sql.gz
bytes: 527
sha256: df4bdd42e9d4465e20a0ff73e684d495ab58fd0bfd5145106edd300496a861e3
table_count: 0
validation_note: technical dump ok; database has no tables
```

Manifest wurde erzeugt:

```text
/var/backups/srv120/mariadb/production/manifests/production-default-20260530T113229Z.manifest.json
```

## Noch offen

Der Scriptlauf brach nach dem Production-Dump vor Abschluss des Staging-Dumps mit Exit-Code 1 ab. Danach war SSH aus der Hermes-Umgebung erneut instabil/nicht erreichbar:

```text
tcp22_fail
ssh: connect to host srv120.4youhosting.ch port 22: Connection timed out
Timeout, server srv120.4youhosting.ch not responding.
```

Daher noch nicht final verifiziert:

- Staging Dump
- Staging gzip Prüfung
- Staging SHA256 Prüfung
- Staging Manifest
- finaler Gesamtlauf mit `OK mariadb-only-v1 completed`

## Produktive Änderungen im freigegebenen T07-Scope

Durchgeführt:

- `/etc/srv120-backup/mariadb/production.env`: `MARIADB_CONTAINER=pcamvbtbrzief6cxc0uyb4jc`
- `/etc/srv120-backup/mariadb/staging.env`: `MARIADB_CONTAINER=jp8vk5wippj9cxuj1wwt34pa`
- `/usr/local/sbin/srv120-backup-mariadb-dumps`: T07-v1-Script aktualisiert, root:root, mode 750
- Production Dump plus SHA256 und Manifest erzeugt

Nicht durchgeführt:

- keine Production Deployments
- keine Migrationen
- keine Coolify Änderungen
- keine Docker Updates
- keine Ubuntu Updates
- keine Reboots
- keine Firewall-/SSH-Änderungen
- keine Ressourcen gelöscht
- keine Backrest Jobs
- keine Schedules
- keine Secrets dokumentiert

## Status

T07 v1 ist noch nicht vollständig abgeschlossen.

Abgeschlossen:

- ENV-Konfiguration geprüft
- Script korrigiert/installiert/verifiziert
- Production Dump erzeugt
- Production Manifest erzeugt

Offen:

- Staging Dump erzeugen
- gzip/SHA256/Manifest für Staging prüfen
- finalen Gesamtlauf dokumentieren
