# fx-shell: Comprehensive Wayland Desktop Shell Specification

**Version:** 1.0  
**Framework:** QuickShell (QtQuick/QML)  
**Target Compositor:** Sway  
**Last Updated:** October 2025

---

## Executive Summary

**fx-shell** is a modern Wayland desktop shell project built on QuickShell, targeting Sway compositor with aspirations for cross-compositor compatibility. The project draws heavy stylistic and architectural inspiration from established implementations while creating a production-ready, feature-complete desktop environment.

This document serves as the comprehensive specification and single source of truth for the fx-shell project, consolidating:
- Complete widget and utility catalog with implementation status across frameworks
- Repository architecture and development guidelines
- Technical implementation roadmaps and patterns
- Reference implementations and ecosystem analysis
- LLM-friendly development infrastructure

### Key Design Principles

1. **QuickShell-native architecture** using QtQuick/QML for declarative UI development
2. **Sway-first integration** with i3-compatible IPC protocol
3. **Modular, service-oriented design** enabling maintainability and extensibility
4. **LLM-optimized development** with embedded references and comprehensive documentation
5. **Production-ready feature parity** with traditional desktop environments

---

## Core Framework Analysis

### QuickShell Framework Overview

QuickShell represents a modern approach to Wayland shell development, leveraging Qt's mature ecosystem while providing native performance and declarative UI patterns. The framework's QML-based architecture enables rapid development while maintaining the flexibility needed for sophisticated desktop environment features.

**Technical Foundation:**
- **Language Stack:** QML/QtQuick with JavaScript logic layer
- **Architecture:** Qt-based declarative UI with native C++ backend
- **Performance:** High (Qt native rendering and event handling)
- **Ecosystem Maturity:** Growing, with several production-grade implementations

**Key Advantages:**
- Mature Qt ecosystem with extensive widget libraries
- Native performance through C++ backend
- Declarative UI patterns reduce complexity
- Strong typing support through QML
- Well-documented Qt framework and tooling

### Reference Implementations

The QuickShell ecosystem has produced several noteworthy implementations that inform fx-shell's development approach:

#### DankMaterialShell (Primary Reference)
**Repository:** https://github.com/AvengeMedia/DankMaterialShell

DankMaterialShell represents the most feature-complete QuickShell implementation available, demonstrating production-ready patterns across the full desktop environment spectrum.

**Key Features:**
- Comprehensive widget ecosystem covering all essential desktop functions
- dgop IPC framework for inter-process communication
- Material Design-inspired visual language
- Robust service architecture with clean separation of concerns
- Advanced workspace and window management

**Notable Components:**
- Status bar with full system integration
- Application launcher with search capabilities
- Notification system with action support
- Media controls with MPRIS integration
- System controls (audio, network, power)

#### Noctalia Shell (Architectural Reference)
**Repository:** https://github.com/noctalia-dev/noctalia-shell

Noctalia demonstrates sophisticated architectural patterns with multi-compositor support (Hyprland/Niri), providing the foundation for fx-shell's modular design.

**Architectural Patterns:**
- Clean service abstraction layer for compositor integration
- Modular component organization with minimal coupling
- Configuration management system
- Event-driven architecture with centralized event bus
- Lazy loading patterns for performance optimization

**Compositor Integration:**
- Abstract CompositorService pattern
- JSON-based IPC for Hyprland integration
- Event subscription and management
- Workspace and window state management

#### Caelestia Shell
**Repository:** https://github.com/caelestia-dots/shell

Caelestia provides additional patterns for QuickShell development, particularly around build system integration and deployment strategies.

**Contributions:**
- CMake integration patterns
- System installation workflows
- Configuration validation approaches

#### Vantesh Dotfiles Integration
**Repository:** https://github.com/Vantesh/dotfiles/tree/main/home/dot_config/quickshell/dms

Demonstrates real-world deployment of DankMaterialShell with dotfile management, providing patterns for user configuration and customization.

---

## Comprehensive Widget & Utility Catalog

This comprehensive catalog analyzes all potential desktop shell components, their current implementation status across frameworks, and integration priorities for fx-shell.

### Status Legend

- ✅ **Full Support:** Native implementation available with comprehensive features
- ⚠️ **Partial Support:** Basic implementation exists but may lack advanced features
- ❌ **Not Available:** No known implementation in this framework
- 🔄 **In Development:** Known to be under active development

### Complete Implementation Matrix

