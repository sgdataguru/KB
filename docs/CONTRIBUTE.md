# Documentation Contribution Guide

This guide explains how to contribute to the CLP Knowledge Base documentation.

## Documentation Structure

```
docs/
├── index.md              # Main documentation index
├── CONTRIBUTE.md         # This file
├── admin/               # Administration docs
│   └── permissions.md   # Access control documentation
├── architecture/        # System design docs
│   └── overview.md      # Architecture overview
├── features/            # Feature specifications
│   ├── rag-chatbot.md
│   ├── video-processing.md
│   ├── sharepoint-sync.md
│   ├── management-console.md
│   ├── ai-avatar.md
│   └── multi-agent.md
├── infra/              # Infrastructure docs
└── project-context/    # Business context
    ├── business-case.md
    └── tech-stack.md
```

## Writing Guidelines

### Markdown Standards
- Use ATX-style headers (`#`, `##`, `###`)
- Include a table of contents for long documents
- Use code blocks with language specification
- Add alt text to images

### Naming Conventions
- Use lowercase with hyphens: `feature-name.md`
- Be descriptive but concise
- Match feature names to actual implementation

### Content Structure

Each feature document should include:
1. **Overview** - What the feature does
2. **User Stories** - Who uses it and why
3. **Technical Details** - How it works
4. **API Reference** - Endpoints and parameters
5. **Configuration** - Settings and options
6. **Examples** - Usage examples

## Diagram Standards

Use PlantUML for architecture diagrams:
- Store `.puml` files in `docs/architecture/`
- Generate PNG/SVG for inclusion in markdown
- Keep diagrams up-to-date with code changes

## Review Process

1. Create a PR with documentation changes
2. Request review from tech writer or subject matter expert
3. Address feedback
4. Merge after approval

## Tools

- **Markdown Editor**: VS Code with Markdown Preview
- **Diagrams**: PlantUML extension
- **Spell Check**: Code Spell Checker extension
