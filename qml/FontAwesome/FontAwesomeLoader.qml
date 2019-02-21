import QtQuick 2.0

FontLoader {
    property string resource
    property bool   loaded: false

    source: resource
    onStatusChanged: (status === FontLoader.Ready) ?  loaded = true : loaded = false
}