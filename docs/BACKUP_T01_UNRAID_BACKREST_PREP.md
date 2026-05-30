# T01 Backrest auf Unraid vorbereiten

## Ziel

T01 bereitet Backrest auf Unraid als primären Backup-Controller vor, ohne Backup-Jobs, Schedules, Repositories oder produktive Quellen zu erstellen.

## Status

```text
Status: teilweise vorbereitet / verifiziert
Datum: 2026-05-30
```

Verifiziert:

- Backrest UI ist im LAN von der Hermes-VM erreichbar.
- Die geladene Backrest UI meldet Build Version `1.13.0`.
- Es wurden keine Backrest-Jobs erstellt.
- Es wurden keine Backrest-Schedules aktiviert.
- Es wurden keine Restic-Repositories angelegt.
- Es wurden keine Secrets gelesen, ausgegeben oder dokumentiert.
- Es wurden keine Änderungen auf `srv120` durchgeführt.

Nicht durchgeführt / offen:

- Admin-Konfiguration in Backrest wurde nicht geprüft, weil Hermes keinen administrativen Backrest-/Unraid-Zugang verwenden soll, solange dieser nicht explizit bereitgestellt/freigegeben ist.
- Repository-Pfad auf Unraid ist noch nicht final bestätigt.
- Backrest-Admin-Account, Secret-Ablage und UI-Zugriffsmodell müssen durch den Betreiber/Igi bestätigt werden.

## T01 Guardrails

T01 darf nur vorbereiten und prüfen:

```text
[✓] Backrest-Erreichbarkeit prüfen
[✓] Backrest-Version/Build sichtbar prüfen
[✓] Keine Jobs erstellen
[✓] Keine Schedules aktivieren
[✓] Keine produktiven Quellen anbinden
[✓] Keine Secrets dokumentieren
[✓] Keine Änderungen auf srv120
```

## Empfohlene Backrest-Basis-Konfiguration

Die konkrete Einrichtung erfolgt über die Backrest-/Unraid-Adminoberfläche durch den Betreiber oder nach expliziter Freigabe mit administrativem Zugang.

Empfohlene Zielwerte:

```text
Backrest Host: Unraid
Backrest UI: nur LAN/VPN, nicht öffentlich im Internet
Repository Root: Unraid persistent storage, finaler Pfad durch Betreiber zu bestätigen
Repository Name Production: srv120-production
Repository Name Staging: srv120-staging
Restic Passwort: ausschließlich Secret Manager / Backrest Secret Store
Prune/Retention: erst nach erfolgreichem manuellem Backup- und Restore-Test aktivieren
Schedules: in T01 nicht aktivieren
```

## Sicherheitsanforderungen vor T10/T11

Vor Repository-Anlage und Testlauf müssen bestätigt sein:

```text
[ ] Backrest UI ist nicht öffentlich erreichbar
[ ] Admin-Zugang ist gesetzt und nur Betreiber/Hermes nach Freigabe zugänglich
[ ] Restic Passwort liegt nicht in GitHub oder Chat
[ ] finaler Unraid-Repository-Pfad ist bestätigt
[ ] separater SSH-Key für Backrest ist erstellt (T02)
[ ] Backup-User auf srv120 existiert (T03)
[ ] sudoers-Minimalrechte sind gesetzt (T04)
[ ] Dump-/Read-Scripts sind installiert und getestet (T07/T08/T09)
```

## Nächster Schritt

T02: separaten SSH-Key für Backrest erzeugen.

T02 darf noch keine produktiven Jobs aktivieren. Der Key wird nur für den späteren dedizierten Backup-Zugriff vorbereitet und darf nicht mit Monitoring-, GitHub- oder Admin-Keys vermischt werden.
