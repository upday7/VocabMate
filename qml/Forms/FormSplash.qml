import QtQuick 2.7
import QtQuick.Window 2.3

Window {
    id: main_splash
    color: "transparent"

    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen | Qt.WindowStaysOnTopHint

    x: (Screen.width - splashImage.width) / 2
    y: (Screen.height - splashImage.height) / 2

    width: splashImage.width
    height: splashImage.height

    Image {
        id: splashImage
        //        anchors.centerIn: splash_rect
        source: "../res/img/vocab_logo.png"
        z: 99
    }

    signal loaded

    Text {
        id: textCtrl
        width: contentWidth
        height: contentHeight
        anchors {
            left: splashImage.left
            bottom: splashImage.bottom
        }
    }
    function show() {
        this.visible = true
    }
    function close() {
        show_splash.start()
    }

    SequentialAnimation {
        id: show_splash

        ParallelAnimation {
            PropertyAnimation {
                target: main_splash
                property: "x"
                to: 0 - splashImage.width - 50
                duration: 300
            }

            PropertyAnimation {
                target: splashImage
                property: "opacity"
                from: 1
                to: 0
                duration: 600
            }
        }
        PropertyAnimation {
            target: main_splash
            property: "visible"
            from: true
            to: false
        }

        onStopped: {
            loaded()
        }
    }
}
