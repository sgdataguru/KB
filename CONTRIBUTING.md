# Contributing to CLP Knowledge Base

Thank you for your interest in contributing to CLP Knowledge Base! This document provides guidelines and best practices for contributing to this project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)

---

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Prioritize security and data privacy in all contributions
- Follow CLP's enterprise guidelines

---

## Getting Started

### Prerequisites

```bash
# Required tools
- Node.js 18+
- Python 3.11+
- Azure CLI
- Terraform 1.5+
- Git
```

### Local Setup

```bash
# Clone repository
git clone https://github.com/clp/clp-kb.git
cd clp-kb

# Install dependencies
./scripts/setup.sh

# Copy environment template
cp .env.example .env

# Start development server
npm run dev
```

---

## Development Workflow

### Branch Naming Convention

```
feature/[ticket-id]-short-description
bugfix/[ticket-id]-short-description
hotfix/[ticket-id]-short-description
docs/[ticket-id]-short-description
infra/[ticket-id]-short-description
```

### Workflow

1. Create a branch from `main`
2. Make your changes
3. Write/update tests
4. Submit a Pull Request to `main`
5. Address review comments
6. Merge after approval

---

## Coding Standards

### TypeScript/JavaScript (Next.js)

- Use TypeScript for all new files
- Follow the project's ESLint configuration
- Use functional components with hooks
- Define interfaces for all props
- Follow the gaming aesthetic design guidelines in `.github/docs/`

### Python (Azure Functions)

- Follow PEP 8 style guide
- Use type hints for all functions
- Write docstrings for public functions
- Use `black` for formatting
- Use `pylint` for linting

### Terraform

- Use consistent naming: `snake_case` for resources
- Add descriptions to all variables
- Use modules for reusable components
- Tag all resources with project metadata

---

## Commit Messages

Follow conventional commits format:

```
type(scope): subject

body (optional)

footer (optional)
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `infra`: Infrastructure changes

### Examples

```
feat(chatbot): add timestamp linking for video responses

fix(pipeline): handle empty transcripts gracefully

docs(api): update authentication documentation

infra(terraform): add Azure AI Search module
```

---

## Pull Request Process

### Before Submitting

- [ ] Code compiles without errors
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] No sensitive data or credentials
- [ ] Follows coding standards

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Infrastructure

## Testing
Describe testing performed

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes
```

### Review Process

1. At least 1 approval required
2. All CI checks must pass
3. No unresolved comments
4. Security review for infrastructure changes

---

## Testing Guidelines

### Unit Tests

```bash
# Run Python tests
pytest tests/unit/

# Run TypeScript tests
npm run test
```

### Integration Tests

```bash
# Run integration tests
pytest tests/integration/
```

### Test Coverage

- Aim for >80% coverage on new code
- Critical paths must have 100% coverage

---

## Security Guidelines

- Never commit credentials or secrets
- Use Azure Key Vault for sensitive configuration
- Follow least-privilege principle
- Report security issues privately

---

## Questions?

Contact the development team or create an issue for clarification.
