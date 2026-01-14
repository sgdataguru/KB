# Component Specifications

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management Platform |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |

---

## 1. Azure OpenAI Service

### 1.1 Purpose
Provides embedding generation for vector search and GPT-4 for response generation with grounded answers.

### 1.2 Technology Choice
- **Service**: Azure OpenAI Service
- **Region**: East Asia (Hong Kong)
- **Tier**: Standard (S0)

### 1.3 Configuration

| Setting | Value |
|---------|-------|
| Deployment Name (Embeddings) | text-embedding-ada-002 |
| Deployment Name (Chat) | gpt-4 |
| API Version | 2024-02-15-preview |
| Content Filtering | Enabled (default) |

### 1.4 Model Deployments

| Model | TPM Quota | Use Case |
|-------|-----------|----------|
| text-embedding-ada-002 | 120K | Document/query embedding |
| gpt-4 | 40K | Response generation |

### 1.5 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| TPM (Embeddings) | 120K | 80% utilization | 240K |
| TPM (Chat) | 40K | 80% utilization | 80K |

### 1.6 Cost Estimate (Monthly)

| Component | Usage | Unit Cost | Monthly |
|-----------|-------|-----------|---------|
| Embeddings | ~500K tokens/day | $0.0001/1K | ~$15 |
| GPT-4 Input | ~200K tokens/day | $0.03/1K | ~$180 |
| GPT-4 Output | ~50K tokens/day | $0.06/1K | ~$90 |
| **Total** | | | **~$285** |

---

## 2. Azure AI Search

### 2.1 Purpose
Vector and hybrid search for knowledge retrieval with semantic ranking.

### 2.2 Technology Choice
- **Service**: Azure AI Search
- **Region**: East Asia (Hong Kong)
- **Tier**: Standard (S1)

### 2.3 Configuration

| Setting | Value |
|---------|-------|
| Replicas | 1 (increase for HA) |
| Partitions | 1 |
| Semantic Search | Enabled |
| Vector Search | HNSW algorithm |

### 2.4 Index Configuration

| Field | Type | Purpose |
|-------|------|---------|
| id | String (key) | Document identifier |
| content | String | Searchable text |
| content_vector | Vector(1536) | Embedding vector |
| sourceUrl | String | Original document URL |
| timestamp | String | Video timestamp |
| department | String | Content category |

### 2.5 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| Documents | 10K | 80% capacity | 1M |
| Queries/sec | 50 | 80% latency SLA | 200 |
| Replicas | 1 | Availability needs | 3 |

### 2.6 Cost Estimate (Monthly)

| Component | Configuration | Monthly |
|-----------|---------------|---------|
| S1 Instance | 1 replica, 1 partition | ~$250 |
| Semantic Search | Per 1000 queries | ~$5 |
| **Total** | | **~$255** |

---

## 3. Azure Cosmos DB

### 3.1 Purpose
Metadata storage for documents, chunks, and processing state.

### 3.2 Technology Choice
- **Service**: Azure Cosmos DB
- **API**: NoSQL (Core SQL)
- **Region**: East Asia (Hong Kong)
- **Consistency**: Session

### 3.3 Configuration

| Setting | Value |
|---------|-------|
| Throughput Mode | Autoscale |
| Min RU/s | 400 |
| Max RU/s | 4000 |
| Backup | Continuous (7 days) |

### 3.4 Container Design

| Container | Partition Key | Purpose |
|-----------|---------------|---------|
| documents | /sourceId | Document metadata |
| chunks | /documentId | Processed chunks |
| processing | /jobId | Processing state |

### 3.5 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| RU/s | 400 | Auto (70% util) | 4000 |
| Storage | 10 GB | Manual review | 50 GB |

### 3.6 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| Autoscale RU/s | Avg 600 RU/s | ~$45 |
| Storage | 10 GB | ~$2.50 |
| Backup | Continuous | Included |
| **Total** | | **~$48** |

---

## 4. Azure Functions

### 4.1 Purpose
Serverless compute for content processing, embedding generation, and orchestration.

### 4.2 Technology Choice
- **Service**: Azure Functions
- **Plan**: Premium (EP1)
- **Runtime**: Node.js 20.x or Python 3.11
- **Region**: East Asia (Hong Kong)

### 4.3 Configuration

| Setting | Value |
|---------|-------|
| Plan | Premium EP1 |
| vCPU | 1 |
| Memory | 3.5 GB |
| Always Ready | 1 instance |
| Max Scale | 10 instances |

### 4.4 Function Inventory

| Function | Trigger | Purpose |
|----------|---------|---------|
| ProcessVideo | Queue | Video transcription orchestration |
| ProcessDocument | Queue | Document parsing |
| GenerateEmbeddings | Queue | Batch embedding creation |
| IndexContent | Queue | AI Search indexing |
| QueryHandler | HTTP | RAG query processing |

### 4.5 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| Instances | 1 | CPU > 70% | 10 |
| Concurrent executions | 100 | Auto | 1000 |

### 4.6 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| EP1 Base | 1 instance | ~$155 |
| Executions | ~100K | ~$20 |
| Storage | 10 GB | ~$2 |
| **Total** | | **~$177** |

---

## 5. Azure Speech Services

### 5.1 Purpose
Video transcription with timestamps for training content.

