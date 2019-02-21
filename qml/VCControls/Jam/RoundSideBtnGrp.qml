import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: round_side_btn_grp
    height: childrenRect.height
    width: childrenRect.width + 20
    property int cur_index: 1
    property string cur_text: ""
    property var cur_model: ["Slow", "Normal", "Fast", "No Time Limit"]

    Row {
        spacing: 5
        Repeater {
            id: speed_btn_rpt

            model: cur_model
            delegate: RoundSideBtn {
                cur_text: modelData

                font_size: 18
                Connections {
                    onClicked: {
                        if (round_side_btn_grp.cur_index !== index) {
                            speed_btn_rpt.itemAt(
                                        round_side_btn_grp.cur_index).set_inactive()
                            round_side_btn_grp.cur_index = index
                            round_side_btn_grp.cur_text = modelData
                        }
                    }
                }
            }

            Component.onCompleted: {
                var cur_item = speed_btn_rpt.itemAt(cur_index)
                cur_item.set_active()
                round_side_btn_grp.cur_text = cur_item.cur_text
            }
        }
    }
    onCur_textChanged: {
        console.log(cur_index, round_side_btn_grp.cur_text)
    }
}
