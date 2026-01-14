# Technical Proposal: CLP Next-Gen Knowledge Platform
## Turning Information into Organizational Power

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management |
| Document Type | Executive Technical Proposal |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Final |
| Target Audience | Executive Leadership, Decision Makers |
| Related Documents | [Business Case](business-case.md), [Value Delivery Roadmap](value-delivery-roadmap.md), [Tech Stack](tech-stack.md) |

---

## 1. Executive Summary: The Struggle for Institutional Memory

### The Business Case (The ThinkSchool Perspective)

Let's break this down. In any major utility organization like CLP, **Knowledge is Power**. But right now, that power is leaking. You have senior engineers—your most valuable assets—holding decades of operational wisdom. They are retiring or moving on. What do they leave behind? Hours of unstructured video recordings and folders of PDF manuals on SharePoint.

For a junior engineer, this isn't "knowledge"; it is **noise**. Searching through a 2-hour video for a 30-second calibration procedure is an operational inefficiency that bleeds money and increases safety risks.

### The Power Dynamic (The Pfeffer Perspective)

To maintain influence and control in a shifting landscape, leadership must capture this "tribal knowledge" and institutionalize it. This proposal is not just about building a chatbot; it is about building an **Intelligence Engine**. By centralizing this data into a controllable, queryable AI platform, you are not just helping juniors; you are securing the organization's brain against attrition. We are moving from "passive storage" (SharePoint) to "active intelligence" (RAG).

### The Strategic Imperative

This initiative addresses three critical organizational challenges:

1. **Knowledge Attrition Risk**: Senior experts retiring with irreplaceable operational knowledge
2. **Operational Inefficiency**: Junior staff spending hours searching for 30-second answers
3. **Safety & Compliance**: Inability to quickly access critical procedures increases risk exposure

---

## 2. Technical Approach: The "Video-to-Precision" Engine

Standard RAG (Retrieval-Augmented Generation) models fail at video because they treat it as a black box. Our approach is different. We focus on **Temporal Precision**.

### Multimodal Ingestion

We don't just "watch" the video. We use **Azure Video Indexer** to extract:
- **Speech Transcription**: Full audio-to-text conversion with timestamp precision
- **OCR (Optical Character Recognition)**: Text visible on screen, diagrams, and overlays
- **Visual Cues**: Scene detection, equipment identification, and procedural steps
- **Metadata Extraction**: Speaker identification, location context, equipment type

### The "K2" Jargon Layer

Generic models fail on industry specifics. We will implement a custom dictionary injection strategy to ensure the model distinguishes between general electrical terms and CLP-specific "K2" jargon.

**Implementation Strategy**:
- Custom embedding space for CLP-specific terminology
- Domain-specific entity recognition
- Contextual disambiguation (e.g., "K2" in different operational contexts)
- Continuous jargon dictionary expansion based on query patterns

### Strict Grounding (The Guardrails)

In the utility sector, a hallucination is a safety hazard. Our architecture uses "Strict Grounding"—if the answer isn't in your SharePoint or Videos, the AI will explicitly say, *"I don't know."* It will never guess.

**Safety Mechanisms**:
- **Citation Requirement**: Every response includes source document/video reference
- **Confidence Scoring**: Low-confidence responses trigger "I don't know" behavior
- **Source Verification**: All retrieved content verified against indexed knowledge base
- **Audit Trail**: Complete logging of query, retrieval, and generation for compliance

---

## 3. Technical Flow: From Raw Data to Actionable Insight

### Step 1: Ingest (The Trigger)

A file is dropped into a watched SharePoint folder. The system automatically detects and queues the content for processing.

**Supported Content Types**:
- Video files (MP4, AVI, MOV, WMV)
- Training documents (PDF, DOCX, PPTX)
- Teams meeting recordings
- Technical manuals and procedures

### Step 2: Process (The Translator)

**For Video Content**:
- **Azure Video Indexer** breaks video into scenes
- Generates a transcript with **Time-Codes (00:14:30 - 00:15:15)**
- Extracts visual text via OCR
- Identifies speakers and equipment
- Detects procedural steps and key moments

**For Document Content**:
- **Azure AI Document Intelligence** parses structure
- Extracts text, tables, diagrams
- Maintains document hierarchy and context
- Preserves formatting and references

### Step 3: Index (The Memory)

- Text is chunked using intelligent semantic boundaries
- Embeddings generated using **Azure OpenAI (text-embedding-ada-002)**
- Metadata attached:
  - Author/Creator
  - Timestamp/Creation Date
  - Device Type/Equipment
  - Department/Category
  - Source Location (SharePoint path)
  - Video timestamps (for video content)
