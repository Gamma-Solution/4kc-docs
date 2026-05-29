# 4KC Architecture Decisions

Dieses Dokument sammelt zentrale Architekturentscheidungen in kompakter ADR-Form.

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
