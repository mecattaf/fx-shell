# fx-shell Architecture Recommendations (ISSUE-2)

**Analysis Date:** October 21, 2025
**Based On:** DankMaterialShell, Noctalia Shell, Caelestia Shell analysis
**Current Status:** Post-ISSUE-1 (Foundation complete)
**Target:** Sustainable architectural evolution

---

## Executive Summary

After comprehensive analysis of three major QuickShell implementations, clear patterns emerge that can guide fx-shell's development. **The good news: fx-shell's current foundation (from ISSUE-1) is already well-aligned with best practices.** This document provides specific recommendations for evolution.

### Key Findings

✅ **What's Already Good:**
- Commons singletons (ServiceRegistry, EventBus, Config, Theme, Utils)
- Modular directory structure
- Development tooling
- LLM-optimized guidelines

⚠️ **What Needs Enhancement:**
- Config management (split into modular configs)
- Theme system (add Material Design 3 + pre-defined themes)
- Services directory (create system integration services)
- Widgets directory (reusable UI components)
- Assets organization (consolidate themes, icons, fonts)

---

## Current State Assessment

### What ISSUE-1 Delivered

```
fx-shell/
├── shell.qml                    # ✅ Entry point
├── commons/                     # ✅ Singletons
│   ├── ServiceRegistry.qml
│   ├── EventBus.qml
│   ├── Config.qml
│   ├── Theme.qml
│   ├── Utils.qml
│   └── qmldir
├── modules/                     # ✅ Structure exists
│   ├── core/
│   ├── ui/
│   ├── services/
│   ├── launchers/
│   ├── utilities/
│   └── integrations/
├── assets/                      # ✅ Placeholder
├── docs/                        # ✅ Comprehensive
├── scripts/                     # ✅ Development tools
└── tests/                       # ✅ Structure ready
```

**Verdict:** Excellent foundation, ready for enhancements.

---

## Recommended Evolutionary Changes

### 1. Modularize Configuration (High Priority)

**Problem:** `commons/Config.qml` will become unwieldy as features grow (DankMaterialShell has 91KB config file!).

**Solution:** Adopt Caelestia's modular config pattern.

#### Create `config/` Directory

```
config/
├── Config.qml                 # Main aggregator
├── AppearanceConfig.qml       # Theme, colors, spacing
├── PanelConfig.qml            # Status bar settings
├── DockConfig.qml             # Dock settings (when implemented)
├── LauncherConfig.qml         # App launcher settings
├── NotificationsConfig.qml    # Notification settings
├── ServiceConfig.qml          # Service-specific settings
└── qmldir                     # Singleton registration
```

#### Implementation

**config/Config.qml:**
```qml
pragma Singleton
import QtQuick
import "./config" as ConfigModules

QtObject {
    id: config

    // Sub-configs
    property AppearanceConfig appearance: AppearanceConfig {}
    property PanelConfig panel: PanelConfig {}
    property LauncherConfig launcher: LauncherConfig {}
    property NotificationsConfig notifications: NotificationsConfig {}
    property ServiceConfig services: ServiceConfig {}

    // Load/save
    function load() {
        // Load from ~/.config/fx-shell/config.json
    }

    function save() {
        // Save to ~/.config/fx-shell/config.json
    }
}
```

**config/AppearanceConfig.qml:**
```qml
pragma Singleton
import QtQuick

QtObject {
    // Theme
    property string colorScheme: "fx-default"
    property string mode: "dark"  // or "light"
    property string font: "Inter"
    property int fontSize: 11

    // Spacing
    property int spacing: 8
    property int spacingSmall: 4
    property int spacingLarge: 16

    // Border radius
    property int radius: 8
    property int radiusSmall: 4
    property int radiusLarge: 16

    // Animations
    property int animationDuration: 200
    property string animationEasing: "OutCubic"
}
```

**Benefits:**
- Each domain has dedicated config file
- Easy to find and modify settings
- Better for LLM code generation (smaller files)
- Scales well as project grows

---

### 2. Enhance Theme System (High Priority)

**Current:** Basic theming in `commons/Theme.qml`

**Enhancement:** Material Design 3 + pre-defined color schemes

