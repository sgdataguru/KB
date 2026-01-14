# Multi-Agent System Feature

## Overview

The Multi-Agent System enables specialized AI agents for different departments (HR, Legal, Technical), each with domain-specific knowledge and response patterns, all managed through Azure AI Foundry.

## User Stories

### US-050: Department-Specific Responses
**As a** junior technician  
**I want** answers tailored to my department  
**So that** I get relevant, context-aware information

### US-051: Agent Governance
**As an** administrator  
**I want** to monitor and control agent behavior  
**So that** I can ensure compliance and safety

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AZURE AI FOUNDRY                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         ORCHESTRATOR                                 │   │
│  │                                                                      │   │
│  │  • Query Classification                                              │   │
│  │  • Agent Selection                                                   │   │
│  │  • Response Aggregation                                              │   │
│  │  • Fallback Handling                                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                              │                                              │
│       ┌──────────────────────┼──────────────────────┐                      │
│       ▼                      ▼                      ▼                      │
│  ┌─────────────┐       ┌─────────────┐       ┌─────────────┐              │
│  │  HR AGENT   │       │ LEGAL AGENT │       │ TECH AGENT  │              │
│  ├─────────────┤       ├─────────────┤       ├─────────────┤              │
│  │ Knowledge:  │       │ Knowledge:  │       │ Knowledge:  │              │
│  │ • Training  │       │ • Safety    │       │ • Equipment │              │
│  │ • Onboarding│       │ • Compliance│       │ • Manuals   │              │
│  │ • Benefits  │       │ • Procedures│       │ • Calibration│             │
│  │ • Policies  │       │ • Regulations│      │ • Maintenance│             │
│  └─────────────┘       └─────────────┘       └─────────────┘              │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      GOVERNANCE LAYER                                │   │
│  │                                                                      │   │
│  │  • Content Filtering                                                 │   │
│  │  • Hallucination Detection                                           │   │
│  │  • Response Validation                                               │   │
│  │  • Audit Logging                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Agent Definitions

### HR Agent

**System Prompt:**
```
You are an HR Knowledge Assistant for CLP. You help employees with:
- Training program information
- Onboarding procedures
- Employee benefits and policies
- Leave and attendance queries
- Career development resources

Guidelines:
- Always reference official HR policies
- Direct sensitive queries to HR department
- Maintain confidentiality
- Use friendly, supportive tone
```

**Knowledge Scope:**
- Employee handbook
- Training catalog
- Benefits documentation
- HR policies
- Onboarding checklists

### Legal Agent

**System Prompt:**
```
You are a Legal & Compliance Assistant for CLP. You help with:
- Safety regulations and procedures
- Compliance documentation
- Standard operating procedures
- Regulatory requirements
- Incident reporting guidelines

Guidelines:
- ALWAYS emphasize safety
- Reference specific regulation numbers
- Flag safety-critical procedures clearly
- Never provide legal advice - direct to Legal team
```

**Knowledge Scope:**
- Safety manuals
- Compliance checklists
- Regulatory documents
- Incident procedures
- Audit requirements

### Technical Agent

**System Prompt:**
```
You are a Technical Knowledge Assistant for CLP power generation. You help with:
- Equipment operation manuals
- Maintenance procedures
- Calibration guides
- Troubleshooting steps
- Technical specifications

Guidelines:
- Use technical terminology accurately
- Reference specific equipment models (K2, etc.)
- Include relevant timestamps for video content
- Flag safety warnings prominently
- Defer to supervisor for critical operations
```

**Knowledge Scope:**
- Equipment manuals
- Calibration procedures
- Maintenance schedules
- Technical training videos
- Troubleshooting guides

## Query Classification

```python
from enum import Enum

class Department(Enum):
    HR = "hr"
    LEGAL = "legal"
    TECHNICAL = "technical"
    GENERAL = "general"

def classify_query(query: str) -> Department:
    """Classify query to appropriate department agent."""
    
    classification_prompt = f"""
    Classify the following query into one of these departments:
    - HR: training, onboarding, benefits, policies, leave
    - LEGAL: safety, compliance, regulations, procedures, incidents
    - TECHNICAL: equipment, maintenance, calibration, troubleshooting
    - GENERAL: does not fit specific department
    
    Query: {query}
    
    Respond with only the department name.
    """
    
    response = openai_client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": classification_prompt}],
        temperature=0
    )
    
    department = response.choices[0].message.content.strip().lower()
    return Department(department)
```

## Agent Selection Logic

```python
async def route_to_agent(query: str, user_context: dict) -> AgentResponse:
    # 1. Classify query
    department = classify_query(query)
    
    # 2. Get user's department preference
    user_department = user_context.get("department")
    
    # 3. Select agent
    if department == Department.GENERAL and user_department:
        # Default to user's department for general queries
        agent = agents[user_department]
    else:
        agent = agents[department]
    
    # 4. Execute agent with governance
    with governance_context():
        response = await agent.execute(query, user_context)
    
    # 5. Validate response
    validated = await validate_response(response, department)
    
    return validated
```

## Governance Controls

### Content Filtering
- PII detection and redaction
- Profanity filtering
- Off-topic detection

### Hallucination Prevention
- Citation requirement enforcement
- Confidence scoring
- "I don't know" threshold

### Safety-Critical Content
- Special handling for safety procedures
- Mandatory disclaimers
- Escalation triggers

## Configuration

```json
{
  "agents": {
    "hr": {
      "model": "gpt-4",
      "temperature": 0.3,
      "max_tokens": 1500,
      "knowledge_filter": "department:HR",
      "response_template": "hr_template"
    },
    "legal": {
      "model": "gpt-4",
      "temperature": 0.1,
      "max_tokens": 2000,
      "knowledge_filter": "department:Legal",
      "response_template": "legal_template",
      "safety_critical": true
    },
    "technical": {
      "model": "gpt-4",
      "temperature": 0.1,
      "max_tokens": 2000,
      "knowledge_filter": "department:Technical",
      "response_template": "technical_template",
      "jargon_enabled": true
    }
  },
  "governance": {
    "citation_required": true,
    "confidence_threshold": 0.7,
    "safety_warnings": true,
    "audit_all_queries": true
  }
}
```

## Monitoring & Analytics

### Per-Agent Metrics
- Query volume
- Response latency
- User satisfaction
- Citation accuracy
- Fallback rate

### Governance Metrics
- Blocked responses
- Hallucination flags
- Safety escalations
- Audit alerts