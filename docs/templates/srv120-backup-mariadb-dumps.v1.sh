#!/usr/bin/env bash
set -Eeuo pipefail
umask 027

BASE_DIR="/var/backups/srv120/mariadb"
CONFIG_DIR="/etc/srv120-backup/mariadb"
RUN_ID="$(date -u +%Y%m%dT%H%M%SZ)"
HOSTNAME_FQDN="$(hostname -f 2>/dev/null || hostname)"

DUMP_OPTIONS=(
  --single-transaction
  --quick
  --routines
  --triggers
  --events
  --default-character-set=utf8mb4
  --hex-blob
)

SYSTEM_DATABASES_REGEX='^(information_schema|performance_schema|mysql|sys)$'

fail() {
  printf 'ERROR %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command missing: $1"
}

load_env() {
  local env_name="$1"
  local env_file="${CONFIG_DIR}/${env_name}.env"

  [[ -r "$env_file" ]] || fail "missing readable config: ${env_file}"

  # shellcheck disable=SC1090
  set -a
  source "$env_file"
  set +a

  : "${DB_NAME:?DB_NAME missing in ${env_file}}"
  : "${DB_USER:?DB_USER missing in ${env_file}}"

  if [[ -z "${MARIADB_CONTAINER:-}" && -n "${DB_HOST:-}" ]]; then
    MARIADB_CONTAINER="$DB_HOST"
  fi
  : "${MARIADB_CONTAINER:?MARIADB_CONTAINER missing in ${env_file}}"

  # Prefer the root-only cnf file for the secret value. This keeps secret handling
  # outside the dump output tree and avoids documenting passwords in env listings.
  local cnf_file="${CONFIG_DIR}/${env_name}.cnf"
  if [[ -r "$cnf_file" ]]; then
    DB_PASSWORD="$(awk -F= '$1 == "password" { print substr($0, index($0, "=") + 1); exit }' "$cnf_file")"
  fi
  : "${DB_PASSWORD:?DB_PASSWORD missing in ${env_file} or ${cnf_file}}"

  if [[ "$DB_NAME" =~ $SYSTEM_DATABASES_REGEX ]]; then
    fail "refusing to dump system database for ${env_name}"
  fi
}

write_manifest() {
  local env_name="$1"
  local dump_file="$2"
  local sha_file="$3"
  local manifest_file="$4"
  local bytes sha

  bytes="$(stat -c '%s' "$dump_file")"
  sha="$(cut -d' ' -f1 "$sha_file")"

  cat > "$manifest_file" <<JSON
{
  "run_id": "${RUN_ID}",
  "created_at_utc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "host": "${HOSTNAME_FQDN}",
  "scope": "mariadb-only-v1",
  "environment": "${env_name}",
  "database": "${DB_NAME}",
  "dump_file": "${dump_file}",
  "sha256_file": "${sha_file}",
  "sha256": "${sha}",
  "bytes": ${bytes},
  "gzip_test": "ok",
  "checksum_test": "ok",
  "excluded": [
    "redis",
    "coolify-volumes",
    "laravel-storage",
    "host-config",
    "backrest-jobs",
    "schedules"
  ]
}
JSON

  chmod 0640 "$manifest_file"
}

dump_environment() {
  local env_name="$1"
  local expected_db_name="$2"
  local dump_dir="${BASE_DIR}/${env_name}/dumps"
  local manifest_dir="${BASE_DIR}/${env_name}/manifests"
  local tmp_dir="${BASE_DIR}/${env_name}/tmp"
  local tmp_file dump_file sha_file manifest_file bytes sha db_count

  load_env "$env_name"

  [[ "$DB_NAME" == "$expected_db_name" ]] || fail "${env_name}: expected DB_NAME=${expected_db_name}, got DB_NAME=${DB_NAME}"

  docker inspect "$MARIADB_CONTAINER" >/dev/null 2>&1 || fail "${env_name}: MariaDB container not found: ${MARIADB_CONTAINER}"

  install -d -m 0750 "$dump_dir" "$manifest_dir" "$tmp_dir"

  db_count="$(docker exec -i -e MYSQL_PWD="$DB_PASSWORD" "$MARIADB_CONTAINER" mariadb -N -B -u "$DB_USER" -e "SHOW DATABASES" 2>/dev/null | awk -v db="$DB_NAME" '$0 == db { count++ } END { print count + 0 }')"
  [[ "$db_count" == "1" ]] || fail "${env_name}: database not found exactly once: ${DB_NAME}"

  tmp_file="${tmp_dir}/${env_name}-${DB_NAME}-${RUN_ID}.sql.gz.tmp"
  dump_file="${dump_dir}/${env_name}-${DB_NAME}-${RUN_ID}.sql.gz"
  sha_file="${dump_file}.sha256"
  manifest_file="${manifest_dir}/${env_name}-${DB_NAME}-${RUN_ID}.manifest.json"

  docker exec -i -e MYSQL_PWD="$DB_PASSWORD" "$MARIADB_CONTAINER" \
    mariadb-dump -u "$DB_USER" "${DUMP_OPTIONS[@]}" "$DB_NAME" | gzip -9 > "$tmp_file"

  gzip -t "$tmp_file"
  bytes="$(stat -c '%s' "$tmp_file")"
  [[ "$bytes" -gt 1024 ]] || fail "${env_name}: dump too small (${bytes} bytes)"

  mv "$tmp_file" "$dump_file"
  chmod 0640 "$dump_file"

  sha256sum "$dump_file" > "$sha_file"
  chmod 0640 "$sha_file"
  sha256sum -c "$sha_file" >/dev/null

  write_manifest "$env_name" "$dump_file" "$sha_file" "$manifest_file"

  sha="$(cut -d' ' -f1 "$sha_file")"
  printf 'OK mariadb %s dump created: %s %s bytes %s\n' "$env_name" "$dump_file" "$bytes" "$sha"
  printf 'OK mariadb %s manifest created: %s\n' "$env_name" "$manifest_file"
}

main() {
  [[ "$(id -u)" -eq 0 ]] || fail "must run as root"
  require_command docker
  require_command gzip
  require_command sha256sum
  require_command stat
  require_command awk

  install -d -m 0750 "$BASE_DIR" "${BASE_DIR}/logs"

  dump_environment production default
  dump_environment staging staging

  printf 'OK mariadb-only-v1 completed: %s\n' "$RUN_ID"
}

main "$@"
