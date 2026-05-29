# Architecture Decision Records

Dieses Verzeichnis enthält Architecture Decision Records (ADR) für 4KC.

Jede wesentliche Architektur-, Infrastruktur- oder Betriebsentscheidung wird als eigener ADR dokumentiert.

## Format

Jeder ADR enthält mindestens:

- Status
- Kontext
- Entscheidung
- Begründung
- Alternativen
- Auswirkungen

## Index

- [ADR-0001: Coolify als Deployment- und Betriebsplattform](ADR-0001-coolify.md)
- [ADR-0002: Eigenes Dockerfile statt Nixpacks als Langfriststrategie](ADR-0002-dockerfile-vs-nixpacks.md)
- [ADR-0003: MariaDB 11 als initiale relationale Datenbank](ADR-0003-mariadb-vs-postgresql.md)
- [ADR-0004: Container-Strategie für App, Worker, Scheduler und Horizon](ADR-0004-container-strategy.md)
- [ADR-0005: Backup-Strategie über Backrest/Restic, Unraid und Synology](ADR-0005-backup-strategy.md)
- [ADR-0006: Öffentliches Dokumentationsrepository als zentrale Wissensbasis](ADR-0006-public-docs-knowledge-base.md)
- [ADR-0007: Coolify API Responses und sensitive Daten](ADR-0007-coolify-api-sensitive-read-behavior.md)
- [ADR-0008: GitHub App und Dockerfile-basierte Deployment-Strategie](ADR-0008-github-integration-dockerfile-deployment.md)
