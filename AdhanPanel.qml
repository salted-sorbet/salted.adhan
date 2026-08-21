import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

Panel {
  id: root
  moduleName: "salted.adhan"
  ipcTarget: "salted.adhan"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root
  readonly property string pluginDir: Quickshell.env("HOME") + "/.config/omarchy/plugins/salted.adhan"

  property var prayerTimes: []
  property var prayerNames: ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
  property bool refreshing: false

  Component.onCompleted: refreshTimes()

  function refreshTimes() {
    if (refreshing) return
    refreshing = true
    scriptProc.running = true
  }

  FileView {
    id: timesFile
    path: root.pluginDir + "/prayer_times.txt"
    watchChanges: false
    printErrors: false
    onLoaded: {
      var content = text()
      if (content.trim().length > 0) {
        root.prayerTimes = text.trim().split("\n")
      }
    }
  }

  Process {
    id: scriptProc
    command: ["python3", root.pluginDir + "/prayer_times.py"]
    onExited: function(exitCode) {
      refreshing = false
      if (exitCode === 0) timesFile.reload()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: true
    contentWidth: panel.fittedContentWidth(Style.space(280))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 12

      Text {
        Layout.fillWidth: true
        text: "Prayer Times"
        color: bar ? bar.barForeground : "white"
        font.pixelSize: 18
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        Layout.fillWidth: true
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        color: bar ? Qt.darker(bar.barForeground, 1.3) : "gray"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        height: 1
        color: bar ? Qt.darker(bar.barForeground, 1.5) : "gray"
        opacity: 0.3
      }

      Repeater {
        model: root.prayerNames

        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: modelData
            color: bar ? bar.barForeground : "white"
            font.pixelSize: 14
            Layout.fillWidth: true
          }

          Text {
            text: root.prayerTimes[index] || "--:--"
            color: bar ? bar.barForeground : "white"
            font.pixelSize: 14
            font.bold: true
          }
        }
      }

      Item { Layout.fillHeight: true }

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        radius: 6
        color: refreshMouse.containsMouse || root.refreshing ? (bar ? Qt.darker(bar.barForeground, 1.2) : "gray") : "transparent"
        border.color: bar ? Qt.darker(bar.barForeground, 1.5) : "gray"
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: root.refreshing ? "Updating..." : "Refresh"
          color: bar ? bar.barForeground : "white"
          font.pixelSize: 12
        }

        MouseArea {
          id: refreshMouse
          anchors.fill: parent
          hoverEnabled: true
          onClicked: root.refreshTimes()
        }
      }
    }
  }
}
