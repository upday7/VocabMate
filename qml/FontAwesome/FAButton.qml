import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Button {
    id: button
    property string icon
    property color color: "black"
    property font font

    style: ButtonStyle {
        id: buttonstyle
        property font font: button.font
        property color foregroundColor: button.color

        background: Item {
            Rectangle {
                id: baserect
                anchors.fill: parent
                color: "transparent"
            }
        }

        label: Item {
            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight

            RowLayout {
                id: row
                anchors.centerIn: parent
                spacing: 15

                Text {
                    color: buttonstyle.foregroundColor
                    font.pointSize: buttonstyle.font.pointSize * 2
                    font.family: awesome.family
                    renderType: Text.NativeRendering
                    text: awesome.loaded ? icon : ""
                    visible: !(icon === "")
                }
                Text {
                    color: buttonstyle.foregroundColor
                    font: buttonstyle.font
                    renderType: Text.NativeRendering
                    text: control.text
                    visible: !(control.text === "")

                    Layout.alignment: Qt.AlignBottom
                }
            }
        }
    }
}
