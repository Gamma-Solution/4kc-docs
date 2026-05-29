# ADR-0001: Coolify als Deployment- und Betriebsplattform

Status: akzeptiert

Datum: 2026-05-29

## Kontext

4KC soll auf `srv120.4youhosting.ch` vollständig containerbasiert betrieben werden. Die Plattform soll Deployments, SSL, Domains, Environment Variables, Services, Logs und Healthchecks zentral verwalten.

## Entscheidung

Coolify wird als zentrale Deployment- und Betriebsplattform für 4KC eingesetzt.

## Begründung

- Docker-native Betriebsweise
- einfache Verwaltung von Domains und SSL
- integrierte Verwaltung von Environment Variables und Secrets
- Unterstützung für GitHub-basierte Deployments
- Verwaltung separater Services wie MariaDB und Redis
- geeignet für Production und Staging auf derselben Host-Plattform

## Alternativen

### Manuelles Docker auf dem Host

Vorteil: maximale Kontrolle.

Nachteil: mehr manueller Betriebsaufwand, weniger standardisierte Deployments, höheres Risiko für Konfigurationsdrift.

### Kubernetes

Vorteil: sehr skalierbar.

Nachteil: für den aktuellen Projektstand zu komplex und unnötig hoher Betriebsaufwand.

### Klassischer LAMP/LEMP Hostbetrieb

Vorteil: bekanntes Modell.

Nachteil: widerspricht der Vorgabe, keine direkten Host-Installationen von PHP, MariaDB, Redis, Nginx oder Apache für 4KC zu verwenden.

## Auswirkungen

- Alle Deployments laufen über Coolify.
- Services werden in Coolify getrennt verwaltet.
- Secrets werden in Coolify gepflegt und nicht in GitHub gespeichert.
- GitHub Integration soll bevorzugt über eine GitHub App erfolgen.
