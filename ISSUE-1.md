# fx-shell: Initial Infrastructure Setup

**Issue #1: Establish Foundation & Core Architecture**  
**Phase:** Foundation (Week 1)  
**Priority:** Critical  
**Estimated Time:** 3-5 days

---

## Objectives

1. **Repository Structure:** Create the modular, LLM-optimized directory structure
2. **Reference Integration:** Link existing reference implementations for easy access
3. **Core Services Foundation:** Establish ServiceRegistry, EventBus, Config, and Theme singletons
4. **Development Tools:** Set up scripts for development, testing, and validation
5. **DankMaterialShell Integration:** Leverage DMS's extensible architecture as foundation

---

## Current Reference Material Status

Based on your repo map analysis:

| Project | Context size (be mindful)| Location | Key Usage |
|---------|-----------|----------|-----------|
| **noctalia-shell** | 4,039% | `/references/noctalia-shell/` | Primary architecture reference |
| **DankMaterialShell** | 974% | `/references/DankMaterialShell/` | Widget implementations |
| **end4-dots** | 489% | `/references/end4-dots/` | Innovative features |
| **DankMaterialShell-vantesh** | <1% | `/references/DankMaterialShell-vantesh/` | Real-world config |
| **shell (Caelestia)** | 174% | `/references/shell/` | Build patterns |
| **matshell** | 159% | `/references/matshell/` | AGS patterns |
| **Ax-Shell** | 143% | `/references/Ax-Shell/` | Feature catalog |
| **dgop** | 38% | `/references/dgop/` | IPC framework |
| **argyrodite** | 3% | `/references/argyrodite/` | Polkit agent |

---

## Step 1: Core Directory Structure

Create the modular architecture following spec.md:

```
fx-shell/
├── shell.qml                          # Main entry point
├── .fx-guidelines/                    # LLM development guidelines
│   ├── development-guidelines.md
│   ├── architecture-principles.md
│   ├── sway-integration-guide.md
│   └── quickshell-patterns.md
├── modules/
│   ├── core/                          # Essential services
│   │   ├── compositor/                # Sway IPC
│   │   ├── workspace/                 # Workspace management
│   │   ├── window/                    # Window management
│   │   └── events/                    # Event system
│   ├── services/                      # System integrations
│   │   ├── audio/
│   │   ├── network/
│   │   ├── power/
│   │   ├── bluetooth/
│   │   ├── notifications/
│   │   └── systemtray/
│   ├── ui/                            # UI components
│   │   ├── panels/
│   │   ├── widgets/
│   │   └── layouts/
│   ├── launchers/                     # Application launching
│   │   ├── app-launcher/
│   │   ├── command-runner/
│   │   └── window-switcher/
│   ├── utilities/                     # Desktop utilities
│   └── integrations/                  # External services
├── commons/                           # Shared infrastructure
│   ├── Config.qml
│   ├── Theme.qml
│   ├── Utils.qml
│   ├── ServiceRegistry.qml
│   └── EventBus.qml
├── assets/                            # Resources
│   ├── icons/
│   ├── fonts/
│   └── themes/
├── docs/                              # Documentation
│   ├── api/
│   ├── guides/
│   └── architecture/
├── scripts/                           # Build & dev tools
│   ├── dev-setup.sh
│   ├── build-debug.sh
│   ├── install-system.sh
│   └── validate-config.sh
├── tests/                             # Test suite
│   ├── unit/
│   ├── integration/
│   └── e2e/
└── references/                        # External reference repos
    ├── DankMaterialShell/
    ├── noctalia-shell/
    ├── dgop/
    └── [other references]/
```

---

## Step 2: LLM-Friendly Guidelines (.fx-guidelines/)

Create comprehensive development guidelines for Claude Code:

### development-guidelines.md
```markdown
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
```

### architecture-principles.md
```markdown
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
```

### sway-integration-guide.md
```markdown
# Sway Integration Guide

## IPC Protocol Overview

Sway uses i3-compatible binary IPC protocol:
- Magic string: `i3-ipc`
- Message format: `<magic><length><type><payload>`
- Little-endian byte order
- JSON payloads

## Critical Message Types

```javascript
const SWAY_MESSAGES = {
    RUN_COMMAND: 0,
    GET_WORKSPACES: 1,
    SUBSCRIBE: 2,
    GET_OUTPUTS: 3,
    GET_TREE: 4,
    GET_MARKS: 5,
    GET_BAR_CONFIG: 6,
    GET_VERSION: 7
};

