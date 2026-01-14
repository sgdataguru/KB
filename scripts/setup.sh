#!/bin/bash
# CLP Knowledge Base - Setup Script

set -e

echo "🚀 CLP Knowledge Base - Setup Script"
echo "======================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
check_prerequisites() {
    echo -e "\n${YELLOW}Checking prerequisites...${NC}"
    
    # Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo -e "${GREEN}✓ Node.js: $NODE_VERSION${NC}"
    else
        echo -e "${RED}✗ Node.js not found. Please install Node.js 18+${NC}"
        exit 1
    fi
    
    # Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        echo -e "${GREEN}✓ Python: $PYTHON_VERSION${NC}"
    else
        echo -e "${RED}✗ Python not found. Please install Python 3.11+${NC}"
        exit 1
    fi
    
    # Azure CLI
    if command -v az &> /dev/null; then
        AZ_VERSION=$(az version --query '"azure-cli"' -o tsv)
        echo -e "${GREEN}✓ Azure CLI: $AZ_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠ Azure CLI not found. Install for Azure deployments${NC}"
    fi
    
    # Terraform
    if command -v terraform &> /dev/null; then
        TF_VERSION=$(terraform version -json | jq -r '.terraform_version')
        echo -e "${GREEN}✓ Terraform: $TF_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠ Terraform not found. Install for infrastructure deployment${NC}"
    fi
}

# Install Node.js dependencies
install_node_deps() {
    echo -e "\n${YELLOW}Installing Node.js dependencies...${NC}"
    npm ci
    echo -e "${GREEN}✓ Node.js dependencies installed${NC}"
}

# Install Python dependencies
install_python_deps() {
    echo -e "\n${YELLOW}Setting up Python environment...${NC}"
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        echo -e "${GREEN}✓ Virtual environment created${NC}"
    fi
    
    # Activate and install dependencies
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✓ Python dependencies installed${NC}"
}

# Setup environment file
setup_env() {
    echo -e "\n${YELLOW}Setting up environment...${NC}"
    
    if [ ! -f ".env.local" ]; then
        cat > .env.local << 'EOF'
# CLP Knowledge Base - Environment Variables
# Copy this file to .env.local and fill in values

# Azure OpenAI
AZURE_OPENAI_ENDPOINT=
AZURE_OPENAI_API_KEY=
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4

# Azure AI Search
AZURE_SEARCH_ENDPOINT=
AZURE_SEARCH_API_KEY=
AZURE_SEARCH_INDEX_NAME=clp-kb-index

# Azure Cosmos DB
COSMOS_ENDPOINT=
COSMOS_KEY=
COSMOS_DATABASE=clp-kb-db

# Azure Speech Services
AZURE_SPEECH_KEY=
AZURE_SPEECH_REGION=eastasia

# Azure AD (NextAuth)
AZURE_AD_CLIENT_ID=
AZURE_AD_CLIENT_SECRET=
AZURE_AD_TENANT_ID=
NEXTAUTH_SECRET=
NEXTAUTH_URL=http://localhost:3000

# Application
NODE_ENV=development
EOF
        echo -e "${GREEN}✓ .env.local template created${NC}"
        echo -e "${YELLOW}⚠ Please update .env.local with your Azure credentials${NC}"
    else
        echo -e "${GREEN}✓ .env.local already exists${NC}"
    fi
}

# Main
main() {
    check_prerequisites
    install_node_deps
    install_python_deps
    setup_env
    
    echo -e "\n${GREEN}======================================"
    echo -e "✅ Setup complete!"
    echo -e "======================================${NC}"
    echo -e "\nNext steps:"
    echo -e "1. Update .env.local with your Azure credentials"
    echo -e "2. Run 'npm run dev' to start the development server"
    echo -e "3. Run 'source venv/bin/activate' to activate Python environment"
}

main