# {{PROJECT_NAME}}

> Brief one-line description of the project

**Status**: Planning | Development | Production  
**Started**: {{DATE}}

---

## Overview

Brief description of what this project does and who it's for.

**Key Features**:
- Feature 1
- Feature 2
- Feature 3

**Documentation**:
- [Requirements](docs/REQUIREMENTS.md) - Original requirements and constraints
- [MVP](docs/MVP.md) - MVP scope and user stories
- [Tech Stack](docs/TECH_STACK.md) - Technology decisions
- [Architecture](docs/ARCHITECTURE.md) - System design and patterns
- [Infrastructure](docs/INFRASTRUCTURE.md) - Deployment and CI/CD

---

## Quick Start

### Prerequisites
- Node.js 20+ (or relevant stack)
- Package manager (pnpm, npm, yarn)
- Docker (for local development)
- (Add other requirements)

### Installation

```bash
# Clone repository
git clone https://github.com/{{GITHUB_USERNAME}}/{{REPO_NAME}}.git
cd {{REPO_NAME}}

# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env
# Edit .env with your configuration
```

### Development

```bash
# Start development server
pnpm dev

# Run tests
pnpm test

# Run linter
pnpm lint
```

### Docker (Alternative)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Project Structure

```
{{REPO_NAME}}/
├── apps/                      # Front-facing applications
│   ├── server/               # Backend API
│   ├── frontend/             # Web frontend
│   └── mobile/               # Mobile app
├── packages/                  # Shared code
│   ├── core/                 # Platform-agnostic logic
│   ├── features/             # Feature modules
│   └── services/             # Service abstractions
├── docs/                      # Documentation
├── scripts/                   # Build/deploy scripts
└── .github/
    ├── workflows/            # CI/CD pipelines
    └── copilot-instructions.md
```

---

## Development Workflow

### Branch Naming
Format: `<type>/#<issue>-<description>`

Examples:
- `feat/#42-user-authentication`
- `fix/#67-login-bug`
- `docs/#15-api-documentation`

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `build`, `ci`, `perf`, `revert`

### Commit Messages
Format: `<type>: <description> (#issue)`

Examples:
- `feat: Add user authentication (#42)`
- `fix: Resolve login timeout issue (#67)`
- `docs: Update API documentation (#15)`

### Pull Requests
- PR title must follow commit message format
- Include "Closes #issue" in PR description
- All checks must pass before merge
- Requires 1 approval

---

## Testing

### Unit Tests
```bash
pnpm test              # Run all tests
pnpm test:watch        # Watch mode
pnpm test:coverage     # With coverage report
```

### Integration Tests
```bash
pnpm test:integration  # Integration test suite
```

### E2E Tests
```bash
pnpm test:e2e         # End-to-end tests
```

---

## Deployment

### Environments
- **Development**: Local development with hot-reload
- **Test**: Ephemeral (Docker Compose / Testcontainers)
- **QA**: Pre-production testing environment
- **Production**: Live environment

### CI/CD Pipeline
- **PR**: Conventions check → Lint → Unit tests → Smoke tests
- **Main**: Full test suite → Build → Deploy to QA
- **Release**: Deploy to production

See [Infrastructure documentation](docs/INFRASTRUCTURE.md) for details.

---

## Contributing

1. Check existing issues or create new one
2. Create branch following naming convention
3. Make changes with tests
4. Commit following commit convention
5. Open PR with description linking issue
6. Address review feedback
7. Merge when approved and checks pass

See [Copilot Instructions](.github/copilot-instructions.md) for detailed guidelines.

---

## Tech Stack

**Backend**:
- Runtime/Language
- Framework
- Database

**Frontend**:
- Framework
- UI Library
- State Management

**Infrastructure**:
- Hosting
- CI/CD
- Monitoring

See [Tech Stack documentation](docs/TECH_STACK.md) for rationale and alternatives considered.

---

## License

{{LICENSE}} - See [LICENSE](LICENSE) file for details.

---

## Contact

**Maintainer**: {{MAINTAINER_NAME}}  
**GitHub**: [@{{GITHUB_USERNAME}}](https://github.com/{{GITHUB_USERNAME}})  
**Project Board**: [GitHub Project](https://github.com/users/{{GITHUB_USERNAME}}/projects/{{PROJECT_NUMBER}})
