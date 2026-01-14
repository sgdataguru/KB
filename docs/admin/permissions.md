# Permissions & Access Control

## Overview

CLP Knowledge Base implements enterprise-grade access control using Azure Active Directory (Azure AD) and Role-Based Access Control (RBAC) across all services.

## Azure AD Integration

### Application Registration

| Application | Purpose | Permissions |
|-------------|---------|-------------|
| clp-kb-api | Backend API | User.Read, openid, profile |
| clp-kb-console | Management Console | User.Read, openid, profile |
| clp-kb-functions | Azure Functions | Managed Identity |

### Enterprise Application Setup

1. Register applications in Azure AD
2. Configure redirect URIs
3. Set up API permissions
4. Configure token settings

## Role Definitions

### Application Roles

| Role | Code | Description |
|------|------|-------------|
| Administrator | `Admin` | Full system access |
| Content Manager | `ContentManager` | Document management |
| User | `User` | Query access only |
| Auditor | `Auditor` | Read-only audit access |

### Role Manifest

```json
{
  "appRoles": [
    {
      "allowedMemberTypes": ["User"],
      "displayName": "Administrator",
      "id": "00000000-0000-0000-0000-000000000001",
      "isEnabled": true,
      "description": "Full access to all features",
      "value": "Admin"
    },
    {
      "allowedMemberTypes": ["User"],
      "displayName": "Content Manager",
      "id": "00000000-0000-0000-0000-000000000002",
      "isEnabled": true,
      "description": "Manage documents and processing",
      "value": "ContentManager"
    },
    {
      "allowedMemberTypes": ["User"],
      "displayName": "User",
      "id": "00000000-0000-0000-0000-000000000003",
      "isEnabled": true,
      "description": "Query the knowledge base",
      "value": "User"
    },
    {
      "allowedMemberTypes": ["User"],
      "displayName": "Auditor",
      "id": "00000000-0000-0000-0000-000000000004",
      "isEnabled": true,
      "description": "View audit logs and analytics",
      "value": "Auditor"
    }
  ]
}
```

## Permission Matrix

### Management Console

| Feature | Admin | Content Manager | User | Auditor |
|---------|-------|-----------------|------|---------|
| Dashboard | ✅ | ✅ | ❌ | ✅ |
| Document List | ✅ | ✅ | ❌ | ✅ |
| Document Edit | ✅ | ✅ | ❌ | ❌ |
| Document Delete | ✅ | ❌ | ❌ | ❌ |
| Processing Queue | ✅ | ✅ | ❌ | ✅ |
| Retry Processing | ✅ | ✅ | ❌ | ❌ |
| Analytics | ✅ | ✅ | ❌ | ✅ |
| Audit Logs | ✅ | ❌ | ❌ | ✅ |
| Settings | ✅ | ❌ | ❌ | ❌ |

### API Endpoints

| Endpoint | Method | Admin | ContentManager | User | Auditor |
|----------|--------|-------|----------------|------|---------|
| /api/chat | POST | ✅ | ✅ | ✅ | ❌ |
| /api/documents | GET | ✅ | ✅ | ❌ | ✅ |
| /api/documents | POST | ✅ | ✅ | ❌ | ❌ |
| /api/documents/:id | DELETE | ✅ | ❌ | ❌ | ❌ |
| /api/processing | GET | ✅ | ✅ | ❌ | ✅ |
| /api/processing/:id/retry | POST | ✅ | ✅ | ❌ | ❌ |
| /api/analytics | GET | ✅ | ✅ | ❌ | ✅ |
| /api/audit | GET | ✅ | ❌ | ❌ | ✅ |
| /api/settings | GET/PUT | ✅ | ❌ | ❌ | ❌ |

## Azure Resource RBAC

### Resource Group Level

| Principal | Role | Scope |
|-----------|------|-------|
| DevOps Service Principal | Contributor | Resource Group |
| Admin Group | Reader | Resource Group |
| Application Managed Identity | Contributor | Resource Group |

### Service-Specific Permissions

#### Azure OpenAI
```bash
az role assignment create \
  --assignee <managed-identity-id> \
  --role "Cognitive Services OpenAI User" \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.CognitiveServices/accounts/<openai>
```

#### Azure AI Search
```bash
az role assignment create \
  --assignee <managed-identity-id> \
  --role "Search Index Data Contributor" \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Search/searchServices/<search>
```

#### Cosmos DB
```bash
az role assignment create \
  --assignee <managed-identity-id> \
  --role "Cosmos DB Built-in Data Contributor" \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.DocumentDB/databaseAccounts/<cosmos>
```

#### Key Vault
```bash
az role assignment create \
  --assignee <managed-identity-id> \
  --role "Key Vault Secrets User" \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault>
```

## Audit Logging

All access is logged to Cosmos DB:

```json
{
  "id": "audit-12345",
  "timestamp": "2026-01-14T10:30:00Z",
  "userId": "user@clp.com.hk",
  "userRoles": ["User"],
  "action": "chat.query",
  "resource": "/api/chat",
  "query": "How do I calibrate K2?",
  "result": "success",
  "responseTime": 2500,
  "ipAddress": "10.0.0.100",
  "userAgent": "Mozilla/5.0..."
}
```

### Retention

- Audit logs retained for 10 years (compliance requirement)
- Query logs retained for 1 year
- Access logs retained for 90 days

## Security Best Practices

1. **Least Privilege** - Assign minimum required permissions
2. **Regular Reviews** - Quarterly access reviews
3. **MFA Required** - Enforce multi-factor authentication
4. **Conditional Access** - Location and device policies
5. **Privileged Identity Management** - Just-in-time admin access