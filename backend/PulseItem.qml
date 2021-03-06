import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Column {
    id: column

    width: parent.width
    height: childrenRect.height

    property string title
    property string viewAll
    property bool show: title !== ""
    property bool showAnyway: wideAspect && title !== ""

    ListItem.Header {
        text: title
        visible: column.show
        height: visible ? units.gu(4) : 0
    }

    states: State {
        when: !(show || showAnyway)

        PropertyChanges {
            target: column
            restoreEntryValues: true
            height: 0
            opacity: 0
        }
    }

    transitions: Transition {
        from: "*"
        to: "*"

        UbuntuNumberAnimation {
            target: column
            properties: "height,opacity"
        }
    }
}
