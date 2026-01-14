# CLP Knowledge Base - Infrastructure Guide

## Overview

This directory contains Terraform configurations for deploying the CLP Knowledge Base infrastructure to Microsoft Azure. All resources are deployed to the **Azure Hong Kong (East Asia)** region for data residency compliance.

## Architecture

```
Azure Hong Kong (East Asia)
├── Resource Group (rg-clp-kb-{env})
│   ├── Virtual Network
│   │   ├── Application Subnet
│   │   ├── Data Subnet
│   │   └── Private Endpoints Subnet
│   │
│   ├── Azure OpenAI Service
│   │   ├── GPT-4 Deployment
│   │   └── text-embedding-ada-002 Deployment
│   │
│   ├── Azure AI Search (Vector enabled)
│   │
│   ├── Azure Cosmos DB (Serverless)
│   │   ├── documents container
│   │   └── audit_logs container
│   │
│   ├── Azure Speech Services
│   │
│   ├── App Service Plan
│   │   ├── API App (Python)
│   │   └── Console App (Node.js)
│   │
│   ├── Azure Functions (Ingestion)
│   │
│   ├── Key Vault
│   │
│   ├── Storage Account
│   │   ├── documents container
│   │   └── transcripts container
│   │
│   └── Monitoring
│       ├── Log Analytics Workspace
│       └── Application Insights
```

## Prerequisites

- Azure CLI (`az`) installed and logged in
- Terraform 1.5+ installed
- Azure subscription with sufficient quota
- Required Azure resource providers registered:
  - `Microsoft.CognitiveServices`
  - `Microsoft.Search`
  - `Microsoft.DocumentDB`
  - `Microsoft.Web`
  - `Microsoft.KeyVault`

## Directory Structure

```
infra/
├── main.tf              # Main resource definitions
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── providers.tf         # Provider configuration
├── modules/             # Reusable Terraform modules
│   ├── ai-foundry/     # Azure AI Foundry (Phase 2)
│   ├── openai/         # Azure OpenAI module
│   ├── storage/        # Storage account module
│   ├── networking/     # Networking module
│   └── monitoring/     # Monitoring module
├── environments/        # Environment-specific configs
│   ├── dev/
│   ├── staging/
│   └── prod/
└── docs/               # This documentation
```

## Quick Start

### 1. Initialize Terraform

```bash
cd infra
terraform init
```

### 2. Review Variables

Copy the example variables file and customize:

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 3. Plan Deployment

```bash
terraform plan -var-file="environments/dev/terraform.tfvars"
```

### 4. Apply Configuration

```bash
terraform apply -var-file="environments/dev/terraform.tfvars"
```

## Environment Configuration

### Development
```hcl
environment = "dev"
search_sku = "basic"
app_service_sku = "B1"
```

### Staging
```hcl
environment = "staging"
search_sku = "standard"
app_service_sku = "P1v3"
```

### Production
```hcl
environment = "prod"
search_sku = "standard"
search_replica_count = 2
app_service_sku = "P2v3"
storage_account_replication = "GRS"
```

## Security Considerations

### Network Security
- All PaaS services use Private Endpoints
- Network Security Groups restrict traffic
- Public access disabled where possible

### Identity & Access
- Managed Identities for service-to-service auth
- Key Vault for secrets management
- RBAC enabled on all services

### Data Protection
- TLS 1.2 minimum
- Encryption at rest enabled
- Soft delete and purge protection on Key Vault

## Outputs

After deployment, these values are available:

| Output | Description |
|--------|-------------|
| `api_app_url` | URL of the API application |
| `console_app_url` | URL of the Management Console |
| `openai_endpoint` | Azure OpenAI endpoint |
| `search_endpoint` | Azure AI Search endpoint |
| `cosmos_endpoint` | Cosmos DB endpoint |
| `key_vault_uri` | Key Vault URI |

## Cost Estimation

### Phase 1 (MVP) - Monthly Estimate
| Service | SKU | Estimated Cost |
|---------|-----|----------------|
| Azure OpenAI | S0 | ~$500-1000 |
| Azure AI Search | Standard | ~$250 |
| Cosmos DB | Serverless | ~$50-100 |
| App Service | P1v3 | ~$150 |
| Speech Services | S0 | ~$50-100 |
| Storage | Standard LRS | ~$20 |
| Monitoring | - | ~$50 |

**Total**: ~$1,000-1,700/month (varies by usage)

## Phase 2 Blueprint

The infrastructure is designed to support Phase 2 additions:

- **AI Avatar**: GPU compute nodes (NC-series VMs)
- **Video Indexer**: Dedicated media processing
- **Scale-out**: Additional search replicas and partitions

Enable Phase 2 features:
```hcl
enable_ai_avatar = true
enable_video_indexer = true
gpu_node_count = 2
```

## Troubleshooting

### Common Issues

1. **Quota exceeded**: Request quota increase for Azure OpenAI in Hong Kong region
2. **Private endpoint DNS**: Ensure DNS zones are properly linked to VNet
3. **RBAC permissions**: Grant Terraform service principal required roles

### Support

Contact the DevOps team for infrastructure issues.