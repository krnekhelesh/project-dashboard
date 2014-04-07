import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    property string title
    property string shortTitle: title
    property string icon
    property bool enabled: true

    property string value

    property Component page

    property Component pulseItem

    property Action action
}
