# 4KC Infrastructure

## Zielbild

4KC wird vollständig containerbasiert betrieben.

Host:

```text
srv120.4youhosting.ch
```

Betriebssystem:

```text
Ubuntu 24.04.4 LTS
```

Infrastruktur-Basis:

- Docker
- Coolify
- SSL/TLS über Coolify/Reverse Proxy
- DNS
- Firewall
- Fail2Ban
- Snapshots

## Aktueller Stand

```text
srv120
├── Ubuntu 24.04.4
├── Docker
├── Coolify
├── MariaDB
└── SSL / DNS
```

MariaDB läuft bereits erfolgreich als Docker-Container in Coolify.

Redis ist der nächste geplante Schritt.

## Architekturvorgabe

Auf dem Ubuntu-Host sollen für 4KC keine direkten Installationen folgender Komponenten erfolgen:

- PHP
- MariaDB
- Redis
- Nginx
- Apache

Alle 4KC-Komponenten werden als Container und über Coolify verwaltet.

## Coolify

Coolify ist die zentrale Betriebs- und Deployment-Plattform für 4KC.

Coolify verwaltet:

- Deployments
- Domains und SSL
- Environment Variables / Secrets
- Datenbankservices
- Redis-Service
- Worker/Scheduler/Horizon-Container
- Logs und Healthchecks
- Volumes und Backups, soweit über Coolify abgebildet

## Production Zielstruktur

```text
Production
├── 4kc-app-production
├── 4kc-worker-production
├── 4kc-scheduler-production
├── 4kc-horizon-production
├── 4kc-mariadb-production
└── 4kc-redis-production
```

## Staging Zielstruktur

```text
Staging
├── 4kc-app-staging
├── 4kc-worker-staging
├── 4kc-scheduler-staging
├── 4kc-horizon-staging
├── 4kc-mariadb-staging
└── 4kc-redis-staging
```

## Datenbank

MariaDB 11 wird als Docker-Container über Coolify betrieben.

Vorgaben:

- kein öffentlicher Datenbank-Port
- Zugriff nur über internes Docker/Coolify-Netzwerk
- persistentes Volume
- regelmässige Backups
- produktive Zugangsdaten nur in Coolify-Secrets oder einem separaten Secret-Management-System

## Redis

Redis oder Valkey soll als separater Container über Coolify betrieben werden.

Verwendung:

- Laravel Queue
- Laravel Cache
- Horizon
- Locks
- optional Sessions

Vorgaben:

- kein öffentlicher Redis-Port
- Passwort setzen
- Zugriff nur über internes Netzwerk
- eigenes Redis pro Environment

## Empfohlene Netzwerkstruktur

Production:

```text
4kc-production-internal
├── 4kc-app-production
├── 4kc-mariadb-production
├── 4kc-redis-production
├── 4kc-worker-production
├── 4kc-scheduler-production
└── 4kc-horizon-production
```

Staging:

```text
4kc-staging-internal
├── 4kc-app-staging
├── 4kc-mariadb-staging
├── 4kc-redis-staging
├── 4kc-worker-staging
├── 4kc-scheduler-staging
└── 4kc-horizon-staging
```

Production und Staging verwenden getrennte Datenbanken, Redis-Instanzen, Volumes und Environment Variables.

## Public Exposure

Öffentlich erreichbar sein sollen nur die Web-Endpunkte der Laravel-App über Coolify/Reverse Proxy.

Nicht öffentlich erreichbar:

- MariaDB
- Redis
- Worker
- Scheduler
- Horizon-Container
- interne Container-Netzwerke
