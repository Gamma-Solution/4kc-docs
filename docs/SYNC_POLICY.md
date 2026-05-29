# 4KC Public Docs Sync Policy

## Ziel

Dieses Dokument definiert, welche Inhalte aus dem privaten Repository `Gamma-Solution/4kc-panel` in das öffentliche Repository `4kc-docs` übernommen werden dürfen.

## Grundregel

Es wird nicht blind synchronisiert.

Jede Übernahme erfolgt als bereinigte, geprüfte Dokumentation. Das öffentliche Repository ist kein Spiegel des privaten Repositories.

## Empfohlene Quellbereiche im privaten Repository

Geeignet als Grundlage, aber nur nach Bereinigung:

```text
README.md
BRAND_4KC_DE.md
4KC_EXECUTION_STRUCTURE_DE.md
docs/context/*.md
docs/architecture/*.md
docs/WORKFLOW_INDEX_DE.md
backend/ARCHITECTURE_*.md
backend/docs/*.md
```

## Nicht automatisch synchronisieren

Nicht übernehmen:

```text
backend/app/
backend/config/
backend/database/migrations/
backend/routes/
backend/resources/
backend/storage/
backend/tests/
backend/.env
backend/.env.*
.env
.env.*
*.sql
*.dump
*.log
id_rsa
*.pem
*.key
```

## Manuelle Synchronisation empfohlen

Folgende öffentliche Dokumente sollten manuell gepflegt oder aus privaten Quellen manuell bereinigt werden:

- `docs/PROJECT_CONTEXT.md`
- `docs/INFRASTRUCTURE.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISIONS.md`
- `docs/ROADMAP.md`
- `docs/DATABASE.md`
- `docs/DEPLOYMENT.md`
- `docs/BACKUP_STRATEGY.md`
- `docs/GLOSSARY.md`
- `docs/MEETING_NOTES.md`

## Automatisierbare Synchronisation, später optional

Später kann ein Skript erstellt werden, das:

1. erlaubte Markdown-Dateien aus dem privaten Repository liest
2. verbotene Muster erkennt
3. Inhalte in öffentliche Zieldokumente transformiert
4. einen Secret-Scan ausführt
5. einen Pull Request im öffentlichen Repository erstellt

Automatisierung darf erst genutzt werden, wenn die Prüfregeln stabil sind.

## Secret-Scan vor Veröffentlichung

Vor jedem Push in das öffentliche Repository muss geprüft werden auf:

- `APP_KEY=`
- `DB_PASSWORD=`
- `REDIS_PASSWORD=`
- `MAIL_PASSWORD=`
- `TOKEN`
- `API_KEY`
- `SECRET`
- private SSH Keys
- PEM-Blöcke
- echte E-Mail-Adressen von Kunden
- Kundennamen oder produktive Datenauszüge

## Öffentlich erlaubte Informationen

Erlaubt, falls bewusst freigegeben:

- Projektname
- grobe Zielarchitektur
- verwendeter Tech-Stack
- öffentliche Domains oder Hostnamen
- allgemeine Deployment-Strategie
- abstraktes Datenmodell
- Roadmap ohne Kundendaten
- Architekturentscheidungen

## Veröffentlichung an ChatGPT

Damit ChatGPT jederzeit auf diese Dokumentation zugreifen kann:

1. Repository öffentlich erstellen
2. sprechende README pflegen
3. relevante Inhalte in Markdown statt Bildern ablegen
4. GitHub-URL dauerhaft verwenden
5. keine Authentifizierung voraussetzen
6. bei grösseren Änderungen die Dokumentation zeitnah aktualisieren

Empfohlene öffentliche URL nach Erstellung:

```text
https://github.com/Gamma-Solution/4kc-docs
```
