# ADR-0006: Öffentliches Dokumentationsrepository als zentrale Wissensbasis

Status: akzeptiert

Datum: 2026-05-29

## Kontext

ChatGPT, KI-Assistenten, Entwickler und externe Gesprächspartner sollen auf aktuelle Architektur- und Infrastrukturinformationen zugreifen können, ohne Zugriff auf den privaten Quellcode oder sensible Daten zu erhalten.

## Entscheidung

`Gamma-Solution/4kc-docs` wird als zentrale öffentliche Wissensbasis für 4KC verwendet.

Das private Source-Repository bleibt:

```text
Gamma-Solution/4kc-panel
```

## Begründung

- klare Trennung zwischen Source-Code und öffentlicher Projektdokumentation
- keine Freigabe privater Repository-Zugriffe nötig
- KI-Assistenten können mit öffentlicher, aktueller Dokumentation arbeiten
- Architekturentscheidungen bleiben langfristig nachvollziehbar
- öffentliches Repository kann sicher geteilt werden

## Alternativen

### Dokumentation nur im privaten Repository

Vorteil: alles an einem Ort.

Nachteil: KI-Assistenten und externe Personen benötigen Zugriff auf private Inhalte oder erhalten keine aktuelle Doku.

### Vollständiger Mirror privater Docs

Vorteil: weniger manuelle Pflege.

Nachteil: hohes Risiko für Secret-, Kunden- oder Quellcode-Leaks.

## Auswirkungen

- Wichtige Infrastruktur-, Architektur- und Entscheidungsdokumente werden zuerst oder spätestens parallel in `4kc-docs` aktualisiert.
- Keine Zugangsdaten, Tokens, Kundendaten, produktiven Secrets oder Quellcode in `4kc-docs`.
- `docs/SYNC_POLICY.md` definiert die Regeln für Übernahmen aus dem privaten Repository.
