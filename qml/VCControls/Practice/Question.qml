import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import Qt.labs.settings 1.0
import QtMultimedia 5.6

Item {

    property variant cardData: {
        "sentence": "Which technological advance depended upon the invention of the camera?",
        "instruction": 'instruction',
        "options": ["the development of the motion picture", "the invention of the personal computer", "the invention of the walkie talkie", "the development of sound effects"],
        "ready": false,
        "def": ""
    }

    Settings {
        id: settings
        category: "Question"
    }

    MediaPlayer {
        id: word_sound
        onPlaying: {
            auto_play_button.text = "<font color='#78A752'>" + $favar.fa_refresh + "</font>"
        }
    }

    id: main

    Item {
        id: question_contents

        PageIndicatorsBar {
            id: round_indicator
            total_pages: 10
            scale: 28 / 128
            y: main.height
            x: main.width - (128 * scale) * total_pages - (this.row.spacing * scale)
               * total_pages - (this.label.width * scale) - 20
        }

        QuestionCard {
            id: cardObj
            x: main.width
            y: main.height / 8
            sentence: cardData['sentence']
            instruction: cardData['instruction']
            options: cardData['options']
            height: main.height * 0.7
            onCorrectAnswerSelected: function (correct, answer) {
                round_indicator.set_correct(correct)
                if (!correct) {
                    return
                }
                word_sound.source = answer.sense.audio
                // if correct play audio
                if (settings.value("auto_play", true)) {
                    word_sound.play()
                }

                wordBlurb.blurb = answer['blurb']
                main.state = "showExpMore"
                console.log('onCorrectAnswerSelected in Question.qml, word leaning progress is: ',
                            $api.cur_word_leaning_progress)
                cur_progress.pctg = $api.cur_word_leaning_progress
            }

            HintsButton {
                id: hints_button
                z: 99

                anchors {
                    right: auto_play_button.left
                    bottom: cardObj.bottom
                    rightMargin: 3
                    bottomMargin: 10
                }

                btn_hint_def.visible: false
                onHint_def_clicked: {
                    show_def(cardObj.def)
                }
            }

            RoundButton {
                id: auto_play_button
                anchors {
                    right: cardObj.right
                    bottom: cardObj.bottom
                    rightMargin: 3
                    bottomMargin: 3
                }

                width: 28
                height: 28
                font.family: $awesome.name

                background: Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: 0
                    radius: parent.width
                }

                onClicked: {
                    if (main.state === "showExpMore") {
                        if (!settings.value("auto_play")) {
                            settings.setValue("auto_play",
                                              !settings.value("auto_play",
                                                              true))
                            set_text()
                        }
                    } else {
                        settings.setValue("auto_play",
                                          !settings.value("auto_play", true))
                        set_text()
                    }
                    if (settings.value("auto_play")) {
                        word_sound.play()
                    }
                }

                Component.onCompleted: {
                    set_text()
                }

                function set_text() {
                    this.text = "<font color='#BB3330'>"
                         + (settings.value(
                                "auto_play",
                                true) ? $favar.fa_volume_up : $favar.fa_volume_off) + "</font>"
                }
            }
        }

        WordBlurb {
            id: wordBlurb
            x: 540 + 30 + (main.width / 28) - 15
            width: main.width - (540 + 30 + (main.width / 28)) - 30 - 15
            height: 320
            blurb: {
                "short": '',
                "long": ''
            }
        }

        NextCardIndicator {
            id: nextCardIndicator
            x: main.width
            y: main.height * 3 / 8
            onClicked: {
                state = 'showExpMore'
                $api.get_question()
            }
        }

        Item {
            id: cur_progress_rect
            x: cardObj.x
            anchors {
                right: cardObj.right
                bottom: cardObj.top
                bottomMargin: 20
            }

            opacity: 0.8

            PercentageCircle {
                id: cur_progress
                anchors {
                    right: cur_progress_rect.right
                    bottom: cur_progress_rect.top
                    verticalCenter: cur_progress_rect.verticalCenter
                    leftMargin: 10
                }
            }

            Text {
                id: progress_text
                anchors {
                    right: cur_progress.left
                    verticalCenter: cur_progress.verticalCenter
                }

                text: 'Leaning Progress: '
                color: "#A7C98B"
                font {
                    family: "open sans"
                    bold: true
                }
            }

            visible: false
            onVisibleChanged: {
                aniShowWordProgress.start()
            }
            ParallelAnimation {
                id: aniShowWordProgress
                PropertyAnimation {
                    property: "y"
                    from: y - 5
                }
                PropertyAnimation {
                    property: "opacity"
                    from: 0.5
                    to: 1
                }
            }
        }
    }

    Rectangle {
        id: busy
        visible: false
        width: 64
        height: 64
        anchors.centerIn: parent
        color: 'white'
        opacity: 0.6
        radius: 10
        BusyIndicator {
            anchors.centerIn: parent
        }
    }

    Connections {
        target: $api
        onLoading: {
            word_sound.stop()
            state = 'preparing'
            auto_play_button.set_text()
        }
        onNewCard: function (rsp) {

            cardObj.sentence = rsp.question_content.sentence
            cardObj.instruction = rsp.question_content.instructions
            cardObj.options = rsp.question_content.choices

            if (rsp.question_content && rsp.question_content.def_) {
                cardObj.def = rsp.question_content.def_
                hints_button.btn_hint_def.visible = true
                console.log("def got from question content: ", cardObj.def)
            }

            round_indicator.played_count = rsp['pdata']['round'].length
            round_indicator.set_item_current(round_indicator.played_count)

            for (var i = 0; i < rsp['pdata']['round'].length; i++) {
                round_indicator.set_correct(rsp['pdata']['round'][i].cor, i)
            }

            state = 'newCard'
        }

        onStarted: function (rsp) {

            round_indicator.round_number = round_indicator.round_number + 1
            round_indicator.played_count = rsp['pdata']['round'].length
            round_indicator.set_item_current(round_indicator.played_count)
            var i
            if (rsp['pdata']['round'].length === 0) {
                round_indicator.reset_indicators()
            } else {
                for (i = 0; i < rsp['pdata']['round'].length; i++) {
                    round_indicator.set_correct(rsp['pdata']['round'][i].cor, i)
                }
            }

            $api.get_question()
        }
    }

    Keys.onRightPressed: {
        if (state !== 'showExpMore')
            return
        nextCardIndicator.clicked()
    }

    states: [
        State {
            name: "preparing"
            PropertyChanges {
                target: busy
                visible: true
            }
            PropertyChanges {
                target: cur_progress_rect
                visible: false
            }
        },
        State {
            name: "newCard"
            PropertyChanges {
                target: busy
                visible: false
            }
            PropertyChanges {
                target: cur_progress_rect
                visible: false
            }
        },
        State {
            name: "showExpMore"
            PropertyChanges {
                target: busy
                visible: false
            }
            PropertyChanges {
                target: cur_progress_rect
                visible: true
            }
        }
    ]

    transitions: [

        Transition {
            from: "newCard"
            to: "showExpMore"
            PropertyAnimation {
                target: cardObj
                property: "x"
                from: main.width / 4
                to: main.width / 28
                duration: 200
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: wordBlurb
                    property: "visible"
                    from: false
                    to: true
                }

                PropertyAnimation {
                    target: wordBlurb
                    property: "opacity"
                    from: 0.5
                    to: 1
                    duration: 200
                }
                PropertyAnimation {
                    target: wordBlurb
                    property: "y"
                    from: main.height / 10
                    to: main.height / 8
                    duration: 200
                }
            }
            PropertyAnimation {
                target: nextCardIndicator
                property: "x"
                to: 540 + 30 + (main.width / 28) + wordBlurb.width
                duration: 200
            }
        },

        Transition {
            from: "showExpMore"
            to: "preparing"
            ParallelAnimation {
                PropertyAnimation {
                    target: cardObj
                    property: "x"
                    to: 0 - width
                    duration: 200
                }
                ParallelAnimation {
                    PropertyAnimation {
                        target: wordBlurb
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 200
                    }
                    PropertyAnimation {
                        target: wordBlurb
                        property: "y"
                        from: main.height / 8
                        to: main.height / 10
                        duration: 200
                    }
                }
                PropertyAnimation {
                    target: nextCardIndicator
                    property: "x"
                    to: main.width
                    duration: 200
                }
                PropertyAnimation {
                    target: round_indicator
                    property: "y"
                    to: main.height
                }
            }
        },
        Transition {
            from: "preparing"
            to: "newCard"
            SequentialAnimation {

                PropertyAnimation {
                    target: wordBlurb
                    property: "visible"
                    from: true
                    to: false
                }

                PropertyAnimation {
                    target: cardObj
                    property: "x"
                    from: main.width
                    to: main.width / 4
                    duration: 200
                }

                PropertyAnimation {
                    target: round_indicator
                    property: "y"
                    to: main.height - 60
                }
            }
        }
    ]
}
