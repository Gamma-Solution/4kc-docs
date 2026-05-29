# 4KC Docs

Öffentliche Dokumentationsbasis für das Projekt **4KC Panel**.

Dieses Repository enthält bewusst **ausschliesslich bereinigte Projektdokumentation**. Es ist dafür gedacht, Architektur, Infrastruktur, Roadmap und Projektentscheidungen öffentlich referenzierbar zu machen, ohne Zugriff auf das private Quellcode-Repository `Gamma-Solution/4kc-panel` zu benötigen.

## Zweck

- Öffentliche Wissensbasis für ChatGPT, Review-Agenten und externe Architekturgespräche
- Dokumentation der Zielarchitektur von 4KC
- Dokumentation der containerbasierten Betriebsstrategie über Docker + Coolify
- Nachvollziehbare Architekturentscheidungen und Roadmap
- Keine Offenlegung von Quellcode, Zugangsdaten, produktiven Secrets oder Kundendaten

## Repository-Regeln

Dieses Repository darf enthalten:

- Architektur- und Infrastrukturübersichten
- Roadmap und Modulplanung
- Betriebs- und Deployment-Konzepte
- ADRs / Architekturentscheidungen
- abstrakte Datenmodell-Dokumentation
- bereinigte Diagramme
- Glossar und Projektkontext

Dieses Repository darf **nicht** enthalten:

- Quellcode
- `.env` Dateien
- Zugangsdaten
- API Keys, Tokens, Passwörter, SSH Keys
- Kundendaten oder produktive Datenauszüge
- interne Betriebsnotizen mit Secrets
- Datenbank-Dumps
- private Logs
- direkte Kopien sensibler Konfigurationsdateien

## Struktur

```text
4kc-docs
├── README.md
├── docs
│   ├── PROJECT_CONTEXT.md
│   ├── INFRASTRUCTURE.md
│   ├── ARCHITECTURE.md
│   ├── DECISIONS.md
│   ├── ROADMAP.md
│   ├── DATABASE.md
│   ├── DEPLOYMENT.md
│   ├── BACKUP_STRATEGY.md
│   ├── SYNC_POLICY.md
│   └── GLOSSARY.md
├── diagrams
│   ├── infrastructure.drawio
│   ├── architecture.drawio
│   └── deployment.drawio
└── images
```

## Schnellzugriff

- [Projektkontext](docs/PROJECT_CONTEXT.md)
- [Infrastruktur](docs/INFRASTRUCTURE.md)
- [Architektur](docs/ARCHITECTURE.md)
- [Entscheidungen](docs/DECISIONS.md)
- [Roadmap](docs/ROADMAP.md)
- [Datenmodell](docs/DATABASE.md)
- [Deployment](docs/DEPLOYMENT.md)
- [Backup-Strategie](docs/BACKUP_STRATEGY.md)
- [Synchronisationsrichtlinie](docs/SYNC_POLICY.md)
- [Glossar](docs/GLOSSARY.md)
- [Meeting Notes](docs/MEETING_NOTES.md)

## Synchronisation aus dem privaten Repository

Die öffentliche Dokumentation wird aus bereinigten, nicht-sensiblen Teilen des privaten Repositories abgeleitet. Es werden **keine Dateien blind kopiert**. Jede Übernahme muss vor Veröffentlichung auf Secrets, Kundendaten und Quellcode geprüft werden.

Details: [docs/SYNC_POLICY.md](docs/SYNC_POLICY.md)

## Empfohlener Repository-Name

Empfohlen: `4kc-docs`

Begründung:

- kurz und eindeutig
- klar als Dokumentationsrepository erkennbar
- neutral genug für öffentliche Nutzung
- keine Verwechslung mit dem privaten Produktiv-/Source-Repository

Alternative Namen:

- `4kc-public-docs`
- `4kc-architecture-docs`
- `4kc-knowledge-base`

Für die aktuelle Zielsetzung ist `4kc-docs` die beste Wahl.
