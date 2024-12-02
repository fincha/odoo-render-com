# Dockerfile
FROM odoo:16.0

USER root

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create Odoo config directory
RUN mkdir -p /etc/odoo
COPY ./odoo.conf /etc/odoo/odoo.conf

USER odoo

# Set the default config file
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
