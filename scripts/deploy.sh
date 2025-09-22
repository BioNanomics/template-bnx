#!/bin/bash
# Deployment script template
# Customize this script based on your deployment needs

set -e  # Exit on any error

# Configuration
PROJECT_NAME="your-project-name"
BRANCH="main"
REMOTE="origin"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed."
        exit 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository."
        exit 1
    fi
    
    # Check for clean working directory
    if ! git diff-index --quiet HEAD --; then
        log_error "Working directory is not clean. Please commit or stash changes."
        exit 1
    fi
    
    log_info "Prerequisites check passed."
}

run_tests() {
    log_info "Running tests..."
    
    # Python tests
    if [ -f "requirements.txt" ]; then
        if command -v pytest &> /dev/null; then
            pytest
        else
            log_warn "pytest not found, skipping tests"
        fi
    fi
    
    # Node.js tests
    if [ -f "package.json" ]; then
        if command -v npm &> /dev/null; then
            npm test
        else
            log_warn "npm not found, skipping tests"
        fi
    fi
    
    log_info "Tests completed."
}

build_application() {
    log_info "Building application..."
    
    # Python build
    if [ -f "pyproject.toml" ]; then
        python -m build
    fi
    
    # Node.js build
    if [ -f "package.json" ]; then
        npm run build
    fi
    
    # Docker build
    if [ -f "Dockerfile" ]; then
        log_info "Building Docker image..."
        docker build -t "$PROJECT_NAME:latest" .
    fi
    
    log_info "Build completed."
}

deploy_to_staging() {
    log_info "Deploying to staging..."
    
    # Add your staging deployment logic here
    # Examples:
    # - Deploy to staging server
    # - Update staging database
    # - Run staging tests
    
    # Docker deployment example
    if [ -f "docker-compose.staging.yml" ]; then
        docker-compose -f docker-compose.staging.yml up -d
    fi
    
    # Heroku deployment example
    # if command -v heroku &> /dev/null; then
    #     heroku git:remote -a your-staging-app
    #     git push heroku $BRANCH:main
    # fi
    
    log_info "Staging deployment completed."
}

deploy_to_production() {
    log_info "Deploying to production..."
    
    # Add your production deployment logic here
    # Examples:
    # - Deploy to production server
    # - Update production database
    # - Run smoke tests
    
    # Docker deployment example
    if [ -f "docker-compose.prod.yml" ]; then
        docker-compose -f docker-compose.prod.yml up -d
    fi
    
    # AWS deployment example
    # if command -v aws &> /dev/null; then
    #     aws ecs update-service --cluster your-cluster --service your-service --force-new-deployment
    # fi
    
    log_info "Production deployment completed."
}

rollback() {
    log_warn "Rolling back deployment..."
    
    # Add rollback logic here
    # Examples:
    # - Revert to previous Docker image
    # - Restore database backup
    # - Switch traffic back to previous version
    
    log_info "Rollback completed."
}

cleanup() {
    log_info "Cleaning up..."
    
    # Clean up build artifacts
    # Remove temporary files
    # Prune Docker images if needed
    
    log_info "Cleanup completed."
}

# Main deployment function
main() {
    local environment=${1:-staging}
    
    log_info "Starting deployment to $environment..."
    
    # Run checks
    check_prerequisites
    
    # Pull latest changes
    log_info "Pulling latest changes from $REMOTE/$BRANCH..."
    git pull $REMOTE $BRANCH
    
    # Run tests
    run_tests
    
    # Build application
    build_application
    
    # Deploy based on environment
    case $environment in
        staging)
            deploy_to_staging
            ;;
        production)
            deploy_to_production
            ;;
        *)
            log_error "Unknown environment: $environment"
            log_info "Usage: $0 [staging|production]"
            exit 1
            ;;
    esac
    
    # Cleanup
    cleanup
    
    log_info "Deployment to $environment completed successfully! 🚀"
}

# Script options
case "${1:-}" in
    -h|--help)
        echo "Usage: $0 [staging|production]"
        echo ""
        echo "Options:"
        echo "  staging     Deploy to staging environment (default)"
        echo "  production  Deploy to production environment"
        echo "  -h, --help  Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0                 # Deploy to staging"
        echo "  $0 staging         # Deploy to staging"
        echo "  $0 production      # Deploy to production"
        exit 0
        ;;
    rollback)
        rollback
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac