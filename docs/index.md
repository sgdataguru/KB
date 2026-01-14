# CLP Knowledge Base Documentation

> Comprehensive documentation for the CLP AI Knowledge Management Platform

---

## 📚 Documentation Index

### Project Context
- [Business Case](project-context/business-case.md) - Project justification and value proposition
- [Technical Stack](project-context/tech-stack.md) - Technology choices and architecture

### Architecture
- [Architecture Overview](architecture/overview.md) - High-level system design
- [Data Flow Diagrams](architecture/overview.md#data-flow) - How data moves through the system

### Features
- [RAG Chatbot](features/rag-chatbot.md) - AI-powered Q&A functionality
- [Video Processing](features/video-processing.md) - Transcription and timestamp extraction
- [SharePoint Sync](features/sharepoint-sync.md) - Real-time document synchronization
- [Management Console](features/management-console.md) - Admin dashboard functionality
- [AI Avatar](features/ai-avatar.md) - Phase 2 text-to-speech avatar
- [Multi-Agent System](features/multi-agent.md) - Department-specific agents

### Infrastructure
- [Infrastructure Guide](../infra/docs/README.md) - Terraform modules and deployment
- [Azure Services](infra/azure-services.md) - Detailed service configuration

### Administration
- [Permissions & Access](admin/permissions.md) - RBAC and security configuration

### Development
- [Contributing Guide](CONTRIBUTE.md) - How to contribute to this project
- [API Documentation](../src/docs/api.md) - API reference

---

## 🏗️ System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  VoltAI Marketplace  │  Management Console  │  Viva Learning   │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                      APPLICATION LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│  Azure AI Foundry (Multi-Agent Orchestration & Governance)     │
│  ├── HR Agent                                                   │
│  ├── Legal Agent                                                │
│  └── Technical Agent                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  Azure OpenAI  │  Azure AI Search  │  Azure Cosmos DB          │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                      INGESTION LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  SharePoint Sync  │  Teams Connector  │  Speech Services       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Concepts

### RAG (Retrieval Augmented Generation)
The core architecture pattern that grounds AI responses in actual documents, preventing hallucinations and ensuring accurate, citable answers.

### Grounded Responses
All chatbot responses include:
- Source document citations
- Video timestamps for multimedia content
- Confidence indicators

### Multi-Agent Architecture
Specialized agents handle domain-specific queries:
- **HR Agent**: Training policies, onboarding procedures
- **Legal Agent**: Compliance documentation, safety regulations
- **Technical Agent**: Equipment manuals, calibration procedures

### Content Versioning
Ensures junior staff always access the most current documentation with clear version indicators.

---

## 📊 Data Governance

| Policy | Value |
|--------|-------|
| Data Residency | Azure Hong Kong (East Asia) |
| Retention Period | 7-10 years |
| Access Logging | Full audit trail |
| Content Classification | Auto-tagged by sensitivity |

---

## 🚀 Quick Links

- [Getting Started](../README.md#quick-start)
- [TODO List](../TODO.md)
- [Infrastructure Deployment](../infra/docs/README.md)
- [API Reference](../src/docs/api.md)