#### Add Material 3 Color Properties

**commons/Theme.qml (enhanced):**
```qml
pragma Singleton
import QtQuick
import "../config"

QtObject {
    id: theme

    // Current theme
    property string mode: AppearanceConfig.mode
    property string scheme: AppearanceConfig.colorScheme

    // Load colors
    property var colors: loadColors()

    // Material Design 3 Color System
    property color mPrimary: colors.mPrimary || "#4285f4"
    property color mOnPrimary: colors.mOnPrimary || "#ffffff"
    property color mPrimaryContainer: colors.mPrimaryContainer || "#1e3a5f"
    property color mOnPrimaryContainer: colors.mOnPrimaryContainer || "#d1e3ff"

    property color mSecondary: colors.mSecondary || "#03dac6"
    property color mOnSecondary: colors.mOnSecondary || "#003731"

    property color mSurface: colors.mSurface || "#1e1e1e"
    property color mOnSurface: colors.mOnSurface || "#e3e3e3"
    property color mSurfaceVariant: colors.mSurfaceVariant || "#2d2d2d"
    property color mOnSurfaceVariant: colors.mOnSurfaceVariant || "#c7c7c7"

    property color mError: colors.mError || "#cf6679"
    property color mOnError: colors.mOnError || "#000000"

    property color mOutline: colors.mOutline || "#3d3d3d"
    property color mShadow: colors.mShadow || "#000000"
    property color mBackground: colors.mBackground || "#121212"
    property color mOnBackground: colors.mOnBackground || "#e3e3e3"

    // Legacy mappings (backward compatibility)
    property color background: mBackground
    property color surface: mSurface
    property color primary: mPrimary
    property color text: mOnSurface

    // Typography
    property string fontFamily: AppearanceConfig.font
    property int fontSize: AppearanceConfig.fontSize

    // Spacing
    property int spacing: AppearanceConfig.spacing
    property int spacingSmall: AppearanceConfig.spacingSmall
    property int spacingLarge: AppearanceConfig.spacingLarge

    // Border radius
    property int radius: AppearanceConfig.radius
    property int radiusSmall: AppearanceConfig.radiusSmall
    property int radiusLarge: AppearanceConfig.radiusLarge

    // Animations
    property int animationDuration: AppearanceConfig.animationDuration

    // Signals
    signal themeChanged()

    // Functions
    function loadColors() {
        const path = `assets/themes/${scheme}.json`
        try {
            const data = Utils.readFile(path)
            const themeData = JSON.parse(data)
            return themeData[mode]
        } catch (e) {
            console.error("Failed to load theme:", e)
            return {}
        }
    }

    function switchScheme(newScheme) {
        scheme = newScheme
        AppearanceConfig.colorScheme = newScheme
        colors = loadColors()
        themeChanged()
    }

    function toggleMode() {
        mode = (mode === "dark") ? "light" : "dark"
        AppearanceConfig.mode = mode
        colors = loadColors()
        themeChanged()
    }
}
```

#### Create Theme Assets

**assets/themes/fx-default.json:**
```json
{
    "dark": {
        "mPrimary": "#4285f4",
        "mOnPrimary": "#ffffff",
        "mPrimaryContainer": "#1e3a5f",
        "mOnPrimaryContainer": "#d1e3ff",
        "mSecondary": "#03dac6",
        "mOnSecondary": "#003731",
        "mSurface": "#1e1e1e",
        "mOnSurface": "#e3e3e3",
        "mSurfaceVariant": "#2d2d2d",
        "mOnSurfaceVariant": "#c7c7c7",
        "mError": "#cf6679",
        "mOnError": "#000000",
        "mOutline": "#3d3d3d",
        "mShadow": "#000000",
        "mBackground": "#121212",
        "mOnBackground": "#e3e3e3"
    },
    "light": {
        "mPrimary": "#1967d2",
        "mOnPrimary": "#ffffff",
        "mPrimaryContainer": "#d1e3ff",
        "mOnPrimaryContainer": "#002c5f",
        "mSecondary": "#006b5d",
        "mOnSecondary": "#ffffff",
        "mSurface": "#ffffff",
        "mOnSurface": "#1a1a1a",
        "mSurfaceVariant": "#f5f5f5",
        "mOnSurfaceVariant": "#424242",
        "mError": "#b00020",
        "mOnError": "#ffffff",
        "mOutline": "#d0d0d0",
        "mShadow": "#000000",
        "mBackground": "#fafafa",
        "mOnBackground": "#1a1a1a"
    }
}
```

