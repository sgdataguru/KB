# Operations Architecture

## Document Information

| Attribute | Value |
|-----------|-------|
| Project | CLP AI Knowledge Management Platform |
| Version | 1.0 |
| Date | January 14, 2026 |
| Status | Draft |

---

## 1. Overview

This document defines the operational architecture for the CLP AI Knowledge Management Platform, including monitoring, alerting, disaster recovery, CI/CD pipelines, and cost optimization strategies.

---

## 2. Monitoring Architecture

### 2.1 Monitoring Stack

| Component | Purpose | Retention |
|-----------|---------|-----------|
| Azure Monitor | Infrastructure metrics | 93 days |
| Application Insights | Application telemetry | 90 days |
| Log Analytics | Centralized logging | 30 days |
| Azure Alerts | Proactive notification | N/A |

### 2.2 Application Insights Configuration

| Setting | Value |
|---------|-------|
| Workspace Mode | Workspace-based |
| Sampling | Adaptive (100% for errors) |
| Live Metrics | Enabled |
| Profiler | Enabled |
| Snapshot Debugger | Enabled |

### 2.3 Key Metrics

**Application Metrics**

| Metric | Source | Threshold |
|--------|--------|-----------|
| Request duration | App Insights | P95 < 500ms |
| Failed requests | App Insights | < 1% |
| Dependency duration | App Insights | P95 < 200ms |
| Exception rate | App Insights | < 0.1% |

**Infrastructure Metrics**

| Metric | Source | Threshold |
|--------|--------|-----------|
| CPU utilization | Azure Monitor | < 80% |
| Memory utilization | Azure Monitor | < 85% |
| Cosmos DB RU consumption | Azure Monitor | < 80% of provisioned |
| AI Search query latency | Azure Monitor | P95 < 100ms |

### 2.4 Custom Metrics

| Metric | Description | Unit |
|--------|-------------|------|
| queries_processed | Total RAG queries | Count |
| documents_indexed | Documents processed | Count |
| embedding_latency | Embedding generation time | Milliseconds |
| search_relevance_score | Average search score | 0-1 |

---

## 3. Alerting Strategy

### 3.1 Alert Severity Levels

| Severity | Response Time | Notification |
|----------|---------------|--------------|
| Sev 0 - Critical | 15 minutes | PagerDuty + SMS + Email |
| Sev 1 - High | 1 hour | PagerDuty + Email |
| Sev 2 - Medium | 4 hours | Email + Teams |
| Sev 3 - Low | 24 hours | Email |

### 3.2 Alert Rules

**Critical Alerts (Sev 0)**

| Alert | Condition | Action |
|-------|-----------|--------|
| Service Down | Availability < 99% for 5 min | Page on-call |
| Data Loss Risk | Cosmos DB unavailable | Page on-call |
| Security Breach | Defender critical alert | Page security + on-call |

**High Alerts (Sev 1)**

| Alert | Condition | Action |
|-------|-----------|--------|
| High Error Rate | Failed requests > 5% for 10 min | Notify team |
| Performance Degradation | P95 latency > 2s for 15 min | Notify team |
| Resource Exhaustion | RU consumption > 90% | Notify team |

**Medium Alerts (Sev 2)**

| Alert | Condition | Action |
|-------|-----------|--------|
| Elevated Errors | Failed requests > 1% for 30 min | Create ticket |
| Processing Backlog | Queue depth > 100 for 1 hour | Create ticket |
| Certificate Expiry | Cert expires in < 30 days | Create ticket |

### 3.3 Alert Action Groups

| Group | Members | Channels |
|-------|---------|----------|
| ag-critical | On-call rotation | PagerDuty, SMS, Email |
| ag-platform | Platform team | Email, Teams |
| ag-security | Security team | Email, Teams |

---

## 4. Logging Architecture

### 4.1 Log Categories

| Category | Sources | Retention |
|----------|---------|-----------|
| Application logs | App Insights, Functions | 30 days |
| Security logs | Azure AD, Defender | 2 years |
| Audit logs | Activity Log, Diagnostic | 90 days |
| Infrastructure logs | Azure Monitor | 30 days |

### 4.2 Log Analytics Queries

**Error Investigation**

```kusto
AppExceptions
| where TimeGenerated > ago(1h)
| summarize count() by ProblemId, outerMessage
| order by count_ desc
```

**Performance Analysis**