- Stored in **Azure AI Search** (Vector Database) with hybrid search capabilities

### Step 4: Retrieval (The Query)

User asks: *"How do I reset the turbine?"*

**The system performs**:
1. **Query Understanding**: Parse intent and extract key entities
2. **Hybrid Search**: Combines keyword matching with semantic similarity
3. **Reranking**: Azure AI Search Semantic Ranker orders results by relevance
4. **Context Assembly**: Retrieves top-k most relevant chunks with full metadata

### Step 5: Generation (The Power Move)

- **LLM (GPT-4o)** synthesizes the answer from retrieved context
- **Grounding Enforcement**: Response limited to provided context only
- **Citation Generation**: Automatic linking to source documents/videos

**Crucial Output**: *"Reset the turbine by pressing the red latch. Watch the demonstration here at [14:30]."*

The response includes:
- Direct answer to the question
- Step-by-step procedure (if applicable)
- Video timestamp link (clickable, jumps to exact moment)
- Source document reference
- Related topics/procedures

---

## 4. High-Level Architecture (Microsoft Azure)

We leverage a serverless, scalable architecture to keep "Time-to-Market" fast and "Cost-to-Serve" low.

### Architecture Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Microsoft Teams │  │  Web Chat UI    │  │ VoltAI Market   │ │
│  │    Bot          │  │  (Next.js)      │  │   place         │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    ORCHESTRATION LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Azure AI Studio │  │ Semantic Kernel │  │  Azure Bot      │ │
│  │   Orchestrator  │  │     Logic       │  │   Service       │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    INTELLIGENCE LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Azure OpenAI    │  │ Azure AI Search │  │  Vector Index   │ │
│  │   GPT-4o        │◄─┤  (Semantic)     │◄─┤   Database      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    PROCESSING LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Azure Video     │  │ Azure Speech    │  │ Azure Document  │ │
│  │   Indexer       │  │   Services      │  │  Intelligence   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    DATA LAYER                                   │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  SharePoint     │  │ Azure Cosmos DB │  │ Azure Blob      │ │
│  │   (Source)      │  │   (Metadata)    │  │   Storage       │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    GOVERNANCE LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ Azure AI        │  │ Application     │  │ Azure Monitor   │ │
│  │   Foundry       │  │   Insights      │  │   & Alerts      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Component Descriptions

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Front-End** | User interaction | Microsoft Teams Bot, Web Chat (Next.js), VoltAI Marketplace |
| **Orchestration** | Logic management | Azure AI Studio, Semantic Kernel for workflow orchestration |
| **Intelligence** | AI capabilities | Azure OpenAI Service (GPT-4o), Azure AI Search with semantic ranker |
| **Processing** | Content transformation | Azure Video Indexer, Azure Speech Services, Azure Document Intelligence |
| **Data** | Content storage | SharePoint (source), Azure Cosmos DB (metadata), Azure Blob Storage |
| **Governance** | Monitoring & control | Azure AI Foundry (usage, costs, access), Application Insights, Azure Monitor |

### Regional Deployment

- **Primary Region**: Azure Hong Kong (East Asia) - Data residency compliance
- **Disaster Recovery**: Azure Southeast Asia (secondary region)
- **Latency**: <100ms for 95th percentile queries
- **Availability**: 99.9% SLA with automated failover

---

## 5. Roadmap: The Evolution of Influence

We propose a **"Land and Expand"** strategy. We start by solving the immediate pain (Search) and then scale to transform the learning culture (Avatars).

### Phase 1: The "Intelligence Desk" (MVP - Early February 2026)

**Goal**: Stop the bleeding. Enable juniors to find answers instantly.

**Timeline**: 6 weeks (Weeks 1-6)

**Scope**:
- SharePoint Connector + Video Indexer + Basic Chatbot
- 100% of approved training videos transcribed and indexed
- Natural language query interface via VoltAI Marketplace
- Video timestamp navigation
- Document source citations
- CLP-specific jargon handling (initial "K2" dictionary)

**Outcome**: A deployed bot that answers questions with timestamped video links.

**Success Metrics**:
- Query response time: <3 seconds
- Timestamp accuracy: ±10 seconds
- Citation accuracy: >90%
- User query resolution: >80% answered without escalation

