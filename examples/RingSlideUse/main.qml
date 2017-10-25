import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "./components" as Components

ApplicationWindow {
    visible: true
    width: 740
    height: 680
    title: "Use RingSlide"

    ListModel {
        id: ringModel
        ListElement{ label:"A0-2222";}
        ListElement{ label:"A1";}
        ListElement{ label:"A2";}
        ListElement{ label:"A3";}
        ListElement{ label:"A4";}
        ListElement{ label:"A5";}
        ListElement{ label:"A6";}
        ListElement{ label:"A7";}
    }
    ListModel {
        id: ringModel2
        ListElement{ label:"A0<br>0.5"; value:6.66; }
        ListElement{ label:"A1<br>1.2";}
        ListElement{ label:"A2<br>2.6";}
        ListElement{ label:"A3<br>3.1";}
        ListElement{ label:"A4<br>4.5";}
        ListElement{ label:"A5<br>5.2";}
        ListElement{ label:"A6";}
        ListElement{ label:"A7<br>7.2";}
    }
    ListModel {
        id: ringModel3
        ListElement{ label:"A0<br>14354";}
        ListElement{ label:"A1";}
        ListElement{ label:"A2";}
        ListElement{ label:"A3<br>3.1";}
        ListElement{ label:"A4<br>4.5";}
        ListElement{ label:"A5<br>5.2";}
        ListElement{ label:"A6<br>6.7";}
        ListElement{ label:"A7<br>7.2";}
    }

    Column {
        spacing: 10
        anchors.centerIn: parent
        Components.RingSlide {
            id: ring1
            title: "Цифирки"
            fontTitle.bold: true
            model: ringModel2
            position: Qt.Horizontal
            type: 1
            numLinesLabelsUse: 2
            srcSelectorIcon: "qrc:/arrow_48.png"
            height: 80
            stepSize: 500/model.count
            color: viewLimits.checked ? "gray" : "transparent"
            onIndexChanged: {
                currentIndex = index
                console.log(currentValue())
            }
        }
        Components.RingSlide {
            id: ring2
            model: ringModel2
            position: Qt.Horizontal
            type: 2
            textSelectorTitle: "v"
            height: 90
            stepSize: 500/model.count
            numLinesLabelsUse: 2
            numLinesTitleUse: 2
            title: "ABS<br>CDEFGH"
            color: viewLimits.checked ? "gray" : "transparent"
            onIndexChanged: {
                currentIndex = index
            }
        }
        Row {
            spacing: 10
            Components.RingSlide {
                id: ring4
                model: ringModel2
                position: Qt.Vertical
                type: 2
                stepSize: 35
                color: viewLimits.checked ? "gray" : "transparent"
                onIndexChanged: {
                    currentIndex = index
                }
            }
            Components.RingSlide {
                id: ring5
                model: ringModel3
                position: Qt.Vertical
                type: 2
                stepSize: 35
                fixedSelectorWidth: 15
                width: 100
                color: viewLimits.checked ? "gray" : "transparent"
                onIndexChanged: {
                    currentIndex = index
                }
            }
            Components.RingSlide {
                id: ring3
                title: "Abababab"
                model: ringModel
                position: Qt.Vertical
                type: 1
                fixedSelectorWidth: 15
                width: 80
                color: viewLimits.checked ? "gray" : "transparent"
                onIndexChanged: {
                    currentIndex = index
                }
            }
            Column {
                CheckBox {
                    id: viewLimits
                    text: "Показать границы"
                }
            }
        }

    }

}
