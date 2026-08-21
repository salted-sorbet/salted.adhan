import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "salted.adhan"

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("AdhanPanel.qml")
    visible: false
    onLoaded: {
      item.bar = root.bar
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "\uf06d"
    tooltipText: "Adhan - Prayer Times"
    onPressed: root.togglePanel()
  }
}
