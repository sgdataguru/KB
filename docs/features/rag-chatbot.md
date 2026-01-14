# RAG Chatbot Feature

## Overview

The RAG (Retrieval Augmented Generation) Chatbot is the core feature of CLP Knowledge Base. It enables junior staff to ask natural language questions and receive accurate, cited answers from the approved knowledge base.

## User Stories

### US-001: Ask a Question
**As a** junior technician  
**I want to** ask questions in natural language  
**So that** I can quickly find answers without searching through documents

### US-002: Video Timestamp Navigation
**As a** trainee  
**I want to** be directed to specific timestamps in training videos  
**So that** I can watch only the relevant portion

### US-003: Source Citations
**As a** user  
**I want to** see the source of each answer  
**So that** I can verify the information and access the original document

## Technical Implementation

### Architecture

```
User Query → Query Embedding → Vector Search → Context Retrieval → LLM Generation → Response + Citations
```

### Components

1. **Query Processing**
   - Convert user question to embedding
   - Extract keywords for hybrid search
   - Classify query for agent routing

2. **Retrieval**
   - Semantic search in Azure AI Search
   - Hybrid search (vector + keyword)
   - Top-K relevant chunks retrieved

3. **Generation**
   - Grounded response using GPT-4
   - System prompt enforces citation requirement
   - Temperature set to 0.1 for factual responses

4. **Response Formatting**
   - Markdown formatting for readability
   - Clickable citations with source links
   - Video timestamps as deep links

## API Endpoints

### POST /api/chat

**Request:**
```json
{
  "query": "How do I calibrate the K2 turbine?",
  "session_id": "uuid",
  "department": "technical"
}
```

**Response:**
```json
{
  "answer": "To calibrate the K2 turbine, follow these steps...",
  "citations": [
    {
      "title": "K2 Turbine Maintenance Manual",
      "source": "sharepoint://documents/manuals/k2-turbine.pdf",
      "page": 45,
      "relevance": 0.95
    }
  ],
  "video_timestamps": [
    {
      "title": "K2 Calibration Training",
      "url": "sharepoint://videos/training/k2-calibration.mp4",
      "timestamp": "00:15:30",
      "duration": "00:05:00"
    }
  ],
  "confidence": 0.92
}
```

## Configuration

### System Prompt Template

```
You are a knowledge assistant for CLP. Your role is to help junior staff 
find information from the approved knowledge base.

Rules:
1. ONLY answer based on the provided context
2. ALWAYS cite your sources
3. If unsure, say "I don't have information about that"
4. Include video timestamps when relevant
5. Use industry terminology correctly (refer to jargon dictionary)
```

### Grounding Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| Temperature | 0.1 | Low for factual accuracy |
| Max Tokens | 2000 | Limit response length |
| Top-P | 0.95 | Nucleus sampling |
| Top-K Results | 5 | Number of retrieved chunks |

## Jargon Dictionary

Custom technical terms are handled via a jargon dictionary:

```json
{
  "K2": "Kawasaki Model 2 Gas Turbine",
  "TPS": "Turbine Protection System",
  "DCS": "Distributed Control System"
}
```

## Error Handling

| Scenario | Response |
|----------|----------|
| No relevant content found | "I couldn't find information about [topic] in the knowledge base" |
| Ambiguous query | "Could you please clarify if you're asking about [option A] or [option B]?" |
| Out of scope | "This question is outside my knowledge area. Please contact [department]" |

## Metrics

- Query response time (target: <3 seconds)
- Citation accuracy rate
- User satisfaction score
- Query volume by department