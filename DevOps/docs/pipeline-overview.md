# CLP Knowledge Base - CI/CD Pipeline Overview

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AZURE DEVOPS                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐                                                           │
│  │   Trigger   │ ◄─── Push to main/develop                                 │
│  └──────┬──────┘                                                           │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                        BUILD STAGE                               │       │
│  ├──────────────────────────┬──────────────────────────────────────┤       │
│  │   Console (Next.js)      │      Python (API/Functions)          │       │
│  │   • npm ci               │      • pip install                   │       │
│  │   • npm lint             │      • black/pylint check            │       │
│  │   • npm build            │      • pytest                        │       │
│  │   • npm test             │      • archive                       │       │
│  └──────────────────────────┴──────────────────────────────────────┘       │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                    INFRASTRUCTURE STAGE                          │       │
│  │                      (main branch only)                          │       │
│  ├─────────────────────────────────────────────────────────────────┤       │
│  │   • terraform init                                               │       │
│  │   • terraform plan                                               │       │
│  │   • terraform apply (manual approval)                            │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│         │                                                                   │
│         ├────────────────────────────────────┐                             │
│         ▼                                    ▼                             │
│  ┌──────────────────┐              ┌──────────────────┐                   │
│  │   DEPLOY DEV     │              │   DEPLOY PROD    │                   │
│  │ (develop branch) │              │  (main branch)   │                   │
│  ├──────────────────┤              ├──────────────────┤                   │
│  │ • Console App    │              │ • Console App    │                   │
│  │ • Functions App  │              │ • Functions App  │                   │
│  │ • API App        │              │ • API App        │                   │
│  └──────────────────┘              └──────────────────┘                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Environments

| Environment | Branch | Approval | Description |
|-------------|--------|----------|-------------|
| Development | develop | Automatic | Testing and integration |
| Staging | - | Manual | Pre-production validation |
| Production | main | Manual | Live environment |

## Pipeline Stages

### 1. Build Stage

**Console Build (Next.js)**
- Installs Node.js 18.x
- Runs `npm ci` for clean install
- Lints code with ESLint
- Builds production bundle
- Runs unit tests with coverage
- Archives `.next` folder

**Python Build**
- Uses Python 3.11
- Installs dependencies from requirements.txt
- Lints with Black and Pylint
- Runs pytest with coverage
- Archives source code

### 2. Infrastructure Stage

**Terraform Workflow**
- Initializes with Azure backend
- Plans infrastructure changes
- Requires manual approval for apply
- Only runs on `main` branch

### 3. Deploy Stages

**Development**
- Auto-deploys on `develop` branch
- Deploys to `-dev` suffixed resources

**Production**
- Requires manual approval
- Deploys to `-prod` suffixed resources
- Only after successful infrastructure apply

## Variable Groups

### Required Variables (clp-kb-variables)

| Variable | Description |
|----------|-------------|
| `environment` | Current environment (dev/staging/prod) |
| `azureSubscriptionId` | Azure subscription ID |
| `resourceGroupName` | Target resource group |

### Secrets (Key Vault linked)

| Secret | Description |
|--------|-------------|
| `AZURE-OPENAI-KEY` | Azure OpenAI API key |
| `COSMOS-KEY` | Cosmos DB primary key |
| `SEARCH-ADMIN-KEY` | AI Search admin key |

## Service Connections

Create the following service connections in Azure DevOps:

1. **Azure-Service-Connection**
   - Type: Azure Resource Manager
   - Scope: Subscription or Resource Group
   - Permissions: Contributor + User Access Administrator

## Triggering Pipelines

### Automatic Triggers
- Push to `main` → Full pipeline with prod deploy
- Push to `develop` → Build + deploy to dev
- Pull requests → Build only (no deploy)

### Manual Triggers
- Use "Run pipeline" in Azure DevOps
- Select branch and variables

## Best Practices

1. **Never commit secrets** - Use Key Vault references
2. **Use variable groups** - Centralize configuration
3. **Require PR reviews** - Enforce code quality
4. **Monitor pipeline health** - Track success rates
5. **Use environments** - Implement approval gates

## Troubleshooting

### Common Issues

1. **Terraform state lock**
   - Check for abandoned locks in storage
   - Use `terraform force-unlock` if needed

2. **Deployment failures**
   - Check App Service logs
   - Verify environment variables

3. **Build failures**
   - Review test output
   - Check for missing dependencies

## Metrics & Monitoring

Track these metrics in Azure DevOps:
- Build success rate
- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery