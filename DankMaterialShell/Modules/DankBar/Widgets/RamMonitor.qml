import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    property bool isVertical: axis?.isVertical ?? false
    property var axis: null
    property bool showPercentage: true
    property bool showIcon: true
    property var toggleProcessList
    property string section: "right"
    property var popupTarget: null
    property var parentScreen: null
    property real barThickness: 48
    property real widgetThickness: 30
    property var widgetData: null
    property bool minimumWidth: (widgetData && widgetData.minimumWidth !== undefined) ? widgetData.minimumWidth : true
    readonly property real horizontalPadding: SettingsData.dankBarNoBackground ? 0 : Math.max(Theme.spacingXS, Theme.spacingS * (widgetThickness / 30))

    width: isVertical ? widgetThickness : (ramContent.implicitWidth + horizontalPadding * 2)
    height: isVertical ? (ramColumn.implicitHeight + horizontalPadding * 2) : widgetThickness
    radius: SettingsData.dankBarNoBackground ? 0 : Theme.cornerRadius
    color: {
        if (SettingsData.dankBarNoBackground) {
            return "transparent";
        }

        const baseColor = ramArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor;
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
    }

    Component.onCompleted: {
        DgopService.addRef(["memory"]);
    }
    Component.onDestruction: {
        DgopService.removeRef(["memory"]);
    }

    MouseArea {
        id: ramArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (popupTarget && popupTarget.setTriggerPosition) {
                const globalPos = mapToGlobal(0, 0)
                const currentScreen = parentScreen || Screen
                const pos = SettingsData.getPopupTriggerPosition(globalPos, currentScreen, barThickness, width)
                popupTarget.setTriggerPosition(pos.x, pos.y, pos.width, section, currentScreen)
            }
            DgopService.setSortBy("memory");
            if (root.toggleProcessList) {
                root.toggleProcessList();
            }

        }
    }

    Column {
        id: ramColumn
        visible: root.isVertical
        anchors.centerIn: parent
        spacing: 1

        DankIcon {
            name: "developer_board"
            size: Theme.barIconSize(barThickness)
            color: {
                if (DgopService.memoryUsage > 90) {
                    return Theme.tempDanger;
                }

                if (DgopService.memoryUsage > 75) {
                    return Theme.tempWarning;
                }

                return Theme.surfaceText;
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }

        StyledText {
            text: {
                if (DgopService.memoryUsage === undefined || DgopService.memoryUsage === null || DgopService.memoryUsage === 0) {
                    return "--";
                }

                return DgopService.memoryUsage.toFixed(0);
            }
            font.pixelSize: Theme.barTextSize(barThickness)
            font.weight: Font.Medium
            color: Theme.surfaceText
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        id: ramContent
        visible: !root.isVertical
        anchors.centerIn: parent
        spacing: 3

        DankIcon {
            name: "developer_board"
            size: Theme.barIconSize(barThickness)
            color: {
                if (DgopService.memoryUsage > 90) {
                    return Theme.tempDanger;
                }

                if (DgopService.memoryUsage > 75) {
                    return Theme.tempWarning;
                }

                return Theme.surfaceText;
            }
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: {
                if (DgopService.memoryUsage === undefined || DgopService.memoryUsage === null || DgopService.memoryUsage === 0) {
                    return "--%";
                }

                return DgopService.memoryUsage.toFixed(0) + "%";
            }
            font.pixelSize: Theme.barTextSize(barThickness)
            font.weight: Font.Medium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideNone

            StyledTextMetrics {
                id: ramBaseline
                font.pixelSize: Theme.barTextSize(barThickness)
                font.weight: Font.Medium
                text: "100%"
            }

            width: root.minimumWidth ? Math.max(ramBaseline.width, paintedWidth) : paintedWidth

            Behavior on width {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }
        }

    }

}
