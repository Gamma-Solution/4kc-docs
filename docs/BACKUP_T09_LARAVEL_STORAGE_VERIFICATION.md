# Backup T09 Laravel Storage Pfade verifizieren

Datum: 2026-05-30
Quelle: read-only Monitoring über `hermes-monitor` und `/usr/local/sbin/srv120-monitor-readonly`.

## Status

```text
Status: blockiert / noch nicht vollständig anwendbar
```

## Befund

In der aktuellen read-only Containerliste sind keine laufenden Laravel App-/Worker-/Scheduler-/Horizon-Container sichtbar.

Erkannte Runtime-Container betreffen aktuell:

- Coolify
- Coolify DB
- Coolify Redis
- Coolify Realtime
- Coolify Proxy / Traefik
- MariaDB Production/Staging
- Redis Production/Staging

Damit können Laravel Storage Mounts derzeit nicht belastbar aus laufenden App-Containern verifiziert werden.

## Zielpfade für spätere Verifikation

Sobald Laravel App-Container laufen, müssen diese Pfade/Mounts geprüft werden:

```text
storage/app
storage/app/public
private uploads
public uploads
generated documents
PDFs/invoices falls lokal gespeichert
imports/exports falls Business Records
```

Auszuschließen bzw. nicht als kritische Business-Daten zu behandeln:

```text
storage/framework/cache
storage/framework/views
runtime logs, falls nicht Compliance-relevant
Laravel cache/config/route/view cache
vendor/node_modules falls reproduzierbar
```

## Benötigte nächste Prüfung

Für Abschluss T09 braucht es eine der folgenden Optionen:

1. Laravel App/Worker/Scheduler/Horizon Container laufen und sind per read-only Docker Inspect/Mount-Liste prüfbar.
2. Coolify Resource-Konfiguration/Mounts werden bereinigt exportiert.
3. Admin/root führt ein dediziertes sanitisiertes Inventar-Script aus.

## Ergebnis

T09 kann noch nicht final abgeschlossen werden. Es wurden keine Änderungen auf `srv120` durchgeführt und keine Secrets gelesen.
