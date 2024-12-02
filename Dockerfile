FROM odoo:16.0

USER root

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy and fix entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh && \
    sed -i 's/\r$//' /entrypoint.sh  # Remove Windows line endings

USER odoo

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]