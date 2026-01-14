# Architecture Overview

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management Platform |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |

---

## 1. Executive Summary

The CLP AI Knowledge Management Platform is a cloud-native, RAG-based (Retrieval Augmented Generation) solution designed to transform CLP's existing training videos and documents into an intelligent, searchable knowledge base. The platform enables junior staff to ask natural language questions and receive precise answers with citations pointing to exact video timestamps and document sources.

### Key Capabilities

- **Natural Language Query**: Users ask questions in plain English
- **Video Timestamp Citations**: Answers include precise video timestamps (e.g., "See video at 30:15")
- **Document Source Links**: All responses cite original sources
- **Grounded Responses Only**: LLM only answers from approved knowledge base (no hallucinations)
- **Real-time Content Sync**: New SharePoint content available within minutes

### Platform Highlights

| Aspect | Approach |
|--------|----------|
| Architecture Pattern | Medallion (Bronze-Silver-Gold) |
| Cloud Platform | Microsoft Azure (Hong Kong Region) |
| AI Engine | Azure OpenAI with RAG pattern |
| Search Technology | Azure AI Search (Vector + Hybrid) |
| Experience Layer | VoltAI Marketplace |
| Infrastructure | Terraform IaC, Azure DevOps CI/CD |

---

## 2. High-Level Logical Architecture

The platform consists of the following architectural layers:

### Layer Overview

1. **Experience Layer** - VoltAI Marketplace (Q&A Interface), Management Console (Next.js Admin)
2. **API Layer** - Chat API, Admin API (Azure App Service)
3. **Intelligence Layer** - Azure OpenAI (GPT-4), Embedding Model (text-embedding-ada-002)
4. **Search Layer** - Azure AI Search (Vector Index), Semantic Ranker
5. **Storage Layer** - Azure Cosmos DB (Metadata), Azure Blob Storage (Raw Content)
6. **Processing Layer** - Azure Functions, Azure Speech Services, Logic Apps
7. **Observability Layer** - Application Insights, Log Analytics

### Data Flow Summary

```
User Query -> VoltAI -> Chat API -> Embeddings -> AI Search -> Azure OpenAI -> Response + Citations
```

```
SharePoint -> Logic Apps -> Azure Functions -> Speech Services -> Embeddings -> AI Search Index
```

---

## 3. Major Components

### 3.1 Component Overview

| Component | Service | Purpose | Layer |
|-----------|---------|---------|-------|
| VoltAI Marketplace | External | Primary user Q&A interface | Experience |
| Management Console | Azure App Service | Admin dashboard for content management | Experience |
| Chat API | Azure App Service | REST API for chatbot interactions | API |
| Admin API | Azure App Service | REST API for administrative functions | API |
| Azure OpenAI | Azure OpenAI Service | LLM for response generation | Intelligence |
| Embedding Model | Azure OpenAI Service | Vector embeddings for semantic search | Intelligence |
| Azure AI Search | Azure AI Search | Vector index and hybrid search | Search |
| Azure Cosmos DB | Azure Cosmos DB | Document metadata and conversation state | Storage |
| Azure Blob Storage | Azure Storage | Raw transcripts and processed content | Storage |
| Azure Functions | Azure Functions | Serverless processing pipeline | Processing |
| Azure Speech Services | Cognitive Services | Video-to-text transcription | Processing |
| Logic Apps | Azure Logic Apps | SharePoint event-driven sync | Processing |
| Application Insights | Azure Monitor | End-to-end observability | Observability |

### 3.2 Integration Points

| Source | Target | Integration Method | Purpose |
|--------|--------|-------------------|---------|
| SharePoint | Logic Apps | Webhooks / Graph API | Content change detection |
| Logic Apps | Azure Functions | HTTP Trigger | Orchestrate processing |
| Azure Functions | Speech Services | REST API | Video transcription |
| Azure Functions | Azure OpenAI | REST API | Generate embeddings |
| Azure Functions | AI Search | REST API | Index content |
| Chat API | Azure OpenAI | REST API | Generate responses |
| Chat API | AI Search | REST API | Retrieve context |
| VoltAI | Chat API | REST API | User queries |
| Management Console | Admin API | REST API | Admin operations |

---

## 4. Key Design Principles

### 4.1 Architectural Principles

| Principle | Description | Implementation |
|-----------|-------------|----------------|
| Grounded AI | LLM only responds from approved knowledge | RAG pattern with strict grounding prompts |
| Source Traceability | Every answer links to original source | Citation metadata in all responses |
| Layered Refinement | Progressive data quality improvement | Medallion architecture (Bronze-Silver-Gold) |
| Event-Driven | React to changes, don't poll | SharePoint webhooks + Logic Apps |
| Idempotent Processing | Safe to reprocess any content | Hash-based change detection |
| Cloud-Native | Leverage managed services | Azure PaaS services throughout |
| Infrastructure as Code | Repeatable, version-controlled infrastructure | Terraform for all resources |

