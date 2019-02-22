import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import "Forms"
import "FontAwesome"
import "Forms/WordList"

import pyAPIBridge 1.0

Window {
    id: window
    maximumWidth: 1080
    minimumWidth: 1080
    minimumHeight: 480
    maximumHeight: 480

    title: qsTr("Vocabulary Mate")
    color: "#293529"

    property var $api: VCPracticeAPI {
    }

    property var $awesome: FontAwesomeLoader {
        resource: "../res/fonts/Fontawesome-Webfont.ttf"
    }
    property var $favar: FaVar {
        id: favar
    }
    //    Load fonts
    Repeater {
        id: fonts_rpt
        model: ["res/fonts/OpenSans-Bold.ttf", "res/fonts/OpenSans-Italic.ttf", "res/fonts/OpenSans-Regular.ttf", "res/fonts/ss-symbolicons-block.woff", "res/fonts/ss-standard.woff"]
        delegate: Item {
            FontLoader {
                source: modelData

                onStatusChanged: {

                    if ((status === FontLoader.Ready)) {
                        console.log(name, " loaded.")
                    }
                }
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: FormWordlist {
            anchors.fill: parent
        }
    }

    //    FormLogin {
    //                id: login_form
    //                anchors.centerIn: parent
    //            }
    //    Connections {
    //        target: login_form
    //        onSuccess: {
    //            stack.pop()
    //            stack.push("Forms/FormQuestion.qml")
    //        }
    //    }
}
