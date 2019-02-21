import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: q_count_button_group
    height: childrenRect.height
    width: childrenRect.width

    property int cur_count: 0
    property int btn_width: 48
    property int _last_active_btn_index: 0

    Row {
        spacing: 5
        Repeater {
            id: btn_rpt

            model: [10, 20, 30, 40]
            delegate: NumberRoundBtn {
                cur_number: modelData
                width: q_count_button_group.btn_width
                height: width

                Connections {
                    onClicked: {
                        if (q_count_button_group.cur_count !== cur_number) {
                            btn_rpt.itemAt(
                                        _last_active_btn_index).set_inactive()
                            q_count_button_group._last_active_btn_index = index
                            cur_count = modelData
                        }
                    }
                }
            }

            Component.onCompleted: {
                var cur_item = btn_rpt.itemAt(_last_active_btn_index)
                cur_item.set_active()
                cur_count = cur_item.cur_number
            }
        }
    }
    onCur_countChanged: {
        console.log(cur_count)
    }
}