const SWAY_EVENTS = {
    WORKSPACE: 0x80000000,
    OUTPUT: 0x80000001,
    MODE: 0x80000002,
    WINDOW: 0x80000003,
    BARCONFIG_UPDATE: 0x80000004,
    BINDING: 0x80000005,
    SHUTDOWN: 0x80000006
};
```

## Reference Implementation

See Waybar's Sway integration:
- `/references/waybar/src/modules/sway/`
- Production-tested IPC handling
- Complete event subscription

## Key Patterns

### Event Subscription
Always subscribe to events during initialization:
```qml
Component.onCompleted: {
    ipcHandler.subscribe([
        "workspace",
        "window",
        "output"
    ])
}
```

### Workspace Management
Sway workspaces are numbered/named per output:
```qml
function switchWorkspace(identifier) {
    // identifier can be number or name
    ipcHandler.runCommand(`workspace ${identifier}`)
}
```

### Window Tree Traversal
Use recursive traversal for window tree:
```qml
function extractWindows(tree) {
    var windows = []
    
    function traverse(node) {
        if (node.type === "con" && node.name) {
            windows.push(node)
        }
        if (node.nodes) node.nodes.forEach(traverse)
        if (node.floating_nodes) node.floating_nodes.forEach(traverse)
    }
    
    traverse(tree)
    return windows
}
```

## Debugging

### Test IPC Manually
```bash
# Get socket path
echo $SWAYSOCK

# Test with swaymsg
swaymsg -t get_tree
swaymsg -t get_workspaces
swaymsg -t subscribe '["workspace"]'

# Monitor with socat
socat - UNIX-CONNECT:$SWAYSOCK
```

### Common Issues
1. **Socket not found**: Check $SWAYSOCK environment
2. **Event not received**: Verify subscription array
3. **Command failed**: Check Sway logs with `journalctl -u sway`
```

### quickshell-patterns.md
```markdown
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
```

---

## Step 3: Core Commons Infrastructure

Create the foundational singletons that all modules depend on:

### 3.1 ServiceRegistry.qml
```qml
// commons/ServiceRegistry.qml
pragma Singleton
import QtQuick

QtObject {
    id: registry
    
    property var _services: ({})
    
    function registerService(name, service) {
        if (_services[name]) {
            console.warn(`[ServiceRegistry] Service '${name}' already registered, replacing`)
        }
        _services[name] = service
        console.log(`[ServiceRegistry] ✓ Registered: ${name}`)
    }
    
    function getService(name) {
        const service = _services[name]
        if (!service) {
            console.error(`[ServiceRegistry] Service '${name}' not found`)
            console.log(`[ServiceRegistry] Available services: ${Object.keys(_services).join(', ')}`)
        }
        return service
    }
    
    function unregisterService(name) {
        if (!_services[name]) {
            console.warn(`[ServiceRegistry] Service '${name}' not registered`)
            return
        }
        delete _services[name]
        console.log(`[ServiceRegistry] ✗ Unregistered: ${name}`)
    }
    
    function listServices() {
        return Object.keys(_services)
    }
    
    function hasService(name) {
        return _services.hasOwnProperty(name)
    }
}
```

### 3.2 EventBus.qml
```qml
// commons/EventBus.qml
pragma Singleton
import QtQuick

QtObject {
    id: eventBus
    
    // System events
    signal workspaceChanged(var workspace)
    signal windowFocused(var window)
    signal windowClosed(var window)
    signal outputAdded(var output)
    signal outputRemoved(var output)
    
    // UI events
    signal themeChanged(var theme)
    signal panelToggled(string panelId, bool visible)
    signal notificationReceived(var notification)
    
    // Service events
    signal audioVolumeChanged(real volume)
    signal networkStateChanged(string state)
    signal batteryLevelChanged(int level)
    signal brightnessChanged(real brightness)
    
    // Generic event emission
    function emit(eventName, data) {
        console.log(`[EventBus] Emitting: ${eventName}`)
        
        switch(eventName) {
            case "workspace:changed":
                workspaceChanged(data)
                break
            case "window:focused":
                windowFocused(data)
                break
            case "window:closed":
                windowClosed(data)
                break
            case "output:added":
                outputAdded(data)
                break
            case "output:removed":
                outputRemoved(data)
                break
            case "theme:changed":
                themeChanged(data)
                break
            case "panel:toggled":
                panelToggled(data.panelId, data.visible)
                break
            case "notification:received":
                notificationReceived(data)
                break
            case "audio:volume":
                audioVolumeChanged(data)
                break
            case "network:state":
                networkStateChanged(data)
                break
            case "battery:level":
                batteryLevelChanged(data)
                break
            case "brightness:changed":
                brightnessChanged(data)
                break
            default:
                console.warn(`[EventBus] Unknown event: ${eventName}`)
        }
    }
}
```

