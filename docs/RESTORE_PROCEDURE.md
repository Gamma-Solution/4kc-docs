# 4KC Restore Procedure

Dieses Dokument beschreibt die Ziel-Prozeduren für Wiederherstellungen.

Es enthält keine Zugangsdaten, Tokens, Passwörter oder produktiven Secrets.

## Restore-Arten

1. Datenbank Restore
2. Laravel Storage Restore
3. Redis Restore
4. Coolify Restore
5. Kompletter Server Restore

## Grundregeln

- Restore zuerst auf Staging testen, wenn möglich.
- Vor jedem Production-Restore aktuelle Situation sichern.
- Secrets werden aus Coolify oder dem separaten Secret-Management wiederhergestellt, nicht aus diesem Repository.
- Nach Restore immer Healthcheck, Login, Queue und zentrale Geschäftsprozesse prüfen.

## 1. Datenbank Restore

Ziel:

- MariaDB-Daten aus einem Backup wiederherstellen.

Ablauf:

1. Zielumgebung bestimmen: Staging oder Production.
2. Aktuellen Datenbankstand sichern, falls noch möglich.
3. Passenden MariaDB Dump aus Backup auswählen.
4. Ziel-Datenbankcontainer stoppen oder Schreibzugriffe unterbinden.
5. Dump in die Ziel-Datenbank einspielen.
6. Laravel Migration-Status prüfen.
7. App Cache leeren/neu aufbauen.
8. App Smoke-Test ausführen.

Zu prüfen:

- Benutzer/Login
- Kundenlisten
- Domains
- Hosting-Abos
- Rechnungen
- Jobs/Queues

## 2. Laravel Storage Restore

Ziel:

- Persistente Dateien wie Uploads, Exporte oder generierte Dokumente wiederherstellen.

Ablauf:

1. Ziel-Storage-Volume identifizieren.
2. Aktuellen Storage-Zustand sichern, falls möglich.
3. Backup der relevanten Storage-Pfade auswählen.
4. Dateien in das Ziel-Volume zurückspielen.
5. Dateirechte für App-Container prüfen.
6. Beispielhafte Dateien über die App prüfen.

Typische Pfade:

```text
storage/app
storage/app/public
```

Konkrete Volume-Namen werden in Coolify dokumentiert und nicht mit Secrets vermischt.

## 3. Redis Restore

Ziel:

- Redis-Daten wiederherstellen, falls Redis für persistente Session- oder Queue-Zustände relevant ist.

Bewertung:

- Cache kann normalerweise neu aufgebaut werden.
- Queues können je nach Zustand neu gestartet oder aus Datenbank-Aktionsverläufen rekonstruiert werden.
- Sessions sind meist nicht kritisch, Benutzer müssen sich ggf. neu anmelden.

Ablauf, falls Redis-Restore nötig ist:

1. Redis-Nutzung der Umgebung prüfen.
2. Redis-Container stoppen.
3. Redis-Datenvolume oder Snapshot wiederherstellen.
4. Redis starten.
5. Horizon/Worker neu starten.
6. Queue-Status prüfen.

## 4. Coolify Restore

Ziel:

- Coolify Projekt-, Service- und Deployment-Konfiguration wiederherstellen.

Ablauf:

1. Coolify-Verfügbarkeit prüfen.
2. Coolify-eigene Backup-/Restore-Funktion verwenden, falls vorhanden.
3. 4KC Projekt wiederherstellen oder neu anlegen.
4. GitHub App Integration prüfen.
5. Services neu verknüpfen:
   - App
   - Worker
   - Scheduler
   - Horizon
   - MariaDB
   - Redis
6. ENV-Werte aus Secret-Management wieder eintragen.
7. Domains/SSL prüfen.
8. Deployment erneut ausführen.

Wichtig:

- Secrets werden nicht aus `4kc-docs` wiederhergestellt.
- Öffentliche Doku beschreibt Struktur und Ablauf, nicht geheime Werte.

## 5. Kompletter Server Restore

Ziel:

- Wiederherstellung von 4KC nach Verlust oder Neuaufbau von `srv120`.

Ablauf:

1. Ubuntu Server bereitstellen.
2. Docker installieren.
3. Coolify installieren.
4. Firewall/Fail2Ban/DNS/SSL-Basis prüfen.
5. Coolify Projekt `4KC` wiederherstellen oder neu anlegen.
6. GitHub Integration mit `Gamma-Solution/4kc-panel` einrichten.
7. MariaDB Service erstellen oder Datenvolume wiederherstellen.
8. Redis Service erstellen oder Datenvolume wiederherstellen.
9. Laravel App/Worker/Scheduler/Horizon Deployments anlegen.
10. ENV-Werte aus Secret-Management eintragen.
11. MariaDB Dump einspielen.
12. Laravel Storage wiederherstellen.
13. Deployment ausführen.
14. Migration-Status prüfen.
15. Healthcheck und Smoke-Tests durchführen.
16. Ergebnis in `docs/MEETING_NOTES.md` dokumentieren.

## Restore Smoke-Test

Nach jedem Restore prüfen:

```text
[ ] App erreichbar
[ ] /up erfolgreich
[ ] Admin Login möglich
[ ] Datenbankdaten sichtbar
[ ] Storage-Dateien verfügbar
[ ] Queue Worker läuft
[ ] Scheduler läuft
[ ] Horizon läuft
[ ] Logs ohne kritische Fehler
[ ] Backup-Kette wieder aktiv
```

## Offene Punkte

- konkrete Coolify Backup-/Restore-Funktion verifizieren
- konkrete Volume-Namen nach Erstellung dokumentieren
- Restore-Test auf Staging durchführen
- Verantwortlichkeiten für Secret-Management definieren
