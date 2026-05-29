# 4KC Roadmap

## Aktueller Infrastruktur-Fokus

1. Redis-Container in Coolify erstellen
2. GitHub-Integration über Coolify sauber anbinden
3. Deployment-Strategie für Laravel unter `backend/` festlegen
4. Laravel Deployment über Coolify vorbereiten
5. Environment Variables pro Environment definieren
6. Migrationen für Staging/Production vorbereiten
7. Backup-Konzept über Unraid und Synology integrieren

## Empfohlene technische Reihenfolge

### Phase 1: Dokumentations- und Deployment-Basis

- öffentliches Repository `4kc-docs` aufbauen
- private Dokumentation bereinigt in öffentliche Struktur überführen
- Coolify Project und Environments definieren
- Staging-Deployment zuerst vorbereiten
- Production erst nach Staging-Smoke-Test aktivieren

### Phase 2: Container-Grundlage

- eigenes Dockerfile für Laravel unter `backend/`
- App-Container definieren
- Worker-Container definieren
- Scheduler-Container definieren
- Horizon-Container definieren
- Redis-Service erstellen
- MariaDB-Service verifizieren

### Phase 3: Laravel Deployment

- `.env.example` bereinigen
- Coolify ENV pro Environment setzen
- Build- und Release-Prozess dokumentieren
- Migration-Strategie festlegen
- Healthcheck einrichten
- Logs und Fehleranalyse vorbereiten

### Phase 4: Core-Funktionalität

- Auth/RBAC Foundation
- Kundenverwaltung
- Produkte/Pakete
- Bestellungen
- Abos/Verträge
- Rechnungen
- Tickets
- Benutzer- und Rollenmodell

### Phase 5: Provider-Module

- Registrar-Module getrennt halten
- Hosting-Control-Panel-Integrationen getrennt halten
- DNS-Zonenverwaltung getrennt halten
- Queue-first Operationsmodell etablieren
- Provider-Fähigkeiten und Fehlercodes zentralisieren

### Phase 6: Betrieb und Härtung

- Backup/Restore-Test
- Monitoring
- Security-Härtung
- i18n-Audit
- Architektur-Guardrails in Tests/CI
- öffentliche Dokumentation aktuell halten

## Definition of Done für Infrastrukturänderungen

Eine Infrastrukturänderung ist erst abgeschlossen, wenn:

- Änderung dokumentiert ist
- keine Secrets im Repository landen
- Staging erfolgreich getestet wurde
- Production-Auswirkung klar ist
- Rollback oder Restore-Ansatz bekannt ist
- Healthcheck erfolgreich ist
