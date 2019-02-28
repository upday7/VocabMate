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

    PageIndicatorsBar {
        id: round_indicator
        total_pages: 10
        anchors {
            right: main.right
            rightMargin: 20
            bottomMargin: 10
            topMargin: 20
        }
    }

    Item {
        id: question_contents
        anchors.fill: parent

        QuestionCard {
            //            height: main.height * 0.7
            id: cardObj

            sentence: cardData['sentence']
            instruction: cardData['instruction']
            options: cardData['options']
            visible: false

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
                    radius: 28
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

            anchors {
                left: cardObj.right
                leftMargin: 20
                verticalCenter: cardObj.verticalCenter
            }

            width: main.width - cardObj.width - 20 - 30

            height: 320
            blurb: {
                "short": '',
                "long": ''
            }
        }

        NextCardIndicator {
            id: nextCardIndicator
            visible: wordBlurb.visible
            anchors {
                left: wordBlurb.right
                verticalCenter: wordBlurb.verticalCenter
                leftMargin: 0 - nextCardIndicator.width - 10
            }

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
            PropertyChanges {
                target: wordBlurb
                visible: false
            }

            AnchorChanges {
                target: round_indicator
                anchors {
                    top: main.bottom
                }
            }

            PropertyChanges {
                target: cardObj
                anchors.centerIn: question_contents
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
            PropertyChanges {
                target: wordBlurb
                visible: false
            }
            AnchorChanges {
                target: round_indicator
                anchors {
                    bottom: main.bottom
                }
            }

            PropertyChanges {
                target: cardObj
                visible: true
                anchors.centerIn: question_contents
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

            AnchorChanges {
                target: round_indicator
                anchors {
                    bottom: main.bottom
                }
            }
            PropertyChanges {
                target: wordBlurb
                visible: true
            }
            PropertyChanges {
                target: cardObj
                visible: true
            }
        }
    ]

    transitions: [

        Transition {
            from: "newCard"
            to: "showExpMore"
            AnchorAnimation {
                targets: [wordBlurb, nextCardIndicator]
                duration: 200
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: wordBlurb
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }

            PropertyAnimation {
                target: cardObj
                property: "x"
                to: main.x + 20
            }
        },

        Transition {
            from: "showExpMore"
            to: "preparing"

            ParallelAnimation {
                ParallelAnimation {
                    PropertyAnimation {
                        target: wordBlurb
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 200
                    }
                }
                AnchorAnimation {
                    targets: [round_indicator]
                    duration: 300
                }
            }
        },

        Transition {
            from: "preparing"
            to: "newCard"

            AnchorAnimation {
                targets: [round_indicator]
                duration: 300
            }
        }
    ]
}
