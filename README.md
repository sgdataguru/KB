# CLP Knowledge Base (clp-kb)

> AI-Powered Knowledge Management Platform for CLP Hong Kong

## 🎯 Project Overview

CLP Knowledge Base is an enterprise AI solution designed to solve the industry-wide challenge of **knowledge transfer** from senior experts to the next generation of workers. The platform leverages RAG (Retrieval Augmented Generation) architecture to transform video training content, technical documents, and Teams recordings into an intelligent, searchable knowledge repository.

### Key Capabilities

- **🤖 AI-Powered Q&A Chatbot** - Natural language search with precise timestamp navigation
- **📹 Video Intelligence** - Automatic transcription and semantic indexing of training videos
- **🎭 AI Avatar (Phase 2)** - Text-to-speech avatar for interactive classroom training
- **🏢 Multi-Agent Architecture** - Specialized agents for HR, Legal, and Technical departments
- **🔒 Enterprise AI Governance** - Azure AI Foundry for model behavior monitoring

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    VoltAI Marketplace Frontend                  │
│                   (Q&A-style Agent Interface)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                     Azure AI Foundry                            │
│              (Multi-Agent Orchestration & Governance)           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ HR Agent    │  │ Legal Agent │  │ Tech Agent  │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    RAG Pipeline                                 │
├─────────────────────────────────────────────────────────────────┤
│  Azure OpenAI ◄─► Azure AI Search ◄─► Vector Database          │
└─────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────┐
│                 Data Ingestion Pipeline                         │
├─────────────────────────────────────────────────────────────────┤
│  SharePoint Sync │ Teams Recordings │ Azure Speech Services    │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
clp-kb/
├── README.md                 # This file
├── CONTRIBUTING.md           # Contribution guidelines
├── TODO.md                   # Project task tracking
├── requirements.txt          # Python dependencies
├── docs/                     # Project documentation
│   ├── admin/               # Permissions & access docs
│   ├── architecture/        # Architecture diagrams
│   ├── features/            # Feature specifications
│   ├── infra/               # Infrastructure overview
│   └── project-context/     # Business context docs
├── data/                     # Data definitions
│   ├── schemas/             # JSON Schema, Avro definitions
│   ├── sample-data/         # Test datasets
│   └── migrations/          # Database migrations
├── src/                      # Source code
│   ├── notebooks/           # Data processing notebooks
│   ├── pipelines/           # Data pipeline scripts
│   ├── serverless/          # Azure Functions
│   └── docs/                # Code documentation
├── tests/                    # Test suites
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── infra/                    # Terraform infrastructure
│   ├── modules/             # Reusable Terraform modules
│   ├── environments/        # Environment-specific configs
│   └── docs/                # Infrastructure docs
├── DevOps/                   # CI/CD configuration
│   ├── pipeline/            # Azure DevOps pipelines
│   └── docs/                # DevOps documentation
└── app/                      # Next.js Management Console
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Python 3.11+
- Azure CLI
- Terraform 1.5+

### Installation

```bash
# Clone the repository
git clone https://github.com/clp/clp-kb.git
cd clp-kb

# Run setup script
./scripts/setup.sh

# Start development server
npm run dev
```

## 🔐 Security & Compliance

- **Data Residency**: Azure Hong Kong Region (East Asia)
- **AI Governance**: Azure AI Foundry for model monitoring
- **Access Control**: Enterprise RBAC with audit logging
- **Retention**: 7-10 year policy for safety/technical documentation
- **Compliance**: Hong Kong utility-sector data privacy standards

## 📊 Phases

### Phase 1: MVP (Current)
- [x] RAG-based knowledge retrieval
- [x] Video transcription with timestamps
- [x] SharePoint real-time sync
- [x] VoltAI Marketplace integration
- [ ] Management Console
- [ ] Teams Recording ingestion

### Phase 2: Ultimate
- [ ] AI Avatar for classroom training
- [ ] Multi-department specialized agents
- [ ] Short video generation
- [ ] Viva Learning integration

## 📝 Documentation

- [Business Case](docs/project-context/business-case.md)
- [Technical Stack](docs/project-context/tech-stack.md)
- [Architecture Overview](docs/architecture/overview.md)
- [Infrastructure Guide](infra/docs/README.md)

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is proprietary to CLP Holdings Limited.

---

**Project Target**: Early February 2026  
**Maintained by**: CLP Digital Team
