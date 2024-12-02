#!/bin/bash

# Generate Odoo configuration
cat << EOF > /etc/odoo/odoo.conf
[options]
addons_path = ${ADDONS_PATH}
data_dir = ${DATA_DIR}
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = odoo
EOF

exec "$@"