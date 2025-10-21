# QuickShell Best Practices

## Component Structure

### Standard Component Pattern
```qml
import QtQuick

Item {
    id: root

    // Public API (exposed properties)
    property string title
    property bool enabled: true

    // Public signals
    signal clicked()
    signal valueChanged(real value)

    // Private properties (underscore prefix)
    property real _internalState: 0

    // Child components
    Rectangle {
        // ...
    }

    // Functions
    function publicMethod() {
        // Public API
    }

    function _privateMethod() {
        // Internal only
    }
}
```

## Singleton Services

### Service Pattern
```qml
pragma Singleton
import QtQuick

QtObject {
    id: service

    // Service state
    property var items: []
    property bool ready: false

    // Initialization
    Component.onCompleted: {
        ServiceRegistry.registerService("myService", this)
        initialize()
    }

    // Public API
    function doSomething() {
        // Implementation
    }

    // Private methods
    function _internalSetup() {
        // Private
    }
}
```

## Reference Projects Usage

### DankMaterialShell Patterns
Located at `/references/DankMaterialShell/`

**When to use:**
- Implementing any widget from spec.md catalog
- Looking for complete working examples
- Understanding Material Design in QML

**How to adapt:**
1. Copy relevant widget from DMS
2. Adapt to fx-shell architecture
3. Replace DMS services with fx-shell services
4. Update imports to use fx-shell commons

### Noctalia Patterns
Located at `/references/noctalia-shell/`

**When to use:**
- Setting up service architecture
- Implementing compositor abstraction
- Building event system
- Configuration management

**How to adapt:**
1. Study the CompositorService abstraction
2. Adapt to Sway-specific IPC
3. Follow module organization pattern
4. Use EventBus pattern

### dgop IPC Patterns
Located at `/references/dgop/`

**When to use:**
- Implementing IPC communication
- Building event-driven services
- Message passing between components

## Testing Patterns

### Unit Test Template
```qml
import QtQuick
import QtTest

TestCase {
    name: "MyServiceTests"

    function init() {
        // Setup before each test
    }

    function cleanup() {
        // Teardown after each test
    }

    function test_basicFunctionality() {
        const service = ServiceRegistry.getService("myService")
        verify(service !== null)
        compare(service.property, expectedValue)
    }
}
```
