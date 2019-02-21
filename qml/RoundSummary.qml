import QtQuick 2.0
import QtQuick.Layouts 1.3

//components
Item {
    id: round_summary
    height: childrenRect.height
    width: childrenRect.width
    property alias round_prg_data: round_summary_rpt.model

    Column {
        spacing: 10
        Repeater {
            id: round_summary_rpt
            model: [{
                    "wrd": 'wary',
                    "prg": 0.25,
                    "def_": 'openly distrustful and unwilling to confide'
                }]
            delegate: WordProgress {
                word: modelData['wrd']
                pctg: modelData['prg']
                def: modelData['def_']
            }
        }
    }
}