```kusto
AppRequests
| where TimeGenerated > ago(24h)
| summarize 
    avg(DurationMs), 
    percentile(DurationMs, 95),
    percentile(DurationMs, 99)
  by bin(TimeGenerated, 1h)
```

**User Activity**

```kusto
AppTraces
| where TimeGenerated > ago(7d)
| where Message contains "query"
| summarize count() by bin(TimeGenerated, 1d)
```

### 4.3 Workbooks

| Workbook | Purpose |
|----------|---------|
| Platform Health | Overall system status |
| User Analytics | Query patterns and usage |
| Error Analysis | Error trends and root cause |
| Cost Tracking | Resource consumption |

---

## 5. Disaster Recovery

### 5.1 Recovery Objectives

| Metric | Target | Justification |
|--------|--------|---------------|
| RTO (Recovery Time Objective) | 4 hours | Business tolerance |
| RPO (Recovery Point Objective) | 1 hour | Data importance |
| MTTR (Mean Time to Recovery) | 2 hours | Operational capability |

### 5.2 Backup Strategy

| Resource | Backup Type | Frequency | Retention |
|----------|-------------|-----------|-----------|
| Cosmos DB | Continuous | Continuous | 7 days |
| AI Search Index | Index rebuild | N/A (rebuild from source) | N/A |
| Blob Storage | Soft delete + versioning | On change | 30 days |
| Key Vault | Soft delete | On change | 90 days |
| App Configuration | Export | Daily | 30 days |

### 5.3 Recovery Procedures

**Cosmos DB Recovery**

1. Identify point-in-time for recovery
2. Use Azure Portal to initiate restore
3. Create new container from backup
4. Update connection strings
5. Verify data integrity
6. Switch traffic to restored database

**AI Search Recovery**

1. Trigger full reindex from Cosmos DB
2. Monitor indexer progress
3. Validate search functionality
4. Update DNS/routing if needed

### 5.4 DR Testing Schedule

| Test Type | Frequency | Scope |
|-----------|-----------|-------|
| Backup verification | Monthly | All backups |
| Component failover | Quarterly | Individual services |
| Full DR drill | Annual | Complete recovery |

---

## 6. CI/CD Pipeline

### 6.1 Pipeline Architecture

```
GitHub Repository
    |
    v
[Pull Request] --> [Build & Test] --> [Security Scan]
    |                                       |
    v                                       v
[Code Review] <----------------------- [Quality Gates]
    |
    v
[Merge to main]
    |
    v
[Build Pipeline]
    |
    +---> [Unit Tests]
    +---> [Integration Tests]
    +---> [Security Scan]
    |
    v
[Deploy to Dev]
    |
    v
[Smoke Tests]
    |
    v
[Deploy to Staging]
    |
    v
[E2E Tests]
    |
    v
[Manual Approval]
    |
    v
[Deploy to Production]
    |
    v
[Health Checks]
```

### 6.2 Build Pipeline (azure-pipelines.yml)

| Stage | Jobs | Duration |
|-------|------|----------|
| Build | Compile, Lint, Test | ~5 min |
| Security | SAST, Dependency scan | ~3 min |
| Package | Docker build, Artifact | ~2 min |
| **Total** | | **~10 min** |

### 6.3 Release Pipeline

| Environment | Trigger | Approval | Tests |
|-------------|---------|----------|-------|
| Dev | Automatic (main) | None | Smoke |
| Staging | Automatic | None | E2E |
| Production | Manual | Required | Health |

### 6.4 Infrastructure Pipeline (Terraform)

| Stage | Action | Approval |
|-------|--------|----------|
| Plan | terraform plan | Auto |
| Review | Manual inspection | Required |
| Apply | terraform apply | Required |
| Verify | Health checks | Auto |

### 6.5 Quality Gates

| Gate | Threshold | Blocking |
|------|-----------|----------|
| Code coverage | > 80% | Yes |
| Security vulnerabilities | 0 critical/high | Yes |
| Lint errors | 0 | Yes |
| Performance regression | < 10% | Warning |

---

## 7. Cost Optimization

### 7.1 Cost Allocation

| Resource Group | Purpose | Budget |
|----------------|---------|--------|
| rg-clp-kb-prod | Production | $1,200/month |
| rg-clp-kb-dev | Development | $300/month |

### 7.2 Cost Optimization Strategies

**Compute Optimization**

