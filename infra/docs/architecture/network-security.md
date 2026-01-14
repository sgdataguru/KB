# Network Security Architecture

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management Platform |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |

---

## 1. Overview

This document defines the network topology, security zones, and connectivity patterns for the CLP AI Knowledge Management Platform deployed in Azure Hong Kong (eastasia) region.

---

## 2. Network Topology

### 2.1 Virtual Network Design

| VNet | Address Space | Purpose |
|------|---------------|---------|
| vnet-clp-kb-prod | 10.0.0.0/16 | Production workloads |

### 2.2 Subnet Layout

| Subnet | CIDR | Purpose | Delegated To |
|--------|------|---------|--------------|
| snet-app | 10.0.1.0/24 | App Service | Microsoft.Web/serverFarms |
| snet-functions | 10.0.2.0/24 | Azure Functions | Microsoft.Web/serverFarms |
| snet-private-endpoints | 10.0.3.0/24 | Private Endpoints | None |
| snet-integration | 10.0.4.0/24 | VNet Integration | Microsoft.Web/serverFarms |

### 2.3 IP Address Allocation

| Range | Usage | Available IPs |
|-------|-------|---------------|
| 10.0.1.0/24 | App Service | 251 |
| 10.0.2.0/24 | Functions | 251 |
| 10.0.3.0/24 | Private Endpoints | 251 |
| 10.0.4.0/24 | Integration | 251 |
| 10.0.5.0-255.0 | Future expansion | ~65,000 |

---

## 3. Network Security Groups (NSG)

### 3.1 NSG: nsg-snet-app

**Inbound Rules**

| Priority | Name | Source | Destination | Port | Protocol | Action |
|----------|------|--------|-------------|------|----------|--------|
| 100 | AllowHTTPS | Internet | Any | 443 | TCP | Allow |
| 110 | AllowAppGateway | GatewayManager | Any | 65200-65535 | TCP | Allow |
| 4096 | DenyAllInbound | Any | Any | Any | Any | Deny |

**Outbound Rules**

| Priority | Name | Source | Destination | Port | Protocol | Action |
|----------|------|--------|-------------|------|----------|--------|
| 100 | AllowAzureServices | Any | AzureCloud | 443 | TCP | Allow |
| 110 | AllowVNet | Any | VirtualNetwork | Any | Any | Allow |
| 4096 | DenyAllOutbound | Any | Any | Any | Any | Deny |

### 3.2 NSG: nsg-snet-functions

**Inbound Rules**

| Priority | Name | Source | Destination | Port | Protocol | Action |
|----------|------|--------|-------------|------|----------|--------|
| 100 | AllowVNet | VirtualNetwork | Any | 443 | TCP | Allow |
| 4096 | DenyAllInbound | Any | Any | Any | Any | Deny |

**Outbound Rules**

| Priority | Name | Source | Destination | Port | Protocol | Action |
|----------|------|--------|-------------|------|----------|--------|
| 100 | AllowAzureServices | Any | AzureCloud | 443 | TCP | Allow |
| 110 | AllowVNet | Any | VirtualNetwork | Any | Any | Allow |
| 120 | AllowInternet | Any | Internet | 443 | TCP | Allow |
| 4096 | DenyAllOutbound | Any | Any | Any | Any | Deny |

### 3.3 NSG: nsg-snet-private-endpoints

**Inbound Rules**

| Priority | Name | Source | Destination | Port | Protocol | Action |
|----------|------|--------|-------------|------|----------|--------|
| 100 | AllowVNet | VirtualNetwork | Any | Any | Any | Allow |
| 4096 | DenyAllInbound | Any | Any | Any | Any | Deny |

---

## 4. Private Endpoints

### 4.1 Private Endpoint Configuration

| Resource | Endpoint Name | Subnet | Private IP |
|----------|---------------|--------|------------|
| Cosmos DB | pe-cosmos-clp-kb | snet-private-endpoints | 10.0.3.4 |
| AI Search | pe-search-clp-kb | snet-private-endpoints | 10.0.3.5 |
| Azure OpenAI | pe-openai-clp-kb | snet-private-endpoints | 10.0.3.6 |
| Blob Storage | pe-storage-clp-kb | snet-private-endpoints | 10.0.3.7 |
| Key Vault | pe-kv-clp-kb | snet-private-endpoints | 10.0.3.8 |

### 4.2 Private DNS Zones

| Zone | Purpose | VNet Link |
|------|---------|-----------|
| privatelink.documents.azure.com | Cosmos DB | vnet-clp-kb-prod |
| privatelink.search.windows.net | AI Search | vnet-clp-kb-prod |
| privatelink.openai.azure.com | Azure OpenAI | vnet-clp-kb-prod |
| privatelink.blob.core.windows.net | Blob Storage | vnet-clp-kb-prod |
| privatelink.vaultcore.azure.net | Key Vault | vnet-clp-kb-prod |

### 4.3 DNS Configuration

| Setting | Value |
|---------|-------|
| DNS Resolver | Azure-provided DNS |
| Custom DNS | Not required (using Private DNS Zones) |
| Zone Registration | Auto-registration enabled |

---

## 5. Service Endpoints

### 5.1 Service Endpoint Configuration

