#!/bin/bash
# Setup script for the project

set -e  # Exit on any error

echo "🚀 Setting up project..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install requirements if requirements.txt exists
if [ -f "requirements.txt" ]; then
    echo "📋 Installing requirements..."
    pip install -r requirements.txt
fi

# Install development requirements if they exist
if [ -f "requirements-dev.txt" ]; then
    echo "🛠️  Installing development requirements..."
    pip install -r requirements-dev.txt
fi

# Set up pre-commit hooks if .pre-commit-config.yaml exists
if [ -f ".pre-commit-config.yaml" ]; then
    echo "🎣 Setting up pre-commit hooks..."
    pip install pre-commit
    pre-commit install
fi

# Create .env file from template if it doesn't exist
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo "📝 Please edit .env file with your specific configuration"
fi

# Run initial tests if they exist
if [ -d "tests" ] && command -v pytest &> /dev/null; then
    echo "🧪 Running initial tests..."
    pytest --version
    # Uncomment the next line to run tests during setup
    # pytest
fi

echo "✅ Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Activate the virtual environment: source venv/bin/activate"
echo "2. Edit .env file if created"
echo "3. Review README.md for project-specific instructions"
echo "4. Start coding! 🎉"