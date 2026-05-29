# ADR-0005: Backup-Strategie über Backrest/Restic, Unraid und Synology

Status: akzeptiert

Datum: 2026-05-29

## Kontext

4KC benötigt eine wiederherstellbare Backup-Strategie für Datenbank, Laravel Storage, Coolify-Konfiguration und Serverausfall-Szenarien.

## Entscheidung

Die Ziel-Backup-Kette lautet:

```text
srv120
└── Backrest / Restic
    └── Unraid
        └── Synology RS422+
```

## Begründung

- mehrstufige Sicherung ausserhalb des produktiven Servers
- Restic/Backrest unterstützt verschlüsselte, inkrementelle Backups
- Unraid und Synology bieten zusätzliche Redundanz
- Restore-Prozesse können auf Staging getestet werden

## Alternativen

### Nur Coolify-interne Backups

Vorteil: einfach.

Nachteil: nicht ausreichend als vollständiges Offsite-/Mehrstufen-Konzept.

### Nur Server-Snapshots

Vorteil: schnell für Rollbacks.

Nachteil: kein Ersatz für granulare DB-/Storage-Restores und externe Sicherung.

## Auswirkungen

- MariaDB Dumps sind kritisch.
- Laravel Storage muss gesichert werden, sobald produktive Dateien entstehen.
- Redis Restore ist abhängig von Nutzung zu bewerten.
- Restore-Prozeduren werden in `docs/RESTORE_PROCEDURE.md` dokumentiert.
- Regelmässige Restore-Tests auf Staging werden empfohlen.
