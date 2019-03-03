import QtQuick 2.9
import QtQuick.Layouts 1.3

Item {
    width: childrenRect.width
    height: childrenRect.height

    property string nickname: " --- "
    property int points: 4432
    property int level: 2 // starting at 1

    FontLoader {
        id: font_levels
        source: "../../res/fonts/VocabLevels.ttf"
    }

    property var level_cars: ['\ue000', '\ue001', '\ue002', '\ue003', '\ue004', '\ue005', '\ue006', '\ue007', '\ue008', '\ue009', '\ue00a', '\ue00b', '\ue00c', '\ue00d', '\ue00e', '\ue00f', '\ue010', '\ue011', '\ue012', '\ue013']
    property var level_points: [0, 5000, 25000, 50000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000, 2000000, 5000000, 10000000, 25000000, 50000000, 100000000]

    ColumnLayout {
        id: user_info
        RowLayout {
            ColumnLayout {
                Text {
                    id: user_points
                    text: points.toString()

                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    color: "#fff"
                    font {
                        pixelSize: 12
                    }
                }

                Text {
                    id: user_nickname
                    text: nickname.toString()
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    color: "#fff"
                    font {
                        pixelSize: 12
                    }
                }
            }

            Text {
                text: level_cars[level - 1]
                font {
                    family: 'levels'
                    pixelSize: 64
                }
                color: "#6AB14B"
            }
        }
    }
}