| Subnet | Service Endpoints |
|--------|-------------------|
| snet-app | Microsoft.KeyVault, Microsoft.Storage |
| snet-functions | Microsoft.KeyVault, Microsoft.Storage, Microsoft.CognitiveServices |
| snet-integration | Microsoft.KeyVault, Microsoft.Storage |

---

## 6. Firewall Rules

### 6.1 Azure Cosmos DB Firewall

| Setting | Configuration |
|---------|---------------|
| Public Network Access | Disabled |
| IP Rules | None (private endpoint only) |
| VNet Rules | snet-functions, snet-app |
| Allow Azure Services | Disabled |

### 6.2 Azure AI Search Firewall

| Setting | Configuration |
|---------|---------------|
| Public Network Access | Disabled |
| IP Rules | None (private endpoint only) |
| Allowed VNets | vnet-clp-kb-prod |

### 6.3 Azure OpenAI Firewall

| Setting | Configuration |
|---------|---------------|
| Public Network Access | Disabled |
| IP Rules | None (private endpoint only) |
| VNet Rules | snet-functions |

### 6.4 Storage Account Firewall

| Setting | Configuration |
|---------|---------------|
| Public Network Access | Disabled |
| Trusted Services | Azure Functions, Logic Apps |
| VNet Rules | snet-functions, snet-app |

---

## 7. Application Gateway / Front Door (Optional)

### 7.1 Azure Front Door Configuration (Recommended for Production)

| Setting | Value |
|---------|-------|
| Tier | Standard |
| WAF Policy | Enabled |
| Origin | App Service |
| Caching | Disabled (dynamic content) |

### 7.2 WAF Rules

| Rule Set | Mode |
|----------|------|
| OWASP 3.2 | Prevention |
| Microsoft Bot Protection | Detection |
| Rate Limiting | 1000 req/min per IP |

### 7.3 Custom Rules

| Rule | Condition | Action |
|------|-----------|--------|
| BlockBadBots | User-Agent contains malicious patterns | Block |
| GeoFilter | Source not in allowed countries | Block |
| RateLimit | Requests > 100/min | Rate limit |

---

## 8. VNet Integration

### 8.1 App Service VNet Integration

| Setting | Value |
|---------|-------|
| Delegation | snet-integration |
| Route All | Enabled |
| DNS Settings | Azure Private DNS |

### 8.2 Azure Functions VNet Integration

| Setting | Value |
|---------|-------|
| Delegation | snet-functions |
| Route All | Enabled |
| WEBSITE_VNET_ROUTE_ALL | 1 |

---

## 9. Connectivity Patterns

### 9.1 Inbound Traffic Flow

```
Internet
    |
    v
[Azure Front Door / WAF]
    |
    v
[App Service (snet-app)]
    |
    v
[VNet Integration (snet-integration)]
    |
    v
[Private Endpoints (snet-private-endpoints)]
    |
    +---> Cosmos DB
    +---> AI Search
    +---> Azure OpenAI
```

### 9.2 Processing Traffic Flow

```
[SharePoint]
    |
    v (HTTPS/Graph API)
[Logic Apps]
    |
    v (Queue message)
[Azure Functions (snet-functions)]
    |
    v (Private Endpoint)
[Azure Speech Services]
    |
    v (Private Endpoint)
[Azure OpenAI - Embeddings]
    |
    v (Private Endpoint)
[AI Search - Indexing]
    |
    v (Private Endpoint)
[Cosmos DB - Metadata]
```

---

## 10. Security Monitoring

### 10.1 NSG Flow Logs

| Setting | Value |
|---------|-------|
| Enabled | Yes |
| Version | 2 |
| Retention | 30 days |
| Storage Account | stclpkblogs |
| Traffic Analytics | Enabled |

### 10.2 Network Watcher

| Capability | Status |
|------------|--------|
| Connection Monitor | Enabled |
| Packet Capture | On-demand |
| IP Flow Verify | Available |
| Next Hop | Available |

### 10.3 Alerts

| Alert | Condition | Severity |
|-------|-----------|----------|
| NSG Rule Hit | DenyAllInbound triggered > 100/hour | Warning |
| High Latency | P95 latency > 500ms | Warning |
| Connection Failure | Private endpoint unreachable | Critical |

---

## 11. Terraform Resources

### 11.1 Resource Dependencies

```
azurerm_virtual_network
    |
    +-- azurerm_subnet (4x)
        |
        +-- azurerm_network_security_group (3x)
            |
            +-- azurerm_subnet_network_security_group_association
        |
        +-- azurerm_private_endpoint (5x)
            |
            +-- azurerm_private_dns_zone (5x)
                |
                +-- azurerm_private_dns_zone_virtual_network_link
```

### 11.2 Naming Convention

| Resource Type | Pattern | Example |
|---------------|---------|---------|
| Virtual Network | vnet-{project}-{env} | vnet-clp-kb-prod |
| Subnet | snet-{purpose} | snet-app |
| NSG | nsg-snet-{subnet} | nsg-snet-app |
| Private Endpoint | pe-{service}-{project} | pe-cosmos-clp-kb |
| Private DNS Zone | privatelink.{service}.{domain} | privatelink.documents.azure.com |

---

## Related Documents

- [Architecture Overview](../../../docs/architecture/overview.md)
- [Security & Governance](../../../docs/architecture/security-governance.md)
- [Component Specifications](component-specifications.md)
- [Operations](operations.md)
