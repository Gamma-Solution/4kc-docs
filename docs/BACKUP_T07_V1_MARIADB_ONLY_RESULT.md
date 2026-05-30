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

## Remote-Zugriff

Root-Zugriff wurde temporär für T07 v1 freigegeben und zu Beginn erfolgreich getestet:

```text
ROOT_ACCESS_OK
uid=0
host=srv120.4youhosting.ch
```

Spätere SSH-Verbindungen aus dieser Hermes-Umgebung waren zeitweise nicht erreichbar (`tcp22_fail` / `Connection timed out`). Der Betreiber hat srv120 extern/manuell als erreichbar bestätigt. Aus Hermes heraus konnte der finale Dump-Lauf deshalb noch nicht vollständig abgeschlossen werden.

## Script-Stand

Installiertes Script auf srv120 wurde geprüft:

```text
/usr/local/sbin/srv120-backup-mariadb-dumps
bash -n: OK
sha256 vor lokaler Korrektur: 55e4a4eb33674916638298e58a55db3b648d061730eaef53864664ebc248ebcf
```

Lokale korrigierte Script-Vorlage:

```text
docs/templates/srv120-backup-mariadb-dumps.v1.sh
bash -n: OK
sha256: eb13ff815756802fa313af7ba900733fe8b709f40fcc1bc7047d6cc2506d2bc9
```

Korrektur in der lokalen Vorlage:

- `MARIADB_CONTAINER` fällt auf `DB_HOST` zurück, wenn noch nicht explizit gesetzt.
- DB-Passwort wird bevorzugt aus der root-geschützten `.cnf` Datei gelesen, nicht aus der `.env` Ausgabe.
- Secret-Werte werden nicht dokumentiert.

Hinweis: Übertragung dieser Script-Korrektur nach srv120 wurde versucht, konnte wegen SSH-Timeout aber nicht final verifiziert werden.

## Config-Stand srv120

ENV-Korrektur wurde auf srv120 durchgeführt und verifiziert:

```text
production.env:
DB_NAME=default
MARIADB_CONTAINER=pcamvbtbrzief6cxc0uyb4jc

staging.env:
DB_NAME=staging
MARIADB_CONTAINER=jp8vk5wippj9cxuj1wwt34pa
```

Weitere vorhandene Config-Dateien:

```text
/etc/srv120-backup/mariadb/production.cnf
/etc/srv120-backup/mariadb/staging.cnf
```

Die `.cnf` Dateien enthalten Secrets und wurden nicht inhaltlich dokumentiert.

## T07 v1 Checkliste

1. ENV-Korrekturen prüfen: erledigt.
2. Script erneut ausführen: blockiert durch erneuten SSH-Timeout aus Hermes-Umgebung.
3. Production Dump erzeugen: offen.
4. Staging Dump erzeugen: offen.
5. Checksummen prüfen: offen.
6. Manifest prüfen: offen.
7. Ergebnis dokumentieren: Zwischenstand dokumentiert; finaler Abschluss steht nach erfolgreichem Scriptlauf aus.

## Produktive Änderungen im T07-Scope

Durchgeführt:

- In `/etc/srv120-backup/mariadb/production.env` wurde `MARIADB_CONTAINER=pcamvbtbrzief6cxc0uyb4jc` ergänzt.
- In `/etc/srv120-backup/mariadb/staging.env` wurde `MARIADB_CONTAINER=jp8vk5wippj9cxuj1wwt34pa` ergänzt.

Versucht, aber nicht final verifiziert:

- Aktualisierung von `/usr/local/sbin/srv120-backup-mariadb-dumps` mit der korrigierten T07-v1-Scriptvorlage.

Nicht durchgeführt:

- keine Production Deployments
- keine Migrationen
- keine 4KC Änderungen
- keine Coolify Änderungen
- keine Docker Updates
- keine Ubuntu Updates
- keine Reboots
- keine Firewall Änderungen
- keine SSH Änderungen
- keine Löschung von Ressourcen
- keine Backrest Jobs
- keine Schedules

## Aktueller Status

T07 v1 ist noch nicht vollständig abgeschlossen, weil der finale manuelle Dump-Lauf aus Hermes heraus wegen SSH-Timeout nicht durchgeführt werden konnte.

Sobald SSH aus Hermes wieder stabil erreichbar ist, sind die verbleibenden Schritte:

1. Remote-Scriptstand verifizieren.
2. `/usr/local/sbin/srv120-backup-mariadb-dumps` manuell ausführen.
3. Production- und Staging-Dump unter `/var/backups/srv120/mariadb` prüfen.
4. `gzip -t` und `sha256sum -c` prüfen.
5. Manifest-Dateien prüfen.
6. Dieses Ergebnisdokument finalisieren.
