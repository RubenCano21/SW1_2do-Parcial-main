#!/bin/bash

# Quick Commands for Production Setup
# ====================================

echo "🚀 UML Diagram Backend - Production Setup Helper"
echo "================================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if we're in the backend directory
if [ ! -f "package.json" ]; then
    print_error "Not in backend directory. Please cd to backend first."
    exit 1
fi

echo "Select an option:"
echo "1. Install dependencies"
echo "2. Generate Prisma Client"
echo "3. Run migrations"
echo "4. Build for production"
echo "5. Start production server"
echo "6. Run all (full setup)"
echo "7. Generate JWT Secret"
echo "8. Test health endpoint"
echo "9. Check environment variables"
echo "0. Exit"
echo ""
read -p "Enter option (0-9): " option

case $option in
    1)
        print_info "Installing dependencies..."
        npm install
        print_success "Dependencies installed"
        ;;
    2)
        print_info "Generating Prisma Client..."
        npm run prisma:generate
        print_success "Prisma Client generated"
        ;;
    3)
        print_info "Running database migrations..."
        npm run prisma:migrate
        print_success "Migrations completed"
        ;;
    4)
        print_info "Building for production..."
        npm run build
        print_success "Build completed"
        ;;
    5)
        print_info "Starting production server..."
        npm run start:prod
        ;;
    6)
        print_info "Running full setup..."
        npm install && \
        npm run prisma:generate && \
        npm run build && \
        print_success "Full setup completed! Ready to deploy."
        ;;
    7)
        print_info "Generating JWT Secret..."
        JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
        echo ""
        print_success "JWT Secret generated:"
        echo $JWT_SECRET
        echo ""
        print_info "Copy this and add it to your Render environment variables as JWT_SECRET"
        ;;
    8)
        read -p "Enter backend URL (e.g., http://localhost:3000): " URL
        print_info "Testing health endpoint..."
        response=$(curl -s "${URL}/api/health")
        if [ $? -eq 0 ]; then
            print_success "Health check response:"
            echo $response | jq . 2>/dev/null || echo $response
        else
            print_error "Failed to connect to health endpoint"
        fi
        ;;
    9)
        print_info "Checking environment variables..."
        echo ""
        
        required_vars=(
            "DATABASE_URL"
            "REDIS_URL"
            "JWT_SECRET"
            "GROQ_API_KEY"
            "GEMINI_API_KEY"
            "NODE_ENV"
        )
        
        for var in "${required_vars[@]}"; do
            if [ -z "${!var}" ]; then
                print_error "$var is not set"
            else
                print_success "$var is set"
            fi
        done
        echo ""
        print_info "For production, also set: FRONTEND_URL, CORS_ORIGIN"
        ;;
    0)
        print_info "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac
