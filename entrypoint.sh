#!/bin/bash
set -e

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
without_demo = all
EOF

echo "Starting Odoo with database ${DB_NAME}"

# Check if database needs initialization
INIT_FLAG=""
PGPASSWORD=${DB_PASSWORD} psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "SELECT 1 FROM ir_module_module LIMIT 1" &>/dev/null || INIT_FLAG="-i base"

if [ ! -z "$INIT_FLAG" ]; then
    echo "Initializing database with base module..."
    exec odoo ${INIT_FLAG} --stop-after-init
    echo "Base module initialized"
fi

echo "Starting Odoo server..."
exec odoo