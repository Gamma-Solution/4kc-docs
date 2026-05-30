# 4KC Backup Strategy

## Ziel

4KC benötigt eine Backup-Architektur für `srv120`, die MariaDB, Redis, Laravel Storage, Coolify/Docker-State und betriebsrelevante Host-Konfigurationen zuverlässig sichert, ohne Secrets öffentlich zu dokumentieren.

Dieses Dokument definiert die Zielarchitektur. Es erstellt noch keine konkreten Backrest-Pläne und enthält keine Zugangsdaten, Tokens, Passwörter, privaten SSH-Keys oder produktiven Secrets.

## Zielplattform

```text
srv120.4youhosting.ch
Ubuntu 24.04
Docker / Coolify
MariaDB Production
MariaDB Staging
Redis Production
Redis Staging
zukünftige Laravel Storage Volumes
```

## Zielkette

Empfohlene Architektur:

```text
srv120
└── dedizierter Backup-SSH-User
    └── definierte Dump-/Read-Scripts
        └── Backrest auf Unraid
            └── verschlüsseltes Restic Repository auf Unraid
                └── zweite verschlüsselte Kopie auf Synology RS422+
```

Unraid ist das primäre Backup-Ziel und soll Backrest betreiben. Die Synology RS422+ erhält eine zweite Sicherung der verschlüsselten Restic-Daten.

## Grundsätze

- Keine produktiven Änderungen ohne Freigabe durch Igi.
- Backups werden verschlüsselt abgelegt.
- Secrets werden nicht in GitHub, `4kc-docs` oder öffentliche Dokumentation übernommen.
- Datenbankdateien werden nicht blind aus Live-Volumes kopiert; MariaDB wird über konsistente Dumps gesichert.
- Backup- und Monitoring-Rechte werden getrennt.
- Backups gelten erst nach Restore-Test als verifiziert.

## 1. Zu sichernde Daten

### MariaDB Production

Kritisch.

Zu sichern:

- vollständiger SQL-Dump der Production-Datenbank
- Schema und Daten
- Routinen, Trigger und Events, falls genutzt
- Zeichensatz/Kollation muss erhalten bleiben

Empfehlung:

- täglicher konsistenter Dump
- `--single-transaction` für InnoDB
- komprimierter Dump
- optional zusätzlicher schema-only Dump für schnelle Strukturprüfung

### MariaDB Staging

Wichtig.

Zu sichern:

- vollständiger SQL-Dump der Staging-Datenbank
- getrennt von Production benennen und wiederherstellbar halten

Empfehlung:

- täglich oder mindestens vor größeren Staging-Tests/Deployments
- initial täglich sichern, da es einfacher und nachvollziehbarer ist

### Redis Production

Abhängig von Nutzung.

Zu sichern, wenn Redis produktive Zustände enthält:

- Queue-Zustände
- Horizon-Metadaten
- Sessions, falls Redis als Session Store genutzt wird

Nicht kritisch bzw. wiederherstellbar:

- Cache
- Locks
- Rate-Limits

Empfehlung:

- Redis Production täglich als RDB/AOF-Snapshot mitnehmen, solange dies sauber möglich ist.
- Restore-Priorität bleibt niedriger als MariaDB und Laravel Storage.
- Nach Restore muss die Anwendung auch mit leerem Redis starten können, falls Redis nur Cache/Queues enthält.

### Redis Staging

Optional.

Empfehlung:

- nur sichern, wenn Staging-Zustände für Tests relevant sind
- sonst wiederherstellbar/leerlaufend behandeln

### Laravel Storage

Kritisch, sobald produktive Dateien entstehen.

Zu sichern:

- `storage/app`
- Uploads
- generierte Dokumente
- Rechnungs-/PDF-Dateien, falls lokal gespeichert
- Import-/Export-Dateien
- private und public Storage Volumes, abhängig vom Deployment

Wichtig:

- Sobald Laravel produktive Dateien schreibt, ist Storage gleich wichtig wie die Datenbank.

### Coolify und Docker State

Zu sichern:

