```
 ____        _                 ____                _           
|  _ \  ___ | | ___ _   _    |  _ \ ___ _ __   __| | ___ _ __ 
| | | |/ _ \| |/ _ \ | | |   | |_) / _ \ '_ \ / _` |/ _ \ '__|
| |_| | (_) | | (_) | |_| |   |  _ <  __/ | | | (_| |  __/ |   
|____/ \___/|_|\___/\__, |   |_| \_\___|_| |_|\__,_|\___|_|   
                    |___/                                       

# Odoo on Render.com

This repository contains Docker configuration for running Odoo 16.0 on Render.com or locally.

## 🚀 Quick Start

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/your-username/odoo-render-com.git
cd odoo-render-com
```

2. Create required directories:
```bash
mkdir -p postgresql odoo-web-data addons config logs backups custom-addons filestore
```

3. Start the containers:
```bash
docker-compose up --build
```

4. Access Odoo at: http://localhost:8069
   - Default login: admin
   - Default password: admin (unless changed in environment variables)

### Render.com Deployment

1. Fork this repository
2. Create a new Web Service in Render
3. Connect your forked repository
4. Render will automatically detect the configuration

## 📁 Project Structure

```
odoo-render-com/
├── addons/              # Odoo addons directory
├── backups/             # Database backup location
├── config/              # Odoo config files
├── custom-addons/       # Your custom modules
├── filestore/           # Uploaded files storage
├── logs/                # Application logs
├── odoo-web-data/       # Odoo system files
├── postgresql/          # PostgreSQL data directory
├── docker-compose.yml   # Docker services configuration
├── Dockerfile          # Odoo image build instructions
├── entrypoint.sh       # Container startup script
└── render.yaml         # Render.com configuration
```

## 🔧 Configuration

### Environment Variables

```env
ADMIN_PASSWORD=your_secure_password
DB_USER=odoo
DB_PASSWORD=odoo_pw
PORT=8069
ADDONS_PATH=/mnt/extra-addons
DATA_DIR=/var/lib/odoo
```

### Docker Compose

The `docker-compose.yml` file defines two services:
- PostgreSQL database
- Odoo application

### Custom Modules

Place your custom Odoo modules in the `custom-addons` directory. They will be automatically loaded by Odoo.

## 🔒 Security Notes

1. Change default passwords in production
2. Set secure admin password
3. Configure proper database credentials
4. Use HTTPS in production
5. Regularly backup your data

## 📝 Logging

Logs are stored in the `logs` directory:
- Odoo application logs
- PostgreSQL database logs

## 💾 Backup

To backup your database:

```bash
docker-compose exec db pg_dump -U odoo odoo > backups/backup_$(date +%F).sql
```

To restore:

```bash
docker-compose exec db psql -U odoo odoo < backups/your_backup.sql
```

## 🛠️ Troubleshooting

### Common Issues

1. Database connection errors:
   - Check PostgreSQL service is running
   - Verify database credentials
   - Ensure database port is accessible

2. Permission issues:
   - Check directory permissions
   - Ensure proper user/group ownership

3. Module loading problems:
   - Verify addons path configuration
   - Check module dependencies

## 📦 Updating

To update Odoo:

1. Update the version in Dockerfile
2. Rebuild containers:
```bash
docker-compose down
docker-compose up --build
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Odoo Community
- Docker
- Render.com

## 📞 Support

For issues and feature requests, please use the GitHub Issues section.

---
Made with ❤️ by Fribu - Smart Solutions UG
```

Would you like me to modify any part of this README or add additional information?
