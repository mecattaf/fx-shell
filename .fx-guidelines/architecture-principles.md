# fx-shell Architecture Principles

## Service-Oriented Architecture

### Core Principles
1. **Services own their state** - No duplicated state
2. **EventBus for communication** - Loose coupling
3. **ServiceRegistry for discovery** - Dependency injection
4. **Modular boundaries** - Clean separation of concerns

### Service Lifecycle
```qml
QtObject {
    id: myService

    Component.onCompleted: {
        ServiceRegistry.registerService("myService", this)
        // Initialize
    }

    Component.onDestruction: {
        ServiceRegistry.unregisterService("myService")
        // Cleanup
    }
}
```

## Cross-Module Communication

### Direct Imports (AVOID)
❌ Don't: `import "../services/audio"`

### Service Registry Pattern (PREFERRED)
✅ Do:
```qml
property var audioService: ServiceRegistry.getService("audio")
```

### Event Bus Pattern (PREFERRED)
✅ Do:
```qml
Connections {
    target: EventBus
    function onAudioVolumeChanged(volume) {
        // Handle event
    }
}
```

## State Management

### Service State
Services manage their own state and emit changes via EventBus:
```qml
QtObject {
    id: audioService
    property real volume: 0.5

    onVolumeChanged: {
        EventBus.emit("audio:volume", volume)
    }
}
```

### UI State
UI components subscribe to service state:
```qml
Item {
    property real volume: ServiceRegistry.getService("audio").volume
}
```

## Error Handling

### Graceful Degradation
Non-critical features should degrade gracefully:
```qml
property var service: ServiceRegistry.getService("optional")

function doOptionalThing() {
    if (service) {
        service.action()
    } else {
        console.warn("Optional service not available")
    }
}
```

### User-Visible Errors
Use notification system for errors:
```qml
function handleError(error) {
    EventBus.emit("notification:show", {
        title: "Error",
        message: error.message,
        type: "error"
    })
}
```

## Performance Guidelines

### Lazy Loading
Load modules on-demand:
```qml
Loader {
    id: heavyModule
    active: false
    source: "HeavyModule.qml"
}
```

### Property Bindings
Use efficiently:
```qml
// ❌ Avoid complex expressions in bindings
width: Math.max(parent.width * 0.5, minimumWidth) + padding * 2

// ✅ Break into computed properties
property real baseWidth: parent.width * 0.5
property real effectiveWidth: Math.max(baseWidth, minimumWidth)
width: effectiveWidth + padding * 2
```

### Signal Connections
Minimize signal connections:
```qml
// ❌ Multiple connections
Connections {
    target: service
    function onProperty1Changed() {}
}
Connections {
    target: service
    function onProperty2Changed() {}
}

// ✅ Single connection
Connections {
    target: service
    function onProperty1Changed() {}
    function onProperty2Changed() {}
}
```
