# Template Usage Guide

This guide explains how to use this BioNanomics project template to create a new project.

## Getting Started

### 1. Create New Repository from Template

#### Method A: Using GitHub UI
1. Navigate to https://github.com/BioNanomics/template
2. Click "Use this template" button
3. Choose "Create a new repository"
4. Fill in your repository details:
   - Repository name
   - Description
   - Public/Private setting
5. Click "Create repository from template"

#### Method B: Using GitHub CLI
```bash
gh repo create your-project-name --template BioNanomics/template --public
cd your-project-name
```

### 2. Customize Your Project

Work through this checklist to customize the template for your specific project:

#### Basic Information
- [ ] Update `README.md` with your project details
- [ ] Replace `[your-project-name]` placeholders throughout files
- [ ] Update `CHANGELOG.md` with your initial version
- [ ] Modify `LICENSE` if using a different license

#### Project Configuration
- [ ] Choose and configure your tech stack:
  - [ ] Python: Use `pyproject.toml.template` → `pyproject.toml`
  - [ ] Node.js: Use `package.json.template` → `package.json`
  - [ ] Docker: Use `Dockerfile.template` → `Dockerfile`
- [ ] Update `requirements.txt` and `requirements-dev.txt` (Python)
- [ ] Customize `.gitignore` for your specific needs
- [ ] Configure `.env.example` with your environment variables

#### Development Setup
- [ ] Update GitHub Actions workflows in `.github/workflows/`
- [ ] Customize pre-commit hooks in `.pre-commit-config.yaml`
- [ ] Modify `Makefile` commands for your project
- [ ] Update setup script `scripts/setup.sh`

#### Documentation
- [ ] Customize documentation in `docs/` directory
- [ ] Update setup instructions in `docs/setup.md`
- [ ] Modify development guide in `docs/development.md`
- [ ] Adjust testing guide in `docs/testing.md`
- [ ] Update deployment guide in `docs/deployment.md`

#### GitHub Configuration
- [ ] Customize issue templates in `.github/ISSUE_TEMPLATE/`
- [ ] Update pull request template in `.github/PULL_REQUEST_TEMPLATE/`
- [ ] Configure repository settings (branch protection, etc.)

#### Clean Up
- [ ] Remove unused template files (`.template` extensions)
- [ ] Delete directories you don't need
- [ ] Remove this usage guide (`docs/TEMPLATE_USAGE.md`)

### 3. Project-Specific Setup

#### For Python Projects
```bash
# Rename template files
mv pyproject.toml.template pyproject.toml
mv Dockerfile.template Dockerfile
mv docker-compose.yml.template docker-compose.yml

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements-dev.txt

# Set up pre-commit hooks
pre-commit install

# Initialize your source code
mkdir -p src/your_package
touch src/your_package/__init__.py
```

#### For Node.js Projects
```bash
# Rename template files
mv package.json.template package.json
mv Dockerfile.template Dockerfile
mv docker-compose.yml.template docker-compose.yml

# Install dependencies
npm install

# Set up pre-commit hooks (if using)
npx husky install
```

#### For Docker Projects
```bash
# Rename template files
mv Dockerfile.template Dockerfile
mv docker-compose.yml.template docker-compose.yml

# Build and test
docker build -t your-project-name .
docker-compose up -d
```

## Template Structure Explained

### Core Files
- `README.md`: Main project documentation
- `LICENSE`: MIT license (customize if needed)
- `CHANGELOG.md`: Version history tracking
- `CONTRIBUTING.md`: Contribution guidelines
- `.gitignore`: Comprehensive ignore patterns
- `.editorconfig`: Editor configuration
- `.env.example`: Environment variables template

### Development Configuration
- `.pre-commit-config.yaml`: Pre-commit hooks
- `Makefile`: Common development commands
- `requirements*.txt`: Python dependencies
- `package.json.template`: Node.js configuration
- `pyproject.toml.template`: Modern Python project config

### Directory Structure
- `src/`: Source code
- `tests/`: Test files
- `docs/`: Documentation
- `scripts/`: Utility scripts
- `config/`: Configuration files
- `data/`: Data files (if applicable)

### GitHub Integration
- `.github/workflows/`: CI/CD workflows
- `.github/ISSUE_TEMPLATE/`: Issue templates
- `.github/PULL_REQUEST_TEMPLATE/`: PR templates

### Docker Support
- `Dockerfile.template`: Multi-stage Docker build
- `docker-compose.yml.template`: Development environment

## Best Practices

### Version Control
- Use meaningful commit messages
- Follow conventional commits format
- Create feature branches for development
- Use pull requests for code review

### Code Quality
- Set up automated linting and formatting
- Write comprehensive tests
- Use type hints (Python) or TypeScript
- Document your code

### Security
- Never commit secrets or credentials
- Use environment variables for configuration
- Keep dependencies updated
- Run security scans regularly

### Documentation
- Keep README up to date
- Document API endpoints
- Write clear setup instructions
- Maintain changelog

## Customization Examples

### Adding New Dependencies

#### Python
```bash
# Add to requirements.txt
echo "fastapi>=0.68.0" >> requirements.txt

# For development dependencies
echo "pytest-asyncio>=0.18.0" >> requirements-dev.txt
```

#### Node.js
```bash
# Production dependency
npm install express

# Development dependency
npm install --save-dev jest
```

### Adding New Scripts

#### Makefile
```makefile
migrate: ## Run database migrations
	python manage.py migrate

deploy: ## Deploy to production
	./scripts/deploy.sh
```

#### package.json
```json
{
  "scripts": {
    "migrate": "npx sequelize-cli db:migrate",
    "seed": "npx sequelize-cli db:seed:all"
  }
}
```

### Custom GitHub Actions

Create `.github/workflows/custom.yml`:
```yaml
name: Custom Workflow

on:
  push:
    branches: [main]

jobs:
  custom-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Custom step
        run: echo "Add your custom logic here"
```

## Troubleshooting

### Common Issues

1. **Template files not renamed**: Remember to rename `.template` files
2. **Dependencies not found**: Run installation commands after customization
3. **Tests failing**: Update test configuration for your specific setup
4. **CI/CD not working**: Check GitHub Actions and update for your tech stack

### Getting Help

- Check existing issues in the template repository
- Create a new issue if you find a problem
- Join BioNanomics community discussions
- Review documentation in the `docs/` directory

## Contributing Back to Template

If you make improvements that would benefit other projects:

1. Fork the template repository
2. Create a feature branch
3. Make your improvements
4. Submit a pull request
5. Include examples and documentation

## Next Steps

After customizing your template:

1. Set up your development environment
2. Write your first test
3. Implement your core functionality
4. Set up continuous integration
5. Write comprehensive documentation
6. Plan your first release

Happy coding! 🚀