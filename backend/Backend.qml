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
import "../ubuntu-ui-extras"
import "services"

Item {
    id: root

    function toJSON() { return doc.toJSON() }
    function fromJSON(json) { doc.fromJSON(json) }

    property int nextIndex: 0

    Document {
        id: doc

        onSave: {
            // Save projects
            var list = []
            for (var i = 0; i < projects.count; i++) {
                var start = new Date()
                var project = projects.get(i).modelData
                list.push(project.toJSON())
                var end = new Date()
                print("Project " + project.name + " saved in " + (end - start) + " milliseconds")
            }

            doc.set("projects", list)
        }

        onLoaded: {
            var list = doc.get("projects", [])
            for (var i = 0; i < list.length; i++) {
                var project = projectComponent.createObject(root, {index: nextIndex++})
                project.fromJSON(list[i])
                projects.append({"modelData": project})
            }
        }
    }

    property ListModel projects: ListModel {

    }

    function newProject(name) {
        var project = projectComponent.createObject(root, {index: nextIndex++})
        project.name = name
        projects.append({"modelData": project})
        project.fromJSON({})
        return project
    }

    function removeProject(index) {
        for (var i = 0; i < projects.count; i++) {
            var project = projects.get(i).modelData

            if (project.index === index) {
                projects.remove(i)
                project.destroy(1000)
                return
            }
        }
    }

    Component {
        id: projectComponent

        Project {

        }
    }

    property ListModel availablePlugins: ListModel {

        ListElement {
            icon: "check-square-o"
            name: "tasks"
            type: "ToDo"
            title: "Tasks"
        }

        ListElement {
            icon: "pencil-square-o"
            name: "notes"
            type: "Notes"
            title: "Notes"
        }

//        ListElement {
//            name: "drawings"
//            type: ""
//            title: "Drawings"
//        }

        ListElement {
            icon: "file"
            name: "resources"
            type: "Resources"
            title: "Resources"
        }

        ListElement {
            icon: "clock"
            name: "timer"
            type: "Timer"
            title: "Time Tracker"
        }

        ListElement {
            icon: "calendar"
            name: "events"
            type: "Events"
            title: "Events"
        }
    }

    property var availableServices: [github, travisCI]

    function getPlugin(name) {
        for (var i = 0; i < availablePlugins.count;i++) {
            var plugin = availablePlugins.get(i)
            if (plugin.name === name)
                return plugin
        }
    }

    function clearInbox() {
        for (var i = 0; i < projects.count; i++) {
            var project = projects.get(i).modelData
            project.clearInbox()
        }
    }
}
