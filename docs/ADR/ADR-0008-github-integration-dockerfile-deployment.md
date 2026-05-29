# ADR-0008: GitHub App und Dockerfile-basierte Deployment-Strategie

## Status

Vorgeschlagen

## Kontext

Das private 4KC Source Repository ist:

```text
Gamma-Solution/4kc-panel
```

Die Laravel-Anwendung liegt im Unterordner:

```text
backend/
```

4KC soll vollständig containerbasiert über Docker und Coolify betrieben werden. Production Deployments sollen nicht direkt aus lokalen Maschinen oder durch Host-Installationen erfolgen.

## Entscheidung

4KC soll über eine private GitHub App Integration in Coolify mit dem Repository `Gamma-Solution/4kc-panel` verbunden werden.

Als Deployment-Strategie wird ein Dockerfile-basierter Build aus `backend/` verwendet.

Branch-Zuordnung:

```text
staging -> Staging Environment
main    -> Production Environment nach Review
```

Production Auto-Deploy bleibt zunächst deaktiviert, bis Staging, Migrationen, Healthchecks und Rollback/Restore validiert sind.

## Begründung

Eine GitHub App Integration ist gegenüber persönlichen Tokens wartbarer und restriktiver. Ein eigenes Dockerfile ist für Laravel Production langfristig reproduzierbarer als Nixpacks und erlaubt klare Trennung zwischen Build, Runtime, Worker, Scheduler und Horizon.

## Alternativen

### Personal Access Token

Wurde verworfen als langfristige Strategie, weil persönlicher Zugriff schwerer zu auditieren und zu rotieren ist.

### Nixpacks

Kann für frühe Tests hilfreich sein, wird aber nicht als langfristiger Production-Standard festgelegt.

### Direkte Deployments per SSH

Wurde verworfen. 4KC soll über Coolify/Docker betrieben werden, nicht über manuelle Host-Installationen.

## Auswirkungen

- Coolify benötigt Zugriff auf `Gamma-Solution/4kc-panel`.
- `backend/Dockerfile` wird Teil des Release-Vertrags.
- App, Worker, Scheduler und Horizon verwenden dasselbe Image.
- Migrationen bleiben ein kontrollierter Release-Schritt und laufen nicht im Dockerfile.
- Production Deployment erfolgt erst nach Review und Staging-Validierung.
