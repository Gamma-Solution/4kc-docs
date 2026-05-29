# ADR-0003: MariaDB 11 als initiale relationale Datenbank

Status: akzeptiert

Datum: 2026-05-29

## Kontext

4KC benötigt eine relationale Datenbank für Kunden, Benutzer, Rollen, Produkte, Bestellungen, Rechnungen, Domains, Hosting-Abos, Tickets und Betriebsdaten.

MariaDB 11 wurde bereits als Docker-Container in Coolify erstellt und läuft erfolgreich.

## Entscheidung

4KC verwendet initial MariaDB 11 als relationale Datenbank.

## Begründung

- MariaDB 11 ist bereits produktionsnah in Coolify eingerichtet.
- Laravel unterstützt MariaDB/MySQL stabil.
- Für den aktuellen Funktionsumfang ist MariaDB ausreichend.
- Die Betriebsumgebung ist bereits auf MariaDB vorbereitet.

## Alternativen

### PostgreSQL

Vorteil: sehr stark bei komplexen Datenmodellen, JSON, Constraints und erweiterten Datenbankfeatures.

Nachteil: aktuell nicht eingerichtet; Wechsel würde den bereits aufgebauten MariaDB-Service ersetzen oder zusätzliche Komplexität schaffen.

### SQLite

Vorteil: einfach für lokale Tests.

Nachteil: nicht geeignet als produktive Datenbank für 4KC.

## Auswirkungen

- Laravel `DB_CONNECTION` wird für MariaDB/MySQL konfiguriert.
- Migrationen müssen MySQL/MariaDB-kompatibel bleiben.
- Fremdschlüssel- und Indexnamen sollen bewusst kurz gehalten werden, um MySQL/MariaDB-Limits zu vermeiden.
- Staging und Production verwenden getrennte MariaDB-Container und Volumes.
