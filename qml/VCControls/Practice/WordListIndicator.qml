import QtQuick 2.9

Rectangle {
    width: childrenRect.width
    height: childrenRect.height
    PrgImg {
        id: aa
        pctg: 0
        width: 90
        height: 90
    }
    Timer {
        property double i: 0
        onTriggered: {
            console.debug("Triggered", i)
            aa.pctg = i
            i = i + 0.1
            if (i > 1) {
                running = false
            }
        }
        running: true
        repeat: true
        interval: 1000
    }
}
