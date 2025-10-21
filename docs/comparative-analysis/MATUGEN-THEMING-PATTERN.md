# Matugen & Material Design 3 Theming Pattern

**Analysis Date:** October 21, 2025
**Pattern Origin:** DankMaterialShell
**Adaptations:** Noctalia Shell, Caelestia Shell
**Target:** fx-shell Implementation

---

## Overview

**Matugen** is a color scheme generation system that creates cohesive Material Design 3 color palettes from a single source (base color or wallpaper). All major QuickShell projects use some form of Material Design 3 theming, with DankMaterialShell pioneering the matugen integration.

---

## The Color Generation Pipeline

### Step 1: Source Selection

**Input Options:**
1. **Wallpaper** - Extract dominant color from image
2. **Base Color** - User-specified hex color
3. **Pre-defined Theme** - Static color scheme (Noctalia's approach)

### Step 2: Palette Generation

**Tool:** `matugen/dank16.py` (DankMaterialShell implementation)

**Algorithm:**
1. Convert base color to HSV (Hue, Saturation, Value)
2. Generate color variants with specific HSV transformations
3. Ensure WCAG contrast ratios (accessibility)
4. Create light and dark mode variants
5. Generate Material Design 3 color roles

**Example from dank16.py:**
```python
def ensure_contrast(hex_color, hex_bg, min_ratio=4.5, is_light_mode=False):
    """
    Adjusts color to meet minimum contrast ratio for accessibility
    """
    current_ratio = contrast_ratio(hex_color, hex_bg)
    if current_ratio >= min_ratio:
        return hex_color

    # Adjust value in HSV space until contrast is met
    r, g, b = hex_to_rgb(hex_color)
    h, s, v = colorsys.rgb_to_hsv(r, g, b)

    for step in range(1, 30):
        delta = step * 0.02
        # Try lightening/darkening based on mode
        if is_light_mode:
            new_v = max(0, v - delta)
        else:
            new_v = min(1, v + delta)

        candidate = rgb_to_hex(*colorsys.hsv_to_rgb(h, s, new_v))
        if contrast_ratio(candidate, hex_bg) >= min_ratio:
            return candidate

    return hex_color
```

### Step 3: Template Application

**Matugen Config:** `matugen/configs/base.toml`
```toml
[config]
reload_apps = false
reload_apps_list = { gtk = "custom", kitty = "bash" }

[templates.dank]
input_path = "templates/dank.json"
output_path = "~/.config/dank/colors.json"

[templates.kitty]
input_path = "templates/kitty.conf"
output_path = "~/.config/kitty/colors.conf"

[templates.gtk]
input_path = "templates/gtk-colors.css"
output_path = "~/.config/gtk-3.0/colors.css"
```

**Template Format:** `matugen/templates/dank.json`
```json
{
    "colors": {
        "primary": "{{colors.primary.default.hex}}",
        "onPrimary": "{{colors.on_primary.default.hex}}",
        "primaryContainer": "{{colors.primary_container.default.hex}}",
        "onPrimaryContainer": "{{colors.on_primary_container.default.hex}}",
        "secondary": "{{colors.secondary.default.hex}}",
        "onSecondary": "{{colors.on_secondary.default.hex}}",
        "surface": "{{colors.surface.default.hex}}",
        "onSurface": "{{colors.on_surface.default.hex}}",
        "surfaceVariant": "{{colors.surface_variant.default.hex}}",
        "onSurfaceVariant": "{{colors.on_surface_variant.default.hex}}",
        "error": "{{colors.error.default.hex}}",
        "onError": "{{colors.on_error.default.hex}}",
        "outline": "{{colors.outline.default.hex}}",
        "shadow": "{{colors.shadow.default.hex}}"
    }
}
```

**Matugen processes:**
1. Reads template files
2. Replaces `{{...}}` placeholders with generated colors
3. Writes output to specified paths
4. Optionally reloads applications

### Step 4: Theme Loading in QML

**DankMaterialShell approach:** `Common/Theme.qml` (snippet)
```qml
pragma Singleton
import QtQuick
import Qt.labs.settings 1.0

QtObject {
    id: theme

    // Load generated colors from matugen output
    property var generatedColors: loadMatugenColors()

    // Material Design 3 color properties
    property color primary: generatedColors.primary
    property color onPrimary: generatedColors.onPrimary
    property color surface: generatedColors.surface
    property color onSurface: generatedColors.onSurface
    // ... etc

    function loadMatugenColors() {
        const path = Paths.config + "/colors.json"
        const file = Proc.readFile(path)
        return JSON.parse(file).colors
    }

    function regenerateTheme(sourceColor) {
        // Call matugen script
        Proc.exec(`python3 ${Paths.matugen}/dank16.py ${sourceColor}`)
        // Reload colors
        generatedColors = loadMatugenColors()
    }
}
```

---

## Material Design 3 Color System

### Color Roles (Standard M3 Naming)

All three projects use this consistent naming convention:

```qml
QtObject {
    // Primary colors - main brand color
    property color mPrimary
    property color mOnPrimary          // Text on primary
    property color mPrimaryContainer   // Lighter primary variant
    property color mOnPrimaryContainer // Text on primary container

    // Secondary colors - complementary accent
    property color mSecondary
    property color mOnSecondary
    property color mSecondaryContainer
    property color mOnSecondaryContainer

    // Tertiary colors - additional accent
    property color mTertiary
    property color mOnTertiary
    property color mTertiaryContainer
    property color mOnTertiaryContainer

    // Error colors - destructive actions
    property color mError
    property color mOnError
    property color mErrorContainer
    property color mOnErrorContainer

    // Surface colors - backgrounds
    property color mSurface           // Main background
    property color mOnSurface         // Text on background
    property color mSurfaceVariant    // Alternative background
    property color mOnSurfaceVariant  // Text on alternative background
    property color mSurfaceContainer  // Container backgrounds

    // Utility colors
    property color mOutline           // Borders, dividers
    property color mOutlineVariant    // Subtle dividers
    property color mShadow            // Drop shadows
    property color mScrim             // Overlay dimming
    property color mBackground        // Canvas background
    property color mOnBackground      // Text on canvas
}
```

**Why these colors?**
- **Semantic naming:** Clear purpose for each color
- **Accessibility built-in:** "On" colors ensure readable contrast
- **Flexible hierarchy:** Primary → Secondary → Tertiary allows emphasis
- **Consistent system-wide:** All components speak same color language

---

## Pattern Evolution Across Projects

### DankMaterialShell: The Origin

**Innovation:**
- Custom Python script (dank16.py) for color generation
- TOML configs for multi-app integration
- Template system for various applications
- Automatic wallpaper color extraction

**Strengths:**
- Comprehensive multi-app theming (GTK, Qt, terminal, Firefox, etc.)
- Accessibility-first (contrast checking)
- Flexible template system

**Limitations:**
- Requires Python + dependencies
- Complex setup for users
- No pre-defined themes (always generated)

---

### Noctalia: Pre-defined + Generated

**Enhancement:** Hybrid approach

#### Pre-defined Color Schemes

`Assets/ColorScheme/Catppuccin/Catppuccin.json`:
```json
{
    "dark": {
        "mPrimary": "#cba6f7",
        "mOnPrimary": "#11111b",
        "mSecondary": "#fab387",
        "mOnSecondary": "#11111b",
        "mTertiary": "#94e2d5",
        "mOnTertiary": "#11111b",
        "mError": "#f38ba8",
        "mOnError": "#11111b",
        "mSurface": "#1e1e2e",
        "mOnSurface": "#cdd6f4",
        "mSurfaceVariant": "#313244",
        "mOnSurfaceVariant": "#a3b4eb",
        "mOutline": "#4c4f69",
        "mShadow": "#11111b"
    },
    "light": {
        "mPrimary": "#8839ef",
        "mOnPrimary": "#eff1f5",
        // ... light mode colors
    }
}
```

**Available Themes (13 total):**
1. Noctalia-default
2. Catppuccin
3. Tokyo-Night
4. Dracula
5. Gruvbox
6. Nord
7. Rosepine
8. Everforest
9. Kanagawa
10. Solarized
11. Ayu
12. Eldritch
13. Monochrome

#### Matugen Templates

`Assets/MatugenTemplates/Terminal/` - Custom terminal templates

**Loading Pattern:**
```qml
// Theme.qml
QtObject {
    property string currentScheme: "Catppuccin"
    property var colors: loadScheme(currentScheme)

    function loadScheme(name) {
        const path = `Assets/ColorScheme/${name}/${name}.json`
        const file = readFile(path)
        const scheme = JSON.parse(file)
        return App.isLightMode ? scheme.light : scheme.dark
    }

    function switchScheme(name) {
        currentScheme = name
        colors = loadScheme(name)
        emit themeChanged()
    }
}
```

**Benefits:**
- **Quick theme switching** without regeneration
- **Curated themes** popular in community
- **Fallback** if matugen unavailable
- **User choice:** Static themes OR dynamic generation

---

### Caelestia: Service-Based Management

**Pattern:** Theme management as a service

`modules/launcher/services/Schemes.qml`:
- Color scheme selection logic
- Integration with launcher for quick switching

`modules/launcher/services/M3Variants.qml`:
- Material 3 color variant generation
- Runtime color adjustments

`config/Appearance.qml`:
```qml
pragma Singleton
QtObject {
    property string currentTheme: "dark"
    property string accentColor: "#6366f1"

    // M3 colors loaded from service
    property var colors: M3Variants.generateColors(accentColor, currentTheme)

    function setAccent(color) {
        accentColor = color
        colors = M3Variants.generateColors(color, currentTheme)
    }

    function toggleMode() {
        currentTheme = (currentTheme === "dark") ? "light" : "dark"
        colors = M3Variants.generateColors(accentColor, currentTheme)
    }
}
```

**Benefits:**
- **QML-native:** No Python dependency
- **Runtime generation:** Instant theme changes
- **Service pattern:** Accessible anywhere
- **Simplified:** Fewer moving parts

---

## Theme Application in Components

### Pattern: Theme Property Binding

**Typical component theming:**
```qml
// modules/ui/panels/statusbar/StatusBar.qml
import "../../../../commons"

Rectangle {
    color: Theme.mSurface
    border.color: Theme.mOutline

    Text {
        color: Theme.mOnSurface
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }

    Button {
        background: Rectangle {
            color: hovered ? Theme.mPrimaryContainer : Theme.mSurface
        }

        contentItem: Text {
            color: hovered ? Theme.mOnPrimaryContainer : Theme.mPrimary
        }
    }
}
```

**Benefits:**
- Automatic updates when theme changes
- Consistent appearance
- Single source of truth

---

## Recommended Pattern for fx-shell

### Phase 1: Static Themes (Immediate)

**Implement Noctalia's hybrid approach:**

1. **Create pre-defined themes**

`assets/themes/fx-default.json`:
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

2. **Enhance Theme.qml**

```qml
// commons/Theme.qml
pragma Singleton
import QtQuick

QtObject {
    id: theme

    // Current theme mode
    property string mode: "dark"  // or "light"

    // Current scheme
    property string scheme: "fx-default"

    // Load colors from JSON
    property var colors: loadColors()

    // Material Design 3 color properties
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

    // Legacy properties (map to M3)
    property color background: mBackground
    property color surface: mSurface
    property color primary: mPrimary
    property color text: mOnSurface

    // Typography (keep existing)
    property string fontFamily: Config.font
    property int fontSize: Config.fontSize
    // ... etc

    // Theme management
    signal themeChanged()

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
        colors = loadColors()
        themeChanged()
    }

    function toggleMode() {
        mode = (mode === "dark") ? "light" : "dark"
        colors = loadColors()
        themeChanged()
    }
}
```

3. **Add popular themes**

Copy Noctalia's popular schemes:
- `assets/themes/catppuccin.json`
- `assets/themes/tokyo-night.json`
- `assets/themes/dracula.json`
- `assets/themes/nord.json`
- `assets/themes/gruvbox.json`

---

### Phase 2: Matugen Integration (Later)

**After core functionality is stable:**

1. Add `assets/matugen/` directory
2. Integrate matugen tool (or implement QML/JS variant)
3. Add wallpaper color extraction
4. Template system for output

---

## Implementation Priority

### Immediate (This Iteration)

1. ✅ Enhance `Theme.qml` with M3 color properties
2. ✅ Create `assets/themes/` directory
3. ✅ Add 3-5 pre-defined color schemes (fx-default, catppuccin, dracula, tokyo-night, nord)
4. ✅ Update existing components to use `Theme.mSurface`, `Theme.mOnSurface`, etc.

### Next Iteration

5. Add theme switcher UI (settings or quick toggle)
6. Persist theme choice in Config
7. Add accent color customization (single color → generate variants)

### Future

8. Matugen integration for wallpaper-based theming
9. Runtime color generation
10. Multi-app theming (GTK, Qt, terminal)

---

## Testing Theme System

**Manual testing:**
```qml
// Test component
Rectangle {
    width: 800
    height: 600

    Column {
        spacing: 20

        // Test all M3 colors
        Rectangle {
            width: 200; height: 50
            color: Theme.mPrimary
            Text {
                anchors.centerIn: parent
                text: "Primary"
                color: Theme.mOnPrimary
            }
        }

        Rectangle {
            width: 200; height: 50
            color: Theme.mSecondary
            Text {
                anchors.centerIn: parent
                text: "Secondary"
                color: Theme.mOnSecondary
            }
        }

        Rectangle {
            width: 200; height: 50
            color: Theme.mSurface
            Text {
                anchors.centerIn: parent
                text: "Surface"
                color: Theme.mOnSurface
            }
        }

        // Test mode switching
        Button {
            text: "Toggle Light/Dark"
            onClicked: Theme.toggleMode()
        }

        // Test scheme switching
        Button {
            text: "Switch to Catppuccin"
            onClicked: Theme.switchScheme("catppuccin")
        }
    }
}
```

---

## Conclusion

The matugen + Material Design 3 pattern provides:
- **Consistent theming** across all components
- **Accessibility** through contrast-checked colors
- **Flexibility** with pre-defined and generated themes
- **User choice** in appearance customization

**For fx-shell:** Start with static themes (Phase 1), add generation later (Phase 2). This balances immediate usability with future extensibility.
