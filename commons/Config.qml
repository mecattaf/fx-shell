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