### 3.3 Config.qml
```qml
// commons/Config.qml
pragma Singleton
import QtQuick

QtObject {
    id: config
    
    // Theme configuration
    property string theme: "material-dark"
    property string accentColor: "#4285f4"
    property string fontFamily: "Inter"
    property int fontSize: 11
    
    // Panel configuration
    property var panels: ({
        statusBar: {
            enabled: true,
            position: "top",
            height: 32,
            modules: {
                left: ["workspaces", "window-title"],
                center: ["clock"],
                right: ["system-tray", "audio", "network", "battery"]
            }
        },
        dock: {
            enabled: false,
            position: "bottom",
            size: 48
        }
    })
    
    // Compositor configuration
    property string compositor: "sway"
    property string swaySocket: Qt.getenv("SWAYSOCK")
    
    // Service configuration
    property var services: ({
        audio: {
            backend: "pulseaudio",
            showPerAppVolume: true,
            mprisEnabled: true
        },
        network: {
            backend: "networkmanager",
            showVpn: true,
            autoConnect: true
        },
        power: {
            suspendOnLidClose: true,
            dimTimeout: 300,
            lockOnSuspend: true
        },
        notifications: {
            position: "top-right",
            maxVisible: 5,
            timeout: 5000
        }
    })
    
    // Launcher configuration
    property var launcher: ({
        fuzzySearch: true,
        maxResults: 10,
        iconTheme: "Papirus",
        categories: true
    })
    
    // User config override
    property var userConfig: ({})
    
    Component.onCompleted: {
        loadUserConfig()
    }
    
    function loadUserConfig() {
        const configPath = Qt.getenv("HOME") + "/.config/fx-shell/config.json"
        console.log(`[Config] Loading user config from: ${configPath}`)
        // TODO: Implement JSON loading
        // For now, use defaults
    }
    
    function get(path, defaultValue) {
        const parts = path.split(".")
        let value = this
        
        for (const part of parts) {
            if (value && value.hasOwnProperty(part)) {
                value = value[part]
            } else {
                console.warn(`[Config] Path '${path}' not found, using default`)
                return defaultValue
            }
        }
        
        return value !== undefined ? value : defaultValue
    }
    
    function set(path, value) {
        console.log(`[Config] Setting: ${path} = ${value}`)
        // TODO: Implement deep property setting
        // For now, just log
    }
}
```

### 3.4 Theme.qml
```qml
// commons/Theme.qml
pragma Singleton
import QtQuick

QtObject {
    id: theme
    
    // Color palette (Material Dark default)
    property color background: "#1e1e1e"
    property color surface: "#252525"
    property color surfaceVariant: "#2d2d2d"
    property color primary: Config.accentColor
    property color onPrimary: "#ffffff"
    property color secondary: "#03dac6"
    property color error: "#cf6679"
    property color text: "#ffffff"
    property color textSecondary: "#b0b0b0"
    property color border: "#3d3d3d"
    
    // Spacing system
    property int spacingTiny: 2
    property int spacingSmall: 4
    property int spacing: 8
    property int spacingMedium: 12
    property int spacingLarge: 16
    property int spacingXLarge: 24
    
    // Border radius
    property int radiusSmall: 4
    property int radius: 8
    property int radiusLarge: 12
    property int radiusXLarge: 16
    
    // Typography
    property string fontFamily: Config.fontFamily
    property int fontSizeTiny: 9
    property int fontSizeSmall: 10
    property int fontSize: Config.fontSize
    property int fontSizeMedium: 12
    property int fontSizeLarge: 14
    property int fontSizeXLarge: 16
    property int fontSizeHeading: 18
    property int fontSizeTitle: 24
    
    // Font weights
    property int fontWeightLight: Font.Light
    property int fontWeightNormal: Font.Normal
    property int fontWeightMedium: Font.Medium
    property int fontWeightBold: Font.Bold
    
    // Animations
    property int animationDurationFast: 100
    property int animationDuration: 200
    property int animationDurationSlow: 300
    property string animationEasing: "OutCubic"
    
    // Shadows
    property string shadowSmall: "0 2px 4px rgba(0,0,0,0.1)"
    property string shadow: "0 4px 8px rgba(0,0,0,0.15)"
    property string shadowLarge: "0 8px 16px rgba(0,0,0,0.2)"
    
    // Component-specific styles
    property var button: ({
        height: 32,
        padding: 12,
        paddingVertical: 8,
        backgroundColor: surface,
        backgroundColorHover: surfaceVariant,
        backgroundColorPressed: Qt.darker(surfaceVariant, 1.1),
        textColor: text
    })
    
    property var panel: ({
        backgroundColor: background,
        borderColor: border,
        borderWidth: 1,
        shadowEnabled: true,
        padding: spacing
    })
    
    property var input: ({
        height: 36,
        padding: 12,
        backgroundColor: surfaceVariant,
        borderColor: border,
        borderWidth: 1,
        focusBorderColor: primary
    })
    
    function loadTheme(themeName) {
        console.log(`[Theme] Loading theme: ${themeName}`)
        // TODO: Load theme from file
        // For now, use default Material Dark
    }
}
```

