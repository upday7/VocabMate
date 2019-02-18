import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import "FontAwsome"
import pyAPIs 1.0

Window {
    id: window
    maximumWidth: 1080
    minimumWidth: 1080
    minimumHeight: 480
    maximumHeight: 480

    title: qsTr("Vocabulary Mate")
    color: "#293529"
    property var $api: VocabAPI {
    }
    property var $awesome: FontAwesomeLoader {
        resource: "fontawesome-webfont.ttf"
    }
    property var $favar: FaVar {
        id: favar
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: FormLogin {
            id: login_form
            anchors.centerIn: parent
        }
    }

    Connections {
        target: login_form
        onSuccess: {
            stack.pop()
            stack.push("FormQuestion.qml")
        }
    }
}
