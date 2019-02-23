import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3

ColumnLayout {
    id: typeItem
    width: 200
    height: 200

    property alias question_text: question.text
    signal correctAnswerSelected(var correct, var answer)

    property int max_error_count: 3

    spacing: 20
    Layout.margins: 20

    Text {
        id: question
        text: qsTr("Question Text")
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        color: "#444444"
        textFormat: Text.RichText
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }

    Text {
        id: spell_label
        text: qsTr("Spell the word:")
        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
        font {

            bold: true
            pixelSize: 24
        }
    }

    RowLayout {

        id: spell_layout
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        spacing: 10

        Item {
            width: childrenRect.width
            height: childrenRect.height
            Rectangle {
                id: input_bg
                radius: 3
                color: "#ffffff"
                width: 200
                height: button.height
                border.width: textInput.activeFocus ? 3 : 2
            }

            TextInput {
                id: textInput
                width: input_bg.width
                padding: 5
                cursorVisible: true
                wrapMode: TextInput.Wrap
                maximumLength: 30
                font.bold: true
                font.pixelSize: textInput.height * .5
                readOnly: false
                Keys.onEnterPressed: {
                    button.clicked()
                }
            }
        }

        Button {
            id: button
            text: "<font color='#ffffff'>" + $favar.fa_pencil + "  SPELL IT</font>"
            //            text: "<font color='#ffffff'>SPELL IT</font>"
            font.bold: true
            font.family: $awesome.name
            display: AbstractButton.TextBesideIcon
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
            width: button.height
            height: button.height

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

    state: "normal"
    states: [

        State {
            name: "normal"
            PropertyChanges {
                target: input_bg
                border.color: textInput.activeFocus ? "#648FE0" : "#ccc"
            }
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
