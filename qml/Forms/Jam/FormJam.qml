import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../../VCControls/Jam"

Rectangle {
    id: form_jame
    width: 1080
    height: 480
    JamBg {
        id: jam_bg
        anchors.fill: parent
    }

    StackView {
        id: form_jam_stack

        anchors.fill: parent
        initialItem: CreateJam {
        }
    }
    state: "create_jam"
    states: [
        State {
            name: "create_jam"
            PropertyChanges {
                target: jam_bg
                color: "#ffffff"
            }
        }
    ]
}
