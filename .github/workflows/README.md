# GitHub Actions Workflow Templates

Generic, reusable GitHub Actions workflows extracted from real projects. These enforce conventions and automate project management.

---

## Available Workflows

### 1. PR Conventions Check (`pr-conventions.yml`)

**Purpose**: Validates that PRs and branches follow Conventional Commits standards.

**Triggers**: On PR opened/synchronized/reopened/edited

**Checks**:
- ✅ PR title follows: `<type>: #<issue> [<Platform> - ] <Description>`
- ✅ Branch name follows: `<type>/#<issue>-<description>`
- ✅ Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- ✅ Platform is optional but preferred for multi-component projects

**Required**: Yes - enforces project conventions

**Setup**: Copy as-is, no customization needed

---

### 2. Add Issue to Project (`project-add-issue.yml`)

**Purpose**: Automatically adds newly created issues to a GitHub Project board.

**Triggers**: When issues are opened

**Setup**:
1. Replace `{{GITHUB_USERNAME}}` with your GitHub username
2. Replace `{{PROJECT_NUMBER}}` with your project number
3. Create a Personal Access Token (classic) with `project` and `repo` scopes
4. Add as repository secret: `ADD_TO_PROJECT_PAT`

**Example**:
```yaml
project-url: https://github.com/users/patterueldev/projects/5
```

---

### 3. Update Status on PR Ready for Review (`project-pr-review.yml`)

**Purpose**: Automatically moves project items to "In Review" status when PR is marked ready for review.

**Triggers**: When PR transitions from draft to ready for review

**Setup**:
1. Replace `{{REPO_NAME}}` with repository name (e.g., `smart-pocket-js`)
2. Replace `{{PROJECT_TITLE}}` with exact project board title
3. Requires `ADD_TO_PROJECT_PAT` secret (same as above)
4. Project must have "In Review" status option

**Note**: Requires custom Status field with "In Review" option (set manually in Project UI)

---

### 4. Update Status on PR Merged (`project-pr-merged.yml`)

**Purpose**: Automatically moves project items to "QA/Testing" or "Done" when PR is merged.

**Triggers**: When PR is closed and merged

**Logic**:
- Regular branches → "QA/Testing" status
- Release branches (`release/*`) → "Done" status

**Setup**:
1. Replace `{{REPO_NAME}}` with repository name
2. Replace `{{PROJECT_TITLE}}` with exact project board title
3. Requires `ADD_TO_PROJECT_PAT` secret
4. Project must have "QA/Testing" and "Done" status options

---

## Setup Guide

### Prerequisites

All project automation workflows require:

1. **Personal Access Token (PAT)**
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token with scopes: `project`, `repo`
   - Copy the token

2. **Add as Repository Secret**
   - Go to repository Settings → Secrets and variables → Actions
   - New repository secret: `ADD_TO_PROJECT_PAT`
   - Paste the token

3. **GitHub Project Board**
   - Create a GitHub Project (Projects v2)
   - Note the project number from URL: `github.com/users/<user>/projects/<NUMBER>`
   - Customize Status field options in Project settings:
     - Todo (default)
     - In Progress (default)
     - Blocked
     - In Review
     - QA/Testing
     - Done (default)

### Installation

1. Copy desired workflows to `.github/workflows/` in your project
2. Replace all placeholders:
   - `{{GITHUB_USERNAME}}` → your GitHub username
   - `{{PROJECT_NUMBER}}` → your project number
   - `{{REPO_NAME}}` → repository name
   - `{{PROJECT_TITLE}}` → exact project title
3. Commit and push
4. Workflows activate automatically

---

## Workflow Dependencies

```
Issue Created → Add to Project (project-add-issue.yml)
                     ↓
              [Todo status]
                     ↓
PR Opened ────────────────────→ Conventions Check (pr-conventions.yml)
                     ↓
PR Ready for Review → In Review (project-pr-review.yml)
                     ↓
              [In Review status]
                     ↓
PR Merged ─────────→ QA/Testing or Done (project-pr-merged.yml)
```

---

## Customization

### Adding More Commit Types

Edit `pr-conventions.yml`:
```yaml
types: |
  feat
  fix
  hotfix  # Add custom type
  ...
```

Also update branch validation pattern in same file.

### Changing Status Names

If your project uses different status names:
1. Update status strings in `project-pr-review.yml` and `project-pr-merged.yml`
2. Match exactly what's in your Project board settings

### Adjusting Release Logic

In `project-pr-merged.yml`, modify the logic:
```javascript
const branchName = context.payload.pull_request.head.ref;
const isRelease = branchName.startsWith('release/'); // Customize this
```

---

## Testing

After setup:
1. Create a test issue → Should appear in project board
2. Create a PR with wrong title → Should fail conventions check
3. Create a PR with correct format → Should pass
4. Mark PR ready for review → Status should update to "In Review"
5. Merge PR → Status should update to "QA/Testing" or "Done"

---

## Troubleshooting

### "Status field not found"
- Ensure your project has a field named exactly "Status"
- This is the default field in GitHub Projects v2

### "In Review option not found"
- Go to Project Settings → Status field → Add "In Review" option
- CLI cannot add custom status options; must be done in UI

### "Issue not linked to any project"
- Workflow only updates items already in the project
- Ensure `project-add-issue.yml` is working first

### Token permission errors
- Regenerate PAT with correct scopes: `project`, `repo`
- Update `ADD_TO_PROJECT_PAT` secret in repository

---

## Related Documentation

- [Git Workflow Rules](../../rules/git-workflow.md) - Explains convention rationale
- [Project Status Workflow](../../docs/PROJECT-STATUS-WORKFLOW.md) - Status transition flow
- [CAPABILITIES.md](../../CAPABILITIES.md) - Testing log and CLI limitations

---

## Source

These templates are extracted from production workflows in:
- [smart-pocket-js](../../projects/smart-pocket-js/.github/workflows/)

Generalized for reuse across different project types.
