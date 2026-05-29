# ADR-0004: Container-Strategie für App, Worker, Scheduler und Horizon

Status: akzeptiert

Datum: 2026-05-29

## Kontext

Laravel benötigt neben dem Web-Prozess zusätzliche Prozesse für Queues, geplante Aufgaben und Horizon. Diese Prozesse sollen wartbar und unabhängig betreibbar sein.

## Entscheidung

4KC verwendet getrennte Coolify-Deployments/Container für:

```text
4kc-app-<environment>
4kc-worker-<environment>
4kc-scheduler-<environment>
4kc-horizon-<environment>
```

MariaDB und Redis laufen als separate Coolify-Services.

## Begründung

- klare Prozessverantwortung
- getrennte Logs
- getrennte Neustarts
- einfachere Skalierung der Worker
- kein überladener All-in-one-Container
- gleiche Image-Basis mit unterschiedlichen Commands

## Alternativen

### Alles in einem Container

Vorteil: weniger Services.

Nachteil: schlechtere Wartbarkeit, unklare Logs, schwierigere Skalierung und Fehleranalyse.

### Supervisor für alle Prozesse in einem Container

Vorteil: technisch möglich.

Nachteil: für Production weniger sauber als getrennte Coolify-Services.

## Auswirkungen

Production-Zielstruktur:

```text
4kc-app-production
4kc-worker-production
4kc-scheduler-production
4kc-horizon-production
4kc-mariadb-production
4kc-redis-production
```

Staging-Zielstruktur:

```text
4kc-app-staging
4kc-worker-staging
4kc-scheduler-staging
4kc-horizon-staging
4kc-mariadb-staging
4kc-redis-staging
```