| Widget/Utility | Current Stack | QuickShell | Fabric/Ax-Shell | Legacy AGS | Modern Alternative | Priority | Implementation Notes |
|----------------|---------------|------------|-----------------|------------|-------------------|----------|---------------------|
| **Core Desktop Infrastructure** |
| Status Bar/Panel | waybar | ✅ DMS/Noctalia | ✅ Ax-Shell | ✅ Multiple | - | Essential | Layer-shell integration, multi-monitor support |
| App Launcher | rofi -show drun | ✅ DMS launcher | ✅ App launcher | ✅ Native service | Sherlock (GTK4) | Essential | Desktop file parsing, fuzzy search, icons |
| Window Switcher | rofi -show window | ✅ Window list | ✅ Window switcher | ✅ Window mgmt | - | Essential | Current focus, window previews, keyboard nav |
| Run Command | rofi -show run | ✅ Command runner | ✅ Run dialog | ✅ Execution | - | Essential | PATH integration, history, suggestions |
| **System Integration** |
| Notifications | mako | ✅ Notification widget | ✅ Daemon impl | ✅ Native impl | - | Essential | D-Bus protocol, actions, persistence, history |
| Audio Control | pavucontrol + scripts | ✅ Audio mixer | ✅ Volume controls | ✅ PulseAudio | - | Essential | Input/output selection, MPRIS, per-app volume |
| Battery Monitor | waybar battery | ✅ Battery indicator | ✅ Power mgmt | ✅ Battery widget | - | Essential | Multiple batteries, charging state, thresholds |
| Network Manager | nmtui + scripts | ✅ Network controls | ✅ WiFi/Ethernet | ✅ NM integration | - | Essential | WiFi selection, VPN, connection profiles |
| Bluetooth Manager | blueman-manager | ✅ Bluetooth controls | ✅ Device mgmt | ✅ BT widgets | - | High | Device pairing, connection status, battery levels |
| Brightness Control | light + scripts | ✅ Display controls | ✅ Brightness slider | ✅ Backlight | - | Essential | Multi-display, keyboard backlight, auto-adjust |
| **Workspace & Window Management** |
| Workspace Manager | sway workspaces | ✅ Workspace indicator | ✅ Desktop switch | ✅ Workspace widgets | - | Essential | Dynamic workspaces, visual indicators, drag-drop |
| Workspace Indicators | Custom scripts | ✅ Visual indicators | ✅ Workspace widgets | ✅ Status widgets | - | High | Current workspace, occupied workspaces, urgent |
| Window Rules | sway for_window | ✅ Window rules | ✅ Positioning | ✅ Window mgmt | - | Medium | Automatic layouts, workspace assignments |
| Live Window Previews | - | ✅ Window previews | ❌ Not available | ❌ Not available | - | Medium | Wayland protocol support, thumbnail rendering |
| **Desktop Utilities** |
| System Tray | waybar tray | ✅ System tray | ⚠️ Basic support | ✅ Tray widgets | - | Essential | StatusNotifierItem protocol, icon themes |
| Clock/Calendar | waybar clock | ✅ Calendar widget | ✅ Date/time | ✅ Clock widgets | - | Essential | Timezone support, calendar events, formatting |
| Clipboard Manager | cliphist + rofi | ⚠️ Limited | ✅ Clipboard history | ⚠️ Basic impl | - | High | History persistence, search, images, formats |
| Emoji Picker | rofimoji | ❌ Not available | ✅ Emoji selector | ⚠️ Basic impl | - | Medium | Unicode database, categories, search, recents |
| Pomodoro Timer | Custom script + rofi | ❌ Not available | ✅ Timer widget | ❌ Not available | - | Medium | Notifications, break intervals, statistics |
| Color Picker | Custom script | ❌ Not available | ✅ Color picker | ⚠️ Basic impl | - | Low | Format options (hex, rgb, hsl), magnifier |
| **Media & Entertainment** |
| Media Controls | - | ✅ Media controls | ✅ Media player | ✅ MPRIS | - | High | Album art, playback control, multiple players |
| **Power & Display** |
| Power Menu | Custom script + rofi | ✅ Power controls | ✅ System menu | ✅ Power mgmt | - | Essential | Logout, shutdown, reboot, suspend, polkit |
| Lock Screen | - | ✅ Lock screen | ❌ Not available | ✅ Screen lock | - | High | Authentication methods, grace period, blur |
| Night Light | - | ✅ Display warmth | ✅ Color temp | ✅ Blue light filter | - | Medium | Automatic scheduling, location-based, manual |
| Wallpaper Manager | swaybg | ✅ Wallpaper controls | ✅ Background mgmt | ✅ Wallpaper | - | Medium | Per-workspace, dynamic, slideshow |
| **Weather & Information** |
| Weather Widget | - | ✅ Weather info | ✅ Weather display | ⚠️ Custom impl | - | Medium | API integration, location, forecast, icons |
| System Monitor | - | ✅ System stats | ✅ CPU/RAM/Disk | ✅ Resource monitor | - | Medium | Performance metrics, graphs, alerts |
| Temperature Monitor | - | ✅ Hardware temps | ✅ Temp sensors | ✅ Thermal monitor | - | Medium | CPU/GPU temps, fan speeds, alerts |
| System Information | - | ✅ System details | ✅ Hardware info | ✅ System info | - | Low | Specs display, kernel version, uptime |
| Disk Usage | - | ✅ Storage info | ✅ Disk space | ✅ Storage monitor | - | Low | Mount points, usage graphs, alerts |
| **Advanced Input/Output** |
| Screenshot Tools | grim/slurp + scripts | ✅ Screenshot tools | ✅ Screen capture | ✅ Screenshot | - | High | Area selection, full screen, window, annotations |
| Screen Recording | wf-recorder + scripts | ⚠️ Limited support | ✅ Screen recording | ⚠️ Basic impl | - | Medium | Codec selection, audio, area selection |
| Keyboard Layout | - | ✅ Layout indicator | ✅ Input method | ✅ Layout switch | - | Medium | Multiple layouts, visual indicator, per-window |
| On-Screen Keyboard | - | ❌ Not available | ❌ Not available | ❌ Not available | squeekboard | Medium | Touch device support, layout selection |
| **Developer Tools** |
| Terminal Integration | kitty | ✅ Terminal widget | ✅ Embedded term | ✅ Terminal | - | Medium | Dropdown terminal, tabs, profiles |
| Hotkey Display | wshowkeys | ❌ Not available | ❌ Not available | ❌ Not available | - | Low | Key visualization, screencast mode |
| **System Management** |
| Package Updates | - | ❌ Not available | ✅ Update notifs | ⚠️ Custom impl | - | Low | Distro-specific, update count, auto-check |
| Process Manager | - | ✅ Process list | ✅ Task manager | ✅ Process monitor | - | Low | Kill processes, resource usage, sorting |
| Service Manager | - | ❌ Not available | ❌ Not available | ❌ Not available | - | Low | Systemd integration, start/stop/restart |
| Log Viewer | - | ❌ Not available | ❌ Not available | ❌ Not available | - | Low | System logs, filtering, search |
| VPN Status | - | ✅ VPN indicator | ✅ VPN connection | ⚠️ Basic support | - | Medium | Multiple providers, connection status |
| **Gestures & Touch** |
| Gestures Support | Custom lisgd | ✅ Touch gestures | ❌ Not available | ✅ Touch support | - | Medium | Touch devices, custom gestures, swipes |
| **Theming & Appearance** |
| Theme Management | Manual CSS/config | ✅ Qt themes | ✅ Color schemes | ✅ Theme switch | - | Medium | Dynamic theming, color extraction, presets |
| Custom Animations | scroll animations | ✅ Qt animations | ✅ Animation support | ✅ CSS animations | - | Low | Smooth transitions, easing functions |
| **File Management** |
| File Manager | thunar | ❌ Not integrated | ✅ File browser | ❌ Not integrated | - | Low | Quick access, thumbnails, drag-drop |
| **Gaming & Performance** |
| Gaming Mode | - | ❌ Not available | ❌ Not available | ❌ Not available | - | Low | Performance optimization, notification pause |
| **Integration & Sync** |
| Password Manager | - | ❌ Not available | ❌ Not available | ❌ Not available | 1Password CLI | High | Secure integration, autofill, biometric |
| Device Sync | - | ❌ Not available | ❌ Not available | ❌ Not available | KDE Connect | Medium | Android integration, notifications, files |
| OCR Text Recognition | - | ❌ Not available | ✅ OCR (Tsumiki) | ❌ Not available | tesseract | Medium | Screen text extraction, language support |
| **Moonshot Features** |
| AI Assistant | - | ❌ Not available | ❌ Not available | ❌ Not available | Ollama | Moonshot | Context awareness, voice, automation |
| Universal Search | - | ❌ Not available | ❌ Not available | ❌ Not available | Gauntlet-style | High | Files/apps/web/commands unified search |
| Plugin System | - | ❌ Not available | ❌ Not available | ❌ Not available | QML plugins | Moonshot | Community extensions, hot reload |
| Voice Control | - | ❌ Not available | ❌ Not available | ❌ Not available | Speech recognition | Moonshot | Accessibility, hands-free control |
| Ambient Computing | - | ❌ Not available | ❌ Not available | ❌ Not available | IoT integration | Moonshot | Smart home, environment awareness |
| Visual Widget Builder | - | ❌ Not available | ❌ Not available | ❌ Not available | Web-based editor | Moonshot | No-code widget creation |
| Configuration Sync | - | ❌ Not available | ❌ Not available | ❌ Not available | Git-based sharing | Moonshot | Community configs, version control |

