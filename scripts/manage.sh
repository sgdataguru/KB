#!/bin/bash
# CLP Knowledge Base - Management Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo "Usage: $0 {start|stop|status|logs|build|deploy}"
    echo ""
    echo "Commands:"
    echo "  start   - Start development servers"
    echo "  stop    - Stop all running servers"
    echo "  status  - Check service status"
    echo "  logs    - View application logs"
    echo "  build   - Build production assets"
    echo "  deploy  - Deploy to Azure (requires az login)"
    exit 1
}

start_services() {
    echo -e "${YELLOW}Starting development services...${NC}"
    
    # Start Next.js dev server in background
    echo -e "Starting Next.js..."
    npm run dev &
    NEXT_PID=$!
    echo $NEXT_PID > .pids/next.pid
    
    echo -e "${GREEN}✓ Services started${NC}"
    echo -e "  Next.js: http://localhost:3000"
    echo -e "\nUse '$0 stop' to stop services"
}

stop_services() {
    echo -e "${YELLOW}Stopping services...${NC}"
    
    if [ -f ".pids/next.pid" ]; then
        kill $(cat .pids/next.pid) 2>/dev/null || true
        rm .pids/next.pid
    fi
    
    # Kill any remaining node processes on port 3000
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    
    echo -e "${GREEN}✓ Services stopped${NC}"
}

check_status() {
    echo -e "${YELLOW}Checking service status...${NC}"
    
    # Check Next.js
    if lsof -i:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Next.js running on port 3000${NC}"
    else
        echo -e "${RED}✗ Next.js not running${NC}"
    fi
    
    # Check Azure connection
    if az account show > /dev/null 2>&1; then
        ACCOUNT=$(az account show --query name -o tsv)
        echo -e "${GREEN}✓ Azure CLI logged in: $ACCOUNT${NC}"
    else
        echo -e "${YELLOW}⚠ Azure CLI not logged in${NC}"
    fi
}

view_logs() {
    echo -e "${YELLOW}Viewing logs...${NC}"
    
    if [ -f ".next/server/logs/server.log" ]; then
        tail -f .next/server/logs/server.log
    else
        echo -e "${YELLOW}No log file found. Start services first.${NC}"
    fi
}

build_production() {
    echo -e "${YELLOW}Building production assets...${NC}"
    
    # Build Next.js
    npm run build
    
    echo -e "${GREEN}✓ Build complete${NC}"
}

deploy_azure() {
    echo -e "${YELLOW}Deploying to Azure...${NC}"
    
    # Check Azure login
    if ! az account show > /dev/null 2>&1; then
        echo -e "${RED}✗ Please login to Azure first: az login${NC}"
        exit 1
    fi
    
    # Build first
    build_production
    
    # Deploy using Azure CLI
    RESOURCE_GROUP="rg-clp-kb-prod"
    APP_NAME="app-console-clp-kb-prod"
    
    echo -e "Deploying to $APP_NAME..."
    
    # Zip and deploy
    zip -r deploy.zip .next package.json next.config.ts public
    az webapp deploy --resource-group $RESOURCE_GROUP --name $APP_NAME --src-path deploy.zip --type zip
    rm deploy.zip
    
    echo -e "${GREEN}✓ Deployment complete${NC}"
}

# Create pids directory if not exists
mkdir -p .pids

# Main
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    status)
        check_status
        ;;
    logs)
        view_logs
        ;;
    build)
        build_production
        ;;
    deploy)
        deploy_azure
        ;;
    *)
        usage
        ;;
esac