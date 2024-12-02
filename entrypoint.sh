#!/bin/bash

echo "Checking environment variables..."
echo "DB_HOST=${DB_HOST}"
echo "DB_PORT=${DB_PORT}"
echo "DB_USER=${DB_USER}"
echo "DB_NAME=${DB_NAME}"
echo "DB_PASSWORD length: ${#DB_PASSWORD}"

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
http_port = 8069
EOF

echo "Configuration generated at /etc/odoo/odoo.conf"

echo "Testing database connection..."
export PGPASSWORD="${DB_PASSWORD}"
until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}"; do
    echo "Waiting for database..."
    sleep 2
done

echo "Database connection successful"
echo "Starting Odoo..."

# Execute with proper foreground flag
exec "$@" --logfile /dev/stdout --no-database-list