**Also create:**
- `assets/themes/catppuccin.json`
- `assets/themes/tokyo-night.json`
- `assets/themes/dracula.json`
- `assets/themes/nord.json`

---

### 3. Create Services Directory (High Priority)

**Current:** Services scattered in `modules/services/`

**Enhancement:** Dedicated `services/` at root level

#### Create `services/` Directory

```
services/
├── CompositorService.qml      # Sway IPC integration
├── WorkspaceService.qml        # Workspace management
├── WindowService.qml           # Window tracking
├── AudioService.qml            # PulseAudio/PipeWire
├── NetworkService.qml          # NetworkManager
├── BluetoothService.qml        # Bluetooth management
├── PowerService.qml            # Battery, brightness, power
├── NotificationService.qml     # D-Bus notifications
└── qmldir                      # Service registration
```

#### Service Pattern Template

**services/AudioService.qml:**
```qml
pragma Singleton
import QtQuick
import "../commons"

QtObject {
    id: audioService

    // Properties
    property real volume: 0.0
    property real micVolume: 0.0
    property bool isMuted: false
    property bool micMuted: false
    property var sinks: []
    property var sources: []
    property string defaultSink: ""
    property string defaultSource: ""

    // Signals
    signal volumeChanged(real newVolume)
    signal muteChanged(bool muted)
    signal deviceAdded(var device)
    signal deviceRemoved(string deviceId)

    // Methods
    function setVolume(vol) {
        volume = Math.max(0, Math.min(100, vol))
        // Call backend (PulseAudio/PipeWire)
        volumeChanged(volume)
    }

    function toggleMute() {
        isMuted = !isMuted
        // Call backend
        muteChanged(isMuted)
    }

    function setDefaultSink(sinkName) {
        defaultSink = sinkName
        // Call backend
    }

    // Initialization
    Component.onCompleted: {
        ServiceRegistry.registerService("audio", audioService)
        initializeBackend()
    }

    function initializeBackend() {
        // TODO: Initialize PulseAudio/PipeWire connection
        // Subscribe to events
        // Load current state
    }
}
```

**Registration:**
Services auto-register via `Component.onCompleted` → `ServiceRegistry.registerService()`

---

### 4. Create Widgets Directory (Medium Priority)

**Purpose:** Reusable UI components used across modules

```
widgets/
├── buttons/
│   ├── PrimaryButton.qml
│   ├── SecondaryButton.qml
│   ├── IconButton.qml
│   └── ToggleButton.qml
├── cards/
│   ├── Card.qml
│   ├── ElevatedCard.qml
│   └── OutlinedCard.qml
├── sliders/
│   ├── Slider.qml
│   ├── VolumeSlider.qml
│   └── BrightnessSlider.qml
├── indicators/
│   ├── ProgressBar.qml
│   ├── Spinner.qml
│   └── Badge.qml
└── containers/
    ├── Panel.qml
    ├── Popover.qml
    └── Modal.qml
```

**Example Widget:**
```qml
// widgets/buttons/PrimaryButton.qml
import QtQuick
import QtQuick.Controls
import "../../commons"

Button {
    id: button

    implicitWidth: 100
    implicitHeight: Theme.button.height

    background: Rectangle {
        color: {
            if (!button.enabled) return Theme.mSurfaceVariant
            if (button.pressed) return Qt.darker(Theme.mPrimary, 1.2)
            if (button.hovered) return Qt.lighter(Theme.mPrimary, 1.1)
            return Theme.mPrimary
        }
        radius: Theme.radius

        Behavior on color {
            ColorAnimation { duration: Theme.animationDuration }
        }
    }

    contentItem: Text {
        text: button.text
        color: button.enabled ? Theme.mOnPrimary : Theme.mOnSurfaceVariant
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
```

---

### 5. Reorganize Assets (Medium Priority)

