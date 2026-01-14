# Value Delivery Roadmap

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |
| Related Documents | [Data Platform Strategy](data-platform-strategy.md), [Risk & Constraint Register](risk-constraint-register.md) |

---

## 1. Overview & Phasing Philosophy

### Purpose

This roadmap defines the strategic phasing and sequencing for delivering the CLP AI Knowledge Management platform. It translates the [Data Platform Strategy](data-platform-strategy.md) into an actionable timeline with clear milestones and measurable outcomes.

### Target Launch

**Phase 1 MVP**: Early February 2026

### Phasing Principles

Our phasing approach is guided by the following principles:

1. **Value First**: Deliver working functionality that solves real problems before building comprehensive infrastructure
2. **End-to-End Slices**: Each phase delivers complete user journeys, not just technical components
3. **Foundation Early**: Observability, security, and governance are built-in from Phase 1—not bolted on later
4. **Learn and Adapt**: Early phases validate assumptions and inform architectural decisions for later phases
5. **Measurable Progress**: Every phase has quantifiable success criteria that demonstrate business value

---

## 2. Strategic Phasing Approach

### Crawl-Walk-Run Model

| Stage | Focus | Business Value |
|-------|-------|----------------|
| **Crawl** (Phase 1) | Core RAG chatbot with video timestamps | Junior staff can find answers instantly |
| **Walk** (Phase 2) | Content expansion, management console, refinement | Administrators govern content, improved accuracy |
| **Run** (Phase 3) | Multi-agent, AI Avatar, advanced capabilities | Department-specific expertise, personalized training |

### Value-Complexity Prioritization

```
                    High Value
                        │
    ┌───────────────────┼───────────────────┐
    │   Phase 1 (DO)    │   Phase 2 (DO)    │
    │ • RAG Chatbot     │ • Multi-agent     │
    │ • Video Timestamps│ • AI Avatar       │
    │ • SharePoint Sync │ • Mgmt Console    │
    ├───────────────────┼───────────────────┤
    │   Phase 1 (DO)    │   Phase 3 (DEFER) │
    │ • Basic Analytics │ • Video Gen       │
    │ • Citations       │ • Viva Learning   │
    │                   │ • Advanced ML     │
    └───────────────────┴───────────────────┘
 Low Complexity ◄─────────────────────► High Complexity
```

---

## 3. Phase Definitions

### Phase 1: Foundation & Core RAG (MVP)

**Timeline**: Weeks 1-6 (Target: Early February 2026)

#### Strategic Objectives

Establish the foundational knowledge platform and prove value with a working RAG chatbot that answers questions from CLP's training videos and documents with precise video timestamp citations.

#### Key Capabilities

| Capability | Description | Priority |
|------------|-------------|----------|
| **SharePoint Integration** | Connect to SharePoint for video and document access | P0 - Critical |
| **Video Transcription** | Convert training videos to searchable transcripts | P0 - Critical |
| **Document Processing** | Parse and chunk PDF/Word documents | P0 - Critical |
| **Vector Indexing** | Embed and index content in Azure AI Search | P0 - Critical |
| **RAG Chatbot API** | Question-answering with grounded responses | P0 - Critical |
| **Citation Generation** | Include source links and video timestamps | P0 - Critical |
| **VoltAI Integration** | Expose chatbot through VoltAI Marketplace | P0 - Critical |
| **Basic Monitoring** | Application Insights, error alerting | P1 - High |

#### Deliverables

1. **Data Ingestion Pipeline**
   - SharePoint connector for videos and documents
   - Azure Speech transcription with timestamps
   - Document parsing and chunking
   - Embedding generation and indexing

2. **RAG Chatbot**
   - Natural language query interface
   - Grounded responses (no hallucinations)
   - Video timestamp citations
   - Document source links

3. **Infrastructure**
   - Azure resources deployed via Terraform
   - CI/CD pipeline (Azure DevOps)
   - Development, staging, and production environments
   - Monitoring and alerting

#### Business Value & Outcomes

