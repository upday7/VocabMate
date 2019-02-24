import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    property var options
    property alias question_text: question.text
    signal correctAnswerSelected(var correct, var answer)

    id: question_pic_grp

    Rectangle {
        id: question_bg
        z: 98
        opacity: 0.8
        color: "black"

        anchors.centerIn: parent
        width: parent.width * 0.3
        height: parent.height * 0.3
        radius: 10

        Text {
            id: question
            text: qsTr("Question Text")
            color: "#ffffff"
            textFormat: Text.RichText
            font {
                pixelSize: 16
            }
            anchors {
                fill: question_bg
            }

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.WordWrap
            z: 99
        }
    }

    Grid  {
        anchors.fill: parent
        columnSpacing: 0
        rowSpacing:0
        columns: 2

        Repeater {
            id: rpt

            model: options
//                   [{'nonce': '12',
//                    'option': '/Users/kylehuang/PycharmProjects/VocabMate/test/support/1.jpg'},
//                   {'nonce': '2',
//                    'option': '/Users/kylehuang/PycharmProjects/VocabMate/test/support/2.jpg'},
//                   {'nonce': '1332',
//                    'option':'/Users/kylehuang/PycharmProjects/VocabMate/test/support/3.jpg'},
//                   {'nonce': '1412',
//                    'option':'/Users/kylehuang/PycharmProjects/VocabMate/test/support/4.jpg'}]

            delegate: QuestionRadioPicItem {
                source: modelData.option

                width:question_pic_grp.width/2
                height: question_pic_grp.height/2

                onClicked: {
                    this.state = 'checking'
                    $api.verify_answer(index, modelData.nonce)
                }

                onStateChanged: function (this_item_state) {
                    // prevent other items be clicked when current state is checking
                    var iidx
                    if (this_item_state === "checking") {
                        for (iidx = 0; iidx < rpt.count; iidx++) {
                            rpt.itemAt(iidx).enabled = false
                        }
                    } else {
                        for (iidx = 0; iidx < rpt.count; iidx++) {
                            var item = rpt.itemAt(iidx)
                            if (item) {
                                item.enabled = true
                            }
                        }
                    }
                }

            }

        }

//        Connections {
//            target: $api
//            onAnswerBingo: function (idx, answer) {
//                var correct = idx === answer.correct_choice
//                var cur_item = rpt.itemAt(idx)
//                if (!cur_item) {
//                    return
//                }
//                cur_item.state = correct ? 'correct' : "incorrect"
//                correctAnswerSelected(correct, answer)
//                if (correct) {
//                    for (var iidx = 0; iidx < rpt.count; iidx++) {
//                        rpt.itemAt(iidx).invalidOption()
//                    }
//                }
//            }
//        }
    }
}
