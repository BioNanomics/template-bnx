# Source Code Directory

This directory contains the main source code for the project.

## Structure

Organize your source code according to your project's needs. Common patterns include:

### Python Project Example
```
src/
├── main/                  # Main application module
│   ├── __init__.py
│   ├── app.py            # Application entry point
│   ├── models.py         # Data models
│   ├── views.py          # View controllers
│   └── utils.py          # Utility functions
├── config/               # Configuration modules
│   ├── __init__.py
│   ├── settings.py       # Application settings
│   └── database.py       # Database configuration
└── __init__.py
```

### JavaScript/Node.js Project Example
```
src/
├── components/           # React components
├── services/            # API services
├── utils/               # Utility functions
├── styles/              # CSS/SCSS files
├── config/              # Configuration files
├── app.js               # Main application file
└── index.js             # Entry point
```

## Guidelines

- Keep modules focused and cohesive
- Use descriptive names for files and directories
- Separate concerns (models, views, controllers, utilities)
- Follow your language's conventions
- Document complex modules and functions