### 3.5 Utils.qml
```qml
// commons/Utils.qml
pragma Singleton
import QtQuick

QtObject {
    id: utils
    
    // String utilities
    function capitalizeFirst(str) {
        if (!str) return ""
        return str.charAt(0).toUpperCase() + str.slice(1)
    }
    
    function truncate(str, maxLength) {
        if (!str || str.length <= maxLength) return str
        return str.substring(0, maxLength - 3) + "..."
    }
    
    // Array utilities
    function unique(array) {
        return [...new Set(array)]
    }
    
    function sortBy(array, key) {
        return [...array].sort((a, b) => {
            const aVal = a[key]
            const bVal = b[key]
            if (aVal < bVal) return -1
            if (aVal > bVal) return 1
            return 0
        })
    }
    
    // Object utilities
    function deepClone(obj) {
        return JSON.parse(JSON.stringify(obj))
    }
    
    function merge(target, source) {
        const result = deepClone(target)
        for (const key in source) {
            if (source.hasOwnProperty(key)) {
                result[key] = source[key]
            }
        }
        return result
    }
    
    // Time utilities
    function formatTime(date, format24Hour) {
        const hours = date.getHours()
        const minutes = date.getMinutes()
        
        if (format24Hour) {
            return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`
        } else {
            const period = hours >= 12 ? 'PM' : 'AM'
            const hours12 = hours % 12 || 12
            return `${hours12}:${String(minutes).padStart(2, '0')} ${period}`
        }
    }
    
    function formatDate(date) {
        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        const months = ['January', 'February', 'March', 'April', 'May', 'June',
                       'July', 'August', 'September', 'October', 'November', 'December']
        
        return `${days[date.getDay()]}, ${months[date.getMonth()]} ${date.getDate()}`
    }
    
    // Number utilities
    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value))
    }
    
    function lerp(start, end, t) {
        return start + (end - start) * clamp(t, 0, 1)
    }
    
    // File utilities
    function getFileName(path) {
        return path.split('/').pop()
    }
    
    function getFileExtension(path) {
        const parts = path.split('.')
        return parts.length > 1 ? parts.pop() : ""
    }
    
    // Debug utilities
    function log(component, message, level) {
        const levels = {
            info: "ℹ️",
            warn: "⚠️",
            error: "❌",
            success: "✓"
        }
        const prefix = levels[level] || "•"
        console.log(`${prefix} [${component}] ${message}`)
    }
}
```

---

## Step 4: Minimal shell.qml Entry Point

```qml
// shell.qml
import QtQuick
import Quickshell

