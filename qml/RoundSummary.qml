import QtQuick 2.0
import QtQuick.Layouts 1.3

//components
Item {
    id: round_summary
    height: childrenRect.height
    width: childrenRect.width
    property alias round_prg_data: rpt.model
    ColumnLayout {
        spacing: 10
        Repeater {
            id: rpt
            delegate: WordProgress {
                word: modelData['wrd']
                pctg: modelData['prg']
                def: modelData['def_']
            }
        }
    }
}
