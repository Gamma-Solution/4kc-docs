#!/usr/bin/env bash
set -euo pipefail

# Template only. Do not deploy without operator review.
# Secrets must be injected via root-owned config file or secure secret store.
# Never print passwords or DSNs.

STAGING_ROOT="/var/backups/srv120"
OUT_DIR="${STAGING_ROOT}/mariadb"
MANIFEST_DIR="${STAGING_ROOT}/manifests"
TS="$(date -u +%Y%m%dT%H%M%SZ)"

install -d -m 0750 -o root -g backrest-backup "$OUT_DIR" "$MANIFEST_DIR"

# Expected env/config, provided securely outside Git/docs:
# MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PWD
# DATABASES="production_db staging_db"

: "${MYSQL_HOST:?missing MYSQL_HOST}"
: "${MYSQL_PORT:=3306}"
: "${MYSQL_USER:?missing MYSQL_USER}"
: "${MYSQL_PWD:?missing MYSQL_PWD}"
: "${DATABASES:?missing DATABASES}"

MANIFEST="${MANIFEST_DIR}/mariadb-${TS}.manifest"
: > "$MANIFEST"
chmod 0640 "$MANIFEST"

for DB in $DATABASES; do
  case "$DB" in
    *[!A-Za-z0-9_\-]*) echo "invalid database name" >&2; exit 2 ;;
  esac

  OUT="${OUT_DIR}/${DB}-${TS}.sql.gz"
  mysqldump \
    --host="$MYSQL_HOST" \
    --port="$MYSQL_PORT" \
    --user="$MYSQL_USER" \
    --single-transaction \
    --quick \
    --routines \
    --triggers \
    --events \
    --default-character-set=utf8mb4 \
    --hex-blob \
    "$DB" | gzip -9 > "$OUT"

  gzip -t "$OUT"
  sha256sum "$OUT" >> "$MANIFEST"
done

sha256sum "$MANIFEST" > "${MANIFEST}.sha256"