### 5.2 Technology Choice
- **Service**: Azure Speech Services
- **Region**: East Asia (Hong Kong)
- **Tier**: Standard (S0)

### 5.3 Configuration

| Setting | Value |
|---------|-------|
| Speech-to-Text | Batch transcription |
| Language | en-US (primary), zh-HK (secondary) |
| Diarization | Enabled |
| Timestamps | Word-level |

### 5.4 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| Concurrent jobs | 10 | Queue depth | 100 |
| Audio hours/month | 50 | Budget review | 200 |

### 5.5 Cost Estimate (Monthly)

| Component | Usage | Unit Cost | Monthly |
|-----------|-------|-----------|---------|
| Batch STT | 50 hours | $1.00/hour | ~$50 |
| **Total** | | | **~$50** |

---

## 6. Azure Logic Apps

### 6.1 Purpose
SharePoint integration and webhook event processing.

### 6.2 Technology Choice
- **Service**: Azure Logic Apps
- **Plan**: Consumption
- **Region**: East Asia (Hong Kong)

### 6.3 Configuration

| Setting | Value |
|---------|-------|
| Plan | Consumption |
| Connectors | SharePoint, Azure Functions |
| Triggers | When file created/modified |

### 6.4 Workflow Design

| Workflow | Trigger | Actions |
|----------|---------|---------|
| NewFileProcessor | SharePoint file created | Get metadata, Queue processing |
| UpdateProcessor | SharePoint file modified | Get changes, Queue re-processing |
| DeleteHandler | SharePoint file deleted | Remove from index |

### 6.5 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| Actions | ~10K | ~$10 |
| Connectors | Standard | ~$5 |
| **Total** | | **~$15** |

---

## 7. Azure App Service

### 7.1 Purpose
Host the Next.js management console and Chat API.

### 7.2 Technology Choice
- **Service**: Azure App Service
- **Plan**: Premium v3 (P1v3)
- **Region**: East Asia (Hong Kong)

### 7.3 Configuration

| Setting | Value |
|---------|-------|
| Plan | P1v3 |
| vCPU | 2 |
| Memory | 8 GB |
| Auto-scale | 1-3 instances |
| Deployment Slots | 1 (staging) |

### 7.4 Scalability

| Metric | Initial | Scale Trigger | Max |
|--------|---------|---------------|-----|
| Instances | 1 | CPU > 70% | 3 |
| Response time | < 500ms | 95th percentile | N/A |

### 7.5 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| P1v3 | 1 instance | ~$150 |
| Staging slot | 50% usage | ~$75 |
| **Total** | | **~$225** |

---

## 8. Azure Blob Storage

### 8.1 Purpose
Raw transcript storage, backup, and archive.

### 8.2 Technology Choice
- **Service**: Azure Blob Storage
- **Account Type**: StorageV2 (GPv2)
- **Replication**: LRS
- **Region**: East Asia (Hong Kong)

### 8.3 Configuration

| Setting | Value |
|---------|-------|
| Performance | Standard |
| Access Tier | Hot (default) |
| Lifecycle Management | Enabled |
| Soft Delete | 7 days |

### 8.4 Container Structure

| Container | Access | Purpose |
|-----------|--------|---------|
| raw-transcripts | Private | Original transcription output |
| processed-content | Private | Chunked content |
| backups | Private | System backups |

### 8.5 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| Hot Storage | 50 GB | ~$1 |
| Operations | 100K | ~$0.50 |
| **Total** | | **~$2** |

---

## 9. Azure Key Vault

### 9.1 Purpose
Centralized secrets and certificate management.

### 9.2 Configuration

| Setting | Value |
|---------|-------|
| SKU | Standard |
| Soft Delete | Enabled (90 days) |
| Purge Protection | Enabled |

### 9.3 Secrets Inventory

| Secret Name | Purpose |
|-------------|---------|
| sharepoint-client-secret | Graph API auth |
| cosmos-connection-string | Database access |
| search-admin-key | Index management |
| openai-api-key | LLM access |

### 9.4 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| Operations | 10K | ~$0.30 |
| **Total** | | **~$1** |

---

## 10. Monitoring Stack

### 10.1 Azure Monitor / Application Insights

| Setting | Value |
|---------|-------|
| Workspace | Log Analytics |
| Retention | 30 days (default) |
| Sampling | Adaptive |

### 10.2 Cost Estimate (Monthly)

| Component | Usage | Monthly |
|-----------|-------|---------|
| Log Analytics | 5 GB ingestion | ~$12 |
| Application Insights | 5 GB | ~$12 |
| **Total** | | **~$24** |

---

## Total Cost Summary

| Component | Monthly Cost |
|-----------|--------------|
| Azure OpenAI | ~$285 |
| Azure AI Search | ~$255 |
| Azure Cosmos DB | ~$48 |
| Azure Functions | ~$177 |
| Azure Speech Services | ~$50 |
| Azure Logic Apps | ~$15 |
| Azure App Service | ~$225 |
| Azure Blob Storage | ~$2 |
| Azure Key Vault | ~$1 |
| Monitoring | ~$24 |
| **Total** | **~$1,082/month** |

*Note: Estimates based on expected MVP usage. Actual costs may vary based on usage patterns.*

---

## Related Documents

- [Architecture Overview](../../../docs/architecture/overview.md)
- [Network Security](network-security.md)
- [Operations](operations.md)
