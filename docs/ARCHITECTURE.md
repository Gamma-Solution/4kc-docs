# 4KC Architecture

## Stack

- Laravel 11
- PHP 8.3+
- Filament / Blade / Livewire
- MariaDB 11
- Redis oder Valkey
- Laravel Queues
- Laravel Scheduler
- Laravel Horizon
- Docker
- Coolify

## Repository-Modell

Privates Source-Repository:

```text
Gamma-Solution/4kc-panel
```

Empfohlene Struktur im privaten Repository:

```text
4kc-panel
├── backend
├── frontend
├── docker
├── infra
├── docs
└── scripts
```

Bedeutung:

- `backend/`: Laravel-Anwendung
- `frontend/`: reserviert für separates Frontend oder spätere UI-Apps
- `docker/`: Docker-bezogene Hilfsdateien, falls nicht direkt unter `backend/`
- `infra/`: Infrastruktur- und Betriebsnotizen ohne Secrets
- `docs/`: private Arbeitsdokumentation
- `scripts/`: Hilfsskripte ohne Secrets

## Core-vs-Module-Prinzip

Der Core enthält zentrale fachliche Bausteine:

- Kunden
- Benutzer und Rollen
- Produkte / Pakete
- Bestellungen
- Verträge / Abos
- Rechnungen
- Tickets
- Einstellungen
- API- und Operation-Grundlagen
- Logging und Audit-Grundlagen

Module und Integrationen enthalten Provider-spezifische Logik:

- Registrar-Provider
- Hosting-Control-Panel-Provider
- DNS-Provider
- Mail-Provider
- Backup-Provider
- Monitoring-Provider

Provider-spezifische Details dürfen nicht direkt in UI- oder Core-Klassen vermischt werden.

## Provider-Trennung

Registrar-Logik und Hosting-Logik sind strikt getrennt.

Beispiele:

- InterNetX und SWITCH EPP werden als getrennte Registrar-Flows behandelt.
- Plesk oder andere Hosting-Control-Panels werden als Hosting-Provider behandelt.
- DNS-Zonen, Registrar-Domainstatus und Hosting-Abos bleiben fachlich getrennte Konzepte.

## Operation-Service-Prinzip

Provider-Aktionen sollen über einheitliche Operationen laufen:

1. UI erstellt eine Aktion oder Anfrage.
2. Operation-Service validiert Kontext, Berechtigungen und Provider-Fähigkeiten.
3. Queue Job führt die Aktion aus.
4. Ergebnis wird protokolliert.
5. UI zeigt Status, Verlauf und Ergebnis an.

Vorteile:

- bessere Testbarkeit
- weniger direkte Provider-Abhängigkeiten in Filament
- zentrale Fehlerbehandlung
- bessere Nachvollziehbarkeit
- Queue-first und retry-fähig

## i18n-First

Mehrsprachigkeit ist ein Architektur-Requirement.

Alle UI-Texte, Labels, Menüs, Notifications und Fehlermeldungen sollen über Übersetzungsschlüssel gepflegt werden.

Ziel:

- Deutsch und Englisch als Basis
- Provider-spezifische Texte ebenfalls übersetzbar
- keine hart kodierten UI-Texte in zentralen Oberflächen

## Security by Default

Grundregeln:

- Secrets nie im Repository
- Secrets nie in öffentlicher Dokumentation
- Provider-Credentials verschlüsselt speichern
- Least Privilege bei GitHub, Coolify und Provider-Zugängen
- TLS-Verifikation standardmässig aktiv
- sensitive Operationen serverseitig authorisieren
- Secrets in Logs und UI-Ausgaben maskieren
- öffentliche Dokumentation vor Veröffentlichung auf Leaks prüfen
