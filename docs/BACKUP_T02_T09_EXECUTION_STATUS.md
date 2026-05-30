# Backup T02-T09 Execution Status

Datum: 2026-05-30

Dieses Dokument protokolliert den Stand der freigegebenen T0x-Umsetzung. Es enthält keine Secrets und keine privaten SSH-Keys.

## T02: separaten SSH-Key für Backrest erzeugen

Status: vorbereitet

- Separater ED25519-Key wurde lokal für Backrest/srv120 vorbereitet.
- Fingerprint: `SHA256:U3s/07c+FRzXlZIEo7iMHjhgecrqNkzipn9l8u9tiEM`
- Private Key wurde nicht dokumentiert und nicht in GitHub gespeichert.
- Für produktive Nutzung muss der Private Key sicher auf Unraid/Backrest hinterlegt werden.

## T03: Backup-User `backrest-backup` auf srv120 anlegen

Status: blockiert

Grund:

- Der verfügbare Zugang `hermes-monitor` ist bewusst read-only.
- `sudo -l` erlaubt nur `/usr/local/sbin/srv120-monitor-readonly`.
- User-Anlage erfordert Admin/root-Rechte und wurde nicht durchgeführt.

Vorbereitete Zielbefehle für Admin/root-Ausführung:

```bash
useradd --system --create-home --home-dir /var/lib/backrest-backup --shell /bin/bash backrest-backup
install -d -m 700 -o backrest-backup -g backrest-backup /var/lib/backrest-backup/.ssh
# Public Key aus T02 in authorized_keys eintragen
install -m 600 -o backrest-backup -g backrest-backup /dev/null /var/lib/backrest-backup/.ssh/authorized_keys
```

## T04: sudoers-Minimalrechte vorbereiten

Status: vorbereitet, Installation blockiert

Ziel: kein allgemeines sudo, nur exakte root-owned Backup-Scripts.

Vorbereitete sudoers-Regel:

```text
backrest-backup ALL=(root) NOPASSWD: /usr/local/sbin/server-backup-preflight
backrest-backup ALL=(root) NOPASSWD: /usr/local/sbin/server-backup-mariadb-dumps
backrest-backup ALL=(root) NOPASSWD: /usr/local/sbin/server-backup-redis-snapshots
backrest-backup ALL=(root) NOPASSWD: /usr/local/sbin/server-backup-manifest
backrest-backup ALL=(root) NOPASSWD: /usr/local/sbin/server-backup-clean-staging
```

Nicht erlaubt:

- `ALL=(ALL) NOPASSWD: ALL`
- apt/install/upgrade/reboot
- docker restart/compose up/down/rm/prune
- breite Schreibrechte ausserhalb des Backup-Staging-Pfads

## T05: Staging-Verzeichnis `/var/backups/srv120` vorbereiten

Status: blockiert

Grund: benötigt Admin/root-Rechte auf srv120.

Zielstruktur:

```text
/var/backups/srv120/
├── mariadb/
├── redis/
├── manifests/
└── tmp/
```

Zielrechte:

```text
Owner: root:backrest-backup
Mode: 0750 für Verzeichnisse
```

## T06: MariaDB Backup-User und Credentials sicher einrichten

Status: blockiert

Grund:

- Benötigt MariaDB Admin-Zugang/Secrets.
- Secrets dürfen nicht gelesen, ausgegeben oder dokumentiert werden.

Zielrechte für DB-Backup-User:

```text
SELECT
SHOW VIEW
TRIGGER
EVENT
optional LOCK TABLES / PROCESS falls erforderlich
```

Keine Mutation-Rechte wie DROP, ALTER, INSERT, UPDATE, DELETE, CREATE USER oder GRANT OPTION.

## T07: MariaDB Dump Script installieren und manuell testen

Status: blockiert

Grund:

- Abhängig von T03-T06.
- Scriptinstallation unter `/usr/local/sbin` erfordert root.
- Manueller Test erfordert eingerichteten DB-Backup-User.

Geplante Dump-Optionen:

```text
--single-transaction
--quick
--routines
--triggers
--events
--default-character-set=utf8mb4
--hex-blob
```

## T08: Coolify/Volume Inventar read-only erstellen

Status: teilweise erledigt

Read-only Monitoring-Ausgabe zeigt:

- Coolify `4.1.1` läuft healthy.
- `coolify-db` läuft healthy.
- `coolify-redis` läuft healthy.
- `coolify-realtime` läuft.
- `coolify-proxy`/Traefik läuft healthy.
- 2x MariaDB 11 Container laufen healthy.
- 2x Redis 7 Alpine Container laufen healthy.

Offen:

- Vollständige Docker-Volume-/Mount-Liste ist über den aktuellen read-only Monitoring-Befehl nicht enthalten.
- Für finales T08-Inventar braucht es entweder erweitertes read-only Script oder Admin/root-Freigabe.

## T09: Laravel Storage Pfade verifizieren

Status: blockiert / noch nicht anwendbar

Grund:

- Aktuell sind in der read-only Containerliste keine Laravel App/Worker/Scheduler/Horizon Container als running sichtbar.
- Storage-Mounts/Pfade können ohne App-Container oder erweitertes read-only Docker-Inspect nicht belastbar verifiziert werden.

## Zusammenfassung

```text
T02: vorbereitet
T03: blockiert, Admin/root benötigt
T04: vorbereitet, Installation blockiert
T05: blockiert, Admin/root benötigt
T06: blockiert, DB-Admin/Secret-Handling durch Betreiber benötigt
T07: blockiert, abhängig von T03-T06
T08: teilweise read-only erledigt, Volume-Details offen
T09: blockiert/noch nicht anwendbar, App-Container/Storage-Mounts fehlen oder sind nicht prüfbar
```

Produktive Backrest-Jobs: keine erstellt.
Schedules: keine aktiviert.
Restic-Repositories: keine angelegt.
Änderungen auf srv120: keine durchgeführt.
Secrets: keine dokumentiert.
