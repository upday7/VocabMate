import QtQuick 2.7
import QtQuick.Window 2.3
import "Forms"

QtObject {

    property var $splash: FormSplash {
    }
    property var loader: Loader {
        asynchronous: true
        source: "main.qml"
        active: false
        onLoaded: {
            $splash.close()
        }
    }

    Component.onCompleted: {
        $splash.show()
        loader.active = true
    }
}
