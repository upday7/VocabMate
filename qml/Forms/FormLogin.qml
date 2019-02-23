import QtQuick 2.9
import QtQuick.Controls 2.9
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

Rectangle {
    id: login

    width: 400
    height: 260
    radius: 1
    color: "#cc000000"

    signal success

    Settings {
        id: settings
        category: "Login"
    }

    Connections {
        target: $api
        onSigningIn: {
            state = 'signingIn'
        }
        onLoggedIn: function (err_msg) {
            if (err_msg) {
                error.error_msg = err_msg
                state = 'error'
            } else {
                settings.setValue("email", text_email.text)
                settings.setValue("pwd", text_pwd.text)
                success()
            }
        }
    }
    Component.onCompleted: {
        text_email.text = settings.value("email",
                                         '') === '' ? '' : settings.value(
                                                          "email", '')
        text_pwd.text = settings.value("pwd",
                                       '') === '' ? '' : settings.value("pwd",
                                                                        '')
    }

    TextField {
        id: text_email
        x: 43
        y: 54
        width: 300
        height: 30
        horizontalAlignment: Text.AlignHCenter
        placeholderText: "Email "
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            radius: 4
            anchors.fill: parent
            border {
                width: text_email.activeFocus ? 3 : 0
                color: "#6AB14B"
            }
        }
    }

    TextField {
        id: text_pwd
        x: 43
        y: 100
        width: 300
        height: 30
        bottomPadding: 0
        topPadding: 0
        font.weight: Font.Light
        echoMode: TextField.Password
        anchors.horizontalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
        placeholderText: "Password"
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            radius: 4
            anchors.fill: parent
            border {
                width: text_pwd.activeFocus ? 3 : 0
                color: "#6AB14B"
            }
        }
    }

    Image {
        id: image
        x: 62
        y: 19
        width: 163
        height: 24
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../res/img/vocab_logo.png"
        fillMode: Image.PreserveAspectFit
    }

    Button {
        id: button
        x: 100
        y: 175
        width: 72
        height: 29
        text: qsTr("<font color='#ffffff'>Sign In</font>")
        font.capitalization: Font.MixedCase
        bottomPadding: 1
        topPadding: 1
        focusPolicy: Qt.NoFocus
        leftPadding: 1
        rightPadding: 1
        spacing: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -60
        wheelEnabled: false
        font.pointSize: 14
        highlighted: false
        flat: false
        autoRepeat: false

        font.bold: false

        background: Rectangle {
            id: sign_in_btn_bg
            radius: 4
            anchors.fill: parent

            color: "#6AB14B"
        }
        onClicked: {
            $api.login(text_email.text, text_pwd.text,
                       login_form_remember_me.on)
        }
        onPressedChanged: {
            this.scale = this.scale < 1 ? 1 : .95
        }
        onHoveredChanged: {
            font.bold = !font.bold
        }
    }

    Button {
        id: btn_try
        x: 100
        y: 175
        width: 72
        height: 29
        text: qsTr("<font color='#ffffff'>Try</font>")
        font.capitalization: Font.MixedCase
        bottomPadding: 1
        topPadding: 1
        rightPadding: 1
        leftPadding: 1
        spacing: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 60
        wheelEnabled: false
        font.pointSize: 14
        highlighted: false
        flat: false
        autoRepeat: false

        font.bold: false

        background: Rectangle {
            id: try_btn_bg
            radius: 4
            anchors.fill: parent

            color: "#6AB14B"
        }
        onClicked: {
            $api.login("", "", login_form_remember_me.on)
        }
        onPressedChanged: {
            this.scale = this.scale < 1 ? 1 : .95
        }
        onHoveredChanged: {
            font.bold = !font.bold
        }
    }

    Text {
        id: sign_up
        property string sign_up_url: 'https://www.vocabulary.com/signup/'
        x: 248
        y: 237
        width: 44

        color: "#6AB14B"
        text: qsTr("<style>a{ color: #6AB14B}</style><a href='" + sign_up_url + "'>Sign Up</a>")
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        textFormat: Text.RichText

        font.pixelSize: 12
        font.bold: false

        MouseArea {
            width: 48
            anchors.rightMargin: 0
            anchors.bottomMargin: -29
            anchors.leftMargin: 0
            anchors.topMargin: 29
            anchors.fill: parent

            hoverEnabled: true
            onHoveredChanged: {
                sign_up.font.bold = !sign_up.font.bold
            }
            onClicked: {
                Qt.openUrlExternally(sign_up.sign_up_url)
            }
        }
    }

    AnimatedImage {
        id: busyIndicator
        x: 138
        y: 210
        width: 33
        height: 21
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../res/img/loading.svg"
        fillMode: Image.PreserveAspectFit

        RotationAnimator on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
            running: true
            duration: 3000
        }
    }

    Text {
        id: error
        property string error_msg
        x: 248
        y: 286

        color: "#6AB14B"
        text: qsTr("<font color=red>" + error_msg + "</font>")
        anchors.verticalCenter: busyIndicator.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.RichText
        font.pixelSize: 12
        font.bold: false
    }

    Text {
        id: element
        x: 192
        y: 182
        text: qsTr("OR")
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
        color: "white"
    }

    Switch {
        id: login_form_remember_me
        x: 129
        y: 128
        text: qsTr("<font color='#ffffff'>Remember me</font>")
        anchors.horizontalCenter: parent.horizontalCenter
        font: {

        }
        scale: 0.8
    }

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: error
                visible: false
            }
            PropertyChanges {
                target: busyIndicator
                visible: false
            }
            PropertyChanges {
                target: button
                enabled: true
            }
        },
        State {
            name: "signingIn"
            PropertyChanges {
                target: error
                visible: false
            }
            PropertyChanges {
                target: busyIndicator
                visible: true
            }
            PropertyChanges {
                target: button
                enabled: false
            }
        },
        State {
            name: "error"
            PropertyChanges {
                target: error
                visible: true
            }
            PropertyChanges {
                target: busyIndicator
                visible: false
            }
            PropertyChanges {
                target: button
                enabled: true
            }
        }
    ]
}
