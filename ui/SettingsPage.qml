/*
 * Project Dashboard - Manage everything about your projects in one app
 * Copyright (C) 2014 Michael Spencer
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    id: page
    
    title: i18n.tr("Settings")

    Column {
        anchors.fill: parent

        ListItem.Header {
            text: i18n.tr("Accounts")
        }

        Repeater {
            model: backend.availableServices
            delegate: ListItem.SingleValue {
                text: modelData.title
                value: modelData.authenticationStatus
                visible: modelData.authenticationRequired

                Button {
                    visible: !modelData.enabled
                    text: i18n.tr("Authenticate")
                    height: units.gu(4)
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    onClicked: {
                        if (!modelData.enabled)
                            modelData.authenticate()
                        else
                            modelData.revoke()
                    }
                }
            }
        }

        ListItem.Header {
            text: i18n.tr("Help and About")
        }

        ListItem.Standard {
            text: i18n.tr("About Project Dashboard")
            progression: true
            onClicked: pageStack.push(aboutPage)
        }

        ListItem.Standard {
            text: i18n.tr("View Tutorial")
            progression: true
            onClicked: pageStack.push(Qt.resolvedUrl("InitialWalkthrough.qml"), {exitable: true})
        }
    }

    tools: ToolbarItems {
        opened: wideAspect
        locked: wideAspect

        onLockedChanged: opened = locked
    }
}
