# ADR-0002: Eigenes Dockerfile statt Nixpacks als Langfriststrategie

Status: akzeptiert

Datum: 2026-05-29

## Kontext

Die Laravel-Anwendung liegt im privaten Repository `Gamma-Solution/4kc-panel` unter `backend/`. Für Coolify muss ein reproduzierbarer Build- und Runtime-Prozess definiert werden.

## Entscheidung

4KC verwendet langfristig ein eigenes Dockerfile unter:

```text
backend/Dockerfile
```

Zusätzlich wird eine `.dockerignore` gepflegt:

```text
backend/.dockerignore
```

Nixpacks wird nicht als langfristige Produktionsstrategie verwendet.

## Begründung

- explizite Kontrolle über PHP-Version und Extensions
- reproduzierbares Build-Verhalten
- gleiche Image-Basis für App, Worker, Scheduler und Horizon
- bessere Debugbarkeit bei Laravel, Filament, Vite und PHP-Extensions
- weniger implizite Automatik als bei Nixpacks

## Alternativen

### Nixpacks

Vorteil: schneller initialer Smoke-Test.

Nachteil: weniger explizit, schwerer zu kontrollieren, langfristig weniger transparent.

### Docker Compose

Vorteil: gut für lokale oder vollständig selbst definierte Multi-Service-Setups.

Nachteil: in Coolify werden getrennte Services für App, Worker, Scheduler, Horizon, MariaDB und Redis bevorzugt.

## Auswirkungen

- Coolify Root Directory: `backend/`
- Build Type: Dockerfile
- App, Worker, Scheduler und Horizon verwenden dasselbe Image mit unterschiedlichen Startcommands.
- Migrationen werden nicht im Dockerfile ausgeführt, sondern im kontrollierten Release-/Deploy-Schritt.
