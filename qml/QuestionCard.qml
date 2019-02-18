import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.12

Rectangle {

    property var options
    property string sentence
    property string instruction

    property var optionsObj
    property var optionsComponent

    signal correctAnswerSelected(var correct, var answer)

    id: question_card
    width: 540
    radius: 10
    color: 'white'
    border.color: "#919691"
    border.width: 5

    opacity: 0

    Connections {
        target: $api
        onNewCard: function (res) {
            var one_option = res.question_content.choices[0]
            while (optionsComponent) {
                optionsComponent.destroy()
                optionsComponent = null
            }

            while (optionsObj) {
                optionsObj.destroy()
                optionsObj = null
            }

            function createOptionsGroup(qml_file, qtype) {
                optionsComponent = Qt.createComponent(qml_file)

                if (optionsComponent.status === Component.Ready
                        || optionsComponent.status === Component.Error) {
                    finishCreation(qtype)
                } else {
                    optionsComponent.statusChanged.connect(finishCreation)
                }
            }

            function finishCreation(qtype) {
                if (optionsComponent.status === Component.Ready) {
                    if (qtype !== "T") {
                        optionsObj = optionsComponent.createObject(
                                    question_card, {
                                        "options": res.question_content.choices
                                    })
                    } else {
                        optionsObj = optionsComponent.createObject(
                                    question_card)
                    }

                    if (optionsObj === null) {
                        console.log("Error creating image")
                    }
                } else if (optionsComponent.status === Component.Error) {
                    console.log("Error loading component:",
                                optionsComponent.errorString())
                }

                optionsObj.focus = true
                optionsObj.onCorrectAnswerSelected.connect(
                            correctAnswerSelected)

                if (qtype === "I") {
                    optionsObj.width = question_card.width
                    optionsObj.height = question_card.height
                    optionsObj.scale = 0.97
                    optionsObj.color = question_card.border.color
                    question_card.color = question_card.border.color
                } else {
                    if (qtype === "T") {
                        optionsObj.anchors.fill = question_card
                        optionsObj.anchors.margins = 20
                    } else {
                        question_card.color = "white"
                        optionsObj.scale = 1
                        optionsObj.options = res.question_content.choices
                        optionsObj.anchors.fill = question_card
                        optionsObj.anchors.margins = 20
                    }
                }

                aniFadeOut.start()
                aniShowup.start()
            }

            if (res.qtype === "I") {
                createOptionsGroup("QuestionPicGroup.qml", res.qtype)
                optionsObj.question_text = instruction
            } else {
                if (res.qtype === "T") {
                    createOptionsGroup("QuestionTypeItem.qml", res.qtype)
                    if (sentence) {
                        sentence = "<div style='font-size: 14px;clear: both'>" + sentence + "</div>"
                    }

                    optionsObj.question_text = sentence
                } else {
                    createOptionsGroup("QuestionRadioGroup.qml", res.qtype)

                    if (sentence) {
                        sentence = "<div style='font-size: 14px;clear: both'>" + sentence + "</div>"
                    }

                    if (instruction) {
                        instruction = "<div style='font-size: 18px'>" + instruction + "</div>"
                    }

                    optionsObj.question_text = "<div style='vertical-align: middle;'>"
                            + sentence + "<br>" + instruction + "</div>"
                    console.log("Question text got: ", optionsObj.question_text)
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
