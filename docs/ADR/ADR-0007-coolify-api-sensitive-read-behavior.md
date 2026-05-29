# ADR-0007: Coolify API Responses und sensitive Daten

## Status

Akzeptiert

## Kontext

4KC verwendet Coolify 4.1.1 als zentrale Deployment- und Betriebsplattform.

Bei API-Prüfungen wurde festgestellt, dass Coolify 4.1.1 bei Datenbank-Ressourcen sensitive Felder in API-Responses mitliefern kann, wenn ein Token mit `read`/`write` verwendet wird.

Betroffen sind insbesondere Datenbank-Metadaten und Credential-Felder. Diese Werte dürfen nicht in öffentliche Dokumentation, Logs oder Chat-Ausgaben übernommen werden.

## Entscheidung

Coolify API Tokens werden für 4KC restriktiv und zweckgebunden verwendet.

Für API-Arbeiten gilt:

- Tokens nur mit minimal nötigen Rechten erstellen.
- Kein `root`, ausser explizit begründet.
- `read:sensitive` nicht vergeben, wenn nicht zwingend nötig.
- Responses vor Dokumentation oder Ausgabe bereinigen.
- Secrets ausschliesslich in Coolify pflegen.
- Tokens nach temporären Provisioning-Arbeiten entfernen oder rotieren.

## Begründung

Auch wenn eine API-Operation nur inventarisierend wirkt, kann die Response sensitive Werte enthalten. Least Privilege allein reicht deshalb nicht aus; zusätzlich sind Ausgabe- und Dokumentationsdisziplin erforderlich.

## Alternativen

### API-Zugriff komplett vermeiden

Wurde verworfen, da Automatisierung, Inventarisierung und kontrolliertes Provisioning über Coolify API effizienter und nachvollziehbarer sind.

### Root Token verwenden

Wurde verworfen. Root ist für normale 4KC Provisioning- und Deployment-Vorbereitung nicht erforderlich.

## Auswirkungen

- Öffentliche Dokumentation enthält nur bereinigte Metadaten.
- Agenten und Operatoren dürfen API-Rohantworten nicht ungeprüft weitergeben.
- Coolify Tokens werden als produktionsnahe Secrets behandelt.
- Die Token-Strategie wird Bestandteil der Betriebsdokumentation.