**Deliverables**:
1. Data ingestion pipeline (SharePoint → Azure)
2. Video transcription with timestamps
3. Document parsing and indexing
4. RAG chatbot API
5. VoltAI Marketplace integration
6. Basic monitoring and alerting
7. User documentation and training materials

### Phase 2: The "Learning Empire" (Future State - Weeks 7-24)

**Goal**: Active Knowledge Transfer and Enterprise-Scale Intelligence

#### Phase 2A: Content Expansion & Management (Weeks 7-12)

**Features**:
- **Management Console**: Next.js admin dashboard for content governance
- **Multi-department Content**: Expand to HR, Legal, and additional Technical domains
- **Query Analytics**: Dashboard showing popular questions, knowledge gaps, and user patterns
- **Feedback Loop**: User satisfaction ratings and continuous improvement
- **Enhanced Jargon**: Expanded "K2" dictionary based on Phase 1 learnings

#### Phase 2B: Multi-Agent System (Weeks 13-18)

**Features**:
- **Specialized Agents**: Department-specific agents for HR, Legal, and Engineering
  - HR Agent: Policies, benefits, onboarding procedures
  - Legal Agent: Compliance, contracts, regulatory requirements
  - Technical Agent: Equipment, procedures, troubleshooting
- **Azure AI Foundry Orchestration**: Intelligent routing to appropriate agent
- **Agent Governance**: Model behavior monitoring and usage analytics

#### Phase 2C: AI Avatar & Advanced Capabilities (Weeks 19-24)

**Features**:
- **AI Avatars**: Use Text-to-Speech Avatars to "present" the manuals, giving a human face to the AI
  - Senior expert digital twins (with consent)
  - Personalized training delivery
  - Interactive classroom presentations
- **Auto-Documentation**: The AI watches the video and *writes* the step-by-step PDF manual for you
- **Short Video Generation**: Automatically create focused video clips from longer training sessions
- **Viva Learning Integration**: Embed chatbot and avatar into Microsoft learning platform

---

## 6. Delivery Approach

We utilize an **Agile/Hybrid** delivery model. In a power-dynamic environment, "black box" development kills trust. We operate with high transparency.

### Methodology

**Framework**: Agile Scrum with 2-week sprints

**Sprint Cadence**:
- **Sprint Planning**: Monday (Week Start) - 2 hours
- **Daily Stand-ups**: 15 minutes (async via Teams for distributed team)
- **Sprint Review**: Friday (Week End) - 1 hour with stakeholders
- **Sprint Retrospective**: Friday (Week End) - 30 minutes (team only)

### Transparency & Stakeholder Engagement

**Show & Tell Every Friday**:
- Live demo of current build to stakeholders
- Builds political capital for project sponsors by showing constant progress
- Opportunity for early feedback and course correction
- Reduces risk of end-stage surprises

**Governance Board (Bi-weekly)**:
- Review "Knowledge Gaps" (questions the bot failed to answer)
- Prioritize new content uploads
- Assess user adoption metrics
- Adjust roadmap based on business priorities

### Quality Assurance

**Continuous Testing**:
- Automated unit tests (>80% code coverage)
- Integration tests for all Azure service interactions
- End-to-end tests for critical user journeys
- Security scanning (Bandit, Azure Security Center)
- Performance testing (load, stress, scalability)

**User Acceptance Testing (UAT)**:
- Pilot user group (10-15 junior staff) for Phase 1
- Weekly feedback sessions
- Bug triage and prioritization
- Feature refinement based on real usage

### Risk Mitigation

| Risk | Mitigation Strategy |
|------|---------------------|
| **Data Quality** | Pilot with curated, high-quality content; iterative expansion |
| **User Adoption** | Early stakeholder involvement; comprehensive training program |
| **Azure Cost Overruns** | Real-time cost monitoring; budget alerts; optimization recommendations |
| **Technical Complexity** | Experienced team; proven architecture patterns; Microsoft partnership |
| **Security & Compliance** | Azure Hong Kong region; RBAC; audit logging; regular security reviews |

---

## 7. Team Composition & Commercials

To execute a project of this strategic importance, you cannot rely on generalists. You need a **Special Forces** unit. We provide top-tier talent focused on execution and delivery.

### Core Team Structure

