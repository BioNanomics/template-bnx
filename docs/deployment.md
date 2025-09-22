# Deployment Guide

This guide covers deployment strategies and procedures for this project.

## Deployment Overview

This project supports multiple deployment environments:

- **Development**: Local development environment
- **Staging**: Pre-production testing environment
- **Production**: Live production environment

## Prerequisites

Before deploying, ensure you have:

- Proper access credentials
- Environment-specific configuration
- Required dependencies installed
- Database migrations ready (if applicable)

## Environment Configuration

### Environment Variables

Create environment-specific configuration files:

```bash
# .env.development
DEBUG=true
DATABASE_URL=sqlite:///dev.db
API_KEY=dev_key_here

# .env.staging  
DEBUG=false
DATABASE_URL=postgresql://user:pass@staging-db:5432/app
API_KEY=staging_key_here

# .env.production
DEBUG=false
DATABASE_URL=postgresql://user:pass@prod-db:5432/app
API_KEY=prod_key_here
```

### Configuration Management

```python
# config.py example
import os
from pathlib import Path

class Config:
    """Base configuration."""
    SECRET_KEY = os.environ.get('SECRET_KEY')
    DATABASE_URL = os.environ.get('DATABASE_URL')
    
class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    TESTING = False

class StagingConfig(Config):
    """Staging configuration."""
    DEBUG = False
    TESTING = False

class ProductionConfig(Config):
    """Production configuration."""
    DEBUG = False
    TESTING = False

config = {
    'development': DevelopmentConfig,
    'staging': StagingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
```

## Deployment Methods

### 1. Manual Deployment

#### Local Development

```bash
# Start development server
python manage.py runserver
# or
npm run dev
```

#### Staging/Production

```bash
# 1. Pull latest code
git pull origin main

# 2. Install dependencies
pip install -r requirements.txt
# or
npm install --production

# 3. Run database migrations
python manage.py migrate
# or
npm run migrate

# 4. Collect static files (if applicable)
python manage.py collectstatic --noinput

# 5. Restart application server
sudo systemctl restart your-app
```

### 2. Docker Deployment

#### Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application
COPY src/ ./src/
COPY manage.py .

# Expose port
EXPOSE 8000

# Run application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

#### Docker Compose

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/app
    depends_on:
      - db
    volumes:
      - ./src:/app/src

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

#### Deployment Commands

```bash
# Build and start services
docker-compose up -d

# View logs
docker-compose logs -f

# Run migrations
docker-compose exec web python manage.py migrate

# Scale services
docker-compose up -d --scale web=3
```

### 3. Cloud Platform Deployment

#### Heroku

```bash
# Install Heroku CLI and login
heroku login

# Create application
heroku create your-app-name

# Set environment variables
heroku config:set SECRET_KEY=your-secret-key
heroku config:set DATABASE_URL=your-db-url

# Deploy
git push heroku main

# Run migrations
heroku run python manage.py migrate
```

#### AWS Elastic Beanstalk

```bash
# Install EB CLI
pip install awsebcli

# Initialize application
eb init

# Create environment
eb create staging

# Deploy
eb deploy

# View logs
eb logs
```

#### Google Cloud Platform

```yaml
# app.yaml for App Engine
runtime: python39

env_variables:
  SECRET_KEY: "your-secret-key"
  DATABASE_URL: "your-db-connection-string"

automatic_scaling:
  min_instances: 1
  max_instances: 10
```

```bash
# Deploy to App Engine
gcloud app deploy
```

### 4. CI/CD Pipeline

#### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: 3.9
    
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        pytest
    
    - name: Deploy to staging
      if: github.ref == 'refs/heads/main'
      run: |
        # Add deployment commands here
        echo "Deploying to staging..."
    
    - name: Deploy to production
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: |
        # Add production deployment commands
        echo "Deploying to production..."
```

## Database Migrations

### Before Deployment

```bash
# Create migration files
python manage.py makemigrations

# Review migrations
python manage.py showmigrations

# Test migrations on staging data
python manage.py migrate --dry-run
```

### During Deployment

```bash
# Apply migrations
python manage.py migrate

# If rollback needed
python manage.py migrate app_name 0001  # Rollback to specific migration
```

## Health Checks

### Application Health Check

```python
# health_check.py
def health_check():
    """Basic health check endpoint."""
    try:
        # Check database connection
        db.engine.execute('SELECT 1')
        
        # Check external services
        external_service.ping()
        
        return {"status": "healthy", "timestamp": datetime.utcnow()}
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}
```

### Monitoring

```bash
# Check application status
curl https://your-app.com/health

# Monitor logs
tail -f /var/log/your-app/app.log

# Check resource usage
htop
df -h
```

## Rollback Procedures

### Quick Rollback

```bash
# Rollback to previous version
git checkout HEAD~1
# or use specific commit
git checkout abc123

# Redeploy
./deploy.sh
```

### Database Rollback

```bash
# Rollback database migrations
python manage.py migrate app_name 0001

# Restore from backup if needed
pg_restore -d database_name backup_file.sql
```

## Security Considerations

### Secrets Management

- Never commit secrets to version control
- Use environment variables or secret management services
- Rotate secrets regularly
- Use different secrets for each environment

### SSL/TLS

```nginx
# Nginx configuration example
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Firewall Rules

```bash
# Allow only necessary ports
ufw allow 22    # SSH
ufw allow 80    # HTTP
ufw allow 443   # HTTPS
ufw enable
```

## Performance Optimization

### Static Files

```bash
# Collect and compress static files
python manage.py collectstatic --noinput
python manage.py compress
```

### Caching

```python
# Redis caching example
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379/1',
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}
```

### Load Balancing

```nginx
# Nginx load balancer
upstream app_servers {
    server 127.0.0.1:8000;
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
}

server {
    location / {
        proxy_pass http://app_servers;
    }
}
```

## Monitoring and Logging

### Application Metrics

- Response times
- Error rates
- Resource usage
- Active users

### Log Management

```python
# Structured logging
import logging
import json

logger = logging.getLogger(__name__)

def log_request(request, response):
    log_data = {
        'timestamp': datetime.utcnow().isoformat(),
        'method': request.method,
        'url': request.url,
        'status_code': response.status_code,
        'response_time': response.time
    }
    logger.info(json.dumps(log_data))
```

## Troubleshooting

### Common Issues

1. **Application won't start**: Check environment variables and dependencies
2. **Database connection errors**: Verify database credentials and network connectivity
3. **Static files not loading**: Check static file configuration and permissions
4. **High memory usage**: Profile application and optimize queries

### Debug Mode

```bash
# Enable debug logging
export LOG_LEVEL=DEBUG

# Run with verbose output
python manage.py runserver --verbosity=2
```

## Backup and Recovery

### Database Backups

```bash
# Create backup
pg_dump database_name > backup_$(date +%Y%m%d).sql

# Automated backup script
#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump database_name | gzip > "$BACKUP_DIR/backup_$DATE.sql.gz"

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete
```

### Application Data

```bash
# Backup uploaded files
tar -czf files_backup_$(date +%Y%m%d).tar.gz /app/media/

# Sync to remote storage
aws s3 sync /app/media/ s3://your-backup-bucket/media/
```

## Resources

- [Deployment Best Practices](https://12factor.net/)
- [Docker Documentation](https://docs.docker.com/)
- [Cloud Platform Documentation](relevant-cloud-docs)
- [Monitoring Tools](monitoring-tools-docs)