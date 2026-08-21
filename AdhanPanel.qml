import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Ui
import qs.Commons

Panel {
  id: root
  moduleName: "salted.adhan"
  ipcTarget: "salted.adhan"

  readonly property string timesFile: OmarchyPath + "/plugins/salted.adhan/prayer_times.txt"
  property var prayerTimes: []
  property var prayerNames: ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]

  Component.onCompleted: refreshTimes()

  function refreshTimes() {
    refreshProc.running = true
  }

  Process {
    id: refreshProc
    command: ["python3", OmarchyPath + "/plugins/salted.adhan/prayer_times.py"]
    onExited: function(exitCode) {
      if (exitCode === 0) readFileProc.running = true
    }
  }

  Process {
    id: readFileProc
    command: ["cat", root.timesFile]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = text.trim().split("\n")
        root.prayerTimes = lines
      }
    }
  }

  contentWidth: fittedContentWidth(Style.space(280))
  contentHeight: fittedContentHeight(column.implicitHeight, Style.space(320))

  ColumnLayout {
    id: column
    width: parent.width
    spacing: 12

    // Header
    Text {
      Layout.fillWidth: true
      text: "Prayer Times"
      color: root.foreground
      font.pixelSize: 18
      font.bold: true
      horizontalAlignment: Text.AlignHCenter
    }

    Text {
      Layout.fillWidth: true
      text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
      color: Qt.darker(root.foreground, 1.3)
      font.pixelSize: 12
      horizontalAlignment: Text.AlignHCenter
    }

    // Divider
    Rectangle {
      Layout.fillWidth: true
      Layout.topMargin: 4
      Layout.bottomMargin: 4
      height: 1
      color: Qt.darker(root.foreground, 1.5)
      opacity: 0.3
    }

    // Prayer times list
    Repeater {
      model: root.prayerNames

      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Text {
          text: modelData
          color: root.foreground
          font.pixelSize: 14
          Layout.fillWidth: true
        }

        Text {
          text: root.prayerTimes[index] || "--:--"
          color: root.foreground
          font.pixelSize: 14
          font.bold: true
        }
      }
    }

    Item { Layout.fillHeight: true }

    // Refresh button
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 32
      radius: 6
      color: refreshMouse.containsMouse ? Qt.darker(root.foreground, 1.2) : "transparent"
      border.color: Qt.darker(root.foreground, 1.5)
      border.width: 1

      Text {
        anchors.centerIn: parent
        text: "Refresh"
        color: root.foreground
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
