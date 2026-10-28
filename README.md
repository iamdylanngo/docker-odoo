# docker-odoo

Docker Compose stack for Odoo 20 with PostgreSQL 16.

## Stack

| Service | Image | Port |
|---------|-------|------|
| Odoo | `odoo:20` | `8069` (web), `8072` (longpolling) |
| PostgreSQL | `postgres:16-alpine` | internal only |

## Quick Start

```bash
cp .env.example .env
# Edit .env with your values
docker compose up -d
```

Open `http://localhost:8069/web/database/manager` to create your database on first run.

## Environment Variables

Copy `.env.example` to `.env` and set:

| Variable | Description |
|----------|-------------|
| `POSTGRES_USER` | Database username (default: `odoo`) |
| `POSTGRES_PASSWORD` | Database password |
| `POSTGRES_DB` | Default database name (default: `postgres`) |

## Configuration

Edit `config/odoo.conf` as needed. Key options:

| Option | Default | Notes |
|--------|---------|-------|
| `workers` | `0` | Threaded server; increase with a reverse proxy |
| `proxy_mode` | `False` | Set `True` when behind Nginx/Caddy |
| `list_db` | `True` | Set `False` after initial DB setup |
| `logfile` | `/var/log/odoo/odoo.log` | Mapped to `./var/log/` on host |

## Directory Structure

```
.
├── config/
│   └── odoo.conf          # Odoo configuration
├── addons/                # Custom addons (mounted at /mnt/extra-addons)
├── var/
│   ├── feed/
│   │   ├── inbound/
│   │   │   ├── new/       # Incoming files to process
│   │   │   ├── archive/   # Successfully processed files
│   │   │   └── errors/    # Files that failed processing
│   │   └── outbound/
│   │       ├── ready/     # Files ready for pickup
│   │       └── sent/      # Confirmed sent files
│   └── log/               # Odoo log files
├── docker-compose.yml
├── .env.example
└── .gitignore
```

## After First Database Setup

Lock down the instance:

```bash
# config/odoo.conf
list_db = False
db_name = <your-database-name>
```

Then restart Odoo:

```bash
docker compose up -d --force-recreate odoo
```

## Useful Commands

```bash
# Follow logs
docker compose logs -f odoo

# Odoo shell
docker compose exec odoo odoo shell -d <dbname>

# Restart Odoo only
docker compose up -d --force-recreate odoo

# Stop everything
docker compose down
```
