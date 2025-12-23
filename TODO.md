# Some SuperApp — Cross-Platform TODO and Source of Truth

Authoritative plan for iOS and Android to keep features, screens, and data consistent. This app demonstrates agentic coding patterns with native mobile stacks.

## Read First
- See [README.md](README.md) for top-level overview
- See [docs/REQUIREMENTS.md](docs/REQUIREMENTS.md) and [docs/MVP.md](docs/MVP.md)
- See [docs/TECH_STACK.md](docs/TECH_STACK.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

## Goals (Phase 1)
- Parity Todo feature on iOS and Android with local persistence
- Consistent screens and UX across platforms
- Clean architecture: UI models decoupled from persistence

Non-goals (Phase 1): Cloud sync, accounts, remote APIs. We’ll evaluate later.

## Screens & Flows
1) Dashboard
   - Lists available features as cards (initially: Todo)
   - Tap Todo card → navigates to Todo List

2) Todo List
   - Displays user’s todos
   - Create new todo
   - Edit and delete existing todos
   - Toggle completion
   - Sorting: default by creation time (desc). Nice-to-have: by due date.
   - Empty state with guidance CTA

3) Todo Detail
   - Shows fields: title (required), description (opt), due date (opt), location (opt), completed
   - Edit, delete, and toggle completion

4) Add/Edit Todo
   - Title is required; validate non-empty
   - Optional fields: description, due date, location
   - Save/cancel flows

## Data Model (Shared Concept)
Entity: Todo
- id: UUID (unique, app-scoped)
- title: String (required)
- description: String? (optional)
- dueDate: Date? (optional)
- location: optional structure (see Open Questions)
- isCompleted: Bool
- createdAt: Date
- updatedAt: Date

Notes
- Use value types as UI-facing models to avoid direct NSManagedObject/Room entity usage in views.
- Prefer immutable UI models with copy-on-write style updates from ViewModels.

## Platform Implementations

### iOS (current)
- UI: SwiftUI
- Persistence: Core Data (`TodoItem` entity)
- View-layer model: `TodoData` struct (decouples views from NSManagedObject)
- Sync: CloudKit planned later (requires enrolled account; currently not enabled)

### Android (target for parity)
- UI: Jetpack Compose + Navigation Compose
- Persistence: Room (SQLite)
  - `TodoEntity` (Room), `TodoDao`, `AppDatabase`
  - Mappers between `TodoEntity` and UI model `Todo`
- Architecture: MVVM + Repository + Coroutines/Flow
  - `TodoRepository` exposes `Flow<List<Todo>>` and CRUD suspend functions
  - ViewModels use `StateFlow`/`MutableStateFlow` for UI state
- DI: Optional Hilt later; start with manual wiring for MVP

## Sync & Cloud (Future Evaluation)
- CloudKit: iOS-only; good privacy; account required
- Realm Sync: cross-platform but paid for sync at scale
- Firebase Firestore: cross-platform, generous free tier, offline cache
- Serverless (e.g., Supabase): viable if backend features expand

Decision for MVP: Local-only. Re-evaluate sync after core UX is stable on both platforms.

## Acceptance Criteria
- Dashboard lists features and links to Todo flow on both platforms
- Todo List shows items; supports add, edit, delete, toggle complete
- Title required; optional fields persist when provided
- UI model decoupled from persistence layer on both platforms
- No crashes when items are deleted/edited; list updates reactively
- Basic unit tests for data and ViewModel layers

## Android Implementation Plan (Phase 1)
1. Data layer
   - Define `TodoEntity(id: UUID, title, description?, dueDate?, location?, isCompleted, createdAt, updatedAt)`
   - Create `TodoDao` with CRUD + paging-friendly list queries
   - Create `AppDatabase` with Room, version 1
   - Add mappers: `TodoEntity` ⇄ UI `Todo`

2. Repository
   - `TodoRepository` with `Flow<List<Todo>>` and `suspend` CRUD by id
   - Business rules: ensure title non-empty; maintain `updatedAt`; set defaults

3. ViewModels
   - `TodoListViewModel`: state (`List<Todo>`, filters), intents (add, toggle, delete)
   - `TodoDetailViewModel`: state for a single `Todo`, intents (update, delete)

4. Navigation & UI
   - Navigation graph: Dashboard → TodoList → TodoDetail/Edit → back
   - Compose screens: DashboardCard(Todo), TodoListScreen, TodoDetailScreen, AddEditTodoSheet/Screen
   - Material3 theme (replace temporary platform theme)
   - Empty, loading, and error UI (local errors only)

5. Testing
   - Unit tests: repository CRUD (in-memory Room), ViewModel intents/state
   - UI tests: basic navigation and add/edit/toggle smoke path

6. Polish
   - Migrations strategy (N/A for v1)
   - App icons and theming
   - Accessibility: content descriptions, focus, dynamic type

## iOS Parity Notes
- Continue using `TodoData` as UI model; keep Core Data concerns out of views
- Consider SwiftData in future if project aligns
- CloudKit integration tracked separately; not required for MVP

## Open Questions
- Location field format: keep it simple initially
  - Option A: human-readable place name (String)
  - Option B: `latitude: Double`, `longitude: Double`, plus `placeName: String?`
- Time zone handling for `dueDate` (store as UTC; render local)
- ID type on Android: prefer `UUID` stored as `TEXT` (or two `BLOB`/`LONG` parts) for symmetry with iOS

## Backlog (Checklist)
- [ ] Android: Room schema (Entity/Dao/Database)
- [ ] Android: Repository with Flow + CRUD
- [ ] Android: ViewModels and UI models
- [ ] Android: Navigation graph
- [ ] Android: Compose screens (Dashboard, TodoList, TodoDetail, Add/Edit)
- [ ] Android: Material3 theme + app icon
- [ ] Android: Unit tests (Repo, ViewModels)
- [ ] Android: UI tests (smoke)
- [ ] iOS: Validate current flows match acceptance criteria
- [ ] Sync: Evaluate CloudKit/Firestore/Realm after MVP
