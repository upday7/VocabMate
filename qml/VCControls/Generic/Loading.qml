import QtQuick 2.9
import QtQuick.Controls 2.4

AnimatedImage {
    id: aniLoading
    x: 138
    y: 180
    width: 33
    height: 21

    source: "../../res/img/loading.svg"
    fillMode: Image.PreserveAspectFit
    property alias running: aniLoading_animator_rotation.running
    RotationAnimator on rotation {
        id: aniLoading_animator_rotation
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 3000
    }
}
