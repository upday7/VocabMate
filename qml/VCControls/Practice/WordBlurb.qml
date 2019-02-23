import QtQuick 2.9
import QtQuick.Controls 2.4

Item {
    id: word_burb
    property variant blurb

    Text {
        id: blurb_short
        text: blurb['short']

        width: parent.width
        opacity: 1
        color: 'white'
        wrapMode: Text.Wrap
        textFormat: Text.RichText
        font {

            pixelSize: 18
        }
    }

    Text {
        id: blurb_long
        opacity: 1
        textFormat: Text.RichText
        text: blurb['long']
        width: parent.width
        anchors.top: blurb_short.bottom
        anchors.topMargin: 20
        color: 'white'
        wrapMode: Text.Wrap

        font {

            pixelSize: 16
        }
    }
}
