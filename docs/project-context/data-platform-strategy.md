# Data Platform Strategy

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |
| Related Documents | [Value Delivery Roadmap](value-delivery-roadmap.md), [Risk & Constraint Register](risk-constraint-register.md) |

---

## 1. Executive Summary

### Business Context

CLP faces an urgent knowledge transfer crisis as senior experts retire, taking decades of institutional knowledge with them. Currently, critical knowledge is scattered across SharePoint—buried in hour-long training videos and disparate documents—making it nearly impossible for junior staff to quickly find answers. This knowledge fragmentation slows onboarding, increases dependency on senior staff, and creates significant operational risk.

### Strategic Vision

We will deploy an **AI-powered Knowledge Management platform** using a Retrieval Augmented Generation (RAG) architecture that transforms CLP's existing video and document assets into an intelligent, searchable knowledge base. The platform will enable junior staff to ask natural language questions and receive precise answers with citations pointing to exact video timestamps (e.g., "Go to this video at 30:15"). This approach maximizes the value of existing content investments while providing a scalable foundation for future AI capabilities including multi-agent systems and AI avatars.

### Expected Outcomes

| Outcome | Target Metric |
|---------|---------------|
| Faster Knowledge Access | 90% reduction in time to find answers (hours → seconds) |
| Senior Expert Time Savings | 50% reduction in repetitive question answering |
| Onboarding Efficiency | 40% reduction in new employee ramp-up time |
| Response Accuracy | 95%+ citation accuracy with source references |
| User Adoption | 80% of target users actively using platform within 3 months |

### Strategic Bets

1. **RAG over Fine-tuning**: We bet that a RAG architecture will provide better traceability, updatability, and control than fine-tuned models—enabling instant content updates without expensive retraining.

2. **Video Timestamp Precision**: We bet that precise video navigation (jumping to exact timestamps) will dramatically increase user adoption compared to generic document search.

3. **Grounded AI Only**: We bet that restricting the LLM to only answer from approved knowledge (no external data, no hallucinations) will build trust faster than a more capable but less predictable system.

---

## 2. Business Requirements & Strategic Response

### REQ-001: Establish Single Source of Truth for Institutional Knowledge

**Strategic Approach**: Centralize all training videos, documents, and tacit knowledge into a unified knowledge repository using Azure AI Search as the vector store with rich metadata including source location, timestamps, and content classification. All content discovery will flow through this single index.

**Key Capabilities**:
- SharePoint integration for real-time content synchronization
- Video transcription with timestamp preservation
- Document parsing (PDF, Word, PowerPoint)
- Semantic search across all content types

**Success Criteria**:
- 100% of approved training content indexed and searchable
- Single query can search across videos AND documents
- <5 minute latency for new content to become searchable

**Dependencies**: SharePoint access configuration (REQ-002), Video processing pipeline (REQ-003)

**Strategic Rationale**: A centralized knowledge index using vector search was chosen over traditional keyword search because (1) semantic search understands intent and handles industry jargon like "K2" naturally, (2) vector embeddings enable cross-content-type search, and (3) this foundation supports future multi-agent capabilities without re-architecture.

---

### REQ-002: Enable Natural Language Knowledge Discovery

**Strategic Approach**: Deploy an AI chatbot powered by Azure OpenAI that allows users to ask questions in plain English and receive contextually relevant answers. The chatbot will be grounded exclusively on indexed content—never generating responses from general training data.

**Key Capabilities**:
- Natural language query interface
- Conversational context retention
- Industry-specific jargon understanding
- Multi-turn conversation support

**Success Criteria**:
- Users can ask questions in natural language without special syntax
- 90%+ of queries return relevant results on first attempt
- Support for CLP-specific terminology and abbreviations

**Dependencies**: Knowledge index (REQ-001), Azure OpenAI deployment

**Strategic Rationale**: Azure OpenAI was selected over open-source alternatives because (1) enterprise-grade security with data remaining in Azure tenant, (2) seamless integration with Azure AI Search for RAG patterns, and (3) Microsoft's responsible AI commitments align with CLP's governance requirements.

---

### REQ-003: Provide Precise Video Navigation with Timestamp Citations

**Strategic Approach**: Transform long training videos into searchable, timestamped content by processing audio through Azure Speech Services, chunking transcripts with preserved timestamp metadata, and enabling the chatbot to cite specific video moments.