| Role | Responsibility | Daily Rate (USD) | Phase 1 Duration | Total (Phase 1) |
|------|---------------|------------------|------------------|-----------------|
| **Program Manager / Solution Architect** | **The Strategist.** Owns the architecture, stakeholder management, and technical alignment. Ensures the "Power Dynamic" remains in CLP's favor. Leads architecture decisions, risk management, and executive communication. | **$1,450.00** | 6 weeks (30 days) | **$43,500.00** |
| **Data Scientist (GenAI Level 2)** | **The Builder.** Specializes in Vector/Hybrid search tuning, Prompt Engineering, and "K2" jargon training. Implements RAG pipeline, embedding strategies, and model fine-tuning. | **$1,300.00** | 6 weeks (30 days) | **$39,000.00** |

**Phase 1 Labor Total**: **$82,500.00**

### Extended Team (As Needed)

| Role | Daily Rate (USD) | Phase 2/3 Applicability |
|------|------------------|------------------------|
| Senior Backend Engineer | $1,200.00 | Phase 2A (Management Console API) |
| Senior Frontend Engineer (Next.js) | $1,100.00 | Phase 2A (Management Console UI) |
| DevOps Engineer (Azure) | $1,050.00 | All Phases (Infrastructure, CI/CD) |
| QA Engineer (Test Automation) | $950.00 | All Phases (Quality Assurance) |
| Technical Writer | $850.00 | All Phases (Documentation) |

### Azure Infrastructure Costs (Estimated Year 1)

**Phase 1 (MVP) - Monthly Costs**:

| Service | Tier/SKU | Estimated Monthly Cost |
|---------|----------|------------------------|
| Azure OpenAI Service | GPT-4o (60K TPM), Ada-002 embeddings | $3,500 - $5,000 |
| Azure AI Search | Standard S1 (25GB, 1 replica) | $250 - $350 |
| Azure Video Indexer | Standard (20 hours/month) | $400 - $600 |
| Azure Speech Services | Standard (transcription) | $200 - $300 |
| Azure Cosmos DB | Serverless (metadata) | $100 - $200 |
| Azure App Service | S2 (2 cores, 3.5GB RAM) | $150 - $200 |
| Azure Blob Storage | Hot tier (500GB) | $50 - $100 |
| Application Insights | Standard | $100 - $150 |
| Azure Monitor | Logs + Metrics | $50 - $100 |

**Phase 1 Monthly Azure Total**: **$4,800 - $7,000**  
**Phase 1 Annual Azure Total (prorated)**: **~$35,000 - $50,000** (assuming 6-month ramp-up)

**Full Year 1 Azure Total (including Phase 2 scale-up)**: **$60,000 - $90,000**

### Total Cost Breakdown (Phase 1)

| Category | Cost Range |
|----------|------------|
| **Labor (6 weeks)** | $82,500 |
| **Azure Infrastructure (6 months, prorated)** | $35,000 - $50,000 |
| **Contingency (10%)** | $11,750 - $13,250 |
| **Total Phase 1** | **$129,250 - $145,750** |

### Funding Strategy

**Microsoft Partner Funding Opportunities**:
By calculating the projected **Azure Consumption Plan (ACP)** for Year 1 ($60K-$90K), we can structure this engagement to leverage Microsoft partner funding buckets, potentially offsetting initial infrastructure costs.

**Recommended Approach**:
1. Structure as Azure consumption commitment
2. Leverage Microsoft AI Cloud Partner Program incentives
3. Apply for Azure Innovate Program funding (if eligible)
4. Position as Microsoft Copilot Stack reference architecture

**Potential Cost Savings**:
- Up to 25% reduction in Year 1 Azure costs through partner funding
- Possible co-marketing opportunities with Microsoft
- Priority support and architecture review from Microsoft AI specialists

---

## 8. Success Criteria & Metrics

### Phase 1 MVP Success Criteria

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| **Time to Answer** | <30 seconds (vs. hours previously) | Query latency tracking |
| **Answer Accuracy** | >90% correct answers | User feedback + manual validation |
| **Timestamp Precision** | ±10 seconds | Video navigation testing |
| **Citation Coverage** | 100% responses include source | Automated validation |
| **User Adoption** | 80% of pilot users active weekly | Usage analytics |
| **Knowledge Coverage** | 100% approved training videos indexed | Content inventory |
| **System Reliability** | 99.5% uptime | Azure Monitor |
| **Query Response Time** | <3 seconds (95th percentile) | Application Insights |

### Business Impact Metrics (6-Month Post-Launch)

| Impact Area | Baseline | Target | Expected ROI |
|-------------|----------|--------|--------------|
| **Junior Staff Onboarding Time** | 12 weeks | 8 weeks | 33% reduction |
| **Senior Expert Time on Repetitive Questions** | 10 hrs/week | 3 hrs/week | 70% reduction |
| **Training Content Utilization** | 20% (videos rarely watched) | 85% (AI-mediated access) | 325% increase |
| **Knowledge Retention** | High risk (retirement) | Institutionalized | Risk eliminated |
| **Safety Incident Response Time** | 15 minutes (average) | 5 minutes | 67% reduction |