### Implementation Statistics

- **Total Widgets/Utilities Identified:** 58
- **Current Implementation (sway/waybar/rofi):** 20+ custom scripts/tools
- **QuickShell Native Support:** ~32 widgets (55%)
- **Fabric/Ax-Shell Coverage:** ~42 widgets (72%)
- **Missing from All Frameworks:** 12+ moonshot features
- **Essential Priority:** 18 core widgets
- **High Priority:** 10 important widgets
- **Medium Priority:** 18 convenience features
- **Low Priority:** 8 power user features
- **Moonshot Priority:** 7 revolutionary features

### Priority Implementation Tiers

#### Tier 1: Essential Desktop Functionality (18 widgets)
Core features required for basic desktop usability:
- Status Bar/Panel
- App Launcher
- Window Switcher
- Run Command
- Notifications
- Audio Control
- Battery Monitor
- Network Manager
- Brightness Control
- Workspace Manager
- System Tray
- Clock/Calendar
- Power Menu
- Clipboard Manager (promoted from High)
- Workspace Indicators (visual feedback critical)

#### Tier 2: High-Value Features (10 widgets)
Important features that significantly improve user experience:
- Bluetooth Manager
- Media Controls
- Screenshot Tools
- Lock Screen
- Universal Search (Gauntlet-style launcher)
- Password Manager Integration
- OCR Text Recognition

#### Tier 3: Convenience Features (18 widgets)
Nice-to-have features that enhance productivity:
- Emoji Picker
- Pomodoro Timer
- Weather Widget
- System Monitor
- Temperature Monitor
- Screen Recording
- Keyboard Layout Indicator
- On-Screen Keyboard
- Night Light
- Wallpaper Manager
- VPN Status
- Gestures Support
- Theme Management
- Live Window Previews
- Terminal Integration
- Window Rules
- Device Sync (KDE Connect)

#### Tier 4: Power User Features (8 widgets)
Optional features for advanced users:
- Color Picker
- File Manager Integration
- System Information
- Disk Usage
- Process Manager
- Custom Animations
- Hotkey Display
- Package Updates

#### Tier 5: Moonshot Innovations (7 features)
Revolutionary features not yet implemented in any framework:
- AI Assistant (Ollama integration)
- Plugin System (QML-based community extensions)
- Voice Control (accessibility and convenience)
- Ambient Computing (IoT/smart home integration)
- Visual Widget Builder (no-code widget creation)
- Configuration Sync (community config sharing)
- Gaming Mode (performance optimization)

---

## Repository Architecture

### Core Structure

The fx-shell repository follows a modular, service-oriented architecture optimized for both human maintainability and LLM-driven development:

```
fx-shell/
├── .fx-guidelines/                    # AI development guidelines
│   ├── development-guidelines.md      # LLM coding instructions  
│   ├── architecture-principles.md     # System design patterns
│   ├── sway-integration-guide.md      # Compositor-specific guidance
│   └── quickshell-patterns.md         # QuickShell best practices
├── shell.qml                          # Main entry point
├── modules/                           # Feature-based modular organization
│   ├── core/                          # Essential shell services
│   │   ├── compositor/                # Sway IPC integration
│   │   ├── workspace/                 # Workspace management
│   │   ├── window/                    # Window management
│   │   └── events/                    # Event bus and routing
│   ├── ui/                            # User interface components  
│   │   ├── panels/                    # Top-level UI containers
│   │   │   ├── statusbar/             # Top status bar
│   │   │   ├── dock/                  # Application dock
│   │   │   └── notifications/         # Notification center
│   │   ├── widgets/                   # Reusable UI components
│   │   │   ├── buttons/
│   │   │   ├── sliders/
│   │   │   ├── indicators/
│   │   │   └── containers/
│   │   └── layouts/                   # Layout management
│   ├── services/                      # System integration services
│   │   ├── audio/                     # Audio system integration
│   │   │   ├── pulseaudio/           # PulseAudio backend
│   │   │   └── mpris/                # MPRIS media control
│   │   ├── network/                   # Network management
│   │   │   ├── networkmanager/       # NetworkManager integration
│   │   │   └── vpn/                  # VPN management
│   │   ├── power/                     # Power and display management
│   │   │   ├── battery/              # Battery monitoring
│   │   │   ├── brightness/           # Display brightness
│   │   │   └── display/              # Display configuration
│   │   ├── bluetooth/                 # Bluetooth integration
│   │   ├── notifications/             # Notification system
│   │   └── systemtray/               # System tray protocol
│   ├── launchers/                     # Application launching systems
│   │   ├── app-launcher/             # Desktop file launcher
│   │   ├── command-runner/           # Command execution
│   │   └── window-switcher/          # Window switching
│   ├── utilities/                     # Desktop utility modules
│   │   ├── clipboard/                # Clipboard management
│   │   ├── screenshot/               # Screenshot tools
│   │   ├── media-controls/           # Media player controls
│   │   └── weather/                  # Weather information
│   └── integrations/                  # External service connectors
│       ├── polkit/                   # PolicyKit agent
│       └── dgop/                     # DankMaterialShell IPC patterns
├── commons/                           # Shared utilities and configuration
│   ├── Config.qml                     # Central configuration management
│   ├── Theme.qml                      # Theming system  
│   ├── Utils.qml                      # Common utility functions
│   ├── ServiceRegistry.qml            # Service discovery and injection
│   └── EventBus.qml                   # Centralized event routing
├── assets/                            # Static resources
│   ├── icons/                        # Icon theme assets
│   ├── fonts/                        # Custom fonts
│   └── themes/                       # Theme definitions
├── docs/                              # Comprehensive documentation
│   ├── api/                          # API documentation
│   ├── guides/                       # User and developer guides
│   └── architecture/                 # Architecture documentation
├── scripts/                           # Build and utility scripts
│   ├── dev-setup.sh                  # Development environment setup
│   ├── build-debug.sh                # Debug build with hot reload
│   ├── install-system.sh             # System-wide installation
│   ├── generate-docs.sh              # Auto-generate API docs
│   └── validate-config.sh            # Configuration validation
└── tests/                             # Test suite
    ├── unit/                         # Unit tests
    ├── integration/                  # Integration tests
    └── e2e/                          # End-to-end tests
```

