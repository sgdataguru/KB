# Management Console Feature

## Overview

The Management Console is a Next.js web application that provides administrators with tools to manage the knowledge base, monitor processing pipelines, and view analytics.

## User Stories

### US-030: Document Management
**As an** administrator  
**I want** to view and manage all indexed documents  
**So that** I can ensure content quality

### US-031: Processing Status
**As a** content manager  
**I want** to see real-time processing status  
**So that** I know when new content is available

### US-032: Usage Analytics
**As a** manager  
**I want** to see which content is most accessed  
**So that** I can identify knowledge gaps

## Features

### 1. Dashboard
- Total documents indexed
- Processing queue status
- Recent activity feed
- System health indicators

### 2. Document Management
- List all documents with filters
- Search by title, content, or metadata
- View document details and versions
- Mark documents as deprecated
- Manually trigger re-processing

### 3. Processing Monitor
- Real-time pipeline status
- Processing history
- Error log viewer
- Manual retry capabilities

### 4. Analytics
- Query volume over time
- Most accessed documents
- Top search queries
- Knowledge gap identification
- User activity tracking

### 5. Access Audit
- User query history
- Document access logs
- Export audit reports

## UI Components

### Gaming Aesthetic Theme

Following the project design guidelines:

```css
/* Primary Colors */
--bg-dark: #0a0a0a;
--bg-card: #1a1a1a;
--neon-cyan: #00f0ff;
--neon-purple: #cc00ff;
--neon-green: #00ff88;
```

### Key Components

#### Status Card
```tsx
interface StatusCardProps {
  title: string;
  value: number | string;
  trend?: 'up' | 'down' | 'stable';
  icon: React.ReactNode;
}

export function StatusCard({ title, value, trend, icon }: StatusCardProps) {
  return (
    <div className="bg-gray-900 border border-cyan-500/30 rounded-lg p-6 
                    hover:shadow-[0_0_20px_rgba(0,240,255,0.2)] transition-all">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-400 text-sm">{title}</p>
          <p className="text-2xl font-bold text-white">{value}</p>
        </div>
        <div className="text-cyan-400">{icon}</div>
      </div>
    </div>
  );
}
```

#### Document Table
```tsx
interface Document {
  id: string;
  title: string;
  department: string;
  status: 'active' | 'processing' | 'error';
  lastModified: Date;
  version: number;
}

export function DocumentTable({ documents }: { documents: Document[] }) {
  return (
    <table className="w-full">
      <thead className="bg-gray-800 text-cyan-400">
        <tr>
          <th>Title</th>
          <th>Department</th>
          <th>Status</th>
          <th>Version</th>
          <th>Last Modified</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {documents.map(doc => (
          <DocumentRow key={doc.id} document={doc} />
        ))}
      </tbody>
    </table>
  );
}
```

## Page Structure

```
/app
├── page.tsx                 # Dashboard
├── documents/
│   ├── page.tsx            # Document list
│   └── [id]/page.tsx       # Document detail
├── processing/
│   ├── page.tsx            # Processing queue
│   └── history/page.tsx    # Processing history
├── analytics/
│   ├── page.tsx            # Analytics dashboard
│   └── queries/page.tsx    # Query analytics
├── audit/
│   └── page.tsx            # Audit log viewer
└── settings/
    └── page.tsx            # System settings
```

## API Integration

### Document List
```typescript
// GET /api/documents
interface DocumentListResponse {
  documents: Document[];
  total: number;
  page: number;
  pageSize: number;
}

async function fetchDocuments(params: {
  page?: number;
  department?: string;
  status?: string;
  search?: string;
}): Promise<DocumentListResponse> {
  const response = await fetch('/api/documents?' + new URLSearchParams(params));
  return response.json();
}
```

### Processing Status
```typescript
// GET /api/processing/status
interface ProcessingStatus {
  queueDepth: number;
  processing: number;
  completed24h: number;
  failed24h: number;
  jobs: ProcessingJob[];
}
```

## Authentication

- Azure AD integration via NextAuth.js
- Role-based UI rendering
- Protected API routes

### Roles
| Role | Permissions |
|------|-------------|
| Admin | Full access |
| Content Manager | Document management, no settings |
| Viewer | Read-only analytics access |
| Auditor | Read-only audit access |

## Deployment

Deployed as Azure App Service (Node.js):
- Next.js production build
- Environment variables from Key Vault
- Azure AD authentication configured
- Application Insights monitoring