| Outcome | Metric | Target |
|---------|--------|--------|
| Faster answers | Time to find information | <30 seconds (vs. hours) |
| Video precision | Timestamp accuracy | Within 10 seconds |
| Reliable responses | Citation accuracy | >90% |
| Content coverage | Training videos indexed | 100% of approved content |

#### Success Criteria

- [ ] All approved training videos transcribed and indexed
- [ ] All approved documents parsed and indexed
- [ ] Users can ask natural language questions
- [ ] Responses include video timestamps (e.g., "See video at 30:15")
- [ ] Responses include document citations
- [ ] System handles CLP-specific jargon correctly
- [ ] <3 second query response time
- [ ] Successful demo to stakeholders

#### Dependencies & Prerequisites

| Dependency | Owner | Status |
|------------|-------|--------|
| Azure subscription (Hong Kong region) | CLP IT | ⏳ Required |
| SharePoint API access | CLP IT | ⏳ Required |
| Sample training videos | CLP Training | ⏳ Required |
| VoltAI Marketplace access | Volt Team | ⏳ Required |
| Azure DevOps project | CLP DevOps | ⏳ Required |

#### Technical Scope

**In Scope**:
- Azure OpenAI (GPT-4, text-embedding-ada-002)
- Azure AI Search (vector index)
- Azure Speech Services (transcription)
- Azure Cosmos DB (metadata)
- Azure Functions (processing pipeline)
- Azure App Service (API hosting)
- Terraform infrastructure
- Azure DevOps CI/CD

**Out of Scope (Phase 2+)**:
- Multi-agent architecture
- AI Avatar
- Management console UI
- Advanced analytics
- Viva Learning integration

---

### Phase 2: Content Expansion & Management Console

**Timeline**: Weeks 7-12

#### Strategic Objectives

Expand content coverage to include additional departments, deploy a management console for administrators, and refine the chatbot based on Phase 1 learnings.

#### Key Capabilities

| Capability | Description | Priority |
|------------|-------------|----------|
| **Management Console** | Next.js admin dashboard | P0 - Critical |
| **Content Dashboard** | View all indexed content and status | P0 - Critical |
| **Query Analytics** | Popular questions, gap analysis | P1 - High |
| **Content Tagging** | Department and category classification | P1 - High |
| **Improved Chunking** | Refined chunking based on learnings | P1 - High |
| **Feedback Collection** | User satisfaction ratings | P1 - High |
| **Multi-department Content** | Expand to HR, Legal content | P2 - Medium |

#### Deliverables

1. **Management Console**
   - Content inventory view
   - Processing status monitoring
   - Query analytics dashboard
   - User activity reports
   - Content lifecycle actions

2. **Platform Refinement**
   - Improved chunking strategy
   - Enhanced prompt engineering
   - Jargon dictionary expansion
   - Performance optimization

3. **Content Expansion**
   - HR department content
   - Legal department content
   - Cross-department tagging

#### Business Value & Outcomes

| Outcome | Metric | Target |
|---------|--------|--------|
| Admin visibility | Content coverage visibility | 100% |
| Content gaps | Identified gap queries | Tracked |
| User satisfaction | Feedback score | >4.0/5.0 |
| Multi-department | Departments covered | 3+ |

#### Success Criteria

- [ ] Management console deployed and accessible
- [ ] Administrators can view all indexed content
- [ ] Query analytics available (top questions, gaps)
- [ ] HR content indexed and searchable
- [ ] Legal content indexed and searchable
- [ ] User feedback mechanism operational
- [ ] Chatbot accuracy improved based on Phase 1 feedback

#### Strategic Enablers

This phase enables:
- Data foundation for multi-agent routing (Phase 3)
- Analytics baseline for continuous improvement
- Governance capabilities for enterprise scale
- Content taxonomy for department-specific agents

#### Dependencies & Prerequisites

| Dependency | Owner | Status |
|------------|-------|--------|
| Phase 1 completion | Delivery Team | ⏳ |
| HR content access | CLP HR | ⏳ Required |
| Legal content access | CLP Legal | ⏳ Required |
| User feedback from Phase 1 | Product Owner | ⏳ |

---