**Key Capabilities**:
- Audio-to-text transcription with word-level timestamps
- Intelligent chunking that preserves context and timestamp boundaries
- "Jump to timestamp" deep links in chatbot responses
- Speaker diarization for multi-speaker content

**Success Criteria**:
- Answers include specific video timestamps (e.g., "See video X at 30:15")
- Users can jump directly to relevant video segment
- Timestamp accuracy within 5 seconds of relevant content

**Dependencies**: SharePoint video access, Azure Speech Services configuration

**Strategic Rationale**: Video timestamp precision is a key differentiator that addresses the core user frustration of scrubbing through hour-long videos. This capability requires investment in speech services but provides immediate, measurable value.

---

### REQ-004: Ensure Response Accuracy with Source Traceability

**Strategic Approach**: Implement a strict grounding policy where the LLM can ONLY generate responses based on retrieved content. Every response must include citations linking to source documents or video timestamps, with confidence scoring to indicate retrieval quality.

**Key Capabilities**:
- Citation generation with source links
- Confidence scoring for responses
- "I don't know" responses when content not found
- Retrieval transparency (show which sources informed the answer)

**Success Criteria**:
- 100% of responses include at least one citation
- Zero responses generated from external/hallucinated content
- Users can verify any answer by clicking source link

**Dependencies**: Vector search quality (REQ-001), Prompt engineering for grounding

**Strategic Rationale**: Strict grounding with citations was chosen over more flexible generation because (1) trust is paramount for knowledge platforms, (2) legal and HR content requires verifiable accuracy, and (3) citation traceability supports audit requirements.

---

### REQ-005: Support Multi-Department Knowledge Domains

**Strategic Approach**: Architect the platform to support content segregation and role-based access from the beginning, even if Phase 1 launches with a single unified agent. This enables Phase 2 multi-agent deployment (HR, Legal, Technical) without re-architecture.

**Key Capabilities**:
- Content tagging by department/domain
- Role-based access control at content level
- Domain-specific metadata schemas
- Agent routing infrastructure (Phase 2)

**Success Criteria**:
- Content can be tagged and filtered by department
- Access controls respect organizational boundaries
- Architecture supports future department-specific agents

**Dependencies**: Organizational taxonomy definition, RBAC integration

**Strategic Rationale**: Building multi-tenant architecture from the start requires modest additional investment but avoids expensive re-architecture when Phase 2 multi-agent requirements emerge.

---

### REQ-006: Enable Real-Time Content Synchronization

**Strategic Approach**: Implement event-driven synchronization between SharePoint and the knowledge index using Azure Logic Apps or SharePoint webhooks. New or updated content should be processed and available for search within minutes.

**Key Capabilities**:
- SharePoint change detection and event triggering
- Incremental processing for updates
- Full reprocessing capability for corrections
- Sync status monitoring and alerting

**Success Criteria**:
- New content searchable within 15 minutes of SharePoint upload
- Updated content reflects changes within 15 minutes
- Deleted content removed from index within 15 minutes

**Dependencies**: SharePoint API access, Logic Apps or Function Apps for orchestration

**Strategic Rationale**: Real-time sync was prioritized over batch processing because (1) knowledge platforms require currency to maintain trust, (2) event-driven processing is more cost-effective than polling, and (3) this supports the "living knowledge base" vision.

---

### REQ-007: Provide Administrative Visibility and Control

**Strategic Approach**: Build a management console that provides administrators visibility into indexed content, query patterns, and system health. Enable content governance actions like flagging, retiring, or promoting content.

**Key Capabilities**:
- Content inventory dashboard
- Query analytics and popular topics
- Content lifecycle management
- User activity reporting

**Success Criteria**:
- Administrators can view all indexed content and status
- Usage patterns visible for capacity planning
- Content can be managed without developer intervention

**Dependencies**: Application hosting, Analytics infrastructure

**Strategic Rationale**: Administrative capabilities are essential for enterprise adoption and ongoing governance. Building these from Phase 1 ensures the platform can scale responsibly.

---

## 3. Data Platform Strategy

### 3.1 Data Architecture Pattern: Medallion Architecture

We will implement a **Medallion (Bronze-Silver-Gold) architecture** adapted for knowledge management:

