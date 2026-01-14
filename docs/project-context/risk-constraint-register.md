# Risk & Constraint Register

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |
| Related Documents | [Data Platform Strategy](data-platform-strategy.md), [Value Delivery Roadmap](value-delivery-roadmap.md) |

---

## 1. Overview

### Purpose

This register captures and tracks risks, assumptions, and constraints that may impact the successful delivery of the CLP AI Knowledge Management platform. It provides a structured approach to risk identification, assessment, and mitigation.

### Risk Management Approach

- **Weekly Review**: Risks reviewed in weekly project stand-ups
- **Escalation**: High/Critical risks escalated to project sponsor within 24 hours
- **Ownership**: Each risk has a designated owner responsible for mitigation
- **Retirement**: Risks closed when mitigated or no longer applicable

### Risk Scoring Matrix

| Likelihood / Impact | Low | Medium | High | Critical |
|---------------------|-----|--------|------|----------|
| **High** | Medium | High | Critical | Critical |
| **Medium** | Low | Medium | High | Critical |
| **Low** | Low | Low | Medium | High |

---

## 2. Risk Register

### Technical Risks

| ID | Risk Description | L | I | Score | Mitigation Strategy | Owner | Phase |
|----|------------------|---|---|-------|---------------------|-------|-------|
| R-001 | **Video transcription accuracy is insufficient** for CLP-specific jargon (e.g., "K2" terms) | M | H | High | Custom vocabulary training in Azure Speech; post-processing correction; human review for critical terms | Data Engineer | Phase 1 |
| R-002 | **SharePoint API rate limits** cause sync delays during bulk processing | M | M | Medium | Implement request throttling; batch processing; incremental sync; Logic Apps retry policies | Backend Engineer | Phase 1 |
| R-003 | **Vector search relevance** doesn't meet user expectations | M | H | High | Iterative chunking strategy tuning; hybrid search (vector + keyword); user feedback loop; A/B testing | Tech Lead | Phase 1 |
| R-004 | **LLM response latency** exceeds 3-second target | L | M | Low | Optimize prompt length; caching strategies; async response patterns; CDN for static assets | Backend Engineer | Phase 1 |
| R-005 | **Azure OpenAI quota limits** restrict usage during peak periods | M | H | High | Request quota increase early; implement request queuing; rate limiting; usage monitoring | DevOps | Phase 1 |
| R-006 | **Schema evolution** in source documents breaks processing pipeline | M | M | Medium | Schema validation at ingestion; graceful degradation; alerting on failures; reprocessing capability | Data Engineer | Phase 2 |
| R-007 | **Multi-agent routing accuracy** is poor, sending users to wrong agent | M | H | High | Comprehensive intent classification; fallback to general agent; user correction feedback | Tech Lead | Phase 3 |
| R-008 | **AI Avatar quality** doesn't meet professional standards | M | H | High | Early vendor evaluation; prototype testing; fallback to text-based responses | Product Owner | Phase 3 |

### Data Quality Risks

| ID | Risk Description | L | I | Score | Mitigation Strategy | Owner | Phase |
|----|------------------|---|---|-------|---------------------|-------|-------|
| R-101 | **Source content quality varies** significantly across departments | H | M | High | Quality scoring at ingestion; low-quality content flagged; admin review workflow | Data Engineer | Phase 1 |
| R-102 | **Duplicate content** creates inconsistent answers | M | M | Medium | Content deduplication; canonical source identification; metadata tracking | Data Engineer | Phase 1 |
| R-103 | **Stale content** remains in index after SharePoint deletion | L | M | Low | Real-time delete sync; daily reconciliation job; content freshness tracking | Backend Engineer | Phase 1 |
| R-104 | **Sensitive content** accidentally indexed and exposed | L | C | Medium | Content classification at ingestion; access control inheritance from SharePoint; audit logging | Security Lead | Phase 1 |
| R-105 | **Timestamps drift** between transcription and video due to processing delays | L | H | Medium | Timestamp validation; video hash verification; reprocessing triggers | Data Engineer | Phase 1 |

### Integration Risks

| ID | Risk Description | L | I | Score | Mitigation Strategy | Owner | Phase |
|----|------------------|---|---|-------|---------------------|-------|-------|
| R-201 | **SharePoint webhook reliability** causes missed updates | M | H | High | Daily reconciliation job; event logging; manual resync capability | Backend Engineer | Phase 1 |
| R-202 | **VoltAI Marketplace integration** has undocumented requirements | M | M | Medium | Early integration testing; direct communication with VoltAI team; fallback standalone UI | Tech Lead | Phase 1 |
| R-203 | **Azure service deprecation** impacts long-term architecture | L | M | Low | Use stable, GA services; monitor deprecation notices; maintain abstraction layers | Tech Lead | All |
| R-204 | **Viva Learning API changes** break integration | M | M | Medium | Version pinning; API monitoring; abstraction layer for easy migration | Backend Engineer | Phase 3 |

