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