- Coolify persistente Volumes
- Coolify interne State-/Konfigurationsdaten, soweit von Coolify vorgesehen
- Projekt-/Resource-/Environment-Metadaten
- Reverse-Proxy-/Proxy-Konfigurationen, soweit persistent
- relevante Docker Compose-/Deployment-Artefakte
- persistente App-/Service-Volumes

Nicht öffentlich dokumentieren:

- produktive ENV-Werte
- Tokens
- Passwörter
- vollständige Secret-haltige Rohkonfigurationen

### Host-Konfiguration

Zu sichern als Wiederaufbauhilfe:

- `/etc` relevante Konfigurationen
- `/usr/local/sbin` relevante Betriebs-/Monitoring-/Backup-Scripts
- relevante systemd Units
- technische User-/SSH-/sudoers-Konfigurationen, bereinigt dokumentiert
- Paketlisten, z. B. `dpkg --get-selections` und `apt-mark showmanual`

## 2. Täglich zu sichernde Daten

Täglich Pflicht:

1. MariaDB Production
2. MariaDB Staging
3. Laravel Storage Production, sobald produktive Dateien vorhanden sind
4. Coolify persistente Konfiguration/State
5. relevante persistente Docker Volumes
6. Redis Production, falls Queue-/Session-Zustände relevant sind
7. Host-Konfigurationssnapshot oder mindestens die relevanten Wiederaufbauartefakte
8. Backup-Metadaten/Manifest mit Snapshot-ID, Zeitpunkt und enthaltenen Komponenten

Zusätzlich empfohlen:

- Pre-Deployment Snapshot vor Production Deployments
- zusätzlicher DB-Dump vor Migrationen
- Snapshot vor relevanten Infrastrukturänderungen

## 3. Nicht zu sichernde Daten

Nicht sichern oder bewusst ausschließen:

- Docker Images, da sie neu gezogen/gebaut werden können
- Container Overlay-Dateisysteme
- Laravel Cache, View Cache, Route Cache, Config Cache
- reine Redis Cache-Daten
- Build-Artefakte
- `node_modules`
- `vendor`, sofern aus Composer reproduzierbar
- `/tmp` und `/var/tmp`
- große kurzlebige Container-Logs ohne Betriebswert
- unverschlüsselte Secret-Exporte
- produktive Secrets in GitHub oder öffentlicher Dokumentation

## 4. Backrest-Zugriff auf srv120

Empfehlung:

Backrest läuft auf Unraid und greift per SSH auf `srv120` zu.

Begründung:

- Wenn `srv120` ausfällt, bleibt die Backup-Steuerung auf Unraid verfügbar.
- Unraid ist primäres Backup-Ziel.
- Backup-Repositories liegen lokal auf Unraid schneller und stabiler.
- `srv120` bleibt schlank und wird nicht zum Single Point of Failure seiner eigenen Backups.

Zugriffsmodell:

- eigener technischer Backup-User, z. B. `backrest-backup`
- nicht der Monitoring-User, da Monitoring und Backup unterschiedliche Rechte benötigen
- SSH key-based
- sudo nur für exakt definierte Dump-/Read-Scripts
- kein Root-Login
- keine Berechtigung für Updates, Reboots, Container-Restarts oder Konfigurationsänderungen

Hinweis:

Backup ist nicht vollständig read-only, weil konsistente Dumps temporäre Dateien erzeugen können. Deshalb soll der Backup-User nur in ein fest definiertes Staging-Verzeichnis schreiben dürfen, z. B. unter `/var/backups/srv120/`.

## 5. MariaDB Dumps

MariaDB wird über konsistente logische Dumps gesichert, nicht durch direktes Kopieren laufender Datenbankdateien.

Empfohlener Ablauf:

1. Backrest auf Unraid verbindet sich per SSH zu `srv120`.
2. SSH ruft ein kontrolliertes Script auf, z. B. `/usr/local/sbin/srv120-backup-mariadb-dumps`.
3. Das Script erstellt getrennte Dumps für Production und Staging.
4. Dumps werden temporär auf `srv120` abgelegt, z. B. unter `/var/backups/srv120/mariadb/`.
5. Backrest/Restic sichert diese Dump-Dateien verschlüsselt.
6. Temporäre Dumps werden nach erfolgreichem Backup kontrolliert rotiert oder überschrieben.