### Phase 3: Multi-Agent & AI Avatar (Ultimate)

**Timeline**: Weeks 13-24 (Post-MVP, dependent on Phase 2 success)

#### Strategic Objectives

Deploy the "Ultimate" solution with department-specific AI agents, AI Avatar for personalized training, and advanced capabilities that position CLP as a leader in AI-powered knowledge management.

#### Key Capabilities

| Capability | Description | Priority |
|------------|-------------|----------|
| **Multi-Agent System** | HR, Legal, Technical agents | P0 - Critical |
| **Agent Orchestration** | Azure AI Foundry routing | P0 - Critical |
| **AI Avatar** | Text-to-speech training avatar | P1 - High |
| **Viva Learning Integration** | Embed in learning platform | P2 - Medium |
| **Short Video Generation** | Auto-generate video clips | P2 - Medium |
| **Advanced Analytics** | ML-powered insights | P3 - Low |

#### Deliverables

1. **Multi-Agent Architecture**
   - HR-specialized agent
   - Legal-specialized agent
   - Technical-specialized agent
   - Intelligent agent routing
   - Azure AI Foundry orchestration

2. **AI Avatar**
   - Text-to-speech avatar generation
   - Senior expert likeness (with consent)
   - Personalized training delivery
   - Video clip generation

3. **Platform Integrations**
   - Viva Learning embedding
   - Advanced observability
   - Enterprise analytics

#### Business Value & Outcomes

| Outcome | Metric | Target |
|---------|--------|--------|
| Domain expertise | Agent accuracy by department | >95% |
| Personalized learning | Avatar training engagement | 2x vs. video |
| Platform adoption | Enterprise-wide rollout | All departments |
| Knowledge preservation | Expert knowledge captured | Key experts digitized |

#### Success Criteria

- [ ] Multi-agent system deployed with routing
- [ ] HR agent answers HR-specific questions accurately
- [ ] Legal agent answers Legal-specific questions accurately
- [ ] Technical agent answers Technical questions accurately
- [ ] AI Avatar prototype demonstrated
- [ ] Viva Learning integration complete
- [ ] Full enterprise rollout

#### Dependencies & Prerequisites

| Dependency | Owner | Status |
|------------|-------|--------|
| Phase 2 completion | Delivery Team | ⏳ |
| AI Foundry access | Microsoft | ⏳ Required |
| Avatar consent from experts | CLP HR/Legal | ⏳ Required |
| Viva Learning licenses | CLP IT | ⏳ Required |
| GPU compute for avatar | Azure | ⏳ Required |

---

## 4. Cross-Phase Dependencies

### Dependency Map

```
Phase 1 ─────────────────────────────────────────────────────┐
│                                                             │
├─ SharePoint Integration ──────────────────────────────────┐ │
├─ Vector Index ─────────────────────────┐                  │ │
├─ Basic RAG ────────────────┐           │                  │ │
└─ Monitoring ─────┐         │           │                  │ │
                   │         │           │                  │ │
                   ▼         ▼           ▼                  ▼ │
Phase 2 ───────────┼─────────┼───────────┼──────────────────┼─┤
│                  │         │           │                  │ │
├─ Mgmt Console ◄──┘         │           │                  │ │
├─ Query Analytics ◄─────────┘           │                  │ │
├─ Content Tagging ◄─────────────────────┘                  │ │
├─ Multi-dept Content ◄─────────────────────────────────────┘ │
└─ Feedback Loop ──────────────────────────────────────────┐  │
                                                           │  │
                   ▼         ▼           ▼                 ▼  ▼
Phase 3 ───────────┼─────────┼───────────┼─────────────────┼──┤
│                  │         │           │                 │  │
├─ Multi-Agent ◄───┴─────────┴───────────┘                 │  │
├─ AI Avatar ◄─────────────────────────────────────────────┘  │
└─ Viva Learning ◄────────────────────────────────────────────┘
```

### Key Decision Points