### Module Organization Pattern

Each module follows a self-contained pattern maximizing both comprehension and LLM effectiveness:

```
modules/core/compositor/
├── README.md                          # Module purpose and API documentation
├── src/                               # Main implementation
│   ├── SwayService.qml               # Primary service implementation
│   ├── IPC.qml                       # Sway IPC protocol handler
│   └── Events.qml                    # Event subscription management
├── reference/                         # Implementation examples and patterns
│   ├── noctalia/                     # Adapted Noctalia CompositorService
│   │   ├── CompositorService.qml     # Original implementation
│   │   └── adaptation-notes.md       # Sway adaptation requirements
│   ├── hyprland-examples/            # Hyprland integration patterns
│   │   ├── hyprland-service.qml      # Reference implementation
│   │   └── ipc-differences.md        # Protocol comparison
│   ├── sway-native/                  # Native Sway implementations
│   │   ├── swaybar-integration.qml   # Official swaybar patterns
│   │   └── waybar-patterns.qml       # Waybar implementation examples
│   └── quickshell-patterns/          # Other QuickShell examples
│       ├── caelestia-compositor.qml  # Caelestia's approach
│       └── dankshell-sway.qml        # DankMaterialShell patterns
├── tests/                            # Comprehensive test suite
│   ├── unit/                         # Unit tests for components
│   └── integration/                  # Integration tests with Sway
├── examples/                         # Usage examples and demos
│   ├── basic-usage.qml               # Simple integration
│   └── advanced-features.qml         # Complex functionality
└── architecture.md                   # Module-specific architecture docs
```

This pattern ensures each module contains all necessary reference materials for development while maintaining clean separation of concerns.

---

## Sway Compositor Integration

### Technical Requirements

Sway uses the i3-compatible IPC protocol, which differs significantly from other Wayland compositors. The integration strategy must account for these specific characteristics.

#### IPC Protocol Specifications

**Binary Protocol Structure:**
- Magic string: `i3-ipc`
- Message format: `<magic><length><type><payload>`
- Response format: Same structure with JSON payload

**Critical Message Types:**
```javascript
const messageTypes = {
    RUN_COMMAND: 0,          // Execute sway commands
    GET_WORKSPACES: 1,       // Query workspace state
    SUBSCRIBE: 2,            // Subscribe to events
    GET_OUTPUTS: 3,          // Query output information
    GET_TREE: 4,             // Get window tree structure
    GET_MARKS: 5,            // Get window marks
    GET_BAR_CONFIG: 6,       // Bar configuration
    GET_VERSION: 7,          // Sway version info
    GET_BINDING_MODES: 8,    // Available binding modes
    GET_CONFIG: 9,           // Current configuration
    SEND_TICK: 10,           // Send tick event
    SYNC: 11,                // Synchronization message
    GET_BINDING_STATE: 12,   // Current binding state
    GET_INPUTS: 100,         // Input device info
    GET_SEATS: 101           // Seat information
};
```

**Event Subscription System:**
```javascript
const eventTypes = {
    WORKSPACE: 0x80000000,    // Workspace changes
    OUTPUT: 0x80000001,       // Output changes
    MODE: 0x80000002,         // Mode changes
    WINDOW: 0x80000003,       // Window changes
    BARCONFIG_UPDATE: 0x80000004,  // Bar config updates
    BINDING: 0x80000005,      // Binding events
    SHUTDOWN: 0x80000006,     // Shutdown event
    TICK: 0x80000007,         // Tick events
    BAR_STATE_UPDATE: 0x80000014,  // Bar state updates
    INPUT: 0x80000015         // Input device events
};
```

### SwayService Implementation

The SwayService provides a clean abstraction layer over Sway's IPC protocol:

```qml
// modules/core/compositor/src/SwayService.qml
pragma Singleton
import QtQuick
import "./IPC.qml" as SwayIPC

QtObject {
    id: swayService
    
    // Public API - Compositor-agnostic interface
    property var workspaces: []
    property int currentWorkspace: 0
    property var windows: []
    property var outputs: []
    property string focusedWindow: ""
    
    // Internal IPC handler
    property var ipcHandler: SwayIPC.Handler {
        socketPath: getSwaySocketPath()
        
        onWorkspaceEvent: function(event) {
            updateWorkspaces()
            if (event.change === "focus") {
                currentWorkspace = event.current.num
            }
        }
        
        onWindowEvent: function(event) {
            updateWindows()
            if (event.change === "focus") {
                focusedWindow = event.container.id
            }
        }
        
        onOutputEvent: function(event) {
            updateOutputs()
        }
    }
    
    // Public methods
    function switchWorkspace(identifier) {
        ipcHandler.runCommand(`workspace ${identifier}`)
    }
    
    function moveWindowToWorkspace(windowId, workspaceId) {
        ipcHandler.runCommand(
            `[con_id="${windowId}"] move container to workspace ${workspaceId}`
        )
    }
    
    function focusWindow(windowId) {
        ipcHandler.runCommand(`[con_id="${windowId}"] focus`)
    }
    
    function closeWindow(windowId) {
        ipcHandler.runCommand(`[con_id="${windowId}"] kill`)
    }
    
    function toggleFloating(windowId) {
        ipcHandler.runCommand(`[con_id="${windowId}"] floating toggle`)
    }
    
    function setWindowFullscreen(windowId, fullscreen) {
        const state = fullscreen ? "enable" : "disable"
        ipcHandler.runCommand(
            `[con_id="${windowId}"] fullscreen ${state}`
        )
    }
    
    // Internal update methods
    function updateWorkspaces() {
        ipcHandler.getWorkspaces().then(function(data) {
            workspaces = data
        })
    }
    
    function updateWindows() {
        ipcHandler.getTree().then(function(tree) {
            windows = extractWindows(tree)
        })
    }
    
    function updateOutputs() {
        ipcHandler.getOutputs().then(function(data) {
            outputs = data
        })
    }
    
    function extractWindows(tree) {
        // Recursive tree traversal to extract window nodes
        var windows = []
        
        function traverse(node) {
            if (node.type === "con" && node.name) {
                windows.push({
                    id: node.id,
                    name: node.name,
                    appId: node.app_id,
                    workspace: node.workspace,
                    focused: node.focused,
                    floating: node.floating,
                    fullscreen: node.fullscreen_mode !== 0,
                    rect: node.rect
                })
            }
            
            if (node.nodes) {
                node.nodes.forEach(traverse)
            }
            if (node.floating_nodes) {
                node.floating_nodes.forEach(traverse)
            }
        }
        
        traverse(tree)
        return windows
    }
    
    function getSwaySocketPath() {
        // Read from environment or default location
        return Qt.platform.os === "linux" 
            ? (Qt.getenv("SWAYSOCK") || "/run/user/1000/sway-ipc.sock")
            : ""
    }
    
    // Initialization
    Component.onCompleted: {
        // Subscribe to all relevant events
        ipcHandler.subscribe([
            "workspace",
            "window",
            "output"
        ])
        
        // Initial state fetch
        updateWorkspaces()
        updateWindows()
        updateOutputs()
    }
}
```