| Layer | Purpose | Content State |
|-------|---------|---------------|
| **Bronze** | Raw ingestion | Original videos, documents, transcripts as-is |
| **Silver** | Processed & enriched | Chunked content, embeddings, extracted metadata |
| **Gold** | Consumption-ready | Vector index, semantic relationships, citations |

**Rationale**: The medallion pattern provides clear separation between raw source data (preserving the original) and progressively refined data. This enables reprocessing when algorithms improve without losing source fidelity.

### 3.2 Data Storage Strategy

| Data Type | Storage Service | Tier | Retention |
|-----------|-----------------|------|-----------|
| Source videos | SharePoint (existing) | Hot | Per CLP policy |
| Source documents | SharePoint (existing) | Hot | Per CLP policy |
| Raw transcripts | Azure Blob Storage | Cool | 7-10 years |
| Document chunks | Azure Cosmos DB | Hot | Active lifecycle |
| Vector embeddings | Azure AI Search | Hot | Active lifecycle |
| Query logs | Log Analytics | Warm→Cold | 2 years |
| Metadata | Azure Cosmos DB | Hot | Active lifecycle |

**Rationale**: Leverage existing SharePoint investment as source of truth. Azure Blob provides cost-effective storage for transcripts. Cosmos DB offers serverless, globally distributed metadata storage. AI Search provides enterprise-grade vector capabilities.

### 3.3 Data Integration Approach

**Primary Pattern**: Event-driven ELT (Extract-Load-Transform)

```
SharePoint ──webhook──▶ Logic App ──▶ Azure Function ──▶ Processing Pipeline
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │ Bronze Layer  │ (Raw Storage)
                                    └───────┬───────┘
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │ Silver Layer  │ (Processing)
                                    │ - Transcribe  │
                                    │ - Chunk       │
                                    │ - Embed       │
                                    └───────┬───────┘
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │ Gold Layer    │ (AI Search Index)
                                    └───────────────┘
```

**Key Principles**:
- **Idempotent processing**: Re-running the same content produces identical results
- **Event-driven**: Process on change, not on schedule (except for full reconciliation)
- **Incremental updates**: Only process what changed
- **Reprocessable**: Can rebuild entire index from Bronze layer if needed

### 3.4 Data Modeling Approach

**Document Metadata Schema**:
```json
{
  "id": "unique-document-id",
  "sourceType": "video | document",
  "sourceUrl": "sharepoint-url",
  "title": "Document Title",
  "department": "HR | Legal | Technical | General",
  "createdDate": "2026-01-14T00:00:00Z",
  "modifiedDate": "2026-01-14T00:00:00Z",
  "contentHash": "sha256-hash",
  "processingStatus": "pending | processing | completed | failed",
  "chunks": [
    {
      "chunkId": "chunk-001",
      "startTimestamp": "00:30:15",
      "endTimestamp": "00:32:45",
      "text": "chunk content",
      "embedding": [0.1, 0.2, ...],
      "speakers": ["John Doe"]
    }
  ]
}
```

**Rationale**: A document-centric model with embedded chunks supports both document-level queries and precise timestamp retrieval. The schema preserves source traceability while enabling efficient vector search.

### 3.5 Data Quality Strategy

| Quality Dimension | Approach | Validation Point |
|-------------------|----------|------------------|
| **Completeness** | Reconcile index against SharePoint inventory | Daily batch job |
| **Accuracy** | Transcription confidence scores, spell-check | Processing pipeline |
| **Consistency** | Canonical department/category taxonomy | Ingestion validation |
| **Timeliness** | SLA monitoring for sync latency | Real-time alerting |
| **Validity** | Schema validation for all metadata | Ingestion pipeline |

**Quality Gates**:
- Transcription confidence < 70% → Flag for human review
- Missing required metadata → Block from Gold layer
- Processing errors → Retry with exponential backoff, then alert

### 3.6 Data Lineage & Observability

**Lineage Tracking**:
- Every chunk links to source document and timestamp
- Processing pipeline logs transformation steps
- Vector embeddings tagged with model version

**Observability Stack**:
- Azure Application Insights for end-to-end tracing
- Log Analytics for centralized logging
- Custom dashboards for:
  - Ingestion pipeline health
  - Query latency and success rates
  - Content coverage metrics
  - Embedding model performance

