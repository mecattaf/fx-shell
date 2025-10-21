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