### IPC Protocol Handler

The IPC handler manages the low-level protocol communication:

```qml
// modules/core/compositor/src/IPC.qml
import QtQuick
import QtNetwork

QtObject {
    id: ipc
    
    property string socketPath
    
    signal workspaceEvent(var event)
    signal windowEvent(var event)
    signal outputEvent(var event)
    signal modeEvent(var event)
    
    property var socket: LocalSocket {
        onConnected: {
            console.log("Connected to Sway IPC socket")
        }
        
        onReadyRead: {
            handleResponse(readAll())
        }
        
        onError: function(error) {
            console.error("Sway IPC error:", error)
        }
    }
    
    function connect() {
        socket.connectToServer(socketPath)
    }
    
    function sendMessage(type, payload) {
        const payloadStr = JSON.stringify(payload || {})
        const payloadBytes = new TextEncoder().encode(payloadStr)
        
        // Build i3 IPC message: magic + length + type + payload
        const magic = "i3-ipc"
        const length = payloadBytes.length
        
        const buffer = new ArrayBuffer(14 + length)
        const view = new DataView(buffer)
        
        // Write magic string
        for (let i = 0; i < 6; i++) {
            view.setUint8(i, magic.charCodeAt(i))
        }
        
        // Write payload length (little-endian)
        view.setUint32(6, length, true)
        
        // Write message type (little-endian)
        view.setUint32(10, type, true)
        
        // Write payload
        for (let i = 0; i < length; i++) {
            view.setUint8(14 + i, payloadBytes[i])
        }
        
        socket.write(buffer)
    }
    
    function handleResponse(data) {
        // Parse i3 IPC response
        const view = new DataView(data)
        
        // Verify magic
        let magic = ""
        for (let i = 0; i < 6; i++) {
            magic += String.fromCharCode(view.getUint8(i))
        }
        
        if (magic !== "i3-ipc") {
            console.error("Invalid IPC magic:", magic)
            return
        }
        
        // Read length and type
        const length = view.getUint32(6, true)
        const type = view.getUint32(10, true)
        
        // Extract payload
        const payloadBytes = new Uint8Array(data, 14, length)
        const payloadStr = new TextDecoder().decode(payloadBytes)
        const payload = JSON.parse(payloadStr)
        
        // Route based on message type
        if (type & 0x80000000) {
            // This is an event
            handleEvent(type & ~0x80000000, payload)
        } else {
            // This is a command response
            handleCommandResponse(type, payload)
        }
    }
    
    function handleEvent(eventType, data) {
        switch(eventType) {
            case 0: // Workspace event
                workspaceEvent(data)
                break
            case 3: // Window event
                windowEvent(data)
                break
            case 1: // Output event
                outputEvent(data)
                break
            case 2: // Mode event
                modeEvent(data)
                break
        }
    }
    
    function handleCommandResponse(type, data) {
        // Handle command responses
        // Store in pending requests map and resolve promises
    }
    
    function runCommand(command) {
        sendMessage(0, { command: command })
    }
    
    function getWorkspaces() {
        return sendMessageAsync(1)
    }
    
    function getTree() {
        return sendMessageAsync(4)
    }
    
    function getOutputs() {
        return sendMessageAsync(3)
    }
    
    function subscribe(events) {
        sendMessage(2, { events: events })
    }
    
    Component.onCompleted: {
        connect()
    }
}
```

---

## Development Infrastructure

### LLM-Friendly Guidelines

The `.fx-guidelines/` directory provides comprehensive instructions for AI-driven development:

#### development-guidelines.md

**Module Development Patterns:**
- Each module must be self-contained with minimal external dependencies
- All public APIs must be documented with JSDoc comments
- Changes must include corresponding test updates
- Configuration changes must be validated with `scripts/validate-config.sh`

**Code Organization:**
- QML files use PascalCase for components
- Property names use camelCase
- Signal names use camelCase with descriptive verb prefixes (on-)
- Private properties and methods prefixed with underscore

**Testing Requirements:**
- Unit tests for all service logic
- Integration tests for compositor interactions
- End-to-end tests for user-facing features

**Dependency Management:**
- Explicit dependency injection through ServiceRegistry
- No circular dependencies between modules
- Commons utilities only for truly shared functionality

#### architecture-principles.md

**Service-Oriented Architecture:**
- Services are singleton QML objects providing system integration
- Services communicate through EventBus for decoupling
- Services registered with ServiceRegistry for discovery

**Cross-Module Communication:**
- Direct imports only for commons utilities
- Service dependencies through ServiceRegistry
- Event-based communication through EventBus
- No direct module-to-module coupling

**State Management:**
- Services own their state
- UI components subscribe to service state changes
- Avoid duplicating state across components

**Error Handling:**
- Graceful degradation for non-critical features
- User-visible errors through notification system
- Console logging for debugging with appropriate levels

**Performance Guidelines:**
- Lazy load modules where possible
- Use Qt's property binding efficiently
- Minimize signal connections
- Profile before optimizing

#### sway-integration-guide.md

**IPC Protocol Implementation:**
- Binary protocol with i3-ipc magic string
- Little-endian byte order for all integers
- JSON payloads for all messages
- Event subscription must be maintained across reconnects

