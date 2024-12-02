#!/bin/bash

echo "Starting Odoo configuration..."
echo "Database settings: ${DB_HOST}:${DB_PORT}"

# Generate Odoo configuration
cat << EOF > /etc/odoo/odoo.conf
[options]
addons_path = ${ADDONS_PATH:-/mnt/extra-addons}
data_dir = ${DATA_DIR:-/var/lib/odoo}
admin_passwd = ${ADMIN_PASSWORD:-admin}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = ${DB_NAME}
db_template = template1
db_maxconn = 64
EOF

echo "Configuration file created"
cat /etc/odoo/odoo.conf | grep -v password

# Wait for Postgres to be ready
echo "Waiting for PostgreSQL..."
until PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d postgres -c '\q'; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is ready"

exec "$@"