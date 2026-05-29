# 4KC Architecture Decisions

Dieses Dokument sammelt zentrale Architektur- und Infrastrukturentscheidungen.

## Entscheidungsformat

Neue Architektur- und Infrastrukturentscheidungen werden künftig mit eindeutiger `DEC-*` ID dokumentiert.

Format:

```text
ID:
DEC-0001

Titel:
...

Datum:
YYYY-MM-DD

Entscheidung:
...

Begründung:
...

Alternativen:
...

Auswirkungen:
...
```

Bestehende ADR-Einträge bleiben als historischer Bestand erhalten. Neue Entscheidungen verwenden das `DEC-*` Format.

## ADR-001: Laravel-first

Status: akzeptiert

4KC wird vollständig mit Laravel entwickelt.

Begründung:

- einheitlicher Stack
- gute Admin-/Backoffice-Basis mit Filament
- starkes Ökosystem für Queues, Jobs, Auth, Policies, Notifications und Scheduler
- gute Wartbarkeit für ein Hosting-/Kundenpanel

## ADR-002: Containerbetrieb über Docker + Coolify

Status: akzeptiert

Alle produktiven Komponenten werden containerbasiert betrieben und über Coolify verwaltet.

Begründung:

- reproduzierbare Deployments
- klare Trennung der Services
- keine Vermischung mit Host-Paketen
- einfache Verwaltung von Domains, SSL, Volumes und Environment Variables

## ADR-003: Eigener Dockerfile-Ansatz für Laravel

Status: akzeptiert

Für das erste echte Deployment wird ein eigenes Dockerfile unter `backend/` verwendet.

Begründung:

- volle Kontrolle über PHP-Version und Extensions
- reproduzierbares Build-Verhalten
- gleiche Image-Basis für App, Worker, Scheduler und Horizon
- besser wartbar als Nixpacks für ein langfristiges Produktionssystem

Nixpacks ist nur für einen schnellen Smoke-Test akzeptabel. Docker Compose ist eher für lokale Entwicklung oder Sonderfälle geeignet.

## ADR-004: Coolify GitHub App für Repository-Anbindung

Status: empfohlen

Die GitHub-Anbindung von Coolify soll bevorzugt über eine GitHub App erfolgen.

Begründung:

- Least Privilege
- gute Webhook-Integration
- repo-spezifische Freigabe
- besser wartbar als persönliche SSH Keys oder breit berechtigte Tokens

## ADR-005: Öffentliche Dokumentation getrennt vom Source-Repository

Status: akzeptiert

Öffentliche Dokumentation wird im separaten Repository `Gamma-Solution/4kc-docs` gepflegt.

Begründung:

- ChatGPT und externe Tools können auf aktuelle Architekturinformationen zugreifen
- privater Quellcode bleibt geschützt
- Secrets, Kundendaten und produktive Konfigurationen bleiben intern
- öffentliche Kommunikation wird konsistenter

## ADR-006: Environment Variables nur in Coolify/Secret Management

Status: akzeptiert

Produktive `.env` Werte werden nicht im Repository gepflegt.

Begründung:

- Schutz vor Secret-Leaks
- klare Trennung von Code und Konfiguration
- getrennte Werte pro Environment

## ADR-007: Production und Staging trennen

Status: akzeptiert

Production und Staging werden als getrennte Coolify-Environments mit eigenen Datenbanken, Redis-Instanzen, Volumes und ENV-Werten betrieben.

Begründung:

- sichere Tests vor Production
- keine Vermischung von Daten
- reproduzierbarer Deployment-Prozess

## ADR-008: 4kc-docs als zentrale öffentliche Wissensbasis

Status: akzeptiert

`Gamma-Solution/4kc-docs` ist die zentrale öffentliche Wissensbasis für Architektur, Infrastruktur, Entscheidungen und Roadmap.

Verbindlich zu aktualisieren nach wichtigen Architektur- oder Infrastrukturentscheidungen:

- `docs/PROJECT_CONTEXT.md`
- `docs/INFRASTRUCTURE.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISIONS.md`
- `docs/ROADMAP.md`
- `docs/MEETING_NOTES.md`

Nicht erlaubt:

- Zugangsdaten
- Tokens
- Kundendaten
- produktive Secrets
- Quellcode


## ADR-Verzeichnis

Historische Detailentscheidungen wurden zusätzlich als einzelne ADRs gepflegt:

```text
docs/ADR/
```

Startset:

- ADR-0001 Coolify
- ADR-0002 Dockerfile vs Nixpacks
- ADR-0003 MariaDB vs PostgreSQL
- ADR-0004 Container Strategy
- ADR-0005 Backup Strategy
- ADR-0006 Public Docs Knowledge Base

Künftige Entscheidungen werden direkt in diesem Dokument als `DEC-*` Einträge geführt, damit neue Entwickler und KI-Agenten Entscheidungen eindeutig referenzieren können.

## ADR-009: Rollenmodell und Production Guardrails

Status: akzeptiert

4KC arbeitet mit klar getrennten Rollen:

- Igi: Product Owner, finale Entscheidungen, Freigabe von Production und Migrationen, Verwaltung von Secrets und Zugängen.
- Hermes: Infrastruktur- und Deployment-Agent für Staging, Coolify, Docker, Build-Analyse, Dokumentation, Deployment-Vorbereitung und Architekturumsetzung.
- ChatGPT: Architekturreview, Gegenprüfung, Strategie, Sicherheitsreview und Qualitätskontrolle.

Hermes darf selbständig vorbereitende Arbeiten in Staging und Dokumentation ausführen, insbesondere Staging-Aufbau, Build-Log-Analyse, Dockerfile-Anpassungen, GitHub-Integration, Staging Redis/MariaDB, `4kc-docs` und Deployment-Prozessvorbereitung.

Ohne explizite Freigabe durch Igi sind blockiert:

- Production Deployment
- Migrationen
- Änderungen an Production-Datenbanken
- Änderungen an der Ubuntu/Docker/Coolify-Basis
- Secrets lesen oder speichern
- Ressourcen löschen

Verbindliche Arbeitsreihenfolge:

1. Staging
2. Build validieren
3. Dockerfile validieren
4. Healthchecks
5. Review
6. Production

Begründung:

- klare Verantwortlichkeiten
- sichere Trennung von Vorbereitung und Production
- nachvollziehbare Übergabe an neue Entwickler oder KI-Agenten
- minimiertes Risiko für Daten, Secrets und produktive Dienste
