# CLP Knowledge Base - Project Tasks

> Last Updated: January 14, 2026

---

## 📋 Documentation
- [ ] Review and finalize business-case.md (PM)
- [ ] Review and update tech-stack.md with final Azure services (Architect)
- [ ] Create detailed API documentation (Dev Lead)
- [ ] Document custom jargon/keyword dictionary format (Dev)
- [ ] Create user guide for Management Console (Tech Writer)

---

## 🏗️ Infrastructure (Terraform)

### Phase 1 - MVP
- [ ] Set up Azure Resource Group in Hong Kong East region (DevOps)
- [ ] Configure Azure OpenAI Service with GPT-4 deployment (DevOps)
- [ ] Set up Azure AI Search with vector search enabled (DevOps)
- [ ] Configure Azure Cosmos DB for metadata storage (DevOps)
- [ ] Set up Azure Speech Services for transcription (DevOps)
- [ ] Configure Azure App Service for API hosting (DevOps)
- [ ] Set up Azure Functions for pipeline triggers (DevOps)
- [ ] Configure Azure Logic Apps for SharePoint sync (DevOps)
- [ ] Set up Azure Key Vault for secrets management (DevOps)
- [ ] Configure networking and private endpoints (DevOps)
- [ ] Set up Azure Monitor and Log Analytics (DevOps)
- [ ] Configure Azure AI Foundry for governance (DevOps)

### Phase 2 - Blueprint (Prepare)
- [ ] Document GPU cluster requirements for AI Avatar (Architect)
- [ ] Plan Video Indexer scale-out architecture (Architect)
- [ ] Create Terraform modules for Phase 2 services (DevOps)

---

## 🔄 Data Ingestion Pipeline

### SharePoint Integration
- [ ] Create Azure Function for SharePoint webhook listener (Dev)
- [ ] Implement Logic App for file change detection (Dev)
- [ ] Build document extraction service (PDF, Word, PPT) (Dev)
- [ ] Create metadata extraction pipeline (Dev)
- [ ] Implement versioning logic for document updates (Dev)

### Video Processing
- [ ] Build video download service from SharePoint (Dev)
- [ ] Implement Azure Speech Services transcription (Dev)
- [ ] Create timestamp metadata extraction (Dev)
- [ ] Build video chunking service for long videos (Dev)
- [ ] Implement Teams Recording connector (Dev)

### Embedding Pipeline
- [ ] Create text chunking service with overlap (Dev)
- [ ] Implement Azure OpenAI embedding generation (Dev)
- [ ] Build vector upsert service for AI Search (Dev)
- [ ] Create custom jargon/keyword dictionary handler (Dev)
- [ ] Implement metadata linking for citations (Dev)

---

## 🤖 RAG Chatbot Service

### Core RAG
- [ ] Build semantic search API endpoint (Dev)
- [ ] Implement grounded response generation with Azure OpenAI (Dev)
- [ ] Create citation extraction and formatting (Dev)
- [ ] Build timestamp linking for video responses (Dev)
- [ ] Implement "I don't know" response for out-of-scope queries (Dev)

### Multi-Agent (Phase 2 Prep)
- [ ] Design agent routing architecture (Architect)
- [ ] Create HR agent prompt template (Dev)
- [ ] Create Legal agent prompt template (Dev)
- [ ] Create Technical agent prompt template (Dev)

---

## 🖥️ Management Console (Next.js)

### Admin Dashboard
- [ ] Create dashboard layout with gaming aesthetic (Frontend)
- [ ] Build document listing page with status indicators (Frontend)
- [ ] Implement search and filter functionality (Frontend)
- [ ] Create document detail view with metadata (Frontend)

### Processing Status
- [ ] Build real-time processing status component (Frontend)
- [ ] Create pipeline monitoring dashboard (Frontend)
- [ ] Implement error notification system (Frontend)

### Analytics
- [ ] Create user query analytics dashboard (Frontend)
- [ ] Build knowledge gap identification view (Frontend)
- [ ] Implement audit log viewer (Frontend)

### API Integration
- [ ] Build API client for backend services (Frontend)
- [ ] Implement authentication with Azure AD (Frontend)
- [ ] Create role-based UI components (Frontend)

---

## 🔐 Security & Compliance

### Access Control
- [ ] Configure Azure AD integration (Security)
- [ ] Implement RBAC for Management Console (Security)
- [ ] Set up API authentication with managed identities (Security)
- [ ] Create audit logging for all data access (Security)

### Data Governance
- [ ] Implement 7-10 year retention policy logic (Security)
- [ ] Create data classification tagging (Security)
- [ ] Set up data residency compliance monitoring (Security)
- [ ] Configure Azure AI Foundry content filters (Security)

### AI Safety
- [ ] Implement hallucination detection monitoring (AI/ML)
- [ ] Create safety-critical content guardrails (AI/ML)
- [ ] Set up model behavior alerting (AI/ML)

---

## 🧪 Testing

### Unit Tests
- [ ] Write tests for document extraction service (QA)
- [ ] Write tests for transcription service (QA)
- [ ] Write tests for embedding pipeline (QA)
- [ ] Write tests for RAG retrieval logic (QA)

### Integration Tests
- [ ] Test SharePoint sync end-to-end (QA)
- [ ] Test video processing pipeline (QA)
- [ ] Test chatbot response quality (QA)
- [ ] Test Management Console workflows (QA)

### E2E Tests
- [ ] Create user journey tests for junior staff (QA)
- [ ] Create admin workflow tests (QA)
- [ ] Performance testing for concurrent users (QA)

---

## 🚀 DevOps & Deployment

### CI/CD Pipeline
- [ ] Set up Azure DevOps project (DevOps)
- [ ] Create build pipeline for Next.js app (DevOps)
- [ ] Create build pipeline for Python functions (DevOps)
- [ ] Set up Terraform plan/apply pipeline (DevOps)
- [ ] Configure environment-specific deployments (DevOps)

### Environments
- [ ] Deploy dev environment (DevOps)
- [ ] Deploy staging environment (DevOps)
- [ ] Deploy production environment (DevOps)
- [ ] Configure environment promotion workflow (DevOps)

---

## 📦 Phase 2 - Ultimate (Future)

- [ ] Evaluate AI Avatar providers (D-ID, HeyGen, Azure) (Architect)
- [ ] Design avatar training data requirements (AI/ML)
- [ ] Plan Viva Learning integration architecture (Architect)
- [ ] Create short video generation pipeline design (Architect)

---

## 📝 Review Tasks

- [ ] Review generated architecture diagrams (Architect)
- [ ] Review Terraform modules for best practices (DevOps Lead)
- [ ] Review API documentation for completeness (Dev Lead)
- [ ] Security review of all infrastructure (Security Lead)
- [ ] Review business case with stakeholders (PM)
