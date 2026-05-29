# 4KC Project Context

## Kurzbeschreibung

4KC ist ein Laravel-basiertes Hosting- und Kundenpanel als moderne Alternative zu klassischen WHMCS-Setups.

Das System soll Kunden, Produkte, Verträge, Rechnungen, Domains, Hosting-Abos, Tickets, Benutzer und Rechte in einem schlanken Core verwalten. Externe Provider werden nicht direkt im Core vermischt, sondern als klar getrennte Module oder Integrationen angebunden.

## Projektziele

- Laravel-first Architektur
- Filament/Blade/Livewire-orientiertes Admin- und Backoffice-Interface
- modularer Core mit klaren Provider-Grenzen
- containerbasierter Betrieb über Docker + Coolify
- sichere Verwaltung von Secrets ausserhalb der Repositories
- mehrsprachige UI und Systemmeldungen von Anfang an
- langfristig wartbare Betriebs- und Deployment-Struktur
- öffentliche, bereinigte Dokumentationsbasis für Architektur- und Infrastrukturwissen

## Repository-Modell

Privates Entwicklungsrepository:

```text
Gamma-Solution/4kc-panel
```

Öffentliches Dokumentationsrepository:

```text
Gamma-Solution/4kc-docs
```

Die Laravel-Anwendung befindet sich im privaten Repository unter:

```text
backend/
```

`4kc-docs` ist die zentrale öffentliche Wissensbasis. Es enthält keine Zugangsdaten, Tokens, Kundendaten, produktiven Secrets oder Quellcode.

## Grundprinzipien

1. Core bleibt schlank.
2. Provider-Logik bleibt in Modulen.
3. Registrar-, Hosting-, DNS-, Mail-, Backup- und Monitoring-Logik werden getrennt betrachtet.
4. UI löst keine Provider-Aktionen direkt aus, sondern arbeitet über Services, Operationen und Queues.
5. Alle sicherheitsrelevanten Informationen bleiben ausserhalb öffentlicher Dokumentation und ausserhalb des Source-Repositories.
6. Neue Features werden schrittweise geplant, implementiert, getestet und dokumentiert.
7. Wichtige Architektur- und Infrastrukturentscheidungen werden in `docs/DECISIONS.md`, `docs/ROADMAP.md` und `docs/MEETING_NOTES.md` nachgeführt.

## Aktuelle Hauptplattform

Die zukünftige Hauptplattform für 4KC ist `srv120.4youhosting.ch`.

Der Betrieb erfolgt vollständig containerbasiert über Docker und Coolify. Auf dem Host sollen keine direkten Installationen von PHP, MariaDB, Redis, Nginx oder Apache für 4KC erfolgen.

## Aktueller Infrastrukturstand

```text
srv120
├── Ubuntu 24.04.4
├── Docker
├── Coolify
├── MariaDB
└── SSL / DNS
```

MariaDB läuft bereits erfolgreich als Coolify-Container.

Redis ist der nächste geplante Infrastruktur-Schritt.

## Nicht-Ziele dieses Repositories

Dieses Repository enthält keinen Quellcode, keine produktiven Konfigurationsdateien und keine geheimen Zugangsdaten.
