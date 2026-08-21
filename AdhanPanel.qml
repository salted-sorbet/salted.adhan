import QtQuick
import QtQuick.Layouts
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

  readonly property string scriptPath: Qt.resolvedUrl("prayer_times.py").toString().replace("file://", "")
  readonly property string timesPath: Qt.resolvedUrl("prayer_times.txt").toString().replace("file://", "")
  property var prayerTimes: []
  property var prayerNames: ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]

  Component.onCompleted: refreshTimes()

  function refreshTimes() {
    refreshProc.running = true
  }

  Process {
    id: refreshProc
    command: ["python3", root.scriptPath]
    onExited: function(exitCode) {
      if (exitCode === 0) readFileProc.running = true
    }
  }

  Process {
    id: readFileProc
    command: ["cat", root.timesPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = text.trim().split("\n")
        root.prayerTimes = lines
      }
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
        color: root.barForeground
        font.pixelSize: 18
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        Layout.fillWidth: true
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        color: Qt.darker(root.barForeground, 1.3)
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        height: 1
        color: Qt.darker(root.barForeground, 1.5)
        opacity: 0.3
      }

      Repeater {
        model: root.prayerNames

        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: modelData
            color: root.barForeground
            font.pixelSize: 14
            Layout.fillWidth: true
          }

          Text {
            text: root.prayerTimes[index] || "--:--"
            color: root.barForeground
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
        color: refreshMouse.containsMouse ? Qt.darker(root.barForeground, 1.2) : "transparent"
        border.color: Qt.darker(root.barForeground, 1.5)
        border.width: 1

        Text {
          anchors.centerIn: parent
          text: "Refresh"
          color: root.barForeground
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