| Decision | Phase | Impact | Timing |
|----------|-------|--------|--------|
| Chunking strategy finalization | 1→2 | Affects retrieval quality | Week 4 |
| Multi-agent vs. single with routing | 2→3 | Architecture complexity | Week 10 |
| Avatar vendor selection | 2→3 | Cost, quality, integration | Week 12 |
| Viva Learning priority | 2→3 | Resource allocation | Week 10 |

### Parallel Work Streams

These activities can run in parallel to accelerate delivery:

| Stream | Parallel With | Benefit |
|--------|---------------|---------|
| Content tagging | Phase 1 processing | Ready for Phase 2 multi-dept |
| Management console design | Phase 1 dev | Faster Phase 2 start |
| Avatar vendor evaluation | Phase 2 | Informed Phase 3 planning |
| User training materials | All phases | Smoother adoption |

---

## 5. Value Milestones

### Timeline View

```
Week 1-2: Foundation
├── Azure infrastructure deployed
├── SharePoint connection verified
└── Development environment ready

Week 3-4: Core Processing
├── Video transcription pipeline working
├── Document processing operational
└── Vector index populated

Week 5-6: MVP Launch (🎯 February 2026)
├── RAG chatbot live
├── VoltAI integration complete
├── Stakeholder demo
└── ✅ Phase 1 Complete

Week 7-8: Console Foundation
├── Management console MVP
├── Content dashboard live
└── Query analytics available

Week 9-10: Content Expansion
├── HR content indexed
├── Legal content indexed
└── Feedback collection active

Week 11-12: Phase 2 Completion
├── All departments covered
├── Refined chatbot accuracy
└── ✅ Phase 2 Complete

Week 13-16: Multi-Agent Foundation
├── Agent architecture deployed
├── HR agent operational
├── Legal agent operational

Week 17-20: AI Avatar
├── Avatar prototype ready
├── Senior expert digitized
└── Training content generated

Week 21-24: Enterprise Rollout
├── Viva Learning integration
├── Full enterprise deployment
└── ✅ Phase 3 Complete
```

### Stakeholder Milestones

| Week | Milestone | Stakeholder Demo |
|------|-----------|------------------|
| 2 | Infrastructure Ready | IT review |
| 4 | First Chatbot Response | Technical demo |
| 6 | **MVP Launch** | **Executive demo** |
| 8 | Management Console | Admin training |
| 12 | Multi-dept Coverage | Department heads |
| 16 | Multi-Agent System | Executive showcase |
| 20 | AI Avatar Prototype | Executive preview |
| 24 | Enterprise Rollout | All-hands launch |

### Go-Live Dates

| Capability | Target Date | User Access |
|------------|-------------|-------------|
| RAG Chatbot (MVP) | Early February 2026 | Pilot users |
| Management Console | Late February 2026 | Administrators |
| Multi-department | March 2026 | All departments |
| Multi-Agent | April 2026 | All users |
| AI Avatar | May 2026 | Training programs |

---

## 6. Resource & Capacity Planning

### Team Composition (Recommended)

| Role | Phase 1 | Phase 2 | Phase 3 |
|------|---------|---------|---------|
| Technical Lead | 1 | 1 | 1 |
| Backend Engineer | 2 | 2 | 3 |
| Frontend Engineer | 0.5 | 1 | 1 |
| DevOps Engineer | 0.5 | 0.5 | 1 |
| Data Engineer | 1 | 1 | 1 |
| QA Engineer | 0.5 | 1 | 1 |
| Product Owner | 0.5 | 0.5 | 0.5 |

### Infrastructure Scaling

| Resource | Phase 1 | Phase 2 | Phase 3 |
|----------|---------|---------|---------|
| Azure OpenAI TPM | 60K | 120K | 240K |
| AI Search Units | 1 | 2 | 3 |
| App Service Plan | B2 | S2 | P2v2 |
| Cosmos DB RU/s | 400 | 1000 | 4000 |

---

## Related Documents

- [Data Platform Strategy](data-platform-strategy.md) - Strategic foundation
- [Risk & Constraint Register](risk-constraint-register.md) - Risk management
- [Business Case](business-case.md) - Business requirements
- [Tech Stack](tech-stack.md) - Technology details
