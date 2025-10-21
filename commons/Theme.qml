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