Empfohlene Dump-Optionen:

```text
--single-transaction
--quick
--routines
--triggers
--events
--default-character-set=utf8mb4
--hex-blob
```

Credentials:

- nicht in GitHub dokumentieren
- nicht in öffentliche Docs schreiben
- bevorzugt dedizierter MariaDB Backup-User mit minimalen Rechten
- keine Rechte für DROP, ALTER, INSERT, UPDATE oder DELETE

Empfohlene DB-Rechte für Backup-User:

- SELECT
- SHOW VIEW
- TRIGGER
- EVENT
- ggf. LOCK TABLES / PROCESS nur falls technisch nötig

## 6. Restore-Test

Ein Backup ist erst belastbar, wenn ein Restore getestet wurde.

### Monatlicher technischer Restore-Test

Ziel:

Prüfen, ob Backups lesbar und Dumps importierbar sind.

Ablauf:

1. Letzten Restic Snapshot aus Unraid in isolierten Testpfad wiederherstellen.
2. MariaDB Production Dump in temporäre Test-MariaDB importieren.
3. MariaDB Staging Dump optional separat importieren.
4. Prüfen:
   - Import erfolgreich
   - Tabellenanzahl plausibel
   - zentrale Tabellen vorhanden
   - Laravel Migration Status lesbar
   - keine offensichtlichen Encoding-Fehler
5. Laravel Storage in temporäres Verzeichnis wiederherstellen.
6. Stichproben auf Lesbarkeit und Verzeichnisstruktur prüfen.
7. Ergebnis dokumentieren: Datum, Snapshot-ID, Dump-Zeitpunkt, Importstatus, Storage-Status, Dauer und Auffälligkeiten.

### Quartalsweiser Applikations-Restore-Test

Ziel:

Prüfen, ob 4KC aus Backup und Git-Code lauffähig wiederhergestellt werden kann.

Ablauf:

1. Isolierte Restore-/Staging-Umgebung verwenden, nicht Production.
2. App-Code aus Git deployen.
3. ENV/Secrets manuell aus sicherer Quelle setzen, nicht aus Docs.
4. DB aus Backup importieren.
5. Storage aus Backup einhängen.
6. Laravel Checks durchführen:
   - `php artisan migrate:status`
   - Healthcheck/Login
   - zentrale Admin-Seiten
   - Kunden-/Domain-/Service-Listen
   - Queue/Redis soweit relevant
7. Kein Mailversand an Kunden und keine produktiven externen Webhooks.
8. Ergebnis als Restore-Protokoll dokumentieren.

## 7. Aufbewahrung

Empfohlene Start-Retention für Production:

```text
Daily:   14 Tage
Weekly:   8 Wochen
Monthly: 12 Monate
Yearly:   3 Jahre
```

Für Staging kann später reduziert werden:

```text
Daily:    7 Tage
Weekly:   4 Wochen
Monthly:  3 Monate
```

Initial ist ein gemeinsames Repository mit Tags sinnvoll:

```text
srv120
production
staging
mariadb
redis
storage
coolify
host-config
```

Synology RS422+:

Empfehlung für den Start:

- Backrest schreibt auf Unraid.
- Unraid repliziert das verschlüsselte Restic Repository zur Synology RS422+.
- Die Synology speichert nur verschlüsselte Repository-Daten, keine unverschlüsselten Staging-Dumps.

Später optional:

- zweites unabhängiges Restic Repository auf der Synology
- höhere Unabhängigkeit, aber mehr Komplexität und Netzwerklast

## Empfohlene Entscheidung

Backrest läuft auf Unraid als zentrale Backup-Steuerung. `srv120` wird per dediziertem SSH-Backup-User angebunden. MariaDB Production und Staging werden über kontrollierte Dump-Scripts auf `srv120` erzeugt und anschließend mit Restic gesichert. Laravel Storage, Coolify persistente Daten, Redis-Snapshots und relevante Host-Konfiguration werden ebenfalls in verschlüsselte Restic Snapshots aufgenommen. Unraid ist das primäre Backup-Ziel; die Synology RS422+ erhält eine zweite verschlüsselte Kopie. Backups gelten erst nach regelmäßigem Restore-Test als verifiziert.