### 3.7 Security & Governance Approach

**Data Classification**:
- All content inherits SharePoint classification
- Additional AI-assisted classification for sensitive content
- Department-level access boundaries

**Access Control**:
- Azure AD integration for authentication
- Role-based access control (RBAC) at content level
- Query auditing for compliance

**Data Protection**:
- Encryption at rest (Azure managed keys)
- Encryption in transit (TLS 1.3)
- No data egress outside Azure Hong Kong region
- No training on customer data

---

## 4. Technology Approach

### 4.1 Cloud Platform Rationale

**Microsoft Azure** was selected as the cloud platform because:

1. **Existing Investment**: CLP uses Microsoft 365 and SharePoint, enabling seamless integration
2. **Data Residency**: Azure Hong Kong region meets local regulatory requirements
3. **AI Services**: Azure OpenAI provides enterprise-grade LLM with data privacy guarantees
4. **Enterprise Security**: Azure AD, RBAC, and compliance certifications align with CLP requirements
5. **Unified Stack**: Single vendor reduces integration complexity and support overhead

### 4.2 Core Platform Capabilities

| Capability | Azure Service | Justification |
|------------|---------------|---------------|
| **LLM Processing** | Azure OpenAI (GPT-4) | Enterprise data privacy, RAG integration |
| **Vector Search** | Azure AI Search | Native vector support, hybrid search, enterprise scale |
| **Embeddings** | Azure OpenAI (ada-002) | Consistent embedding model, high quality |
| **Speech-to-Text** | Azure Speech Services | Accurate transcription, timestamp support |
| **Metadata Store** | Azure Cosmos DB | Serverless, globally distributed, flexible schema |
| **Blob Storage** | Azure Blob Storage | Cost-effective, tiered storage |
| **Orchestration** | Azure Functions | Serverless, event-driven, cost-effective |
| **Integration** | Azure Logic Apps | SharePoint connector, low-code integration |
| **Observability** | Application Insights + Log Analytics | Full-stack observability |
| **Hosting** | Azure App Service | Managed web hosting, easy scaling |

### 4.3 Integration Patterns

**SharePoint → Knowledge Platform**:
- Event-driven using SharePoint webhooks
- Logic Apps for orchestration and retry logic
- Azure Functions for processing logic

**User → Chatbot**:
- REST API for chat interface
- WebSocket for real-time responses (optional)
- VoltAI Marketplace as primary experience layer

**Admin → Management Console**:
- Next.js application on Azure App Service
- Direct API access to metadata and analytics

### 4.4 Analytics & Reporting Approach

**Query Analytics**:
- Track popular questions and topics
- Identify content gaps (queries with poor results)
- Monitor user satisfaction signals

**Content Analytics**:
- Track content usage and citations
- Identify stale or unused content
- Measure content coverage by department

**Operational Analytics**:
- Processing pipeline health metrics
- Query latency and throughput
- Error rates and patterns

### 4.5 Infrastructure as Code

**Terraform** will be used for all infrastructure provisioning:
- Version-controlled infrastructure definitions
- Environment parity (dev, staging, prod)
- Repeatable deployments
- Drift detection and correction

**Azure DevOps** for CI/CD:
- Multi-stage pipelines (build, test, deploy)
- Infrastructure deployment stages
- Environment-specific configurations
- Approval gates for production

---

## 5. Strategic Decision Framework

### Decision D-001: RAG vs. Fine-tuned Model

**Decision Point**: What approach should we use to enable the LLM to answer CLP-specific questions?

**Options Considered**:

| Option | Pros | Cons |
|--------|------|------|
| **RAG Architecture** | Instant content updates, full traceability, cost-effective, controllable grounding | Retrieval quality dependent on chunking/embedding, latency from search |
| **Fine-tuned Model** | Faster inference, potentially better fluency | Expensive retraining, no citations, black-box responses, training data leakage risk |
| **Hybrid (RAG + Fine-tuning)** | Best of both worlds | High complexity, expensive, overkill for current requirements |

**Recommended Strategy**: RAG Architecture

**Decision Criteria**:
- Traceability requirement (citations with sources) is non-negotiable
- Content updates frequently (new training videos added regularly)
- Cost-effectiveness for pilot/MVP phase
- Team skill alignment with RAG patterns vs. ML engineering

