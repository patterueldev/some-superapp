# Templates

Templates and scaffolding for new projects using this methodology.

---

## Contents

### Documentation Templates (`docs/`)
- **REQUIREMENTS.md** - Captured requirements from gathering conversation
- **MVP.md** - MVP scope, user stories, priorities
- **TECH_STACK.md** - Technology decisions with rationale
- **ARCHITECTURE.md** - System design, patterns, structure
- **INFRASTRUCTURE.md** - Deployment, CI/CD, environments

### GitHub Configuration (`.github/`)
- **copilot-instructions.md** - AI agent instructions template
- **workflows/** - Reusable GitHub Actions workflows

### Project README
- **README.md** - Project overview template

---

## GitHub Actions Workflows

Pre-built workflows for PR conventions, project automation, and CI/CD:

- **pr-conventions.yml** - Validates PR titles and branch names
- **project-add-issue.yml** - Auto-adds issues to project board
- **project-pr-review.yml** - Updates status to "In Review"
- **project-pr-merged.yml** - Updates status to "QA/Testing" or "Done"

See [.github/workflows/README.md](.github/workflows/README.md) for detailed setup instructions.

---

## Usage

These templates are used by the project initialization scripts in `scripts/`:
- `init-project.sh` - Creates new project from templates
- `generate-project-docs.sh` - Generates documentation

Templates use placeholders that get replaced during initialization:
- `{{PROJECT_NAME}}` - Project name
- `{{GITHUB_USERNAME}}` - GitHub username
- `{{PROJECT_NUMBER}}` - GitHub Project number
- `{{REPO_NAME}}` - Repository name
- `{{PROJECT_TITLE}}` - Project board title

---

## Customization

After copying templates to a new project:
1. Replace all placeholders with actual values
2. Customize workflows for project-specific needs
3. Remove unused templates
4. Add project-specific sections

---

## Evolution

Templates improve through usage. After each project:
- Document what worked/didn't in [METHODOLOGY.md](../METHODOLOGY.md)
- Update templates based on learnings
- Remove unused sections
- Add newly discovered patterns
