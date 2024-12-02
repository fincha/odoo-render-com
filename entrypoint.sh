#!/bin/bash

echo "Starting Odoo configuration..."
echo "Database settings: Host=${DB_HOST:-localhost} Port=${DB_PORT:-5432}"

# Generate Odoo configuration
cat << EOF > /etc/odoo/odoo.conf
[options]
addons_path = ${ADDONS_PATH:-/mnt/extra-addons}
data_dir = ${DATA_DIR:-/var/lib/odoo}
admin_passwd = ${ADMIN_PASSWORD:-admin}
db_host = ${DB_HOST:-localhost}
db_port = ${DB_PORT:-5432}
db_user = ${DB_USER:-odoo}
db_password = ${DB_PASSWORD:-odoo}
db_name = ${DB_NAME:-postgres}
db_template = template1
db_maxconn = 64
http_port = 8069
EOF

echo "Configuration file created"
cat /etc/odoo/odoo.conf | grep -v password

# Wait for Postgres to be ready
echo "Waiting for PostgreSQL..."
if [ -z "${DB_HOST}" ] || [ -z "${DB_PORT}" ] || [ -z "${DB_USER}" ] || [ -z "${DB_PASSWORD}" ]; then
    echo "Error: Database connection variables are not set properly"
    echo "DB_HOST: ${DB_HOST:-not set}"
    echo "DB_PORT: ${DB_PORT:-not set}"
    echo "DB_USER: ${DB_USER:-not set}"
    echo "DB_PASSWORD: ${DB_PASSWORD:-length: ${#DB_PASSWORD}}"
    exit 1
fi

max_tries=30
count=0
until PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c '\q' 2>/dev/null; do
    echo "Postgres is unavailable - sleeping (attempt ${count}/${max_tries})"
    count=$((count+1))
    if [ $count -ge $max_tries ]; then
        echo "Error: Maximum retry attempts reached"
        exit 1
    fi
    sleep 5
done

echo "PostgreSQL is ready"
echo "Starting Odoo on port 8069"

exec "$@"