**Current:** `assets/` is placeholder

**Enhanced Structure:**
```
assets/
├── themes/                    # Color schemes (JSON)
│   ├── fx-default.json
│   ├── catppuccin.json
│   ├── tokyo-night.json
│   ├── dracula.json
│   └── nord.json
├── icons/                     # Icon theme
│   ├── actions/
│   ├── status/
│   ├── devices/
│   └── apps/
├── fonts/                     # Custom fonts
│   └── tabler-icons.ttf       # Icon font
├── sounds/                    # Notification sounds (optional)
│   ├── notification.ogg
│   └── bell.ogg
└── matugen/                   # Future: color generation
    ├── templates/
    └── configs/
```

---

## Updated Directory Structure

### Final Recommended Structure

```
fx-shell/
├── shell.qml                          # Entry point ✅
│
├── commons/                           # Shared singletons ✅
│   ├── ServiceRegistry.qml            # ✅
│   ├── EventBus.qml                   # ✅
│   ├── Theme.qml                      # ⚠️ ENHANCE with M3
│   ├── Utils.qml                      # ✅
│   └── qmldir                         # ✅
│
├── config/                            # 🆕 MODULAR CONFIG
│   ├── Config.qml                     # Main aggregator
│   ├── AppearanceConfig.qml
│   ├── PanelConfig.qml
│   ├── LauncherConfig.qml
│   ├── NotificationsConfig.qml
│   ├── ServiceConfig.qml
│   └── qmldir
│
├── services/                          # 🆕 SYSTEM SERVICES
│   ├── CompositorService.qml          # Sway IPC
│   ├── WorkspaceService.qml
│   ├── WindowService.qml
│   ├── AudioService.qml
│   ├── NetworkService.qml
│   ├── BluetoothService.qml
│   ├── PowerService.qml
│   ├── NotificationService.qml
│   └── qmldir
│
├── modules/                           # Feature modules ✅
│   ├── ui/
│   │   ├── panels/statusbar/          # ✅
│   │   ├── panels/notifications/
│   │   └── ...
│   ├── launchers/
│   │   ├── app-launcher/              # ✅
│   │   └── ...
│   └── utilities/
│       └── ...
│
├── widgets/                           # 🆕 REUSABLE UI
│   ├── buttons/
│   ├── cards/
│   ├── sliders/
│   ├── indicators/
│   └── containers/
│
├── assets/                            # ⚠️ ORGANIZE
│   ├── themes/                        # 🆕 Color schemes
│   ├── icons/                         # Icon theme
│   ├── fonts/                         # Custom fonts
│   └── matugen/                       # Future: generation
│
├── scripts/                           # Development tools ✅
├── docs/                              # Documentation ✅
└── tests/                             # Test suite ✅
```

**Legend:**
- ✅ Already exists and good
- ⚠️ Exists but needs enhancement
- 🆕 New, needs creation

---

## Implementation Phases

### Phase 1: Foundation Enhancements (ISSUE-3, ~1 week)

**Goal:** Strengthen architectural foundation

**Tasks:**
1. Create `config/` directory with modular configs
2. Enhance `Theme.qml` with M3 color system
3. Create `assets/themes/` with 5 pre-defined schemes
4. Create `services/` directory structure
5. Create `widgets/` directory structure
6. Update documentation

**Deliverables:**
- Modular configuration system
- Material Design 3 theming
- Pre-defined color schemes
- Service and widget directories ready for implementation

---

### Phase 2: Core Services (ISSUE-4, ~2 weeks)

**Goal:** Implement essential system integration

**Services to implement:**
1. **CompositorService** - Sway IPC integration
2. **WorkspaceService** - Workspace management
3. **WindowService** - Window tracking
4. **AudioService** - Volume/device management
5. **PowerService** - Battery, brightness

**Success Criteria:**
- Services auto-register with ServiceRegistry
- Services accessible from anywhere
- Events propagate via EventBus
- Configuration loaded from modular configs

---

### Phase 3: UI Components (ISSUE-5, ~2 weeks)

**Goal:** Build reusable widget library

