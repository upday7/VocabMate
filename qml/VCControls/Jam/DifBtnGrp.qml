import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: diff_button_group
    height: childrenRect.height
    width: 410

    property int cur_dif_lvl: -1
    readonly property int default_dif_lvl: 2
    readonly property var dif_lvl_verbose_list: ["Very Easy", "Easier than Average", "About Average", "Harder than Average", "Very Hard"]
    property int btn_width: 48

    Row {
        id: row
        spacing: 5
        Repeater {
            id: dif_btn_rpt

            model: 5
            delegate: DifBtn {
                dif_lvl: index
                width: diff_button_group.btn_width
                height: width

                Connections {
                    onClicked: {
                        if (diff_button_group.cur_dif_lvl !== index
                                && diff_button_group.cur_dif_lvl >= 0) {
                            dif_btn_rpt.itemAt(
                                        diff_button_group.cur_dif_lvl).set_inactive()
                        }
                        diff_button_group.cur_dif_lvl = index
                        dif_lvl_verbose_txt.text = dif_lvl_verbose_list[index]
                    }
                }
            }

            Component.onCompleted: {
                dif_btn_rpt.itemAt(default_dif_lvl).clicked()
            }
        }
    }

    Text {
        id: dif_lvl_verbose_txt
        text: qsTr("text")

        font {

            pixelSize: 14
            bold: true
        }
        color: "#cccccc"
        anchors {
            verticalCenter: row.verticalCenter
            left: row.right
            leftMargin: 10
        }
    }

    onCur_dif_lvlChanged: {
        console.log("current difficulty level: ", cur_dif_lvl)
    }
}
