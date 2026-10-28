#!/usr/bin/env bash
# Usage: ./scripts/restore.sh <dbname> <backup-file>
# Example: ./scripts/restore.sh odoo ./backups/odoo_20261028_120000.dump
# WARNING: drops and recreates the target database.

set -euo pipefail

DB="${1:?Usage: $0 <dbname> <backup-file>}"
FILE="${2:?Usage: $0 <dbname> <backup-file>}"
PG_USER="${POSTGRES_USER:-odoo}"

if [[ ! -f "$FILE" ]]; then
  echo "Error: backup file not found: $FILE"
  exit 1
fi

echo "Restoring '$FILE' → database '$DB'"
read -rp "This will DROP and recreate '$DB'. Continue? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# Drop and recreate
docker compose exec -T db psql -U "$PG_USER" -c "DROP DATABASE IF EXISTS \"$DB\";"
docker compose exec -T db psql -U "$PG_USER" -c "CREATE DATABASE \"$DB\" OWNER \"$PG_USER\";"

# Restore
docker compose exec -T db pg_restore \
  -U "$PG_USER" \
  -d "$DB" \
  --no-owner \
  --role="$PG_USER" < "$FILE"

echo "Restore complete."
