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

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo", "--database", "odoo", "-i", "base"]