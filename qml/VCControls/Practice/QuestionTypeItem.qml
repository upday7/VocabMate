import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3

Item {
    id: typeItem
    width: childrenRect.width
    height: childrenRect.height

    property alias question_text: question.text
    signal correctAnswerSelected(var correct, var answer)
    property int minWidth: 520
    property int max_error_count: 3

    Text {
        id: question
        text: qsTr("Question Text")
        color: "#444444"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        width: typeItem.minWidth
    }

    Text {
        id: spell_label
        text: qsTr("Spell the word:")
        font {
            bold: true
            pixelSize: 24
        }
        anchors {
            top: question.bottom
            topMargin: 20
        }
    }

    RowLayout {

        id: spell_layout

        spacing: 10

        anchors {
            top: spell_label.bottom
            topMargin: 20
        }

        TextField {
            id: textInput

            Layout.fillWidth: true
            Layout.minimumWidth: 300
            Layout.minimumHeight: 35
            focus: true
            padding: 5
            cursorVisible: true
            font.bold: true
            background: Rectangle {
                id: input_bg
                radius: 3
                color: "#ffffff"
                border.width: textInput.activeFocus ? 3 : 2
                anchors.fill: parent
                border.color: textInput.activeFocus ? "#648FE0" : "#ccc"
            }
        }

        Button {
            id: button
            Layout.minimumHeight: textInput.height
            Layout.minimumWidth: 80

            text: "<font color='#ffffff'>" + $favar.fa_pencil + "  SPELL IT</font>"
//                        text: "<font color='#ffffff'>SPELL IT</font>"
            font.bold: true
            font.family: $awesome.name

            enabled: !textInput.readOnly
            background: Rectangle {
                radius: 3
                color: "#6cb25a"
                anchors.fill: parent
                border.width: button.activeFocus ? 3 : 2
                border.color: "#ccc"
            }
            onClicked: {

                var answer_word = textInput.text.toLocaleLowerCase().trim()
                if (answer_word === "") {
                    return
                }
                typeItem.state = 'checking'
                $api.verify_answer(-1, answer_word)
            }
        }

        AnimatedImage {
            id: loading

            Layout.minimumWidth: button.height
            Layout.minimumHeight: button.height

            source: "../../res/img/loading.svg"
            visible: textInput.readOnly
            RotationAnimator on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                running: true
                duration: 3000
            }
        }

        signal correctAnswerSelected(var correct, var answer)

        Connections {
            target: $api
            onAnswerBingo: function (idx, answer) {
                var answer_word = textInput.text.toLocaleLowerCase().trim()
                var correct = answer.word.toLocaleLowerCase().trim(
                            ) === answer_word
                typeItem.state = correct ? 'correct' : "incorrect"
                correctAnswerSelected(correct, answer)
                if (correct) {
                    question_text = answer.sentence_html
                } else {
                    max_error_count = max_error_count - 1
                }
                if (max_error_count <= 0) {
                    textInput.text = answer.word
                    textInput.color = "#78A752"
                    typeItem.state = correct
                }
            }
        }
    }

    onVisibleChanged: {
        textInput.text =""
        max_error_count = 3
    }

    state: "normal"
    states: [

        State {
            name: "normal"
            PropertyChanges {
                target: textInput
                readOnly: false
            }
        },

        State {
            name: "checking"
            PropertyChanges {
                target: textInput
                readOnly: true
            }
        },

        State {
            name: "incorrect"
            PropertyChanges {
                target: input_bg
                border.color: "#BB3330"
            }
            PropertyChanges {
                target: textInput
                readOnly: false
            }
        },
        State {
            name: "correct"
            PropertyChanges {
                target: input_bg
                border.color: "#78A752"
            }
            PropertyChanges {
                target: textInput
                readOnly: false
            }
        }
    ]
}
