import QtQuick
import qs.Ui

PanelWidget {
  id: root
  moduleName: "salted.adhan"

  implicitWidth: 300
  implicitHeight: 400

  // TODO: Implement prayer times panel
  Text {
    anchors.centerIn: parent
    text: "Adhan Panel"
    color: root.foreground
  }
}