ShellRoot {
    id: root
    
    // Load commons (singletons auto-load, but be explicit for clarity)
    property var serviceRegistry: ServiceRegistry
    property var eventBus: EventBus
    property var config: Config
    property var theme: Theme
    property var utils: Utils
    
    Component.onCompleted: {
        console.log("════════════════════════════════════════")
        console.log("  fx-shell - QuickShell Desktop Shell")
        console.log("════════════════════════════════════════")
        console.log("")
        Utils.log("fx-shell", "Initializing infrastructure...", "info")
        
        // Verify commons loaded
        Utils.log("ServiceRegistry", `Loaded (${serviceRegistry ? "✓" : "✗"})`, 
                  serviceRegistry ? "success" : "error")
        Utils.log("EventBus", `Loaded (${eventBus ? "✓" : "✗"})`, 
                  eventBus ? "success" : "error")
        Utils.log("Config", `Loaded (${config ? "✓" : "✗"})`, 
                  config ? "success" : "error")
        Utils.log("Theme", `Loaded (${theme ? "✓" : "✗"})`, 
                  theme ? "success" : "error")
        Utils.log("Utils", `Loaded (${utils ? "✓" : "✗"})`, 
                  utils ? "success" : "error")
        
        console.log("")
        Utils.log("fx-shell", "Infrastructure initialized successfully", "success")
        console.log("════════════════════════════════════════")
        
        // TODO: Load core services
        // TODO: Load UI panels
    }
    
    // Minimal test window to verify QuickShell is working
    PanelWindow {
        id: testPanel
        
        anchors {
            top: true
            left: true
            right: true
        }
        
        height: 32
        
        Rectangle {
            anchors.fill: parent
            color: Theme.background
            
            Text {
                anchors.centerIn: parent
                text: "fx-shell infrastructure test - " + Utils.formatTime(new Date(), true)
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }
        }
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                testPanel.update()
            }
        }
    }
}
```

---

## Step 5: Development Scripts

### 5.1 dev-setup.sh
```bash
#!/bin/bash
# scripts/dev-setup.sh

set -e

echo "════════════════════════════════════════"
echo "  fx-shell Development Setup"
echo "════════════════════════════════════════"
echo ""

# Check dependencies
echo "Checking dependencies..."

command -v quickshell >/dev/null 2>&1 || {
    echo "❌ Error: quickshell not found"
    echo "Please install QuickShell first:"
    echo "  https://github.com/quickshell/quickshell"
    exit 1
}
echo "✓ QuickShell found: $(quickshell --version)"

command -v sway >/dev/null 2>&1 || {
    echo "⚠️  Warning: Sway not found"
    echo "fx-shell requires Sway compositor"
}
echo "✓ Sway found: $(sway --version)"

# Create config directory
CONFIG_DIR="${HOME}/.config/fx-shell"
echo ""
echo "Creating config directory: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
echo "✓ Config directory created"

# Link development shell.qml
echo ""
echo "Linking development shell.qml..."
ln -sf "$(pwd)/shell.qml" "${CONFIG_DIR}/shell.qml"
echo "✓ Development shell linked"

# Set up environment variables
echo ""
echo "Setting up environment..."
export FX_SHELL_DEV=1
export FX_SHELL_DEBUG=1
echo "✓ Environment configured"

# Create default config if it doesn't exist
if [ ! -f "${CONFIG_DIR}/config.json" ]; then
    echo ""
    echo "Creating default config..."
    cat > "${CONFIG_DIR}/config.json" <<EOF
{
  "theme": "material-dark",
  "accentColor": "#4285f4",
  "fontFamily": "Inter",
  "fontSize": 11,
  "compositor": "sway"
}
EOF
    echo "✓ Default config created"
fi

echo ""
echo "════════════════════════════════════════"
echo "  Development environment ready!"
echo "════════════════════════════════════════"
echo ""
echo "To start fx-shell in development mode:"
echo "  cd $(pwd)"
echo "  ./scripts/run-dev.sh"
echo ""
echo "Or manually:"
echo "  quickshell ./shell.qml"
echo ""
```

### 5.2 run-dev.sh
```bash
#!/bin/bash
# scripts/run-dev.sh

set -e

export FX_SHELL_DEV=1
export FX_SHELL_DEBUG=1
export QT_LOGGING_RULES="*.debug=true"

echo "════════════════════════════════════════"
echo "  Starting fx-shell in development mode"
echo "════════════════════════════════════════"
echo ""

quickshell ./shell.qml
```

### 5.3 validate-config.sh
```bash
#!/bin/bash
# scripts/validate-config.sh

set -e

CONFIG_FILE="${1:-${HOME}/.config/fx-shell/config.json}"

echo "Validating config: ${CONFIG_FILE}"

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "❌ Config file not found: ${CONFIG_FILE}"
    exit 1
fi

# Basic JSON validation
if ! python3 -m json.tool "${CONFIG_FILE}" > /dev/null 2>&1; then
    echo "❌ Invalid JSON in config file"
    exit 1
fi

echo "✓ Config file is valid JSON"

# TODO: Add schema validation
# For now, just check basic structure
if ! grep -q "theme" "${CONFIG_FILE}"; then
    echo "⚠️  Warning: 'theme' property not found in config"
fi