**Decision Timing**: Confirmed for Phase 1; revisit if query quality or latency becomes problematic

**Reversibility**: Two-way door—can evolve to hybrid approach without discarding RAG infrastructure

---

### Decision D-002: Vector Database Selection

**Decision Point**: Which vector storage solution should we use?

**Options Considered**:

| Option | Pros | Cons |
|--------|------|------|
| **Azure AI Search** | Native Azure integration, hybrid search, enterprise features, managed | Cost at scale, less control |
| **Azure Cosmos DB (vector)** | Multi-model, serverless, global distribution | Newer feature, less mature vector capabilities |
| **Pinecone/Weaviate** | Purpose-built, high performance | Additional vendor, data egress concerns |

**Recommended Strategy**: Azure AI Search

**Decision Criteria**:
- Must remain within Azure for data residency
- Enterprise features (security, scaling, monitoring) required
- Hybrid search (vector + keyword) provides better results
- Managed service reduces operational burden

**Decision Timing**: Confirmed; re-evaluate if Cosmos DB vector capabilities mature significantly

**Reversibility**: Medium—index schema and chunking strategy transferable, but migration requires effort

---

### Decision D-003: Real-time vs. Batch Content Synchronization

**Decision Point**: How should new SharePoint content be synchronized to the knowledge index?

**Options Considered**:

| Option | Pros | Cons |
|--------|------|------|
| **Real-time (Event-driven)** | Immediate availability, cost-effective at low volume | Complexity of event handling, retry logic |
| **Micro-batch (15-min)** | Simpler implementation, batching efficiency | Delay in content availability |
| **Daily Batch** | Simplest implementation, predictable costs | Unacceptable delay for knowledge platform |

**Recommended Strategy**: Real-time with daily reconciliation

**Decision Criteria**:
- Knowledge currency is critical for user trust
- Event-driven is more cost-effective than polling
- Daily reconciliation catches any missed events

**Decision Timing**: Implement event-driven from Phase 1

**Reversibility**: Two-way door—can fall back to batch if event handling proves problematic

---

### Decision D-004: Single Agent vs. Multi-Agent Architecture

**Decision Point**: Should Phase 1 deploy a single unified agent or department-specific agents?

**Options Considered**:

| Option | Pros | Cons |
|--------|------|------|
| **Single Unified Agent** | Simpler deployment, unified experience, faster to market | May struggle with domain-specific nuances |
| **Multi-Agent (HR, Legal, Tech)** | Domain expertise, better access control | Complexity, user routing decisions, higher cost |
| **Single Agent with Domain Routing** | Best of both—simple interface, domain awareness | Architecture complexity from start |

**Recommended Strategy**: Single Unified Agent (Phase 1) with architecture for future multi-agent (Phase 2)

**Decision Criteria**:
- Speed to value—single agent can launch faster
- Validate approach before adding complexity
- Content tagging and metadata support future routing

**Decision Timing**: Phase 1 single agent; multi-agent in Phase 2 based on learnings

**Reversibility**: Two-way door—architecture designed to support multi-agent evolution

---

## 6. Success Metrics & KPIs

### Platform Health Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Index Freshness | <15 min | Time from SharePoint update to searchable |
| Query Latency (P95) | <3 seconds | End-to-end response time |
| System Availability | 99.5% | Uptime during business hours |
| Processing Success Rate | >99% | Content successfully indexed |

### User Experience Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Query Success Rate | >90% | Queries returning relevant results |
| Citation Accuracy | >95% | Citations correctly link to source |
| User Satisfaction | >4.0/5.0 | Post-query feedback rating |
| Return Usage | >60% | Users returning within 7 days |

### Business Impact Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Time to Answer | 90% reduction | Baseline vs. with platform |
| Senior Expert Time Saved | 10+ hrs/week | Survey and tracking |
| Onboarding Time | 40% reduction | New hire ramp-up measurement |
| Knowledge Coverage | 80% | Queries answerable from index |

---

## Related Documents

- [Value Delivery Roadmap](value-delivery-roadmap.md) - Phasing and value delivery timeline
- [Risk & Constraint Register](risk-constraint-register.md) - Risk landscape and mitigations
- [Business Case](business-case.md) - Original business requirements
- [Tech Stack](tech-stack.md) - Technology component details
