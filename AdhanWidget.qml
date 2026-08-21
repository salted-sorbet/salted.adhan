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
    text: "\uf06d"
    tooltipText: "Adhan - Prayer Times"
    onPressed: root.togglePanel()
  }

  function togglePanel() {
    if (root.bar) {
      root.bar.requestPopout(root)
    }
  }
}
