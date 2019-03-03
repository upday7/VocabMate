import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    property int total_pages: 10
    property int round_number: 0
    property int played_count: 0
    property variant indicatorComponent
    property alias row: row
    property alias label: label

    width: childrenRect.width
    height: childrenRect.height

    RowLayout {
        id: row
        spacing: 3

        Text {
            id: label
            color: "#BDC0BD"
            text: "Round " + round_number.toString() + ": "
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            font {
                pixelSize: 13
                bold: true
            }
            visible: false // todo: don't show for now
        }

        Repeater {
            id: indicators
            model: total_pages

            delegate: PageNumberIndicator {
                page_number: modelData + 1
                width: 18
            }
        }
    }

    onTotal_pagesChanged: {
        reset_indicators()
    }
    onPlayed_countChanged: {
        set_item_current(played_count)
    }
    Component.onCompleted: {
        reset_indicators()
    }

    function reset_indicators() {
        for (var i = 1; i < total_pages; i++) {
            indicators.itemAt(i).state = "normal"
        }
    }

    function set_item_current(idx) {
        console.log('setting indicator current: ', idx)
        indicators.itemAt(idx).state = 'current'
    }

    function set_correct(correct, idx) {
        if (idx === undefined) {
            idx = played_count
        }
        var indicator = indicators.itemAt(idx)
        if ("correct,incorrect".search(indicator.state) !== -1) {
            return
        }
        if (correct) {
            indicator.state = "correct"
        } else {
            indicator.state = "incorrect"
        }
    }
}
