# Odoo 15

The repository support run odoo 15 in docker.

## How to run?

```bash
docker-compose up -d
docker exec -ti --user root odoo chown -R odoo:odoo /mnt/extra-addons/ /var/lib/odoo/

```

## Install odoo

* DB Name: odoo

## How to create custom module?

```bash
docker exec -ti odoo odoo scaffold /mnt/extra-addons/custom_module
```