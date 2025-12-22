# Project Initialization Checklist

> **Purpose**: Track setup tasks for this project from requirements through initial commit. Remove once initial structure is finalized and first commit is pushed.

**Project**: some-superapp  
**Started**: 2025-12-23  
**Status**: 🔄 In Progress

---

## Phase 1: Requirements & Planning

- [ ] **Requirements Gathering**: Clarify purpose, users, core MVP features
  - Document in `docs/REQUIREMENTS.md`
  - Link to requirements conversation
- [ ] **MVP Definition**: Define 3-5 core features and explicit non-goals
  - Create `docs/MVP.md` with user stories and acceptance criteria
  - Prioritize by risk and value
- [ ] **Success Criteria**: Define what "done" looks like
  - Add to MVP or REQUIREMENTS

---

## Phase 2: Tech & Architecture

- [ ] **Tech Stack Decision**: Choose languages, frameworks, databases, hosting
  - Document rationale in `docs/TECH_STACK.md`
  - Note trade-offs and alternatives considered
- [ ] **Architecture Design**: Outline system components and data flow
  - Sketch in `docs/ARCHITECTURE.md`
  - Define folder structure and key patterns
- [ ] **First Slice Planning**: Identify minimal feature to validate core flow
  - Use as proof-of-concept for tech choices

---

## Phase 3: Infrastructure & Setup

- [ ] **Deployment Strategy**: Where will this live? (Cloud, VPS, Vercel, etc.)
  - Document in `docs/INFRASTRUCTURE.md`
- [ ] **CI/CD Pipeline**: Define what runs on PR and after merge
  - Copy/customize GitHub Actions workflows
- [ ] **Local Development Setup**: Devbox/environment isolation
  - Add `devbox.json` and environment detector script
  - Document in README
- [ ] **Repository Configuration**: Branch protection, PR templates, status checks
  - Enable branch protection if automation ready

---

## Phase 4: Documentation

- [ ] **README.md**: Project overview, quick start, key links
  - Reference other docs (REQUIREMENTS, MVP, TECH_STACK, ARCHITECTURE, INFRASTRUCTURE)
- [ ] **.github/copilot-instructions.md**: AI guidance for working on this project
  - Apply personal rules from starter-kit
  - Include workflow, patterns, common commands
- [ ] **docs/REQUIREMENTS.md**: Original requirements (from Phase 1)
- [ ] **docs/MVP.md**: MVP scope, user stories, priorities (from Phase 1)
- [ ] **docs/TECH_STACK.md**: Tech choices + rationale (from Phase 2)
- [ ] **docs/ARCHITECTURE.md**: System design, patterns, folder structure (from Phase 2)
- [ ] **docs/INFRASTRUCTURE.md**: Deployment, CI/CD, environments (from Phase 3)
- [ ] **.gitignore**: Language/framework-specific ignore patterns

---

## Phase 5: Initial Commit

- [ ] **Code Scaffold**: Framework/template setup (if applicable)
  - "Hello world" deployed to staging, or
  - Basic project structure with core dependencies installed
- [ ] **All docs complete**: No placeholders; all reference docs filled
- [ ] **Tests passing**: Basic test setup (even if just empty suite)
- [ ] **Linting/formatting**: Configured and passing
- [ ] **Git workflow ready**: Branch protection, PR template, commit conventions in place
- [ ] **Copilot instructions finalized**: AI knows how to work on this project

---

## Phase 6: Commit & Handoff

- [ ] **Initial commit created**: All setup work committed
  - Message: `Initial project setup with requirements, MVP, tech stack, architecture, and scaffolding`
- [ ] **Push to origin**: All changes synced to GitHub
- [ ] **Remove this checklist**: Delete INITIAL-SETUP-CHECKLIST.md (or archive in commit message)
- [ ] **Create backlog/issues**: Break MVP into deliverable tasks
  - Add to GitHub Projects v2 board (if set up)
- [ ] **Retrospective note**: Capture what went well, what was awkward, what's missing
  - Keep as `docs/WORKING_NOTES.md` or similar for iteration notes

---

## Notes & Decisions

*(Add comments, blockers, or decisions as you go)*

---

## Related Documents

- `docs/REQUIREMENTS.md` — Original requirements
- `docs/MVP.md` — MVP scope and user stories
- `docs/TECH_STACK.md` — Tech choices and rationale
- `docs/ARCHITECTURE.md` — System design and patterns
- `docs/INFRASTRUCTURE.md` — Deployment and CI/CD
- `.github/copilot-instructions.md` — AI guidance for this project
- `README.md` — Project overview and quick start
