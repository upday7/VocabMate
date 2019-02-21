import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: diff_button_group
    height: childrenRect.height
    width: childrenRect.width

    property int cur_dif_lvl: 2
    property int btn_width: 48

    Row {
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
                        if (diff_button_group.cur_dif_lvl !== index) {
                            dif_btn_rpt.itemAt(
                                        diff_button_group.cur_dif_lvl).set_inactive()
                            diff_button_group.cur_dif_lvl = index
                        }
                    }
                }
            }

            Component.onCompleted: {
                dif_btn_rpt.itemAt(cur_dif_lvl).set_active()
            }
        }
    }
}
