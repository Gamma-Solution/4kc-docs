# 4KC Meeting Notes

Dieses Dokument ist das öffentliche, bereinigte Entscheidungs- und Fortschrittsprotokoll für 4KC.

Es enthält keine Zugangsdaten, Tokens, Kundendaten oder produktiven Secrets.

## 2026-05-29

- Ubuntu 24.04.4 auf `srv120.4youhosting.ch` als zukünftige Hauptplattform bestätigt.
- Docker installiert.
- Coolify installiert und als zentrale Deployment-Plattform festgelegt.
- SSL/DNS eingerichtet.
- MariaDB 11 als Docker-Container in Coolify erstellt; Status: Running/healthy.
- Architekturvorgabe bestätigt: 4KC wird vollständig containerbasiert betrieben.
- Keine direkte Host-Installation von PHP, MariaDB, Redis, Nginx oder Apache für 4KC.
- Privates Entwicklungsrepository bestätigt: `Gamma-Solution/4kc-panel`.
- Laravel-Anwendung liegt im Unterordner `backend/`.
- Öffentliches Dokumentationsrepository erstellt: `Gamma-Solution/4kc-docs`.
- `4kc-docs` als zentrale öffentliche Wissensbasis für Architektur, Infrastruktur, Roadmap und Entscheidungen festgelegt.
- Zielarchitektur mit getrennten Production- und Staging-Services beschlossen.
- Docker-Strategie beschlossen: eigenes Dockerfile für `backend/`, Nixpacks nicht als langfristige Produktionslösung.
- Nächste technische Prioritäten festgelegt: Redis, GitHub App Integration, Staging, Dockerfile, Laravel Staging Deployment, Deployment-Dokumentation, Backup-/Restore-Konzept.

## 2026-05-30

- Geplant: Redis-Service in Coolify für Production und Staging erstellen.
- Redis-Service `4kc-production-redis` in Coolify für Production erstellt; Status `running:healthy`; nicht öffentlich exponiert.
- Coolify 4.1.1 Verhalten dokumentiert: API-Responses können bei read/write Tokens sensitive Daten enthalten; öffentliche Doku nur bereinigt.
- GitHub App Integration und Dockerfile-basierte Deployment-Strategie für `Gamma-Solution/4kc-panel` vorbereitet.
- Staging-Konzept vorbereitet; Production Deployment und Migrationen bleiben bis Review blockiert.
- Geplant: Redis-Service in Coolify für Staging erstellen.
- Geplant: GitHub App Integration für Organisation `Gamma-Solution` sauber einrichten.
- Staging Environment `staging` in Coolify erstellt.
- Staging MariaDB `4kc-staging-mariadb` erstellt; Status `running:healthy`; nicht öffentlich exponiert.
- Staging Redis `4kc-staging-redis` erstellt; Status `running:healthy`; nicht öffentlich exponiert.
- Befund zur GitHub Integration: `Gamma-Solution/4kc-panel` ist privat, in Coolify ist aktuell nur `Public GitHub` sichtbar; private GitHub App muss interaktiv autorisiert werden, bevor eine saubere Staging-App angelegt wird.
- Lokale Docker-Build-Validierung in der Agent-Umgebung nicht möglich, da dort `docker` nicht installiert ist; Build-Validierung soll über Coolify Staging erfolgen.
- Geplant: private GitHub App Integration für Organisation `Gamma-Solution` abschliessen.
- Geplant: Staging Environment in Coolify vorbereiten.
- Geplant: Laravel Deployment auf Staging validieren.


## Staging App Provisioning 2026-05-29

Erkenntnisse:

- GitHub App Installation für `Gamma-Solution` ist abgeschlossen und in Coolify sichtbar.
- `4kc-app-staging` wurde in Coolify im Environment `staging` angelegt.
- Branch `staging` wurde aus dem Dockerfile-Validierungsbranch erstellt.
- Coolify Deploy konnte wegen fehlender API Permission `deploy` noch nicht ausgelöst werden.
- Build Logs liegen noch nicht vor.

Entscheidung:

- Keine Production-Aktionen bis separater Freigabe.
- Für den nächsten Lauf wird ein temporärer Coolify Token mit `read + write + deploy` benötigt oder der bestehende Token wird um `deploy` erweitert.


## Staging Deploy Freigabe 2026-05-29

Freigegeben:

- Deploy von `4kc-app-staging`
- Build Logs analysieren
- Dockerfile-/Pfadprobleme beheben
- `/up` Healthcheck prüfen
- Ergebnis in `4kc-docs` dokumentieren

Nicht freigegeben:

- Production Deployment
- Production Migrationen
- Änderungen an Production MariaDB
- Migrationen allgemein
- Secrets ins Repository

Durchführung:

- Deploy per Coolify API versucht.
- Ergebnis: API blockiert mit `Missing required permissions: deploy`.
- Nächster technischer Schritt: Token mit `deploy` Permission verwenden.


## Staging Deploy Analyse 2026-05-29

Erkenntnisse:

- Neuer Coolify API Token kann Deploys auslösen.
- Deployments werden gequeued, schlagen aber fehl.
- Pfadkorrektur in Coolify: `Base Directory=/backend`, `Dockerfile Location=/Dockerfile`.
- Lokale Checks des Staging-Branches: Composer Install, NPM Build und `/up` Route erfolgreich.
- Für weitere Ursachenanalyse werden Deployment Logs benötigt; die Coolify API blendet diese ohne sensitive-read Permission aus.

Nächster Schritt:

- Temporären Token mit Log-/read-sensitive Zugriff verwenden oder bereinigte Deployment Logs aus der Coolify UI bereitstellen.
- Danach gezielte Dockerfile-/Runtime-Korrektur vornehmen.

## Rollen und Guardrails 2026-05-29

Festgelegt:

- Igi ist Product Owner, trifft finale Entscheidungen, gibt Production und Migrationen frei und verwaltet Secrets/Zugänge.
- Hermes arbeitet als Infrastruktur- und Deployment-Agent für Staging, Coolify, Docker, Build-Analyse, Dokumentation, Deployment-Vorbereitung und Architekturumsetzung.
- ChatGPT übernimmt Architekturreview, Gegenprüfung, Strategie, Sicherheitsreview und Qualitätskontrolle.

Hermes darf selbständig:

- Staging aufbauen
- Build Logs analysieren
- Dockerfile anpassen
- GitHub Integration vorbereiten
- Redis/MariaDB Staging verwalten
- `4kc-docs` aktualisieren
- Deployment-Prozesse vorbereiten

Ohne explizite Freigabe blockiert:

- Production Deployments
- Migrationen
- Änderungen an Production-Datenbanken
- Änderungen an der Ubuntu/Docker/Coolify-Basis
- Secrets lesen oder speichern
- Ressourcen löschen

Dokumentationspflicht:

- Nach wichtigen Änderungen werden `docs/PROJECT_STATUS.md`, `docs/MEETING_NOTES.md` und `docs/DECISIONS.md` aktualisiert.

Arbeitsreihenfolge:

1. Staging
2. Build validieren
3. Dockerfile validieren
4. Healthchecks
5. Review
6. Production
