# 4KC Database

## Datenbanktechnologie

4KC verwendet MariaDB 11 als relationale Datenbank.

Die Datenbank läuft als Container über Coolify und ist nur intern erreichbar.

## Datenmodell: Hauptbereiche

Das Datenmodell ist fachlich in Core- und Modulbereiche gegliedert.

### Core

- Benutzer
- Rollen und Berechtigungen
- Kunden
- Adressen
- Produkte / Pakete
- Bestellungen
- Rechnungen
- Hosting-Abos
- Domains als Kundenobjekte
- Tickets
- Systemeinstellungen
- Jobs / Queues
- Scheduled Jobs

### Registrar / Domain

- Domain-Registrar-Konfigurationen
- Kunden-Domains
- Domain-Provisioning-Aktionen
- Domain-Sync-Läufe
- Registrar Webhook Events
- Provider-spezifische Payloads als gekapselte Datenbereiche

### Hosting

- Hosting-Server
- Hosting-Abos
- Hosting-Provisioning-Aktionen
- Provider-spezifische Felder für Hosting-Integrationen

## Grundregeln

- Migrationen müssen reversibel sein.
- Fremdschlüssel und Indizes sollen explizit und mit kurzen Namen benannt werden, um MariaDB/MySQL-Limits zu vermeiden.
- Secrets werden nicht unverschlüsselt gespeichert.
- Provider-spezifische Payloads dürfen nicht zu Core-Abhängigkeiten werden.
- Staging und Production verwenden getrennte Datenbanken.

## Public-Docs-Abgrenzung

Dieses Dokument beschreibt nur das konzeptionelle Datenmodell.

Nicht enthalten:

- produktive Daten
- Dumps
- echte Kundendaten
- Zugangsdaten
- vollständige Migration-Dateien
- Quellcode

## Backup-Relevanz

Besonders kritisch für Backups:

- Kunden
- Benutzerzuordnungen
- Rechnungen
- Bestellungen
- Domains
- Hosting-Abos
- Tickets
- Provider-Aktionsverläufe
- Systemeinstellungen

Redis wird für Queues, Cache, Horizon und optional Sessions verwendet. Die MariaDB bleibt die zentrale persistente Quelle für geschäftskritische Daten.
