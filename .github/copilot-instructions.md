# Project Copilot Instructions (Template)

> AI guidance for working on THIS project.

## Read First
1. README.md (overview, quick start)
2. docs/REQUIREMENTS.md (original requirements)
3. docs/MVP.md (features & acceptance criteria)
4. docs/TECH_STACK.md (choices & rationale)
5. docs/ARCHITECTURE.md (structure & patterns)
6. docs/INFRASTRUCTURE.md (deployment & CI/CD)

## Conventions
- Branch: `<type>/#<issue>-<short-hyphenated-desc>`
- Commit: `<type>: #<issue> [<Platform> - ] <description>`
- PR title: `<type>: #<issue> [<Platform> - ] <description>`
  - Issue number required
  - Platform optional but preferred (Backend, Web, Mobile, iOS, Android)
  - Start with capital letter, no period at end, use imperative mood
- PR body: Testing notes, risks, rollback plan

### ⚠️ CRITICAL: Commit Policy

**DO NOT AUTO-COMMIT OR AUTO-PUSH.**

- ❌ Never run `git commit` or `git push` unless the user **explicitly requests it**
- ❌ Never commit within a time window (e.g., "within 30 mins") without explicit approval in **this conversation**
- ✅ Default behavior: Make file edits, propose changes, but **always pause and ask for permission before committing**
- ✅ When explicitly authorized: Use commit conventions from [rules/git-workflow.md](../../rules/git-workflow.md)

**Exception**: Only commit if the user says something like "go ahead and commit this" or "authorize 10 minutes to commit changes" in the current message.

## Task Creation (Projects v2)
To add tasks to the project board:
1. Create GitHub Issue: `gh issue create --repo [owner/repo] --title "[Platform] Task Title" --body "..."` 
2. Assign label: `gh issue edit [issue-number] --repo [owner/repo] --add-label [label]` (e.g., feat, fix, docs, chore)
3. Assign milestone: `gh issue edit [issue-number] --repo [owner/repo] --milestone "MVP-1.0.0"` (or latest milestone)
4. Add to Project: `gh project item-add [project-number] --owner [owner] --url [issue-url]`
5. Use issue number (#N) in branch names and commits

### When Starting a Task
1. Create branch: `git checkout -b <type>/#<issue>-<short-desc>` (follow branch naming convention)
2. Move to In Progress: Use Project UI or `gh api graphql` to set Status field to "In Progress"
3. Implement incrementally; commit and push regularly

Note: Draft project items (without issues) require the Project UI; CLI cannot create them.

## Workflow
- Build incrementally; follow MVP priorities
- Use rules in starter-kit `rules/` as baseline; adapt minimally
- Keep docs updated as decisions evolve

## Common Commands (fill per project)
- Install:
- Dev:
- Test:
- Lint/Format:
- Build:
- Deploy:

## Where Things Live
- docs/: reference materials
- backend/, frontend/, mobile/: code by component
- .github/: workflows, templates