**Event Handling:**
- Subscribe to events during service initialization
- Handle reconnection scenarios gracefully
- Process events asynchronously to avoid blocking UI

**Workspace Management:**
- Sway uses numbered/named workspaces per output
- Workspace numbers are not guaranteed contiguous
- Handle urgent workspace indicators
- Support dynamic workspace creation

**Layer Shell Integration:**
- Use layer-shell protocol for panels and notifications
- Set appropriate layer (background, bottom, top, overlay)
- Configure anchors and exclusive zones correctly
- Handle output hotplug events

**Debugging:**
- Use `swaymsg -t get_tree` to inspect window tree
- Monitor IPC socket with `socat`
- Enable Sway debug logging for protocol issues
- Test with multiple outputs

### Configuration Management

#### Runtime Configuration

```qml
// commons/Config.qml
pragma Singleton
import QtQuick

QtObject {
    id: config
    
    // Theme configuration
    property string theme: "material-dark"
    property string accentColor: "#4285f4"
    property string font: "Inter"
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
    
    // Load user configuration from file
    property var userConfig: loadConfig()
    
    function loadConfig() {
        const configPath = Qt.getenv("HOME") + "/.config/fx-shell/config.json"
        // Load and parse JSON config file
        // Merge with defaults
        return {}
    }
    
    function get(path) {
        // Dot-notation config access
        // e.g., Config.get("panels.statusBar.height")
        const parts = path.split(".")
        let value = this
        for (const part of parts) {
            value = value[part]
            if (value === undefined) break
        }
        return value
    }
}
```

#### Theme System

```qml
// commons/Theme.qml
pragma Singleton
import QtQuick

QtObject {
    id: theme
    
    // Color palette
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
    
    // Spacing
    property int spacing: 8
    property int spacingSmall: 4
    property int spacingLarge: 16
    
    // Border radius
    property int radiusSmall: 4
    property int radius: 8
    property int radiusLarge: 16
    
    // Shadows
    property string shadowSmall: "0 2px 4px rgba(0,0,0,0.1)"
    property string shadow: "0 4px 8px rgba(0,0,0,0.15)"
    property string shadowLarge: "0 8px 16px rgba(0,0,0,0.2)"
    
    // Typography
    property string fontFamily: Config.font
    property int fontSizeSmall: 10
    property int fontSize: Config.fontSize
    property int fontSizeLarge: 14
    property int fontSizeHeading: 18
    
    // Animations
    property int animationDuration: 200
    property string animationEasing: "OutCubic"
    
    // Component-specific
    property var button: ({
        height: 32,
        padding: 12,
        backgroundColor: surface,
        backgroundColorHover: surfaceVariant,
        backgroundColorPressed: Qt.darker(surfaceVariant, 1.1)
    })
    
    property var panel: ({
        backgroundColor: background,
        borderColor: border,
        shadowEnabled: true
    })
    
    function loadTheme(themeName) {
        // Load theme from theme file
        const themePath = `assets/themes/${themeName}.json`
        // Apply theme colors
    }
}
```

### Service Registry Pattern

```qml
// commons/ServiceRegistry.qml
pragma Singleton
import QtQuick

QtObject {
    id: registry
    
    property var services: ({})
    
    function registerService(name, service) {
        if (services[name]) {
            console.warn(`Service ${name} already registered, replacing`)
        }
        services[name] = service
        console.log(`✓ Registered service: ${name}`)
    }
    
    function getService(name) {
        const service = services[name]
        if (!service) {
            console.error(`Service ${name} not found`)
        }
        return service
    }
    
    function unregisterService(name) {
        if (!services[name]) {
            console.warn(`Service ${name} not registered`)
            return
        }
        delete services[name]
        console.log(`✗ Unregistered service: ${name}`)
    }
    
    function listServices() {
        return Object.keys(services)
    }
}
```