### Project & Resource Risks

| ID | Risk Description | L | I | Score | Mitigation Strategy | Owner | Phase |
|----|------------------|---|---|-------|---------------------|-------|-------|
| R-301 | **February deadline** is too aggressive for MVP scope | M | H | High | Prioritize ruthlessly; cut scope not quality; parallel work streams; daily progress tracking | Project Manager | Phase 1 |
| R-302 | **Key team member unavailable** during critical phase | L | H | Medium | Knowledge sharing; documentation; cross-training; backup resources identified | Project Manager | All |
| R-303 | **Stakeholder requirements change** mid-phase | M | M | Medium | Change control process; regular stakeholder alignment; scope freeze periods | Product Owner | All |
| R-304 | **CLP IT approvals** for Azure resources delayed | M | H | High | Early engagement with IT; pre-approved resource templates; escalation path defined | Project Manager | Phase 1 |

### Security & Compliance Risks

| ID | Risk Description | L | I | Score | Mitigation Strategy | Owner | Phase |
|----|------------------|---|---|-------|---------------------|-------|-------|
| R-401 | **Data residency requirements** not met by Azure service | L | C | Medium | Verify Hong Kong region availability for all services; document data flows; legal review | Security Lead | Phase 1 |
| R-402 | **Unauthorized access** to knowledge base via API | L | C | Medium | Azure AD integration; API authentication; RBAC; audit logging | Security Lead | Phase 1 |
| R-403 | **LLM data leakage** exposes training data | L | C | Medium | Use Azure OpenAI with data privacy; no fine-tuning on customer data; RAG-only approach | Tech Lead | Phase 1 |
| R-404 | **Avatar consent and likeness rights** create legal issues | M | H | High | Legal review of consent process; explicit written consent; usage restrictions documented | Legal/Product | Phase 3 |

---

## 3. Assumptions

### Project Scope

| ID | Assumption | Impact if Invalid | Validation |
|----|------------|-------------------|------------|
| A-001 | Training videos and documents in SharePoint are the primary knowledge sources | Major scope change required | Confirm with stakeholders Week 1 |
| A-002 | English is the primary language for all content | May need multi-language support | Confirm with stakeholders Week 1 |
| A-003 | VoltAI Marketplace is the primary user interface | May need custom UI development | Confirm with VoltAI team Week 1 |
| A-004 | Phase 1 scope is achievable in 6 weeks | Timeline extension or scope reduction | Weekly progress assessment |

### Data Availability

| ID | Assumption | Impact if Invalid | Validation |
|----|------------|-------------------|------------|
| A-101 | SharePoint API provides sufficient access to all required content | Alternative ingestion method needed | Test API access Week 1 |
| A-102 | Video files are in standard formats (MP4, etc.) | Additional transcoding required | Inventory content formats Week 1 |
| A-103 | Training videos have clear audio for transcription | Manual transcription for some content | Test transcription quality Week 2 |
| A-104 | Content volume is manageable within Azure service limits | Increased costs, architectural changes | Estimate content volume Week 1 |

### Skills & Capabilities

| ID | Assumption | Impact if Invalid | Validation |
|----|------------|-------------------|------------|
| A-201 | Team has Azure and RAG development experience | Training time, potential delays | Team skill assessment Week 1 |
| A-202 | DevOps pipeline can be established quickly | Manual deployments, slower iteration | Pipeline setup Week 1-2 |
| A-203 | Product owner available for regular feedback | Misaligned features, rework | Confirm availability Week 1 |

### Technology

| ID | Assumption | Impact if Invalid | Validation |
|----|------------|-------------------|------------|
| A-301 | Azure OpenAI GPT-4 available in Hong Kong region | Alternative region or model needed | Verify availability Week 1 |
| A-302 | Azure AI Search provides adequate vector search quality | Alternative vector DB evaluation | Test search quality Week 2-3 |
| A-303 | Azure Speech Services handles CLP jargon | Custom vocabulary needed | Test transcription Week 2 |
| A-304 | Terraform can provision all required resources | Manual provisioning for some resources | Test Terraform Week 1-2 |

### Organization

| ID | Assumption | Impact if Invalid | Validation |
|----|------------|-------------------|------------|
| A-401 | CLP IT will provide Azure access within 1 week | Project start delayed | Request access immediately |
| A-402 | Stakeholders available for weekly demos | Misalignment, scope creep | Confirm schedule Week 1 |
| A-403 | No competing priorities will pull team resources | Resource conflicts, delays | Escalate early if conflicts arise |

---

## 4. Constraints

### Technical Constraints

| ID | Constraint | Impact | Mitigation |
|----|------------|--------|------------|
| C-001 | **Must use Microsoft Azure** as cloud provider (existing enterprise agreement) | Limited to Azure services and capabilities | Design for Azure-native patterns; leverage existing skills |
| C-002 | **Data must remain in Hong Kong region** for regulatory compliance | Some Azure services may not be available | Verify service availability; document data flows |
| C-003 | **No external data egress** for LLM processing | Cannot use external AI services (Anthropic, etc.) | Use Azure OpenAI exclusively |
| C-004 | **SharePoint is source of truth** for content | Cannot modify content storage architecture | Design sync patterns; preserve SharePoint as master |
| C-005 | **VoltAI Marketplace** is primary experience layer | Limited UI customization | Work within VoltAI constraints; propose enhancements |

