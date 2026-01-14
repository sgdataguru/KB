# CLP AI Knowledge Management - Technical Stack

## Overview

This document outlines the technical architecture and stack for the CLP AI Knowledge Management solution, built using a RAG (Retrieval Augmented Generation) model architecture.

---

## Core Architecture

### RAG (Retrieval Augmented Generation) Model

The solution uses a RAG architecture which consists of:

1. **Document Ingestion Pipeline**
   - Video to transcript conversion
   - Document parsing (PDF, Word, etc.)
   - Metadata extraction (source location, timestamps, file info)

2. **Vector Database**
   - Stores embeddings of all knowledge content
   - Maintains metadata relationships
   - Enables semantic search capabilities

3. **LLM Integration**
   - Tuned to only answer from approved knowledge base
   - No external internet access (prevents hallucinations)
   - Citation-based responses with source references

---

## Technology Components

### Cloud Platform
| Component | Technology | Purpose |
|-----------|------------|---------|
| Cloud Provider | **Microsoft Azure** | Primary cloud infrastructure |
| AI Orchestration | **Azure AI Foundry** | Multi-agent governance and management |
| Knowledge Storage | **SharePoint** | Source document and video storage |
| Learning Platform | **Viva Learning** | End-user training interface |
| Experience | **VoltAI Marketplace** | Q&A-style agent interface, Consumed directly by VoltAI frontend |

### AI/ML Stack
| Component | Technology | Purpose |
|-----------|------------|---------|
| LLM | Azure OpenAI | Natural language processing and generation |
| Embeddings | Azure OpenAI Embeddings | Vector representation of documents |
| Vector DB | Azure Cosmos DB / Azure AI Search | Semantic search and retrieval |
| Speech-to-Text | Azure Speech Services | Video transcript generation |

### Future Components (Phase 2)
| Component | Technology | Purpose |
|-----------|------------|---------|
| AI Avatar | Azure AI Video / D-ID / HeyGen | Text-to-speech avatar for training |
| Video Generation | Azure Media Services | Short video creation from content |
| Multi-Agent | Azure AI Foundry Agents | Department-specific AI agents (HR, Legal, Tech) |

---

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA INGESTION PIPELINE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │  SharePoint  │───▶│   Video      │───▶│  Transcript  │                  │
│  │   Videos     │    │  Processor   │    │  Generator   │                  │
│  └──────────────┘    └──────────────┘    └──────────────┘                  │
│                                                 │                           │
│  ┌──────────────┐                              │                           │
│  │  Training    │───────────────────────────────┼───────▶ ┌──────────────┐ │
│  │  Documents   │                              │         │  Embedding   │ │
│  └──────────────┘                              │         │   Model      │ │
│                                                 │         └──────────────┘ │
│                                                 │                │          │
│                                                 ▼                ▼          │
│                                          ┌─────────────────────────┐       │
│                                          │     Vector Database     │       │
│                                          │   (Metadata + Vectors)  │       │
│                                          └─────────────────────────┘       │
│                                                      │                      │
└──────────────────────────────────────────────────────┼──────────────────────┘
                                                       │
┌──────────────────────────────────────────────────────┼──────────────────────┐
│                           QUERY PIPELINE             │                      │
├──────────────────────────────────────────────────────┼──────────────────────┤
│                                                      │                      │
│  ┌──────────────┐    ┌──────────────┐               │                      │
│  │   User       │───▶│   Query      │               │                      │
│  │   Question   │    │  Embedding   │◀──────────────┘                      │
│  └──────────────┘    └──────────────┘                                      │
│                             │                                               │
│                             ▼                                               │
│                      ┌──────────────┐    ┌──────────────┐                  │
│                      │  Semantic    │───▶│    LLM       │                  │
│                      │   Search     │    │  (Grounded)  │                  │
│                      └──────────────┘    └──────────────┘                  │
│                                                 │                           │
│                                                 ▼                           │
│                                          ┌──────────────┐                  │
│                                          │   Response   │                  │
│                                          │ + Citations  │                  │
│                                          │ + Timestamps │                  │
│                                          └──────────────┘                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Technical Decisions

### Why RAG over Fine-Tuning?
- **Updatable**: New content can be added without retraining
- **Traceable**: Every answer includes source citations
- **Cost-effective**: No expensive model training required
- **Controllable**: Responses limited to approved knowledge base

### Video Processing Strategy
- Convert video audio to text using Azure Speech Services
- Store timestamp metadata for precise video navigation
- Enable "jump to timestamp" feature in responses

### Grounding & Safety
- LLM is configured to ONLY use retrieved context
- No external internet access for the model
- All responses must cite specific sources
- Industry jargon (e.g., "K2") handled via custom embeddings

---

## Integration Points

### SharePoint Integration
- Source of truth for all documents and videos
- Automatic sync for new/updated content
- Metadata inheritance from SharePoint properties

### Viva Learning Integration (Phase 2)
- AI chatbot embedded in learning experience
- AI Avatar delivers personalized training
- Progress tracking and analytics

### Management Console
- Document reference management
- Implementation plan tracking
- User analytics and reporting

---

## Security Considerations

- All data remains within Azure tenant
- Role-based access control (RBAC)
- No data sent to external services
- Audit logging for all queries and responses

---

## Estimated Azure Services

### Phase 1 (MVP)
- Azure OpenAI Service
- Azure AI Search (Vector Search)
- Azure Speech Services
- Azure App Service (Chatbot hosting)
- Azure Cosmos DB (Metadata storage)

### Phase 2 (Ultimate)
- Azure AI Foundry (Multi-agent orchestration)
- Azure AI Video / Third-party Avatar Service
- Azure Media Services
- Enhanced analytics and monitoring

---

## Cost Estimation Approach

- Based on 1st-year Azure consumption
- Pay-as-you-go model for scalability
- Optimized for initial adoption pricing
- Detailed breakdown to be provided in proposal

---

## References

- [Azure AI Foundry Documentation](https://learn.microsoft.com/azure/ai-studio/)
- [Azure OpenAI RAG Patterns](https://learn.microsoft.com/azure/ai-services/openai/concepts/retrieval-augmented-generation)
- [Azure Speech Services](https://learn.microsoft.com/azure/ai-services/speech-service/)
