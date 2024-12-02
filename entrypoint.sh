#!/bin/bash

# Ensure DB_PORT has a default value
DB_PORT=${DB_PORT:-5432}

# Generate Odoo configuration
cat << EOF > /etc/odoo/odoo.conf
[options]
addons_path = ${ADDONS_PATH:-/mnt/extra-addons}
data_dir = ${DATA_DIR:-/var/lib/odoo}
admin_passwd = ${ADMIN_PASSWORD:-admin}
db_host = ${DB_HOST:-db}
db_port = ${DB_PORT}
db_user = ${DB_USER:-odoo}
db_password = ${DB_PASSWORD:-odoo_pw}
db_name = odoo
EOF

exec "$@"