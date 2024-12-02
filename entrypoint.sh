#!/bin/bash

echo "Checking environment variables..."
echo "DB_HOST=${DB_HOST:-not set}"
echo "DB_PORT=${DB_PORT:-not set}"
echo "DB_USER=${DB_USER:-not set}"
echo "DB_NAME=${DB_NAME:-not set}"
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
db_template = template1
db_maxconn = 64
http_port = 8069
EOF

echo "Configuration generated at /etc/odoo/odoo.conf"

if [ -z "${DB_HOST}" ] || [ -z "${DB_PORT}" ] || [ -z "${DB_USER}" ] || [ -z "${DB_PASSWORD}" ]; then
    echo "Error: Required environment variables are missing"
    env | grep -v PASSWORD
    exit 1
fi

echo "Testing database connection..."
export PGPASSWORD="${DB_PASSWORD}"
max_retries=30
counter=0

while ! pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}"; do
    counter=$((counter + 1))
    if [ ${counter} -gt ${max_retries} ]; then
        echo "Failed to connect to database after ${max_retries} attempts."
        exit 1
    fi
    echo "Waiting for database... (${counter}/${max_retries})"
    sleep 2
done

echo "Database connection successful"
echo "Starting Odoo..."

exec "$@"