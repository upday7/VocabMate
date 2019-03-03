import QtQuick 2.9

Canvas {
    property double pctg: 0
    id: prg_img

    width: 90
    height: width

    property string img_url: "../../res/img/progress.png"
    readonly property int unit_width: 90
    onPaint: {
        var image_loaded = isImageLoaded(img_url)
        console.debug("Progress Image is loaded:", image_loaded)
        if (image_loaded) {
            console.debug("Drawing progress image",
                          unit_width * Math.floor(pctg * 100), 0, unit_width,
                          unit_width, 0, 0, width, width)
            console.debug("Pctg is", pctg)
            var ctx = getContext('2d')
            ctx.reset()
            ctx.drawImage(img_url, unit_width * Math.floor(pctg * 100), 0,
                          unit_width, unit_width, 0, 0, width, width)
            ctx.save()
        }
    }

    Component.onCompleted: {
        loadImage(img_url)
    }

    onPctgChanged: {
        //        paint(prg_img)
        requestPaint()
    }
}
