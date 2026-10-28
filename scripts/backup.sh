#!/usr/bin/env bash
# Usage: ./scripts/backup.sh <dbname> [output-dir]
# Example: ./scripts/backup.sh odoo ./backups

set -euo pipefail

DB="${1:?Usage: $0 <dbname> [output-dir]}"
OUT_DIR="${2:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE="${OUT_DIR}/${DB}_${TIMESTAMP}.dump"

mkdir -p "$OUT_DIR"

echo "Backing up database '$DB' → $FILE"

docker compose exec -T db pg_dump \
  -U "${POSTGRES_USER:-odoo}" \
  -Fc \
  "$DB" > "$FILE"

echo "Done: $FILE ($(du -sh "$FILE" | cut -f1))"
