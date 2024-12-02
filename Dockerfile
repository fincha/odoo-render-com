FROM odoo:16.0

USER root

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create configuration script
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Create necessary directories
RUN mkdir -p /var/lib/odoo \
    && mkdir -p /mnt/extra-addons \
    && mkdir -p /etc/odoo \
    && chown -R odoo:odoo /var/lib/odoo \
    && chown -R odoo:odoo /mnt/extra-addons \
    && chown -R odoo:odoo /etc/odoo

# Install psql for health checks
RUN apt-get update && apt-get install -y postgresql-client

# Expose the port
EXPOSE 8069

USER odoo

ENTRYPOINT ["/entrypoint.sh"]