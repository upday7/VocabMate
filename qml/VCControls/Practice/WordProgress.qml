import QtQuick 2.0
import QtQuick.Layouts 1.3

RowLayout {
    property alias pctg: pc.pctg
    property alias word: word.text
    property alias def: def.text
    height: 32

    spacing: 10

    PercentageCircle {
        id: pc
        width: parent.height * 0.9
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        id: word
        color: "#fff"
        text: qsTr("word")
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        font {
            family: 'open sans'
            pixelSize: parent.height * 0.8
        }
    }

    Text {
        id: def
        color: "#fff"
        text: qsTr("relating to the study or practice of medicine")
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        font {
            family: 'open sans'
            pixelSize: parent.height * 0.4
        }
    }
}
