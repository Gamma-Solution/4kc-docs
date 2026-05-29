# 4KC Staging Concept

Dieses Dokument beschreibt das empfohlene Staging-Konzept für 4KC.

Staging ist Pflicht vor jedem Production Deployment.

## Ziel

Staging validiert Build, Container-Start, ENV-Konfiguration, Migrationen und Smoke-Tests, bevor Production verändert wird.

## Branch-Zuordnung

```text
feature/*  -> Entwicklung / Review
staging    -> Staging Deployment
main       -> Production Deployment nach Review
```

## Coolify Struktur

Aktuell vorhanden:

```text
Project: 4KC
├── Environment: staging
│   ├── UUID: y48bhtrfu6lxx3n7lrsibh1j
│   ├── 4kc-staging-mariadb  running:healthy
│   └── 4kc-staging-redis    running:healthy
└── Environment: production
    ├── 4kc-mariadb-production / existing MariaDB resource
    └── 4kc-production-redis   running:healthy
```

Zielstruktur für die nächsten Schritte:

```text
4kc-app-staging
4kc-worker-staging
4kc-scheduler-staging
4kc-horizon-staging
```

Die App-/Worker-/Scheduler-/Horizon-Container werden erst nach aktiver privater GitHub App Integration und Build-Review angelegt.

## Trennung von Production

Staging verwendet eigene:

- ENV-Werte
- Datenbank
- Redis-Instanz
- Volumes
- Domains/Subdomains
- Laravel APP_KEY
- Mail-/Webhook-Testkonfiguration

Staging darf niemals Production-Datenbank oder Production-Redis verwenden.

## Domain-Konzept

Empfohlene öffentliche Staging-Domain:

```text
staging.4kc.ch
```

Alternativ bis zur finalen Domain-Entscheidung:

```text
staging.4youhosting.ch
```

## Deployment-Regeln

- Auto-Deploy für `staging` ist erlaubt, sobald Build zuverlässig ist.
- Production Auto-Deploy bleibt deaktiviert, bis der Release-Prozess stabil ist.
- Migrationen laufen zuerst in Staging.
- Production Deployment erfolgt erst nach Review.

## Staging Smoke-Test

Minimaler Smoke-Test nach Staging Deployment:

1. App URL erreichbar
2. `/up` erfolgreich
3. Login/Admin erreichbar
4. Migrationen aktuell
5. Queue Worker läuft
6. Scheduler läuft
7. Horizon läuft
8. Logs ohne kritische Fehler
9. Keine Verbindung zu Production-Diensten

## Nicht-Ziele dieses Schritts

In diesem Vorbereitungsschritt werden nicht ausgeführt:

- kein Production Deployment
- keine Production Migrationen
- keine Änderungen an MariaDB Production
- keine Änderungen an Basisinfrastruktur auf Ubuntu