### 4.2 Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| AI Approach | RAG over Fine-tuning | Instant updates, full traceability, cost-effective |
| Vector Store | Azure AI Search | Native Azure integration, hybrid search, enterprise features |
| Processing Model | Event-driven with daily reconciliation | Balance freshness with reliability |
| Compute Model | Serverless (Functions) | Cost-effective, auto-scaling, pay-per-use |
| Data Residency | Azure Hong Kong (eastasia) | Regulatory compliance, low latency |
| Experience Layer | VoltAI Marketplace | Existing platform, faster time-to-value |

---

## 5. Architectural Layers Detail

### 5.1 Experience Layer

| Component | Technology | Users |
|-----------|------------|-------|
| VoltAI Marketplace | External Platform | Junior Staff |
| Management Console | Next.js on App Service | Administrators |

### 5.2 API Layer

| API | Endpoints | Purpose |
|-----|-----------|---------|
| Chat API | /api/chat, /api/feedback | Query processing, user feedback |
| Admin API | /api/content, /api/analytics, /api/health | Content management, reporting |

### 5.3 Intelligence Layer

| Component | Model | Purpose |
|-----------|-------|---------|
| LLM | GPT-4 (Azure OpenAI) | Response generation with grounding |
| Embeddings | text-embedding-ada-002 | Vector representations for search |
| Prompt Orchestration | Custom | Coordinate retrieval and generation |

### 5.4 Search & Retrieval Layer

| Component | Technology | Purpose |
|-----------|------------|---------|
| Vector Index | Azure AI Search | Semantic similarity search |
| Semantic Ranker | AI Search Feature | Re-rank results for relevance |
| Hybrid Search | AI Search Feature | Combine vector + keyword search |

### 5.5 Storage Layer

| Store | Technology | Data Type | Access Pattern |
|-------|------------|-----------|----------------|
| Metadata | Cosmos DB | Document metadata, chunks, state | Random read/write |
| Raw Content | Blob Storage | Transcripts, original files | Sequential write, rare read |
| Vector Index | AI Search | Embeddings, searchable content | High-frequency read |
| Logs | Log Analytics | Operational telemetry | Analytical queries |

### 5.6 Processing Layer

| Component | Technology | Purpose |
|-----------|------------|---------|
| Sync Orchestration | Logic Apps | SharePoint event handling |
| Processing Pipeline | Azure Functions | Content transformation |
| Transcription | Speech Services | Video-to-text conversion |

---

## 6. Data Architecture

### 6.1 Medallion Architecture

| Layer | Purpose | Storage | Retention |
|-------|---------|---------|-----------|
| Bronze | Preserve original source data | Blob Storage | 7-10 years |
| Silver | Processed, enriched content | Cosmos DB + Blob | Active lifecycle |
| Gold | Consumption-ready data | AI Search | Active lifecycle |

### 6.2 Content Processing Flow

1. SharePoint triggers webhook on content change
2. Logic Apps receives event and triggers Azure Function
3. Azure Function processes content:
   - For videos: Submit to Speech Services for transcription
   - For documents: Parse and extract text
4. Content is chunked with overlap for context preservation
5. Chunks are embedded via Azure OpenAI
6. Metadata stored in Cosmos DB
7. Vectors indexed in AI Search

---

## 7. Deployment Architecture

### 7.1 Azure Resource Organization

All resources are deployed within a single Resource Group per environment:

- **Resource Group**: clp-kb-{environment}
- **Region**: East Asia (Hong Kong)
- **Naming Convention**: clp-kb-{resource-type}-{environment}

### 7.2 Environment Strategy

| Environment | Purpose | Resource Sizing | Data |
|-------------|---------|-----------------|------|
| Development | Feature development and testing | Minimal (B1, Basic) | Subset of production |
| Staging | Pre-production validation | Production-like | Copy of production |
| Production | Live system | Full scale | Real data |

---

## 8. Cross-Cutting Concerns

### 8.1 Security

- **Authentication**: Azure AD for all APIs
- **Authorization**: RBAC with content-level permissions
- **Encryption**: TLS 1.3 in transit, AES-256 at rest
- **Network**: Private endpoints, VNet integration
- **Secrets**: Azure Key Vault for all credentials

### 8.2 Observability

- **Distributed Tracing**: Correlation IDs across all services
- **Structured Logging**: JSON format with consistent schema
- **Metrics**: Custom metrics for business KPIs
- **Alerting**: Azure Monitor Alerts integration

### 8.3 Resilience

- **Retry Policies**: Exponential backoff for transient failures
- **Circuit Breakers**: Prevent cascade failures
- **Dead Letter Queues**: Capture failed processing
- **Health Checks**: Liveness and readiness probes

### 8.4 Performance

- **Caching**: Response caching for frequent queries
- **Connection Pooling**: Efficient resource utilization
- **Async Processing**: Non-blocking operations
- **CDN**: Static asset delivery

---

## Related Documents

- [Data Flows](data-flows.md) - Detailed data flow diagrams
- [Security & Governance](security-governance.md) - Security architecture
- [Component Specifications](../../infra/docs/architecture/component-specifications.md) - Detailed component specs
- [Network Security](../../infra/docs/architecture/network-security.md) - Network design
- [Operations](../../infra/docs/architecture/operations.md) - Operational procedures