### Event Bus System

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
            case "theme:changed":
                themeChanged(data)
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
            default:
                console.warn(`Unknown event: ${eventName}`)
        }
    }
    
    // Event subscription helper
    property var subscriptions: ({})
    
    function subscribe(eventName, handler) {
        if (!subscriptions[eventName]) {
            subscriptions[eventName] = []
        }
        subscriptions[eventName].push(handler)
    }
    
    function unsubscribe(eventName, handler) {
        if (!subscriptions[eventName]) return
        
        const index = subscriptions[eventName].indexOf(handler)
        if (index > -1) {
            subscriptions[eventName].splice(index, 1)
        }
    }
}
```

---

## Implementation Roadmap

### Phase 1: Foundation & Core Services (Weeks 1-4)

**Objectives:**
- Establish repository structure and development infrastructure
- Implement core Sway IPC integration
- Create fundamental service architecture
- Set up build and deployment systems

**Deliverables:**
1. Complete repository structure with all directories and guidelines
2. SwayService with full IPC protocol implementation
3. WorkspaceService and WindowService
4. EventBus and ServiceRegistry
5. Configuration and Theme systems
6. Development scripts and tooling

**Success Criteria:**
- Successful connection to Sway IPC socket
- Real-time workspace and window tracking
- Event subscription and handling working
- Services discoverable through registry
- Configuration loading and validation

### Phase 2: Essential UI Components (Weeks 5-8)

**Objectives:**
- Implement layer-shell integration for panels
- Create status bar with essential widgets
- Develop notification system
- Build basic launcher functionality

**Deliverables:**
1. Layer-shell implementation for panels and overlays
2. Status bar with:
   - Workspace indicators
   - Window title
   - System tray
   - Clock/calendar
   - Audio controls
   - Network status
   - Battery indicator
3. Notification daemon and UI
4. Basic app launcher

**Success Criteria:**
- Panels render correctly on all outputs
- Status bar widgets display accurate information
- Notifications appear and dismiss correctly
- App launcher can launch applications

### Phase 3: System Services Integration (Weeks 9-12)

**Objectives:**
- Integrate with system services (audio, network, power)
- Implement media controls
- Add bluetooth management
- Create power menu

**Deliverables:**
1. Audio service with PulseAudio and MPRIS
2. Network service with NetworkManager
3. Power service with battery, brightness, display
4. Bluetooth service for device management
5. Media controls widget
6. Power menu with logout/shutdown/reboot

**Success Criteria:**
- Volume controls work across all audio streams
- Network connections manageable from UI
- Brightness adjustments functional
- Bluetooth pairing and connection working
- Media controls interact with MPRIS players
- Power actions execute correctly

### Phase 4: Advanced Features (Weeks 13-16)

**Objectives:**
- Implement advanced launchers (window switcher, command runner)
- Add clipboard manager
- Create screenshot tools
- Implement lock screen
- Add theme management

**Deliverables:**
1. Window switcher with live previews
2. Command runner with PATH integration
3. Clipboard manager with history
4. Screenshot tools (fullscreen, area, window)
5. Lock screen implementation
6. Theme switcher and customization

**Success Criteria:**
- Window switcher shows all windows with previews
- Command runner executes commands successfully
- Clipboard history persists across sessions
- Screenshots save correctly with all modes
- Lock screen prevents unauthorized access
- Themes switch dynamically

### Phase 5: Polish & Optimization (Weeks 17-20)

**Objectives:**
- Performance optimization
- Animation and transition polish
- Comprehensive testing
- Documentation completion
- Community preparation

**Deliverables:**
1. Performance profiling and optimization
2. Smooth animations throughout UI
3. Complete test coverage
4. User and developer documentation
5. Configuration examples and presets
6. Installation and setup guides

**Success Criteria:**
- <100ms response time for all interactions
- Smooth 60fps animations
- >80% test coverage
- Complete API documentation
- Working installation scripts
- User guide completed

### Phase 6: Extended Features & Moonshots (Weeks 21+)

**Objectives:**
- Implement high-priority moonshot features
- Add extended utilities
- Community plugin system
- Advanced integrations

**Deliverables:**
1. Universal search (Gauntlet-style)
2. AI assistant integration (Ollama)
3. Plugin system for community extensions
4. Password manager integration
5. Device sync (KDE Connect)
6. OCR text recognition
7. Voice control (if feasible)

**Success Criteria:**
- Universal search searches across all sources
- AI assistant responds to queries
- Plugin system allows third-party extensions
- Password manager integration secure
- Device sync with Android working
- OCR accurately extracts screen text

---

## Key Reference Projects & Resources

### Primary References

**DankMaterialShell**
- Repository: https://github.com/AvengeMedia/DankMaterialShell
- IPC Framework: https://github.com/AvengeMedia/dgop
- Key Learning: Production-ready QuickShell implementation
- Focus Areas: Complete widget ecosystem, IPC patterns, service architecture

**Noctalia Shell**
- Repository: https://github.com/noctalia-dev/noctalia-shell
- Key Learning: Multi-compositor abstraction, modular architecture
- Focus Areas: CompositorService pattern, event system, configuration

**Caelestia Shell**
- Repository: https://github.com/caelestia-dots/shell
- Key Learning: Build system integration, deployment patterns
- Focus Areas: CMake patterns, system installation

**Vantesh DMS Integration**
- Repository: https://github.com/Vantesh/dotfiles/tree/main/home/dot_config/quickshell/dms
- Key Learning: Real-world dotfile management
- Focus Areas: User configuration, customization patterns

### Supporting References

**End-4 Dots Hyprland**
- Repository: https://github.com/end-4/dots-hyprland
- Wiki: https://end-4.github.io/dots-hyprland-wiki/en/general/showcase/
- Key Learning: AI plugin integration, shortcut visualization
- Note: Has legacy AGS implementation as well

**Fabric Implementations**
- Ax-Shell: https://github.com/Axenide/Ax-Shell (explicit roadmap)
- Tsumiki: https://github.com/rubiin/Tsumiki (OCR implementation)

**Alternative Launchers (Raycast-inspired)**
- Vicinae: https://github.com/vicinaehq/vicinae
- Gauntlet: https://github.com/project-gauntlet/gauntlet
- Sherlock: https://github.com/Skxxtz/sherlock

**Traditional Tool References**
- Waybar: https://github.com/Alexays/Waybar (module reference)
- Rofi: https://github.com/adi1090x/rofi (rich implementation history)

### Technical Documentation

**Sway Documentation**
- IPC Protocol: https://github.com/swaywm/sway/blob/master/sway/sway-ipc.7.scd
- Man Pages: sway(1), sway-ipc(7), sway-bar(5)

**Layer Shell Protocol**
- Protocol Spec: https://github.com/swaywm/wlr-protocols
- Qt Integration: qt-wayland layer-shell plugin

**Qt/QML Documentation**
- Qt Quick: https://doc.qt.io/qt-6/qtquick-index.html
- QML Best Practices: https://doc.qt.io/qt-6/qtquick-bestpractices.html

---

## Build and Deployment

### Development Setup

```bash
#!/bin/bash
# scripts/dev-setup.sh

set -e

echo "Setting up fx-shell development environment..."

# Check dependencies
command -v quickshell >/dev/null 2>&1 || {
    echo "Error: quickshell not found. Please install quickshell first."
    exit 1
}

# Create config directory
mkdir -p ~/.config/fx-shell

# Link development config
ln -sf "$(pwd)/shell.qml" ~/.config/fx-shell/shell.qml

# Set up development environment
export FX_SHELL_DEV=1
export FX_SHELL_DEBUG=1

echo "Development environment ready!"
echo "Run 'quickshell ~/.config/fx-shell/shell.qml' to start"
```

### Debug Build

```bash
#!/bin/bash
# scripts/build-debug.sh

set -e

export QT_LOGGING_RULES="*.debug=true"
export FX_SHELL_DEBUG=1

quickshell --debug shell.qml
```

### System Installation

```bash
#!/bin/bash
# scripts/install-system.sh

set -e

PREFIX="${PREFIX:-/usr/local}"
CONFIG_DIR="${HOME}/.config/fx-shell"

echo "Installing fx-shell to ${PREFIX}..."

# Install QML files
install -d "${PREFIX}/share/fx-shell"
cp -r modules commons assets "${PREFIX}/share/fx-shell/"
install -Dm644 shell.qml "${PREFIX}/share/fx-shell/shell.qml"

# Install user configuration
install -d "${CONFIG_DIR}"
[ ! -f "${CONFIG_DIR}/config.json" ] && \
    install -Dm644 docs/examples/config.json "${CONFIG_DIR}/config.json"

# Install desktop entry
install -Dm644 <<EOF "${PREFIX}/share/wayland-sessions/fx-shell.desktop"
[Desktop Entry]
Name=fx-shell
Comment=Modern Wayland desktop shell
Exec=quickshell ${PREFIX}/share/fx-shell/shell.qml
Type=Application
EOF

echo "Installation complete!"
```

---

## Testing Strategy

### Unit Tests

```qml
// tests/unit/test-sway-service.qml
import QtQuick
import QtTest