echo "✓ Config validation complete"
```

---

## Step 6: qmldir Files for Singletons

Create qmldir files to register singletons:

### commons/qmldir
```
singleton ServiceRegistry 1.0 ServiceRegistry.qml
singleton EventBus 1.0 EventBus.qml
singleton Config 1.0 Config.qml
singleton Theme 1.0 Theme.qml
singleton Utils 1.0 Utils.qml
```

---

## Step 7: Initial Documentation

### README.md
```markdown
# fx-shell

A modern Wayland desktop shell built on QuickShell, targeting Sway compositor.

## Status

🚧 **Early Development** - Infrastructure phase

Currently implemented:
- ✅ Core repository structure
- ✅ ServiceRegistry singleton
- ✅ EventBus system
- ✅ Config management
- ✅ Theme system
- ✅ Development tooling

## Quick Start

### Prerequisites

- QuickShell
- Sway compositor
- Qt 6.x

### Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/fx-shell.git
cd fx-shell

# Run setup script
./scripts/dev-setup.sh

# Start development shell
./scripts/run-dev.sh
```

## Architecture

fx-shell uses a modular, service-oriented architecture:

- **ServiceRegistry**: Dependency injection and service discovery
- **EventBus**: Decoupled inter-component communication
- **Config**: Centralized configuration management
- **Theme**: Theming and visual customization

See [docs/architecture/](docs/architecture/) for detailed documentation.

## References

This project draws inspiration from:
- **DankMaterialShell** - Widget implementations
- **Noctalia Shell** - Architecture patterns
- **Caelestia** - Build patterns

Reference implementations are included in `references/` directory.

## Development

See [.fx-guidelines/](.fx-guidelines/) for comprehensive development guidelines
optimized for LLM-assisted development.

## License

MIT
```

---

## Deliverables Checklist

- [ ] Directory structure created
- [ ] `.fx-guidelines/` with 4 guideline files
- [ ] `commons/` with 5 singleton QML files
- [ ] `commons/qmldir` for singleton registration
- [ ] `shell.qml` minimal entry point
- [ ] `scripts/` with 3 development scripts
- [ ] `README.md` with quick start
- [ ] Test that `quickshell ./shell.qml` runs without errors
- [ ] Verify all singletons load correctly
- [ ] Confirm test panel displays with current time

---

## Success Criteria

1. **Structure**: Complete modular directory tree
2. **Singletons**: All 5 commons singletons load and register
3. **Scripts**: Dev setup and run scripts work
4. **Visual**: Test panel displays successfully
5. **Logging**: Clear console output showing initialization
6. **Documentation**: Comprehensive guidelines for future development

---

## Next Steps (Phase 2)

After infrastructure is complete:

1. **Sway IPC Integration** - Implement `modules/core/compositor/`
2. **Workspace Service** - Implement `modules/core/workspace/`
3. **Window Service** - Implement `modules/core/window/`
4. **Basic Status Bar** - First functional UI component

---

## Reference Material Quick Access

When implementing features, consult:

- **DankMaterialShell patterns**: `/references/DankMaterialShell/`
- **Noctalia architecture**: `/references/noctalia-shell/`
- **dgop IPC**: `/references/dgop/`
- **Spec document**: `/docs/spec.md`
- **Additional notes**: `/docs/additional-notes.md`

---

## Testing the Infrastructure

After setup, verify with:

```bash
# 1. Run setup
./scripts/dev-setup.sh

# 2. Start shell (should show test panel)
./scripts/run-dev.sh

# 3. Check console output for:
#    - ✓ All singletons loaded
#    - ✓ No errors or warnings
#    - ✓ Test panel rendering

# 4. Validate config
./scripts/validate-config.sh
```

Expected output:
```
════════════════════════════════════════
  fx-shell - QuickShell Desktop Shell
════════════════════════════════════════

ℹ️ [fx-shell] Initializing infrastructure...
✓ [ServiceRegistry] Loaded (✓)
✓ [EventBus] Loaded (✓)
✓ [Config] Loaded (✓)
✓ [Theme] Loaded (✓)
✓ [Utils] Loaded (✓)

✓ [fx-shell] Infrastructure initialized successfully
════════════════════════════════════════
```

---

## Claude Code Instructions

When implementing this infrastructure:

1. **Start with commons/**: Create all 5 singleton files first
2. **Add qmldir**: Register singletons properly
3. **Create shell.qml**: Minimal entry point with test panel
4. **Write scripts**: Development tooling
5. **Test thoroughly**: Ensure QuickShell loads without errors
6. **Document**: Add inline comments explaining patterns

Follow the architecture principles in `.fx-guidelines/` for all future work.

The goal is a solid foundation that every subsequent module will build upon.
