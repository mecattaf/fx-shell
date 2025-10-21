# QuickShell Architecture Patterns - Comparative Analysis

**Date:** October 21, 2025
**Scope:** DankMaterialShell, Noctalia Shell, Caelestia Shell
**Focus:** Architectural patterns, module organization, theming systems

---

## Executive Summary

After analyzing three major QuickShell implementations (DankMaterialShell, Noctalia, Caelestia), clear architectural patterns emerge that can guide fx-shell's development. All three projects share core design principles while each introduces refinements based on their specific goals.

### Key Findings

1. **Module Organization:** All use feature-based modules (Bar, Launcher, Notifications, etc.)
2. **Service Architecture:** Singleton services accessed globally, registered at startup
3. **Theme System:** Material Design 3 + matugen color generation pipeline
4. **Configuration:** Multiple approaches from monolithic to highly modular
5. **Commons/Shared:** Centralized utilities and singletons (similar to fx-shell's current approach)

---

## 1. Top-Level Organization Comparison

### DankMaterialShell (Most Comprehensive)
```
DankMaterialShell/
├── shell.qml              # Main entry point
├── Common/                # Shared singletons (Theme, SettingsData, Paths)
├── Services/              # System integration services (30+ services)
├── Modules/               # Feature modules (DankBar, Dock, Notifications, etc.)
├── Modals/                # Modal dialogs (Spotlight, Clipboard, Settings)
├── Widgets/               # Reusable UI components
├── PLUGINS/               # Plugin system with examples
├── matugen/               # Color scheme generation (dank16.py + templates)
├── Shaders/               # QML shaders
├── assets/                # Icons, sounds, systemd units, PAM config
└── scripts/               # Utility scripts
```

**Characteristics:**
- Most feature-complete
- Clear separation: Common → Services → Modules → Widgets
- Plugin system built-in
- Matugen integration at project root level

---

### Noctalia Shell (Refined & Modular)
```
noctalia-shell/
├── shell.qml              # Main entry point
├── Commons/               # Shared utilities
├── Services/              # System services
├── Modules/               # Feature modules (Bar, Launcher, Dock, etc.)
├── Widgets/               # Reusable components
├── Helpers/               # Helper utilities
├── Shaders/               # QML shaders
├── Assets/                # Resources
│   ├── ColorScheme/       # Pre-defined color schemes (13 themes!)
│   ├── MatugenTemplates/  # Matugen template adaptations
│   ├── Wallpaper/         # Default wallpapers
│   ├── Fonts/             # Icon fonts
│   └── Translations/      # i18n support
└── Bin/                   # Utility binaries (battery-manager, dev tools)
```

**Characteristics:**
- Similar structure to DMS but more organized
- Pre-defined color schemes as static assets
- Strong focus on theming infrastructure
- Helpers/ for utility functions
- Better asset organization

---

### Caelestia Shell (Highly Modular Config)
```
caelestia-shell/
├── shell.qml              # Main entry point
├── components/            # Reusable UI components
│   ├── controls/          # Form controls
│   ├── misc/              # Miscellaneous
│   ├── effects/           # Visual effects
│   ├── images/            # Image components
│   ├── containers/        # Layout containers
│   ├── widgets/           # Complex widgets
│   └── filedialog/        # File picker
├── modules/               # Feature modules
├── services/              # System services
├── config/                # MODULAR CONFIG FILES
│   ├── Config.qml         # Main config aggregator
│   ├── Appearance.qml     # Appearance singleton
│   ├── AppearanceConfig.qml
│   ├── BarConfig.qml
│   ├── LauncherConfig.qml
│   ├── GeneralConfig.qml
│   └── [15+ config files]
├── plugin/                # C++ plugin (src/Caelestia/)
├── utils/scripts/         # Utility scripts
├── extras/                # Extra functionality
└── assets/                # Resources
```

**Characteristics:**
- Most granular config organization
- C++ plugin for performance-critical code
- Components organized by type/purpose
- Highly modular configuration approach

---

## 2. Service Architecture Patterns

### Service Count Comparison

| Project | Service Count | Notable Services |
|---------|---------------|------------------|
| DankMaterialShell | 31 services | CompositorService, DgopService, PluginService, WallpaperCyclingService, SystemUpdateService |
| Noctalia | ~15-20 services | More focused, multi-compositor support |
| Caelestia | ~10 services | Minimal, Hyprland-focused |

### Common Services Across All Projects

1. **Audio/Media**
   - Audio volume/device management
   - MPRIS media player integration

2. **Network**
   - NetworkManager integration
   - WiFi/Ethernet status
   - VPN management (DMS)

3. **Power**
   - Battery monitoring
   - Brightness control
   - Display management

4. **Notifications**
   - D-Bus notification daemon
   - Notification history

5. **Compositor Integration**
   - Workspace management
   - Window tracking
   - IPC communication

### Service Pattern: Singleton with Global Access

All three projects use similar service patterns:

```qml
// Service definition (example from pattern analysis)
pragma Singleton
import QtQuick

QtObject {
    id: audioService

    // Properties
    property real volume: 0.0
    property bool isMuted: false
    property var devices: []

    // Signals
    signal volumeChanged(real newVolume)
    signal deviceAdded(var device)

    // Methods
    function setVolume(vol) { ... }
    function toggleMute() { ... }

    // Initialization
    Component.onCompleted: {
        // Connect to system (PulseAudio/PipeWire)
        initializeBackend()
    }
}
```

**Access Pattern:**
```qml
// From anywhere in the application
import "../Services"

Item {
    Text {
        text: `Volume: ${AudioService.volume}%`
    }

    Slider {
        value: AudioService.volume
        onValueChanged: AudioService.setVolume(value)
    }
}
```

---

## 3. Configuration Management Patterns

### Pattern 1: Monolithic Config (DankMaterialShell)

**File:** `Common/SettingsData.qml` (91 KB!)

```qml
pragma Singleton
import QtQuick

QtObject {
    id: settings

    // Bar settings
    property var bar: ({
        position: "top",
        height: 32,
        // ... hundreds of settings
    })

    // Launcher settings
    property var launcher: ({
        // ... many settings
    })

    // ... continues for all modules
}
```

**Pros:**
- Single source of truth
- Easy to access any setting
- Simple mental model

**Cons:**
- Huge file (hard to maintain)
- Slow to load/parse
- Difficult to modularize

---

### Pattern 2: Modular Config (Caelestia)

**Main:** `config/Config.qml`
```qml
pragma Singleton
import QtQuick

QtObject {
    id: config

    property GeneralConfig general: GeneralConfig {}
    property AppearanceConfig appearance: AppearanceConfig {}
    property BarConfig bar: BarConfig {}
    property LauncherConfig launcher: LauncherConfig {}
    // ... etc
}
```

**Individual configs:** `config/BarConfig.qml`
```qml
pragma Singleton
import QtQuick

QtObject {
    property int height: 32
    property string position: "top"
    property bool transparent: false
    // ... bar-specific settings only
}
```

**Pros:**
- Each module has dedicated config file
- Easy to find and modify settings
- Better for team collaboration
- Lazy loading potential

**Cons:**
- More files to manage
- Need aggregator pattern
- Slightly more complex imports

---

### Pattern 3: Hybrid (Noctalia + fx-shell current)

**Approach:** Commons singletons for each major concern
- `Config.qml` - User preferences
- `Theme.qml` - Theming/appearance
- `SessionData.qml` - Session state
- `Appearance.qml` - Appearance management

**fx-shell already uses this pattern!**

---

## 4. Theme System & Matugen Integration

### The Matugen Pipeline

**Purpose:** Generate cohesive color schemes from a single base color (or wallpaper)

#### DankMaterialShell (Origin)

**Script:** `matugen/dank16.py`
- Python script using `colorsys` module
- Generates Material Design 3 color palette
- Ensures WCAG contrast ratios
- Outputs to multiple template formats

**Config:** `matugen/configs/base.toml`
```toml
[config]
reload_apps = false
reload_apps_list = { gtk = "custom", kitty = "bash" }

[templates.dank]
input_path = "templates/dank.json"
output_path = "~/.config/dank/colors.json"
```

**Template:** `matugen/templates/dank.json`
```json
{
    "colors": {
        "primary": "{{colors.primary.default.hex}}",
        "onPrimary": "{{colors.on_primary.default.hex}}",
        "secondary": "{{colors.secondary.default.hex}}",
        ...
    }
}
```

**Integration:**
```qml
// Common/Theme.qml loads generated colors
property var colors: loadMatugenColors()

function loadMatugenColors() {
    // Read ~/.config/dank/colors.json
    // Parse and expose as properties
}
```

---

#### Noctalia (Adaptation)

**Enhancement 1:** Pre-defined color schemes

`Assets/ColorScheme/Catppuccin/Catppuccin.json`:
```json
{
    "dark": {
        "mPrimary": "#cba6f7",
        "mOnPrimary": "#11111b",
        "mSurface": "#1e1e2e",
        "mOnSurface": "#cdd6f4",
        ...
    },
    "light": { ... }
}
```

**Enhancement 2:** Custom matugen templates

`Assets/MatugenTemplates/Terminal/` - Terminal-specific color outputs

**Benefits:**
- Users can choose pre-made themes OR generate from wallpaper
- Consistent naming (mPrimary, mOnPrimary, etc.)
- Both manual and automatic theme generation

---

#### Caelestia (Refinement)

**Approach:** Material 3 variants service

`modules/launcher/services/M3Variants.qml`:
- Manages Material 3 color variants
- Likely integrates with matugen or similar

`modules/launcher/services/Schemes.qml`:
- Color scheme selection/management

**Pattern:** Service-based theme management rather than static loading

---

### Material Design 3 Color System (All Three Use This)

```qml
// Standard M3 color properties
QtObject {
    // Primary colors
    property color mPrimary
    property color mOnPrimary
    property color mPrimaryContainer
    property color mOnPrimaryContainer

    // Secondary colors
    property color mSecondary
    property color mOnSecondary
    property color mSecondaryContainer
    property color mOnSecondaryContainer

    // Tertiary colors
    property color mTertiary
    property color mOnTertiary

    // Surface colors
    property color mSurface
    property color mOnSurface
    property color mSurfaceVariant
    property color mOnSurfaceVariant

    // Utility colors
    property color mError
    property color mOnError
    property color mOutline
    property color mShadow
    property color mBackground
}
```

---

## 5. Module Organization Patterns

### Common Module Structure (All Three)

```
modules/[feature]/
├── [Feature].qml           # Main module component
├── Components/             # Feature-specific components
├── Models/                 # Data models
├── Widgets/                # Feature-specific widgets
└── utils/                  # Feature-specific utilities
```

### Module Responsibilities

#### Bar/StatusBar Module
- Workspace indicators
- System tray
- Clock/calendar
- Quick settings buttons
- Window title

#### Launcher Module
- Application search
- Desktop file parsing
- Fuzzy matching
- Recent apps tracking
- Categories/filtering

#### Notifications Module
- D-Bus notification server
- Notification popup
- Notification center
- Action handling
- Persistence

#### Dock Module
- Favorite apps
- Running apps
- Window previews
- Drag-and-drop

#### ControlCenter Module
- Audio controls
- Network settings
- Bluetooth
- Brightness
- Power management
- Quick toggles

---

## 6. Plugin System (DankMaterialShell)

**Location:** `PLUGINS/` directory

**Architecture:**
- `Services/PluginService.qml` - Plugin loader and manager
- Each plugin is a QML module with metadata
- Plugins can extend: Launcher, ControlCenter, Bar widgets, Emoji picker

**Example Plugin Structure:**
```
PLUGINS/ExamplePlugin/
├── metadata.json          # Plugin info (name, version, author)
├── Main.qml               # Plugin entry point
└── Components/            # Plugin components
```

**Registration:**
```qml
// Plugin defines what it extends
QtObject {
    property string pluginType: "launcher"  // or "controlcenter", "widget"
    property string name: "Calculator"
    property string icon: "calculator"

    function activate() {
        // Plugin activation logic
    }
}
```

---

## 7. Inter-Module Communication

### Pattern: Event-Driven via Signals

All three projects use Qt signal/slot mechanism:

```qml
// Service emits signals
AudioService {
    signal volumeChanged(real newVolume)
}

// Modules connect to signals
Item {
    Connections {
        target: AudioService
        function onVolumeChanged(newVolume) {
            // Update UI
        }
    }
}
```

### Pattern: Direct Service Access

```qml
// Modules access services directly
Button {
    onClicked: AudioService.toggleMute()
}

Text {
    text: `${NetworkService.ssid} - ${NetworkService.signalStrength}%`
}
```

### Pattern: Modal Manager (DMS)

```qml
// Common/ModalManager.qml
pragma Singleton
QtObject {
    signal showLauncher()
    signal showSettings()
    signal closeAll()
}

// Any component can trigger
Button {
    onClicked: ModalManager.showLauncher()
}
```

**fx-shell's EventBus is similar but more centralized!**

---

## 8. Build System & Installation

### DankMaterialShell
- **Build:** None (pure QML)
- **Install:** Scripts to copy files to `.config/dank/`
- **Assets:** systemd units, PAM config for greeter

### Noctalia
- **Build:** None (pure QML)
- **Install:** User installs to `.config/noctalia/`
- **Helpers:** `Bin/` directory with battery manager, dev tools

### Caelestia
- **Build:** C++ plugin (`plugin/src/Caelestia/`)
  - Compiled with CMake
  - Provides native performance for specific features
- **Install:** Mix of QML + compiled plugin
- **Advanced:** Uses nix for reproducible builds

---

## 9. Key Takeaways for fx-shell

### Adopt These Patterns

1. **Modular Config Approach (Caelestia-style)**
   - Split `Config.qml` into domain-specific configs
   - Easier to maintain as project grows
   - Better for LLM code generation (smaller files)

2. **Matugen Color System**
   - Material Design 3 color naming
   - Pre-defined themes + wallpaper generation
   - Consistent color system across all components

3. **Service Architecture (All Three)**
   - Keep singleton services pattern
   - 10-15 core services is sufficient to start
   - Add more as needed

4. **Module Organization (Noctalia-style)**
   - Feature-based modules with internal structure
   - Each module self-contained
   - Clear dependencies

5. **Commons/Shared Utilities (Current Approach is Good!)**
   - Theme, Config, Utils, ServiceRegistry, EventBus
   - fx-shell already follows this pattern

### Avoid These Patterns

1. **Monolithic Config File**
   - DMS's 91KB SettingsData.qml is hard to maintain
   - Split early before it grows

2. **Too Many Services**
   - Start lean (10-15 services)
   - Don't create service for every small feature
   - Some features can be module-internal

3. **Scattered Assets**
   - Consolidate assets/ early
   - Clear organization like Noctalia

### Unique Opportunities for fx-shell

1. **Compositor Abstraction from Day 1**
   - Plan for multi-compositor even if Sway-first
   - Learn from Noctalia's multi-compositor approach
   - DMS supports Niri + Hyprland

2. **Plugin System (Future)**
   - DMS has proven plugin architecture
   - Can be added later when core is stable

3. **Enhanced Event Bus**
   - fx-shell's EventBus is more centralized than DMS's ModalManager
   - Can be powerful for cross-cutting concerns
   - Document event types clearly

---

## 10. Recommended Architecture for fx-shell

Based on analysis, fx-shell should evolve to:

```
fx-shell/
├── shell.qml                      # Entry point (already have)
├── commons/                       # Shared singletons (already have)
│   ├── ServiceRegistry.qml        # ✅ Have
│   ├── EventBus.qml               # ✅ Have
│   ├── Theme.qml                  # ✅ Have (enhance with M3 colors)
│   ├── Utils.qml                  # ✅ Have
│   └── qmldir                     # ✅ Have
├── config/                        # NEW: Modular config (Caelestia pattern)
│   ├── Config.qml                 # Main aggregator
│   ├── AppearanceConfig.qml
│   ├── PanelConfig.qml
│   ├── LauncherConfig.qml
│   ├── NotificationsConfig.qml
│   └── ... (create as needed)
├── services/                      # NEW: System services
│   ├── AudioService.qml
│   ├── NetworkService.qml
│   ├── PowerService.qml
│   ├── BluetoothService.qml
│   ├── NotificationService.qml
│   ├── CompositorService.qml      # Sway integration
│   ├── WorkspaceService.qml
│   └── ... (add as needed)
├── modules/                       # Feature modules (already have structure)
│   ├── ui/panels/statusbar/       # ✅ Have structure
│   ├── ui/notifications/          # Enhance
│   ├── launchers/app-launcher/    # Enhance
│   └── ... (existing modules)
├── widgets/                       # NEW: Reusable components
│   ├── buttons/
│   ├── sliders/
│   ├── cards/
│   └── indicators/
├── assets/                        # Consolidate resources
│   ├── themes/                    # Pre-defined color schemes
│   │   ├── Catppuccin.json
│   │   ├── Dracula.json
│   │   ├── Tokyo-Night.json
│   │   └── fx-default.json
│   ├── icons/
│   ├── fonts/
│   └── matugen/                   # Color generation
│       ├── templates/
│       └── configs/
├── scripts/                       # ✅ Have
└── docs/                          # ✅ Have
```

---

## Conclusion

All three QuickShell projects converge on similar architectural patterns with minor variations. **fx-shell's current foundation is already aligned with best practices**. The main enhancements should be:

1. **Split Config.qml into modular configs** (Caelestia pattern)
2. **Implement matugen + M3 color system** (DMS/Noctalia pattern)
3. **Create services/ directory** with core system services
4. **Add widgets/ directory** for reusable components
5. **Consolidate assets/** with pre-defined themes

These changes will set fx-shell up for sustainable growth while maintaining the clean architecture established in ISSUE-1.
