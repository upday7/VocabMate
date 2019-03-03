import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.12
import QtQuick.Controls 2.4

Rectangle {

    property var options
    property string sentence
    property string instruction
    property string def

    signal correctAnswerSelected(var correct, var answer)

    id: question_card

    radius: 10
    color: 'white'
    border.color: "#919691"
    border.width: 5

    height: 350
    width: 540

    QuestionRadioGroup {
        id: question_radio_grp
        visible: false

        anchors {
            centerIn: parent
            margins: 20
        }

        onCorrectAnswerSelected: function (correct, answer) {
            if (!visible) {
                return
            }
            question_card.correctAnswerSelected(correct, answer)
        }
        onHeightChanged: {

            if (!visible) {
                return
            }

            question_card.height = childrenRect.height + 40
            question_card.width = childrenRect.width + 40
        }
    }

    QuestionTypeItem {
        id: question_type_word
        visible: false

        anchors {
            fill: parent
            margins: 20
        }

        onCorrectAnswerSelected: function (correct, answer) {
            if (!visible) {
                return
            }
            question_card.correctAnswerSelected(correct, answer)
        }
        onHeightChanged: {
            if (!visible) {
                return
            }
            question_card.height = 350
            question_card.width = 540
        }
    }

    QuestionPicGroup {
        id: question_pic_grp
        visible: false

        anchors {
            fill: parent
            margins: 5
        }

        onCorrectAnswerSelected: function (correct, answer) {
            if (!visible) {
                return
            }
            console.debug("QuestionPicGroup onCorrectAnswerSelected")
            question_card.correctAnswerSelected(correct, answer)
        }

        onHeightChanged: {
            if (!visible) {
                return
            }
        }
    }

    Connections {
        target: $api
        onNewCard: function (res) {

            var options = res.question_content.choices

            if (res.qtype === "I") {
                question_radio_grp.visible = false
                question_pic_grp.visible = true
                question_type_word.visible = false

                question_pic_grp.question_text = instruction
                question_pic_grp.options = options
            } else {
                if (res.qtype === "T") {
                    if (sentence) {
                        sentence = "<div style='font-size: 14px;clear: both'>" + sentence + "</div>"
                    }
                    question_radio_grp.visible = false
                    question_pic_grp.visible = false
                    question_type_word.visible = true
                    question_type_word.question_text = sentence
                } else {
                    if (sentence) {
                        sentence = "<div style='font-size: 14px;clear: both'>" + sentence + "</div>"
                        sentence = "<div style='vertical-align: middle;'>" + sentence + "<br>"
                    } else {
                        sentence = ""
                    }

                    if (instruction) {
                        instruction = "<div style='font-size: 18px'>" + instruction + "</div>"
                    }

                    question_radio_grp.visible = true
                    question_pic_grp.visible = false
                    question_type_word.visible = false

                    question_radio_grp.question_text = sentence + instruction + "</div>"
                    question_radio_grp.options = options
                }
            }
        }
    }

    onXChanged: {
        aniFadeOut.start()
        aniShowup.start()
    }

    // animation
    ParallelAnimation {
        id: aniShowup
        PropertyAnimation {
            target: question_card
            property: "opacity"
            from: 0.6
            to: 1
            duration: 300
        }
    }

    ParallelAnimation {
        id: aniFadeOut
        PropertyAnimation {
            target: question_card
            property: "opacity"
            from: 1
            to: 0
            duration: 300
        }
    }
}
