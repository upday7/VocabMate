import QtQuick 2.0

Item {
    property int total_pages
    property int round_number: 0
    property int played_count: 0
    property variant indicatorComponent
    property alias row: row
    property alias label: label

    Row {
        id: row
        spacing: 20

        Text {
            id: label
            color: "#BDC0BD"
            text: "Round " + round_number.toString() + ": "
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: 'open sans'
                pixelSize: 72
                bold: true
            }
        }

        Repeater {
            id: indicators
            model: page_indicators_model
            delegate: PageNumberIndicator {
                anchors.verticalCenter: parent.verticalCenter
                page_number: modelData
            }
        }
    }

    ListModel {
        id: page_indicators_model
    }

    onTotal_pagesChanged: {
        reset_indicators()
    }
    onPlayed_countChanged: {
        set_item_current(played_count)
    }

    function reset_indicators() {
        page_indicators_model.clear()
        if (!indicatorComponent) {
            indicatorComponent = Qt.createComponent("PageNumberIndicator.qml")
        }
        for (var i = 1; i <= total_pages; i++) {
            page_indicators_model.append({
                                             "page_number": i.toString()
                                         })
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
