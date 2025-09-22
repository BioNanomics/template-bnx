# Makefile for project automation
# Customize based on your specific needs

.PHONY: help install install-dev test test-cov lint format clean build run docker-build docker-run

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Python project commands
install: ## Install production dependencies
	pip install -r requirements.txt

install-dev: ## Install development dependencies
	pip install -r requirements.txt -r requirements-dev.txt
	pre-commit install

test: ## Run tests
	pytest

test-cov: ## Run tests with coverage
	pytest --cov=src --cov-report=html --cov-report=term

lint: ## Run linting checks
	flake8 src/ tests/
	pylint src/
	mypy src/

format: ## Format code
	black src/ tests/
	isort src/ tests/

# Node.js project commands (uncomment if using Node.js)
# install: ## Install dependencies
# 	npm install

# install-dev: ## Install development dependencies
# 	npm install --include=dev

# test: ## Run tests
# 	npm test

# test-cov: ## Run tests with coverage
# 	npm run test:coverage

# lint: ## Run linting
# 	npm run lint

# format: ## Format code
# 	npm run format

# Build commands
build: ## Build the project
	python -m build
	# npm run build  # For Node.js projects

clean: ## Clean build artifacts
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name __pycache__ -delete
	find . -type f -name "*.pyc" -delete

# Runtime commands
run: ## Run the application
	python -m src.main
	# npm start  # For Node.js projects

dev: ## Run in development mode
	python -m src.main --debug
	# npm run dev  # For Node.js projects

# Docker commands
docker-build: ## Build Docker image
	docker build -t your-project-name .

docker-run: ## Run Docker container
	docker run -p 8000:8000 your-project-name

docker-compose-up: ## Start services with docker-compose
	docker-compose up -d

docker-compose-down: ## Stop services
	docker-compose down

# Database commands (customize based on your needs)
db-migrate: ## Run database migrations
	python manage.py migrate
	# npm run migrate  # For Node.js projects

db-reset: ## Reset database
	python manage.py reset_db
	# npm run db:reset  # For Node.js projects

# Documentation
docs: ## Generate documentation
	cd docs && make html
	# npm run docs  # For Node.js projects

docs-serve: ## Serve documentation locally
	cd docs/_build/html && python -m http.server 8080

# Security
security-check: ## Run security checks
	pip-audit
	bandit -r src/
	# npm audit  # For Node.js projects

# Release
release: clean test lint ## Prepare for release
	@echo "Ready for release!"

# Environment setup
setup: ## Set up development environment
	python -m venv venv
	@echo "Now run: source venv/bin/activate && make install-dev"

# Git hooks
pre-commit: ## Run pre-commit hooks
	pre-commit run --all-files

# Performance
profile: ## Profile the application
	python -m cProfile -o profile.stats src/main.py
	python -c "import pstats; pstats.Stats('profile.stats').sort_stats('cumulative').print_stats(20)"