TestCase {
    name: "SwayServiceTests"
    
    function test_workspace_switching() {
        const service = ServiceRegistry.getService("sway")
        service.switchWorkspace(2)
        // Verify workspace changed
        wait(100)
        compare(service.currentWorkspace, 2)
    }
    
    function test_window_management() {
        const service = ServiceRegistry.getService("sway")
        const window = service.windows[0]
        service.toggleFloating(window.id)
        wait(100)
        verify(window.floating !== service.windows[0].floating)
    }
}
```

### Integration Tests

```qml
// tests/integration/test-panel-integration.qml
import QtQuick
import QtTest

TestCase {
    name: "PanelIntegrationTests"
    
    function test_status_bar_loads() {
        const statusBar = createTemporaryObject(
            Qt.createComponent("modules/ui/panels/statusbar/src/StatusBar.qml"),
            null
        )
        verify(statusBar !== null)
        verify(statusBar.visible === true)
    }
    
    function test_workspace_widget_updates() {
        const workspaceWidget = createTemporaryObject(
            Qt.createComponent("modules/ui/widgets/WorkspaceIndicator.qml"),
            null
        )
        
        // Trigger workspace change
        EventBus.emit("workspace:changed", { num: 3 })
        wait(50)
        
        // Verify widget updated
        compare(workspaceWidget.currentWorkspace, 3)
    }
}
```

---

## Packaging for Fedora COPR

### QuickShell Dependencies

The QuickShell framework and fx-shell should be packaged for Fedora COPR following these specifications:

**Runtime Dependencies:**
- `qt6-qtbase` - Qt 6 base framework
- `qt6-qtdeclarative` - QML runtime and Qt Quick
- `qt6-qtwayland` - Wayland platform plugin
- `wayland-protocols` - Wayland protocol definitions
- `layer-shell-qt` - Layer shell protocol support
- `sway` - Target compositor (recommended but not required)

**Build Dependencies:**
- `cmake` - Build system
- `gcc-c++` - C++ compiler
- `qt6-qtbase-devel` - Qt development files
- `qt6-qtdeclarative-devel` - QML development files
- `wayland-devel` - Wayland development files

### COPR Spec File Template

```spec
Name:           fx-shell
Version:        1.0.0
Release:        1%{?dist}
Summary:        Modern Wayland desktop shell built on QuickShell

License:        MIT
URL:            https://github.com/yourusername/fx-shell
Source0:        %{url}/archive/v%{version}/%{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       quickshell
Requires:       qt6-qtbase
Requires:       qt6-qtdeclarative
Requires:       qt6-qtwayland
Requires:       layer-shell-qt

Recommends:     sway
Recommends:     pulseaudio
Recommends:     networkmanager

%description
fx-shell is a modern, feature-complete Wayland desktop shell built on
QuickShell, targeting Sway compositor with cross-compositor ambitions.

%prep
%autosetup

%build
# QML files don't need building

%install
# Install QML files
mkdir -p %{buildroot}%{_datadir}/fx-shell
cp -r modules commons assets shell.qml %{buildroot}%{_datadir}/fx-shell/

# Install desktop entry
mkdir -p %{buildroot}%{_datadir}/wayland-sessions
cat > %{buildroot}%{_datadir}/wayland-sessions/fx-shell.desktop <<EOF
[Desktop Entry]
Name=fx-shell
Comment=Modern Wayland desktop shell
Exec=quickshell %{_datadir}/fx-shell/shell.qml
Type=Application
EOF

# Install documentation
mkdir -p %{buildroot}%{_docdir}/%{name}
cp -r docs/* %{buildroot}%{_docdir}/%{name}/

%files
%license LICENSE
%doc README.md
%{_datadir}/fx-shell/
%{_datadir}/wayland-sessions/fx-shell.desktop
%{_docdir}/%{name}/

%changelog
* Tue Oct 21 2025 Your Name <your@email.com> - 1.0.0-1
- Initial package
```

---

## Future Considerations

### Compositor Expansion

While fx-shell is Sway-first, the architecture supports future expansion to other compositors:

**Priority Order:**
1. **Sway** (Primary target, current focus)
2. **Hyprland** (Large user base, JSON IPC similar to Noctalia patterns)
3. **River** (Wayland-native, growing ecosystem)
4. **Niri** (Innovative scrollable columns, modern architecture)

**Abstraction Strategy:**
- Maintain CompositorService as abstraction layer
- Implement compositor-specific backends
- Share common UI components across backends
- Use feature detection for compositor-specific functionality

### Plugin System Architecture

A future plugin system could enable community extensions:

**Plugin Types:**
- Widget plugins (custom status bar widgets)
- Service plugins (new system integrations)
- Theme plugins (complete visual overhauls)
- Launcher plugins (additional search sources)

**Plugin API:**
```qml
// Example plugin interface
QtObject {
    id: plugin
    
    property string name
    property string version
    property string author
    property var dependencies: []
    
    function activate() {
        // Plugin activation
    }
    
    function deactivate() {
        // Plugin cleanup
    }
}
```

### Community & Ecosystem

**Documentation:**
- Complete API documentation for all services
- User guide with screenshots and examples
- Developer guide for contributing
- Plugin development tutorial

**Configuration Sharing:**
- Git-based config repository
- Community config presets
- Theme gallery with previews
- Widget catalog

**Development Tools:**
- Visual widget builder (web-based)
- Configuration validator
- Theme editor
- Debug inspector

---

## Conclusion

This specification provides a comprehensive foundation for fx-shell development, consolidating all research, architectural decisions, and implementation details into a single authoritative document.

**Key Takeaways:**

1. **QuickShell** provides the optimal balance of performance, developer experience, and ecosystem maturity for fx-shell

2. **DankMaterialShell** serves as the primary reference implementation, demonstrating production-ready patterns across the full widget spectrum

3. **Noctalia's modular architecture** informs fx-shell's service-oriented design, enabling clean separation of concerns and future compositor expansion

4. **Sway IPC integration** requires careful implementation of i3-compatible binary protocol, event subscriptions, and workspace management

5. **LLM-optimized repository structure** with embedded references and comprehensive documentation accelerates development while maintaining quality

6. **Comprehensive widget catalog** identifies 58+ potential components across 5 priority tiers, from essential desktop functionality to moonshot innovations

7. **Phased implementation roadmap** provides clear milestones from foundation through advanced features, spanning 20+ weeks of development

This document replaces all previous specifications and serves as the single source of truth for fx-shell moving forward.
