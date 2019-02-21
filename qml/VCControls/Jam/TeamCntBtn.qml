import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: team_cnt_btn_grp
    height: childrenRect.height
    width: childrenRect.width

    property int team_count: 0
    property int btn_width: 48
    property int _last_active_btn_index: 0

    Row {
        spacing: 5
        Repeater {
            id: team_cnt_btn_rpt

            model: [2, 3, 4]
            delegate: NumberRoundBtn {
                cur_number: modelData
                width: q_count_button_group.btn_width
                height: width
                property int btn_index: index

                Connections {
                    onClicked: {
                        if (team_cnt_btn_grp.team_count !== cur_number) {
                            team_cnt_btn_rpt.itemAt(
                                        _last_active_btn_index).set_inactive()
                            team_cnt_btn_grp._last_active_btn_index = index
                            team_count = cur_number
                        }
                    }
                }
            }

            Component.onCompleted: {
                team_cnt_btn_rpt.itemAt(_last_active_btn_index).set_active()
            }
        }
    }
}
