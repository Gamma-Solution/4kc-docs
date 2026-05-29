# 4KC Redis

Dieses Dokument beschreibt die bereinigte Redis-Konfiguration für 4KC Production.

Es enthält keine Passwörter, Tokens oder produktiven Secrets.

## Status

```text
Status: erstellt
Plattform: Coolify
Server: srv120
Environment: production
```

## Coolify Resource

```text
Name: 4kc-production-redis
UUID: bcc5hpvcj8alax9efh7jvgif
Typ: standalone-redis
Image: redis:7-alpine
Status: running:healthy
Public: false
Public Port: none
Docker Destination: coolify
Docker Network: coolify
```

## Zweck

Redis wird für Laravel Production vorbereitet als:

- Queue Backend
- Cache Backend
- Session Backend, falls aktiviert
- Cache/Queue Locks
- Horizon Backend und Monitoring-Quelle
- Scheduler Mutexes, falls Laravel diese über Cache/Redis nutzt

## Laravel ENV Zielwerte

Die konkreten Secrets werden ausschliesslich in Coolify gepflegt.

Empfohlene nicht-sensitive Zielwerte:

```text
QUEUE_CONNECTION=redis
CACHE_STORE=redis
SESSION_DRIVER=redis
REDIS_HOST=bcc5hpvcj8alax9efh7jvgif
REDIS_PORT=6379
REDIS_CLIENT=phpredis
```

Falls in Coolify später ein Redis-Passwort gesetzt wird:

```text
REDIS_PASSWORD=<in Coolify als Secret setzen>
```

## Exponierung

Redis bleibt intern.

```text
is_public=false
public_port=null
```

Keine direkte Veröffentlichung über Firewall, Public Port oder Reverse Proxy.

## Abhängige Container

Folgende 4KC-Container verwenden Redis später:

- `4kc-app-production`
- `4kc-worker-production`
- `4kc-scheduler-production`
- `4kc-horizon-production`

## Betriebsregeln

- Redis ist kein öffentlich erreichbarer Dienst.
- App/Worker/Scheduler/Horizon verwenden dieselbe Redis-Resource.
- Keine Secrets in GitHub oder öffentlicher Dokumentation.
- Keine Migrationen oder Laravel Production Deployments im Rahmen der Redis-Erstellung.
- Änderungen an Redis-Passwort oder Persistenzstrategie nur nach Review.

## Coolify 4.1.1 Hinweis

Bei API-Tests wurde festgestellt, dass Coolify 4.1.1 sensitive Daten für Datenbank-Ressourcen über API-Responses mitliefern kann, wenn ein Token mit read/write verwendet wird.

Daraus folgt:

- API-Tokens möglichst kurzlebig und restriktiv verwenden.
- Responses nie ungefiltert in Logs oder Dokumentation kopieren.
- Secrets ausschliesslich in Coolify pflegen.
- Öffentliche Doku enthält nur bereinigte Resource-Metadaten.
