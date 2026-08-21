import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "salted.adhan"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "🕌"
    tooltipText: "Adhan - Prayer Times"
    onPressed: root.togglePanel()
  }

  function togglePanel() {
    // TODO: Open popup panel
  }
}
