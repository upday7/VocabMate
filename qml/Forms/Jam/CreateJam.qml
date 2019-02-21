import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../../VCControls/Jam"

Item {
    property string word_list_url: "https://www.vocabulary.com/lists/2863679"
    height: 480
    width: 1080
    id: create_jam
    anchors {
        fill: parent
        margins: 20
    }

    Text {
        id: create_jam_title
        text: qsTr("Let's start a Vocabulary Jam!")
        font.family: "open sans"
        font.pixelSize: 36
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    //    Column {
    //        spacing: 10
    //        Text {
    //            text: qsTr("Source:")
    //            font.family: "open sans"
    //            font.pixelSize: 18
    //        }

    //        Text {
    //            text: qsTr(word_list_url)
    //            font.family: "open sans"
    //            font.pixelSize: 14
    //        }
    //    }
    GridLayout {
        id: create_jame_options

        anchors {
            top: create_jam_title.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }

        rowSpacing: 30
        columnSpacing: 60
        columns: 2
        rows: 4

        Column {
            spacing: 10
            Text {
                text: qsTr("How many questions should the Jam include?")
                font.family: "open sans"
                font.pixelSize: 18
            }

            QuestionCntBtnGrp {
                id: question_cnt_grp
            }
        }

        Column {
            spacing: 10
            Text {
                text: qsTr("How hard should it be?")
                font.family: "open sans"
                font.pixelSize: 18
            }

            DifBtnGrp {
                id: dif_lvl_grp
            }
        }

        Column {
            spacing: 10
            Text {
                text: qsTr("Game Speed")
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.family: "open sans"
                font.pixelSize: 18
            }

            RoundSideBtnGrp {
                id: game_speed_grp
                cur_model: ["Slow", "Normal", "Fast", "No Time Limit"]
            }
        }

        Column {
            spacing: 10
            Text {
                text: qsTr("How many teams?")
                font.family: "open sans"
                font.pixelSize: 18
            }

            TeamCntBtn {
                id: team_cnt_grp
            }
        }

        Column {
            spacing: 10
            Text {
                text: qsTr("How do you want to assign teams?")
                font.family: "open sans"
                font.pixelSize: 18
            }

            RoundSideBtnGrp {
                id: assign_team_grp
                cur_model: ["Randomly", "Students Choose"]
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 10
            Text {
                text: qsTr("Give me a list url")
                font.family: "open sans"
                font.pixelSize: 18
            }

            TextField {
                width: parent.width
                text: word_list_url
                font.family: "open sans"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignLeft
                placeholderText: "url of vocabulary list"
            }
        }
    }

    Row {
        height: childrenRect.height
        width: childrenRect.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: create_jame_options.bottom
            topMargin: 20
        }

        Button {
            id: btn_create_jam_previous
            hoverEnabled: true
            width: 180
            height: 56

            text: qsTr("<font color='#ffffff'>Create Jam</font>")
            font.capitalization: Font.MixedCase

            background: Rectangle {
                id: create_jam_btn_bg
                color: "#6ab14b"
                radius: 4
                anchors.fill: parent
            }

            font {
                family: "open sans"
                pointSize: 18
                bold: hovered ? true : false
            }
            MouseArea {
                anchors.fill: parent
                onPressedChanged: {
                    parent.scale = parent.scale === 0.95 ? 1 : 0.95
                }

                onClicked: {

                    console.log("Create Jam clicked:",
                                question_cnt_grp.cur_count,
                                dif_lvl_grp.cur_dif_lvl,
                                game_speed_grp.cur_text,
                                team_cnt_grp.team_count,
                                assign_team_grp.cur_text, word_list_url)
                }
            }
        }
    }
}