**Widgets to create:**
1. Primary/Secondary/Icon buttons
2. Cards (flat, elevated, outlined)
3. Sliders (generic, volume, brightness)
4. Progress indicators
5. Containers (panel, popover, modal)

**Success Criteria:**
- All widgets use Theme properties
- Consistent M3 design language
- Accessible (keyboard navigation, screen reader support)
- Documented with examples

---

### Phase 4: Feature Modules (ISSUE-6+, ongoing)

**Goal:** Implement user-facing features using services and widgets

**Order:**
1. Enhanced StatusBar (workspace indicators, system tray, quick settings)
2. Notification system (daemon + UI)
3. App launcher
4. Control center
5. Additional modules as prioritized

---

## Migration Strategy

### Backward Compatibility

During transition, maintain compatibility:

```qml
// OLD: Direct access to Config
property int panelHeight: Config.panels.statusBar.height

// NEW: Access via modular config
property int panelHeight: Config.panel.statusBarHeight

// Provide migration path in Config.qml
QtObject {
    // New pattern
    property PanelConfig panel: PanelConfig {}

    // Legacy compatibility (deprecated)
    property var panels: ({
        statusBar: {
            height: panel.statusBarHeight
            // ... map old structure to new
        }
    })
}
```

### Gradual Migration

1. **Phase 1:** Create new structure alongside old
2. **Phase 2:** Migrate components incrementally
3. **Phase 3:** Remove old structure after full migration

---

## Best Practices (Learned from Analysis)

### DO:

✅ **Use Material Design 3 color system consistently**
- All components reference `Theme.mPrimary`, `Theme.mOnSurface`, etc.
- Never hardcode colors

✅ **Keep services focused and single-purpose**
- AudioService handles audio only
- Don't create mega-services

✅ **Register all services with ServiceRegistry**
- Enables dependency injection
- Facilitates testing
- Clear service discovery

✅ **Use EventBus for cross-cutting concerns**
- Theme changes
- Workspace switches
- Global hotkeys
- Avoids tight coupling

✅ **Keep config files small and focused**
- One domain per config file
- Easy to find and modify

### DON'T:

❌ **Don't create monolithic config files**
- Hard to maintain
- Difficult to navigate
- Slow to parse

❌ **Don't bypass ServiceRegistry**
- Direct imports create tight coupling
- Hard to test
- Difficult to swap implementations

❌ **Don't hardcode values in components**
- Use Theme for appearance
- Use Config for behavior
- Enables user customization

❌ **Don't mix service logic in UI components**
- Services handle system integration
- Components handle presentation
- Clear separation of concerns

---

## Success Metrics

### After Phase 1 (Foundation)

- [ ] Config split into 5+ modular files
- [ ] Theme.qml has M3 color properties
- [ ] 5 pre-defined color schemes available
- [ ] Theme switching works (light/dark + schemes)
- [ ] Directory structure matches recommendation

### After Phase 2 (Core Services)

- [ ] 5+ services implemented and registered
- [ ] Services accessible via ServiceRegistry
- [ ] Events flow through EventBus
- [ ] Services load config from modular configs

### After Phase 3 (UI Components)

- [ ] 15+ reusable widgets created
- [ ] All widgets use Theme properties
- [ ] Widgets documented with examples
- [ ] Consistent M3 design language

### After Phase 4 (Feature Modules)

- [ ] StatusBar functional with system integration
- [ ] Notifications working (daemon + UI)
- [ ] App launcher functional
- [ ] User can customize appearance and behavior

---

## Conclusion

fx-shell's foundation from ISSUE-1 is solid. The recommended enhancements align the project with proven patterns from successful QuickShell implementations while maintaining the unique strengths of fx-shell's architecture (EventBus, ServiceRegistry).

**Next Steps:**
1. Review and approve these recommendations
2. Begin ISSUE-3: Foundation Enhancements
3. Implement modular config + M3 theming
4. Proceed with phased implementation

The architecture is designed for:
- **Scalability:** Can grow to dozens of modules/services
- **Maintainability:** Small, focused files
- **LLM-friendly:** Clear patterns, good documentation
- **User-friendly:** Customizable themes and behavior
- **Future-proof:** Plugin system, multi-compositor support

---

**Status:** Ready for implementation 🚀