### Budget Constraints

| ID | Constraint | Impact | Mitigation |
|----|------------|--------|------------|
| C-101 | **Budget based on 1st-year Azure consumption** only | No upfront capital for software licenses | Use consumption-based services; optimize costs |
| C-102 | **Pricing must be attractive** for initial adoption | Cannot over-engineer Phase 1 | Minimal viable architecture; scale with usage |
| C-103 | **No additional software license purchases** | Limited to Azure/Microsoft ecosystem | Maximize Azure-native capabilities |

### Timeline Constraints

| ID | Constraint | Impact | Mitigation |
|----|------------|--------|------------|
| C-201 | **Target launch: Early February 2026** | ~6 weeks for Phase 1 MVP | Ruthless prioritization; parallel work streams |
| C-202 | **Proposal due Thursday/Friday** this week | Limited time for detailed cost analysis | Ballpark estimates; refine in later proposal |
| C-203 | **Budget confirmation within 1-2 days** | Rapid decision-making required | Prepare multiple cost scenarios |

### Organizational Constraints

| ID | Constraint | Impact | Mitigation |
|----|------------|--------|------------|
| C-301 | **Must integrate with existing CLP security policies** | Additional compliance requirements | Early security review; document controls |
| C-302 | **Multi-department rollout** requires departmental approval | Phased department adoption | Start with willing departments; demonstrate value |
| C-303 | **AI Avatar requires explicit consent** from depicted individuals | Legal process for each avatar | Early consent process; prototype with willing participants |

### Resource Constraints

| ID | Constraint | Impact | Mitigation |
|----|------------|--------|------------|
| C-401 | **Team size limited** for Phase 1 | Scope must match capacity | Focus on core capabilities; defer nice-to-haves |
| C-402 | **Azure OpenAI quota limits** may apply | Rate limiting during peak usage | Request quota increase; implement queuing |

---

## 5. Risk Monitoring & Review

### Review Cadence

| Activity | Frequency | Participants |
|----------|-----------|--------------|
| Risk assessment update | Weekly | Project Manager, Tech Lead |
| Assumption validation | Bi-weekly | Product Owner, Stakeholders |
| Constraint review | Monthly | Project Sponsor, Tech Lead |
| Full register review | Phase gate | All stakeholders |

### Escalation Process

1. **Low/Medium Risks**: Managed within project team; reported in weekly status
2. **High Risks**: Escalated to Project Manager; mitigation plan within 48 hours
3. **Critical Risks**: Immediate escalation to Project Sponsor; emergency mitigation

### Risk Retirement Criteria

A risk can be retired (closed) when:
- Mitigation implemented and validated effective
- Risk event occurred and was resolved
- Risk no longer applicable due to scope/timeline changes
- Probability reduced to negligible through controls

### Monitoring Dashboards

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Open High/Critical Risks | <5 | >5 |
| Risks without owner | 0 | >0 |
| Overdue mitigations | 0 | >0 |
| Assumptions not validated | <3 | >5 |

---

## 6. Risk Response Summary

### Immediate Actions (Week 1)

| Action | Owner | Due |
|--------|-------|-----|
| Verify Azure Hong Kong service availability | DevOps | Day 2 |
| Test SharePoint API access | Backend Engineer | Day 3 |
| Confirm VoltAI integration requirements | Tech Lead | Day 3 |
| Validate Azure OpenAI quota | DevOps | Day 2 |
| Sample video transcription quality test | Data Engineer | Day 5 |

### Phase 1 Risk Focus Areas

1. **Transcription Quality**: Early testing with CLP content; jargon dictionary development
2. **Search Relevance**: Iterative chunking strategy; user feedback integration
3. **Timeline Pressure**: Daily stand-ups; scope protection; parallel work streams
4. **Integration Points**: Early SharePoint and VoltAI integration testing

### Contingency Plans

| Trigger | Response |
|---------|----------|
| Transcription quality <80% | Fallback to manual transcription for critical content |
| Search relevance unsatisfactory | Switch to hybrid search; increase chunking overlap |
| February deadline at risk | Reduce scope to core chatbot only; defer management console |
| Azure OpenAI quota exhausted | Implement strict rate limiting; queue requests |
| VoltAI integration blocked | Deploy standalone web UI as fallback |

---

## Related Documents

- [Data Platform Strategy](data-platform-strategy.md) - Strategic foundation
- [Value Delivery Roadmap](value-delivery-roadmap.md) - Phasing and timeline
- [Business Case](business-case.md) - Business requirements
- [Tech Stack](tech-stack.md) - Technology details