---

## 9. Risk Assessment & Mitigation

### Critical Risks

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| **Inaccurate Transcriptions** | Medium | High | Multi-pass verification; manual review for critical procedures; audio quality requirements |
| **Insufficient Training Data** | Medium | High | Prioritize high-quality content curation; expand gradually; supplement with SME reviews |
| **User Resistance** | Low | Medium | Early stakeholder involvement; comprehensive training; demonstrate quick wins |
| **Azure Cost Overruns** | Medium | Medium | Real-time monitoring; budget alerts; cost optimization reviews; reserved capacity planning |
| **Security/Compliance** | Low | High | Hong Kong data residency; RBAC; audit logging; regular security assessments |
| **SharePoint Integration Issues** | Low | Medium | Early POC; Microsoft support engagement; fallback data ingestion methods |
| **"K2" Jargon Handling** | Medium | Medium | Iterative dictionary expansion; SME validation; continuous learning from queries |

---

## 10. Next Steps & Call to Action

### Immediate Actions (This Week)

1. **Budget Approval**: Review and approve Phase 1 budget ($130K-$146K)
2. **Stakeholder Alignment**: Confirm executive sponsors and governance board members
3. **Resource Commitment**: Identify CLP point of contacts for:
   - IT (Azure subscription, SharePoint access)
   - Training (content curation, SME availability)
   - HR (change management, user adoption)
4. **Kickoff Planning**: Schedule project kickoff for Week 1 (target: next Monday)

### Week 1 Activities

1. Azure environment provisioning
2. SharePoint API access setup
3. Sample content identification (10-15 training videos for pilot)
4. Team onboarding and architecture review
5. Sprint 1 planning

### Decision Points

**This proposal requires approval on**:
1. ✅ / ❌ **Budget**: $130K-$146K for Phase 1 (6 weeks)
2. ✅ / ❌ **Timeline**: Target launch Early February 2026
3. ✅ / ❌ **Resource Commitment**: CLP SME availability (4-6 hours/week)
4. ✅ / ❌ **Scope**: Phase 1 MVP as defined (defer Phase 2 to post-launch)

---

## 11. Appendices

### A. Glossary

| Term | Definition |
|------|------------|
| **RAG** | Retrieval-Augmented Generation - AI architecture that grounds responses in retrieved documents |
| **Vector Database** | Database optimized for semantic similarity search using embeddings |
| **Embedding** | Numerical representation of text that captures semantic meaning |
| **Grounding** | Constraining AI responses to only use provided context (no hallucinations) |
| **TPM** | Tokens Per Minute - Azure OpenAI throughput measurement |
| **K2** | CLP-specific operational terminology requiring custom handling |
| **Semantic Ranker** | Azure AI Search feature that re-ranks results using deep learning |

### B. References

- [Azure AI Foundry Documentation](https://learn.microsoft.com/azure/ai-studio/)
- [Azure OpenAI RAG Patterns](https://learn.microsoft.com/azure/ai-services/openai/concepts/retrieval-augmented-generation)
- [Azure Video Indexer](https://learn.microsoft.com/azure/azure-video-indexer/)
- [Azure AI Search Vector Search](https://learn.microsoft.com/azure/search/vector-search-overview)
- [Semantic Kernel](https://learn.microsoft.com/semantic-kernel/)

### C. Related Documentation

- [Business Case](business-case.md) - Detailed business requirements and value proposition
- [Value Delivery Roadmap](value-delivery-roadmap.md) - Detailed sprint-by-sprint timeline
- [Tech Stack](tech-stack.md) - Comprehensive technical architecture
- [Data Platform Strategy](data-platform-strategy.md) - Strategic foundation and principles
- [Risk & Constraint Register](risk-constraint-register.md) - Detailed risk management plan

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | January 14, 2026 | Program Manager | Initial executive proposal |

---

**Prepared for**: CLP Holdings Limited, Hong Kong  
**Prepared by**: CLP Digital Transformation Team  
**Proposal Valid Until**: January 31, 2026  
**Contact**: [Contact details placeholder]

---

*This proposal outlines not just a software installation, but a strategic upgrade to CLP's organizational capability. We are ready to transform CLP's institutional knowledge from a liability into a competitive advantage.*
