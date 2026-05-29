# 4KC Roadmap

## Aktueller Infrastruktur-Fokus

Priorität:

1. Redis Infrastruktur
2. GitHub App Integration für `Gamma-Solution`
3. Staging Environment
4. Dockerfile für `backend/`
5. Laravel Deployment auf Staging
6. Deployment Dokumentation
7. Backup- und Restore-Konzept dokumentieren

## Status

Bereits vorhanden:

- srv120 als Zielplattform
- Ubuntu 24.04.4
- Docker
- Coolify
- SSL/DNS
- MariaDB als Coolify-Container
- öffentliches Dokumentationsrepository `Gamma-Solution/4kc-docs`

Nächster geplanter Schritt:

- Redis als Coolify-Service für Production und Staging vorbereiten

## Empfohlene technische Reihenfolge

### Phase 1: Dokumentations- und Deployment-Basis

- öffentliches Repository `4kc-docs` als Wissensbasis pflegen
- wichtige Entscheidungen in `docs/MEETING_NOTES.md` nachführen
- private Dokumentation nur bereinigt in öffentliche Struktur überführen
- Coolify Project und Environments definieren
- Staging-Deployment zuerst vorbereiten
- Production erst nach Staging-Smoke-Test aktivieren

### Phase 2: Container-Grundlage

- eigenes Dockerfile für Laravel unter `backend/`
- `.dockerignore` für `backend/`
- App-Container definieren
- Worker-Container definieren
- Scheduler-Container definieren
- Horizon-Container definieren
- Redis-Service erstellen
- MariaDB-Service verifizieren

### Phase 3: GitHub + Coolify

- GitHub App Integration für Organisation `Gamma-Solution`
- privates Repository `Gamma-Solution/4kc-panel` anbinden
- Root Directory in Coolify auf `backend/` setzen
- Branch-Modell festlegen:
  - `main` für Production
  - `staging` oder `develop` für Staging
- Auto-Deploy erst nach stabilen Build-/Healthcheck-Ergebnissen aktivieren

### Phase 4: Laravel Deployment

- `.env.example` bereinigen
- Coolify ENV pro Environment setzen
- Build- und Release-Prozess dokumentieren
- Migration-Strategie festlegen
- Healthcheck einrichten
- Logs und Fehleranalyse vorbereiten

### Phase 5: Core-Funktionalität

- Auth/RBAC Foundation
- Kundenverwaltung
- Produkte/Pakete
- Bestellungen
- Abos/Verträge
- Rechnungen
- Tickets
- Benutzer- und Rollenmodell

### Phase 6: Provider-Module

- Registrar-Module getrennt halten
- Hosting-Control-Panel-Integrationen getrennt halten
- DNS-Zonenverwaltung getrennt halten
- Queue-first Operationsmodell etablieren
- Provider-Fähigkeiten und Fehlercodes zentralisieren

### Phase 7: Betrieb und Härtung

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

## Dokumentationsausbau

Ergänzt und künftig mitzuführen:

- ADR-Struktur unter `docs/ADR/`
- Projektstatus unter `docs/PROJECT_STATUS.md`
- Containerdokumentation unter `docs/CONTAINERS.md`
- Deployment Flow unter `docs/DEPLOYMENT_FLOW.md`
- Restore Procedure unter `docs/RESTORE_PROCEDURE.md`