| Strategy | Implementation | Savings |
|----------|----------------|---------|
| Right-sizing | Monitor and adjust SKUs | 20-30% |
| Auto-scaling | Scale based on demand | 15-25% |
| Reserved instances | 1-year commitment (future) | 30-40% |

**Storage Optimization**

| Strategy | Implementation | Savings |
|----------|----------------|---------|
| Lifecycle policies | Auto-tier to cool/archive | 40-60% |
| Compression | Compress stored content | 30-50% |
| Deduplication | Remove duplicate chunks | Variable |

**AI Service Optimization**

| Strategy | Implementation | Savings |
|----------|----------------|---------|
| Batch processing | Batch embedding requests | 20-30% |
| Caching | Cache frequent queries | 30-40% |
| Model selection | Use appropriate model size | Variable |

### 7.3 Cost Monitoring

| Report | Frequency | Recipients |
|--------|-----------|------------|
| Daily spend | Daily | Platform team |
| Weekly summary | Weekly | Tech lead |
| Monthly analysis | Monthly | Management |
| Budget alerts | Real-time | All stakeholders |

### 7.4 Budget Alerts

| Threshold | Action |
|-----------|--------|
| 50% of budget | Email notification |
| 75% of budget | Teams alert + review |
| 90% of budget | Escalation + action required |
| 100% of budget | Emergency review |

---

## 8. Performance Tuning

### 8.1 Application Performance

| Area | Optimization | Target |
|------|--------------|--------|
| API Response | Response caching | < 200ms |
| Search | Query optimization | < 100ms |
| Embedding | Batch processing | < 500ms/batch |
| Database | Index optimization | < 50ms |

### 8.2 Database Tuning

**Cosmos DB Optimization**

| Setting | Recommendation |
|---------|----------------|
| Partition key | High cardinality (documentId) |
| Indexing policy | Selective indexing |
| Query patterns | Point reads preferred |
| Consistency | Session (default) |

**AI Search Optimization**

| Setting | Recommendation |
|---------|----------------|
| Index fields | Minimal filterable fields |
| Vector dimensions | 1536 (ada-002) |
| Search mode | Hybrid (vector + keyword) |
| Top-K | 5-10 results |

### 8.3 Caching Strategy

| Cache Layer | Implementation | TTL |
|-------------|----------------|-----|
| Response cache | Redis (future) | 5 min |
| Embedding cache | In-memory | 1 hour |
| Search results | Not cached | N/A |

---

## 9. Runbooks

### 9.1 Incident Response

| Step | Action | Owner |
|------|--------|-------|
| 1 | Acknowledge alert | On-call |
| 2 | Assess impact | On-call |
| 3 | Communicate status | On-call |
| 4 | Diagnose root cause | Platform team |
| 5 | Implement fix | Platform team |
| 6 | Verify resolution | On-call |
| 7 | Post-incident review | All |

### 9.2 Common Operations

| Operation | Frequency | Automation |
|-----------|-----------|------------|
| Certificate renewal | Annual | Manual |
| Secret rotation | As needed | Semi-auto |
| Index rebuild | On demand | Manual |
| Backup verification | Monthly | Automated |
| Security patching | Monthly | Semi-auto |

### 9.3 Escalation Matrix

| Severity | L1 Response | L2 Escalation | L3 Escalation |
|----------|-------------|---------------|---------------|
| Critical | 15 min | 30 min | 1 hour |
| High | 1 hour | 2 hours | 4 hours |
| Medium | 4 hours | 8 hours | 24 hours |
| Low | 24 hours | 48 hours | 1 week |

---

## 10. SLA Commitments

### 10.1 Service Level Objectives

| Metric | Target | Measurement |
|--------|--------|-------------|
| Availability | 99.5% | Monthly |
| Query latency (P95) | < 2 seconds | Daily |
| Indexing latency | < 15 minutes | Per document |
| Error rate | < 1% | Daily |

### 10.2 Maintenance Windows

| Type | Schedule | Duration | Notification |
|------|----------|----------|--------------|
| Planned | Weekends, 2-6 AM HKT | 4 hours max | 1 week advance |
| Emergency | As needed | Minimal | Immediate |
| Updates | Monthly | 1 hour | 3 days advance |

---

## Related Documents

- [Architecture Overview](../../../docs/architecture/overview.md)
- [Security & Governance](../../../docs/architecture/security-governance.md)
- [Component Specifications](component-specifications.md)
- [Network Security](network-security.md)
