# Backup T08 Coolify / Container Inventory

Datum: 2026-05-30
Quelle: read-only Monitoring über `hermes-monitor` und `/usr/local/sbin/srv120-monitor-readonly`.

## Status

```text
Status: teilweise erledigt
```

## Erkannte Runtime

```text
Ubuntu: 24.04.4 LTS
Docker: 29.5.2
Docker Compose: v5.1.4
Disk /: 5% belegt
RAM: unauffällig
```

## Erkannte Container

```text
cnohbgibw9x8kzj6e8zmwtct   redis:7-alpine                               Up / healthy
jp8vk5wippj9cxuj1wwt34pa   mariadb:11                                   Up / healthy
bcc5hpvcj8alax9efh7jvgif   redis:7-alpine                               Up / healthy
pcamvbtbrzief6cxc0uyb4jc   mariadb:11                                   Up / healthy
coolify-proxy              traefik:v3.6                                 Up / healthy
coolify-sentinel           ghcr.io/coollabsio/sentinel:0.0.21           Up / healthy
coolify                    ghcr.io/coollabsio/coolify:4.1.1             Up / healthy
coolify-db                 postgres:15-alpine                           Up / healthy
coolify-redis              redis:7-alpine                               Up / healthy
coolify-realtime           ghcr.io/coollabsio/coolify-realtime:1.0.15   Up
```

## Backup-Relevanz

Kritisch / wahrscheinlich relevant:

- MariaDB Production Container
- MariaDB Staging Container
- Laravel Storage Volumes, sobald App-Container produktiv Dateien schreiben
- Coolify persistente Daten / Coolify DB
- Reverse Proxy persistenter Zustand, falls für Recovery erforderlich

Optional / abhängig von Nutzung:

- Redis Production
- Redis Staging
- Horizon-/Queue-Zustand

Nicht sichern als Primärziel:

- Docker Images
- Container Overlay Filesystems
- Build Cache
- kurzlebige Logs

## Offene Punkte

Die vollständige Docker-Volume-/Mount-Liste ist im aktuellen read-only Monitoring-Script nicht enthalten. Für final vollständiges T08 braucht es eine der folgenden Freigaben:

1. Erweiterung des read-only Monitoring-Scripts um `docker volume ls` und sanitisiertes `docker inspect` für Mounts ohne Secrets.
2. Admin/root-Ausführung eines dedizierten, sanitisierten Inventar-Scripts.

## Ergebnis

T08 ist containerseitig teilweise erledigt, aber volume-seitig noch nicht vollständig belastbar.
