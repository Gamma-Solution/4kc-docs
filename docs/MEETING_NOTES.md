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
