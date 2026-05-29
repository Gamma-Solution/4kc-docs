# 4KC Backup Strategy

## Ziel

4KC benötigt eine Backup-Strategie für Datenbank, persistente Dateien und betriebsrelevante Konfigurationen, ohne Secrets öffentlich zu dokumentieren.

## Zielkette

```text
srv120
└── Backrest / Restic
    └── Unraid
        └── Synology RS422+
```

## Zu sichernde Daten

### MariaDB

Kritisch.

Enthält:

- Kunden
- Benutzerzuordnungen
- Rollen- und Berechtigungsdaten
- Bestellungen
- Rechnungen
- Domains
- Hosting-Abos
- Tickets
- Provider-Aktionsverläufe
- Systemeinstellungen

Empfehlung:

- tägliche Dumps
- Verschlüsselung
- Aufbewahrung: täglich / wöchentlich / monatlich
- Restore-Test regelmässig durchführen

### Laravel Storage

Kritisch, falls Dateien lokal gespeichert werden.

Mögliche Inhalte:

- Uploads
- Exporte
- generierte Dokumente
- Rechnungs-PDFs
- Import-/Export-Dateien

Empfehlung:

- persistentes Volume
- tägliche Sicherung
- langfristig Prüfung von S3-kompatiblem Storage oder separatem Datei-Storage

### Redis

Abhängig von Nutzung.

Wenn Redis nur für Cache und Queues verwendet wird, ist Redis nicht die wichtigste persistente Quelle.

Wenn Redis für Sessions oder kritische Locks verwendet wird, muss Persistenz und Restore-Verhalten bewusst geplant werden.

### Coolify-Konfiguration

Soweit möglich sichern oder dokumentieren:

- Projekte
- Environments
- Services
- Domains
- Volumes
- Deployment-Einstellungen

Secrets werden nicht in dieses öffentliche Repository übernommen.

## Restore-Test

Ein Backup ist erst belastbar, wenn ein Restore getestet wurde.

Empfohlener Test:

1. Staging-Umgebung vorbereiten
2. MariaDB-Dump einspielen
3. Storage-Daten einspielen
4. ENV-Werte setzen
5. Migration-/Schema-Status prüfen
6. Admin-Login prüfen
7. Queue/Horizon prüfen
8. Beispielprozesse testen

## Public-Docs-Abgrenzung

Dieses Dokument beschreibt die Backup-Strategie, aber enthält keine konkreten Zugangsdaten, Repository-Secrets, Passwörter oder vollständigen Backup-Befehle mit produktiven Pfaden/Keys.
