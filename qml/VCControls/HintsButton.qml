import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

Item {
    id: hints_button
    width: childrenRect.width
    height: childrenRect.height

    signal hint_def_clicked

    property alias btn_hint_def: hint_def

    function show_def(def_text) {
        hint_def_text.text = def_text
        hint_def_text.visible = true
    }

    RowLayout {
        id: button_layout
        spacing: 5
        width: childrenRect.width
        height: childrenRect.height
        Text {
            id: hint_def_text
            visible: false
            text: "this is a test message of defination"
            elide: Text.ElideRight
            font.family: "open sans"
        }
        Button {
            id: hint_def
            height: bg_gif_def.paintedHeight
            width: bg_gif_def.paintedWidth
            background: Image {
            id: bg_gif_def
                source: "../res/img/hint-def.gif"
                anchors.fill: parent
            }

            onClicked: {
                hint_def_clicked()
                hint_def_text.visible = true
                console.log("hint_def clicked")
            }
        }
    }
}
