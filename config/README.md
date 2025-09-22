# Configuration Directory

This directory contains configuration files for the project.

## Files

Place environment-specific and application configuration files here:

- `settings.py` - Application settings
- `database.py` - Database configuration
- `logging.conf` - Logging configuration
- `nginx.conf` - Web server configuration
- `docker-compose.yml` - Docker composition
- `.env.example` - Environment variables template

## Environment Variables

Create a `.env.example` file in the project root with template variables:

```bash
# Database
DATABASE_URL=sqlite:///app.db
DATABASE_PASSWORD=change_me

# API Keys
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here

# Application
DEBUG=false
LOG_LEVEL=INFO
```

## Guidelines

- Never commit sensitive information
- Use environment variables for secrets
- Provide example/template configuration files
- Document all configuration options
- Use different configurations for different environments