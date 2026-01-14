# Security & Governance Architecture

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management Platform |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |

---

## 1. Overview

This document defines the security architecture and governance framework for the CLP AI Knowledge Management Platform, ensuring compliance with CLP Hong Kong's security requirements and regulatory obligations.

---

## 2. Authentication & Authorization

### 2.1 Identity Provider

| Component | Configuration |
|-----------|---------------|
| Provider | Azure Active Directory (Entra ID) |
| Tenant | CLP Hong Kong corporate tenant |
| Protocol | OAuth 2.0 / OpenID Connect |
| MFA | Required for all users |

### 2.2 Application Registration

| Application | Type | Permissions |
|-------------|------|-------------|
| VoltAI Marketplace | Web App | User.Read, GroupMember.Read.All |
| Admin Console | SPA | Sites.Read.All, Files.Read.All |
| Processing Functions | Daemon | Sites.Read.All, Files.Read.All |
| Speech Services | Service | Cognitive Services User |

### 2.3 Authorization Model - Role-Based Access Control (RBAC)

| Role | Scope | Permissions |
|------|-------|-------------|
| KB User | Application | Query knowledge base, view results |
| KB Admin | Application | Manage content, view analytics |
| Platform Admin | Infrastructure | Full platform management |
| Auditor | Read-only | View logs and compliance reports |

### 2.4 Azure RBAC Assignments

| Role | Resource | Principal |
|------|----------|-----------|
| Contributor | Resource Group | DevOps Service Principal |
| Cognitive Services User | Azure OpenAI | App Service Identity |
| Search Index Data Contributor | AI Search | Functions Identity |
| Cosmos DB Data Contributor | Cosmos DB | Functions Identity |

---

## 3. Data Encryption

### 3.1 Encryption at Rest

| Resource | Encryption Type | Key Management |
|----------|-----------------|----------------|
| Azure Cosmos DB | AES-256 | Microsoft-managed keys |
| Azure AI Search | AES-256 | Microsoft-managed keys |
| Blob Storage | AES-256 | Microsoft-managed keys |
| Azure Functions Storage | AES-256 | Microsoft-managed keys |

### 3.2 Encryption in Transit

| Connection | Protocol | Minimum Version |
|------------|----------|-----------------|
| Client to App Service | TLS | 1.2 |
| App Service to Azure Services | TLS | 1.2 |
| Service to Service | TLS | 1.2 |
| SharePoint API calls | TLS | 1.2 |

---

## 4. Network Security

### 4.1 Network Security Groups (NSG)

**App Subnet NSG Rules**

| Priority | Direction | Source | Destination | Port | Action |
|----------|-----------|--------|-------------|------|--------|
| 100 | Inbound | Internet | App Service | 443 | Allow |
| 110 | Inbound | VNet | App Service | 443 | Allow |
| 4096 | Inbound | Any | Any | Any | Deny |

**Functions Subnet NSG Rules**

| Priority | Direction | Source | Destination | Port | Action |
|----------|-----------|--------|-------------|------|--------|
| 100 | Inbound | VNet | Functions | 443 | Allow |
| 110 | Outbound | Functions | Azure Services | 443 | Allow |
| 4096 | Inbound | Any | Any | Any | Deny |

### 4.2 Private Endpoints

| Service | Private Endpoint | DNS Zone |
|---------|------------------|----------|
| Cosmos DB | pe-cosmos-clp-kb | privatelink.documents.azure.com |
| AI Search | pe-search-clp-kb | privatelink.search.windows.net |
| Azure OpenAI | pe-openai-clp-kb | privatelink.openai.azure.com |
| Blob Storage | pe-storage-clp-kb | privatelink.blob.core.windows.net |

---

## 5. Data Protection

### 5.1 Data Classification

| Classification | Description | Examples |
|----------------|-------------|----------|
| Confidential | Business sensitive | Training content, Q&A logs |
| Internal | Internal use only | Analytics, metadata |
| Public | No restrictions | Public documentation |

### 5.2 Data Residency

| Requirement | Implementation |
|-------------|----------------|
| Region | Azure Hong Kong (eastasia) |
| Data sovereignty | All data remains in Hong Kong |
| Backup location | Hong Kong region only |
| Processing location | Hong Kong region only |

---

## 6. Compliance Framework

### 6.1 Regulatory Requirements

| Regulation | Applicability | Controls |
|------------|---------------|----------|
| PDPO (HK Privacy) | Personal data handling | Data minimization, consent |
| CLP Internal Policy | Corporate governance | Access controls, audit |
| ISO 27001 | Information security | Security management system |

### 6.2 Audit Log Retention

| Log Type | Retention | Storage |
|----------|-----------|---------|
| Authentication logs | 2 years | Log Analytics |
| Application logs | 1 year | Log Analytics |
| Diagnostic logs | 90 days | Storage Account |
| Security alerts | 2 years | Log Analytics |

---

## 7. Threat Protection

### 7.1 Security Monitoring

| Capability | Service | Configuration |
|------------|---------|---------------|
| Threat detection | Microsoft Defender for Cloud | Standard tier |
| SIEM integration | Azure Sentinel | Connected to Log Analytics |
| Vulnerability scanning | Defender for App Service | Enabled |
| DDoS protection | Azure DDoS Protection | Basic tier |

### 7.2 Security Alerts

| Alert Type | Severity | Response |
|------------|----------|----------|
| Failed authentication spike | High | Auto-block, notify SOC |
| Unusual API activity | Medium | Investigate, notify team |
| Configuration changes | Low | Review, approve/rollback |
| Data exfiltration attempt | Critical | Auto-block, incident response |

---

## 8. Secret Management

### 8.1 Azure Key Vault Configuration

| Setting | Value |
|---------|-------|
| SKU | Standard |
| Soft delete | Enabled (90 days) |
| Purge protection | Enabled |
| RBAC authorization | Enabled |

### 8.2 Managed Identity Usage

| Resource | Identity Type | Purpose |
|----------|---------------|---------|
| App Service | System-assigned | Access to Cosmos DB, AI Search |
| Azure Functions | System-assigned | Access to all Azure resources |
| Logic Apps | System-assigned | SharePoint access |

---

## 9. Governance Policies

### 9.1 Access Review

| Review Type | Frequency | Reviewer |
|-------------|-----------|----------|
| User access | Quarterly | Application owner |
| Service principal | Semi-annual | Security team |
| Admin access | Monthly | Security team |

### 9.2 Change Management

| Change Type | Approval Required | Process |
|-------------|-------------------|---------|
| Infrastructure | Platform team lead | PR + Terraform plan review |
| Application code | Dev team lead | PR + code review |
| Security config | Security team | PR + security review |
| Emergency | 2 approvers | Expedited review + post-mortem |

---

## Related Documents

- [Architecture Overview](overview.md)
- [Data Flows](data-flows.md)
- [Network Security](../../infra/docs/architecture/network-security.md)
- [Operations](../../infra/docs/architecture/operations.md)
