# SharePoint Sync Feature

## Overview

Real-time synchronization between SharePoint document libraries and the CLP Knowledge Base ensures that the AI chatbot always has access to the latest approved content.

## User Stories

### US-020: Automatic Content Sync
**As a** content manager  
**I want** documents uploaded to SharePoint to automatically appear in the knowledge base  
**So that** I don't need to manually import content

### US-021: Version Updates
**As a** user  
**I want** to always see the latest version of documents  
**So that** I don't reference outdated procedures

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SHAREPOINT                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  Document Library: "CLP Knowledge Base"                                     │
│  ├── /Training Videos/                                                      │
│  ├── /Technical Manuals/                                                    │
│  ├── /HR Policies/                                                          │
│  └── /Safety Procedures/                                                    │
└──────────────────────────────────┬──────────────────────────────────────────┘
                                   │
                                   │ Webhook Event
                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AZURE LOGIC APP                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  Trigger: "When a file is created or modified"                             │
│  Actions:                                                                   │
│    1. Get file metadata                                                     │
│    2. Check file type (supported)                                          │
│    3. Send to processing queue                                             │
└──────────────────────────────────┬──────────────────────────────────────────┘
                                   │
                                   │ Queue Message
                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AZURE FUNCTION                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│  1. Download file from SharePoint                                          │
│  2. Extract text (PDF/Word/PPT)                                            │
│  3. Process video if applicable                                            │
│  4. Generate embeddings                                                     │
│  5. Update AI Search index                                                 │
│  6. Update metadata in Cosmos DB                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Logic App Configuration

### Trigger: SharePoint Connector

```json
{
  "type": "ApiConnection",
  "inputs": {
    "host": {
      "connection": {
        "name": "@parameters('$connections')['sharepointonline']['connectionId']"
      }
    },
    "method": "get",
    "path": "/datasets/@{encodeURIComponent(encodeURIComponent('https://clp.sharepoint.com/sites/KnowledgeBase'))}/triggers/onupdatedfile"
  },
  "recurrence": {
    "frequency": "Minute",
    "interval": 1
  }
}
```

### Supported Events

| Event | Action |
|-------|--------|
| File Created | Full processing and indexing |
| File Modified | Re-process and update index |
| File Deleted | Remove from index, archive metadata |
| File Moved | Update source path in metadata |

## Document Type Handlers

### PDF Documents

```python
from azure.ai.formrecognizer import DocumentAnalysisClient

def extract_pdf_content(blob_url: str) -> dict:
    client = DocumentAnalysisClient(
        endpoint=os.getenv("FORM_RECOGNIZER_ENDPOINT"),
        credential=DefaultAzureCredential()
    )
    
    poller = client.begin_analyze_document_from_url("prebuilt-read", blob_url)
    result = poller.result()
    
    return {
        "text": " ".join([page.content for page in result.pages]),
        "page_count": len(result.pages),
        "tables": extract_tables(result)
    }
```

### Word Documents

```python
from docx import Document

def extract_word_content(file_path: str) -> dict:
    doc = Document(file_path)
    paragraphs = [para.text for para in doc.paragraphs]
    
    return {
        "text": "\n".join(paragraphs),
        "headings": extract_headings(doc),
        "tables": extract_tables(doc)
    }
```

### PowerPoint

```python
from pptx import Presentation

def extract_pptx_content(file_path: str) -> dict:
    prs = Presentation(file_path)
    slides = []
    
    for slide_num, slide in enumerate(prs.slides, 1):
        text = []
        for shape in slide.shapes:
            if hasattr(shape, "text"):
                text.append(shape.text)
        slides.append({
            "slide_number": slide_num,
            "content": "\n".join(text)
        })
    
    return {"slides": slides}
```

## Metadata Extraction

Each document gets rich metadata:

```json
{
  "id": "doc-abc123",
  "filename": "K2-Maintenance-Manual.pdf",
  "source_url": "sharepoint://sites/KnowledgeBase/Technical%20Manuals/K2-Maintenance-Manual.pdf",
  "content_type": "application/pdf",
  "department": "technical",
  "version": 3,
  "created_at": "2025-06-15T10:00:00Z",
  "modified_at": "2026-01-10T14:30:00Z",
  "created_by": "john.smith@clp.com.hk",
  "modified_by": "jane.doe@clp.com.hk",
  "page_count": 45,
  "word_count": 12500,
  "tags": ["K2", "turbine", "maintenance", "calibration"],
  "status": "active",
  "retention_until": "2036-01-10T00:00:00Z"
}
```

## Version Control

1. **Version Tracking** - Each modification creates new version
2. **Index Update** - Old version marked inactive, new version indexed
3. **Audit Trail** - All changes logged to Cosmos DB
4. **Rollback** - Admin can revert to previous version

## Folder Structure Mapping

| SharePoint Folder | Department | Agent |
|-------------------|------------|-------|
| /Training Videos/ | All | General |
| /Technical Manuals/ | Technical | Tech Agent |
| /HR Policies/ | HR | HR Agent |
| /Safety Procedures/ | Legal | Legal Agent |
| /Calibration Guides/ | Technical | Tech Agent |

## Error Handling

| Error | Recovery |
|-------|----------|
| Connection timeout | Retry with exponential backoff |
| File locked | Queue for retry in 5 minutes |
| Unsupported format | Log warning, skip file |
| Extraction failure | Flag for manual review |

## Monitoring

### Metrics Dashboard
- Files processed per hour
- Processing success rate
- Average processing time
- Queue depth
- Error rate by type

### Alerts
- Processing queue > 100 items
- Error rate > 5%
- No files processed in 1 hour