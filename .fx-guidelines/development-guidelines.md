# fx-shell Development Guidelines for Claude Code

## Module Development Pattern

Each module must be self-contained with:
- README.md documenting API and usage
- src/ with implementation
- reference/ with adaptation examples from other projects
- tests/ with unit and integration tests
- examples/ with usage demonstrations

## Code Organization Rules

### QML Naming Conventions
- Components: PascalCase (e.g., `StatusBar.qml`)
- Properties: camelCase (e.g., `currentWorkspace`)
- Signals: camelCase with verb prefix (e.g., `onWorkspaceChanged`)
- Private members: underscore prefix (e.g., `_internalState`)

### Service Pattern
- Services are singleton QtObjects
- Register with ServiceRegistry on Component.onCompleted
- Communicate via EventBus for decoupling
- Never direct import between services

### Testing Requirements
- Unit tests for all service logic
- Integration tests for compositor interactions
- Minimum 80% coverage target

## Reference Material Usage

When implementing features, ALWAYS consult reference implementations:

1. **DankMaterialShell** (`/references/DankMaterialShell/`)
   - Complete widget implementations
   - Use as code template library

2. **Noctalia** (`/references/noctalia-shell/`)
   - Architecture patterns
   - CompositorService abstraction
   - Event system design

3. **dgop** (`/references/dgop/`)
   - IPC communication patterns
   - Event-driven architecture

## Module Reference Structure

Each module should include reference/ directory:

```
modules/feature/
├── src/              # Implementation
├── reference/
│   ├── noctalia/     # Noctalia patterns
│   ├── dms/          # DankMaterialShell examples
│   └── notes.md      # Adaptation notes
└── tests/
```
