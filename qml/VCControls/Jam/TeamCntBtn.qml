import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.3

Rectangle {
    id: team_cnt_btn_grp
    height: childrenRect.height
    width: childrenRect.width

    property int team_count: 0
    property int btn_width: 48
    property int _last_active_btn_index: -1
    readonly property int default_btn_index: 0

    Row {
        spacing: 5
        Repeater {
            id: team_cnt_btn_rpt

            model: [2, 3, 4]
            delegate: NumberRoundBtn {
                cur_number: modelData
                width: team_cnt_btn_grp.btn_width
                height: width
                property int btn_index: index

                Connections {
                    onClicked: {
                        if (team_count !== cur_number
                                && _last_active_btn_index >= 0) {
                            team_cnt_btn_rpt.itemAt(
                                        _last_active_btn_index).set_inactive()
                        }
                        _last_active_btn_index = index
                        team_count = cur_number
                    }
                }
            }

            Component.onCompleted: {
                team_cnt_btn_rpt.itemAt(default_btn_index).clicked()
            }
        }
    }
    onTeam_countChanged: {
        console.log("current team count: ", team_count)
    }
}
