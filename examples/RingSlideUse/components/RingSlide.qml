import QtQuick 2.4

Rectangle
{
    id: root_ring

    /* Внимание! Чтобы контрол работал, необходимо прописать слот на сигнал indexChanged(index)
      Пример:
        RingSlide {
            title: qsTr("Цифирки")
            value: 0
            type: 1 // 1 or 2
            position: Qt.Horizontal // Qt.Horizontal or Qt.Vertical
            width: 60
            height: 180
            model: ListModel {
                ListElement{ label:"0"; value:0.1; }
                ListElement{ label:"1"; value:0.5; }
                ListElement{ label:"2"; value:1.7; }
                ListElement{ label:"3"; value:2.0; }
                ListElement{ label:"4"; value:8.0; }
                ListElement{ label:"5"; value:11.4; }
                ListElement{ label:"6"; value:12.0; }
                ListElement{ label:"7"; value:15.5; }
            }
            // ...
            onIndexChanged: { // !
                currentIndex = index // or Pars.setSomeRingIndex(index)
            }
        }

    */

    color: "transparent"

    /* Размеры и положение */
    property int position: Qt.Horizontal 	// Позиционирование (Qt.Horizontal или Qt.Vertical)
    property int type: 1					// Тип отображения, отвечает за то где будут расположены заголовки модели (1-сверху/слева или 2-снизу/справа)
    property int stepSize: 30				// Размер позиции для ползунка по ширине или высоте (зависит от position)
    height: setRingDefaultHeight()			// Высота контрола (* можно настроить только один параметр в зависимости от position, остальной будет зависеть от количества элементов модели и stepSize *)
    width: setRingDefaultWidth()        	// Ширина контрола (* можно настроить только один параметр в зависимости от position, остальной будет зависеть от количества элементов модели и stepSize *)
    property int borderWidth: 1				// Ширина обводки границ (фоновых)
    property int numLinesTitleUse: 1        // Сколько необходимо отобразить строк заголовка, чтобы он не наехал на функционал.
    property int numLinesLabelsUse: 1       // Сколько необходимо отобразить строк заголовка для каждого элемента модели.
    property int fixedSelectorWidth: -1      // Фиксированная ширина контрола

    /* Вид */
    // задний вид и заголовки
    property color colorBackBackground: Qt.darker("#f1eee0", 1.1) 	// Цвет заднего фона (провала)
    property color colorBackBorder: Qt.darker("#f1eee0", 1.7)		// Цвет границ (фоновых)
    property color colorTextActiveItem: "red"		// Цвет текста заголовка, который выбран по индексу
    property alias title: ring_label_u.text         // Главный заголовок
    property alias fontTitle: ring_label_u.font     // Настройка шрифта отображения главного заголовка
    property alias fontLabels: fontProvider.font    // Настройка шрифта отображения заголовков модели
    // вид переключателя
    property color colorSelectorBackground: "#ccfbf9d2"		// Цвет заливки ползунка
    property color colorSelecterBorder: "black" 	// Цвет обводки ползунка
    property bool ellipticSelector: true            // Вкл. скругление ползунка
    property string srcSelectorIcon: ""		// Иконка, отображаемая в ползунке
    property string textSelectorTitle: "" 	// Если иконка выше не указана, можно указать текст который будет отображен в ползунке, например что-то вида "^", "v", "<", ">" ...
    
    /* Позиция */    
    property int currentIndex: 0    		// текущий выбранный индекс элемента модели

    /* Состояния */
    property bool dimmed: false				// контрол выключен (для изменения вида и отключения)

    /* Модель с данными (заголовками) */
    property ListModel model

    /* Функциональные сигналы */
    signal indexChanged(int index)	// посылается всякий раз, когда меняется положение ползунка

    /* Не трогаемые параметры */
    property Component ring: getRingComponent(type, position)

    /* Методы */
    function getValue(idx) {
        return model.get(idx).value
    }
    function currentValue() {
        return getValue(currentIndex)
    }

    /* Системные функции */
    // Изменить вид отображения
    function updateView() {
        ring = getRingComponent(type, position);
    }
    // Получить цвет по индексу элемента, активный
    function putColor(currentIndex,index) {
        return (currentIndex === index) ? colorTextActiveItem : "black";
    }
    // Установка высоты по умолчанию
    function setRingDefaultHeight() {
        if(position === Qt.Horizontal) {
            return ((ring_label_u.text.length > 0) ? 60 : 60-ring_label_u.height)+5;
        }
        if(position === Qt.Vertical) {
            return ((ring_label_u.text.length > 0 && numLinesTitleUse > 0) ? model.count*stepSize+numLinesTitleUse*14+5 : model.count*stepSize)+5;
        }
        return 65;
    }
    // Установка ширины по умолчанию
    function setRingDefaultWidth() {
        if(position === Qt.Horizontal) {
            if(model !== null) {
                return stepSize*model.count;
            }
            return stepSize;
        }
        return 60;
    }
    // Получить компонент переключателя по положению и типу
    function getRingComponent(type, position) {
        if(type === 1 && position === Qt.Horizontal) {
            return ring_horizontal_1;
        }
        else if(type === 2 && position === Qt.Horizontal) {
            return ring_horizontal_2;
        }
        else if(type === 1 && position === Qt.Vertical) {
            return ring_vertical_1;
        }
        else if(type === 2 && position === Qt.Vertical) {
            return ring_vertical_2;
        }
        return ring_horizontal_1;
    }

    /* Обработчики */
    onPositionChanged: {
        updateView();
    }
    onTypeChanged: {
        updateView();
    }    

    /* Объекты */
    // Главный заголовок
    Text {
        id: ring_label_u
        text: ""
        height: (text.length > 0) ? 14*numLinesTitleUse : 0
        width: (text.length > 0) ? parent.width : 0
        font.pixelSize: 14
        anchors.top: root_ring.top
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
    }
    // Для хранения и инициализации шрифта заголовков положений
    Text {
        id: fontProvider
        visible: false
        font.pixelSize: 14
    }

	// Загрузчик компонента переключателя
    Loader {
        id: ringTypeLoader
        anchors.top: ring_label_u.bottom
        anchors.topMargin: ((ring_label_u.text.length > 0) ? 5 : 0)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        sourceComponent: ring
    }

    /* Компоненты */
    Component {
        id: ring_horizontal_1
        Item {
            id: ring_1
            height: ringTypeLoader.height
            width: root_ring.width
            Row {
                id: ring_li_labels_h1
                anchors.top: parent.top
                height: fontProvider.font.pixelSize*numLinesLabelsUse
                Repeater {
                    model: (root_ring.model !== null) ? root_ring.model.count : 0
                    Text {
                        width: stepSize
                        text: root_ring.model.get(index).label
                        horizontalAlignment: Text.AlignHCenter                        
                        color: putColor(currentIndex, index)
                        // проброс аттрибутов шрифта с fontProvider
                        font.bold: fontProvider.font.bold
                        font.capitalization: fontProvider.font.capitalization
                        font.family: fontProvider.font.family
                        font.hintingPreference: fontProvider.font.hintingPreference
                        font.italic: fontProvider.font.italic
                        font.letterSpacing: fontProvider.font.letterSpacing
                        font.overline: fontProvider.font.overline
                        font.strikeout: fontProvider.font.strikeout
                        font.styleName: fontProvider.font.styleName
                        font.underline: fontProvider.font.underline
                        font.weight: fontProvider.font.weight
                        font.wordSpacing: fontProvider.font.wordSpacing
                        font.pixelSize: fontProvider.font.pixelSize
                    }
                }
            }
            Row {
                id: ring_li_marks_h1
                anchors.top: ring_li_labels_h1.bottom
                anchors.topMargin: 5
                height: 4
                Repeater {
                    model: (root_ring.model !== null) ? root_ring.model.count : 0
                    Item {
                        width: stepSize
                        height: ring_li_marks_h1.height
                        Rectangle {
                            height: parent.height;
                            width: 2;
                            anchors.centerIn: parent;
                            color: putColor(currentIndex, index)
                        }
                    }
                }
            }
            Rectangle {
                id: ring_background_h1
                function getHeight() {
                    if(fixedSelectorWidth > 0) {
                        return fixedSelectorWidth;
                    }
                    return (ring_1.height - fontProvider.font.pixelSize*numLinesLabelsUse - ring_li_marks_h1.height - ring_li_marks_h1.anchors.topMargin - ring_background_h1.anchors.topMargin);
                }
                anchors.top: ring_li_marks_h1.bottom
                anchors.topMargin: 2
                width: (root_ring.model !== null) ? root_ring.model.count*stepSize : stepSize
                height: getHeight()
                color: colorBackBackground
                radius: height/2
                border.color: colorBackBorder
                border.width: borderWidth
            }
            Row {
                id: ring_hover_h1
                anchors.top: ring_li_labels_h1.top                
                Repeater {
                    model: root_ring.model.count
                    Item {
                        height: ring_background_h1.height + ring_background_h1.anchors.topMargin + ring_li_marks_h1.height + ring_li_marks_h1.anchors.topMargin + ring_li_labels_h1.height
                        width: ring_background_h1.width / root_ring.model.count
                        state: (index == currentIndex) ? "checked" : "unchecked"
                        Rectangle {
                            radius: ellipticSelector ? ring_background_h1.height / 2 : 0
                            height: ring_background_h1.height
                            width: stepSize
                            anchors.horizontalCenter: parent.horizontalCenter                            
                            anchors.bottom: parent.bottom
                            border.width: 2
                            color: colorSelectorBackground
                            border.color: colorSelecterBorder
                            visible: (parent.state === "checked") ? true : false
                            Text {
                                text: textSelectorTitle
                                visible: textSelectorTitle.length > 0
                                font.bold: true
                                color: colorSelecterBorder
                                font.pixelSize: 8
                                anchors.centerIn: parent
                            }
                            Image {
                                height: parent.height-6 <= 48 ? parent.height-6 : 48
                                width: height
                                visible: textSelectorTitle.length === 0  && srcSelectorIcon.length > 0
                                anchors.centerIn: parent
                                mipmap: true
                                source: srcSelectorIcon
                            }
                        }
                        MouseArea
                        {
                            id: mouseLayout
                            anchors.fill: parent
                            onClicked: indexChanged(index)
                        }
                    }
                }
            }
        }
    }
    Component {
        id: ring_horizontal_2
        Item {
            id: ring_2
            height: ringTypeLoader.height
            width: root_ring.width
            Rectangle {
                id: ring_background_h2
                function getHeight() {
                    if(fixedSelectorWidth > 0) {
                        return fixedSelectorWidth;
                    }
                    return (ring_2.height - ring_li_labels_h2.height - ring_li_marks_h2.height - ring_li_marks_h2.anchors.topMargin - ring_li_labels_h2.anchors.topMargin - ring_background_h2.anchors.topMargin - 5)
                }
                anchors.top: parent.top
                width: parent.width
                height: ring_background_h2.getHeight()
                color: colorBackBackground
                radius: 10
                border.color: colorBackBorder
                border.width: borderWidth                
            }
            Row {
                id: ring_hover_h2
                anchors.top: ring_2.top
                anchors.topMargin: ring_background_h2.anchors.topMargin
                Repeater {
                    model: root_ring.model.count
                    anchors.top: parent.top
                    Item {
                        height: ring_background_h2.height + ring_li_marks_h2.height + ring_li_marks_h2.anchors.topMargin + ring_li_labels_h2.height
                        width: ring_background_h2.width / root_ring.model.count
                        state: (index == currentIndex) ? "checked" : "unchecked"
                        Rectangle {                            
                            radius: ellipticSelector ? ring_background_h2.height / 2 : 0
                            height: ring_background_h2.height
                            width: stepSize
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            border.width: 2
                            color: colorSelectorBackground
                            border.color: colorSelecterBorder
                            visible: (parent.state === "checked") ? true : false
                            Text {
                                text: textSelectorTitle
                                font.bold: true
                                color: colorSelecterBorder
                                font.pixelSize: 8
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea
                        {
                            id: mouseLayout
                            anchors.fill: parent
                            onClicked: indexChanged(index)
                        }
                    }
                }
            }
            Row {
                id: ring_li_marks_h2
                anchors.top: ring_background_h2.bottom
                anchors.topMargin: 2
                height: 4
                Repeater {
                    model: root_ring.model.count
                    Item {
                        width: root_ring.width / root_ring.model.count
                        height: ring_li_marks_h2.height
                        Rectangle {
                            height: parent.height;
                            width: 2;
                            anchors.centerIn: parent;
                            color: putColor(currentIndex, index)
                        }
                    }
                }
            }
            Row {
                id: ring_li_labels_h2
                function getHeight() {
                    if(fixedSelectorWidth > 0) {
                        return (ring_2.height - fixedSelectorWidth - ring_li_marks_h2.height - ring_li_marks_h2.anchors.topMargin - ring_background_h2.anchors.topMargin - ring_background_h2.anchors.bottomMargin - ring_li_labels_h2.anchors.topMargin)
                    }
                    return fontProvider.font.pixelSize * numLinesLabelsUse
                }
                anchors.top: ring_li_marks_h2.bottom
                anchors.topMargin: 2
                height: getHeight()
                Repeater {
                    model: root_ring.model.count
                    Text {
                        anchors.top: parent.top
                        width: stepSize
                        height: fontProvider.font.pixelSize*numLinesLabelsUse
                        text: root_ring.model.get(index).label
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignTop
                        color: putColor(currentIndex, index)
                        // проброс аттрибутов шрифта с fontProvider
                        font.bold: fontProvider.font.bold
                        font.capitalization: fontProvider.font.capitalization
                        font.family: fontProvider.font.family
                        font.hintingPreference: fontProvider.font.hintingPreference
                        font.italic: fontProvider.font.italic
                        font.letterSpacing: fontProvider.font.letterSpacing
                        font.overline: fontProvider.font.overline
                        font.strikeout: fontProvider.font.strikeout
                        font.styleName: fontProvider.font.styleName
                        font.underline: fontProvider.font.underline
                        font.weight: fontProvider.font.weight
                        font.wordSpacing: fontProvider.font.wordSpacing
                        font.pixelSize: fontProvider.font.pixelSize                        
                    }
                }
            }
        }
    }
    Component {
        id: ring_vertical_1
        Item {
            id: ring_3
            height: root_ring.height - ring_label_u.height - ringTypeLoader.anchors.topMargin
            width: root_ring.width
            Column {
                id: ring_li_labels_v1
                function getWidth() {
                    if(fixedSelectorWidth > 0) {
                        return (ring_3.width-fixedSelectorWidth-ring_li_marks_v1.width-ring_li_marks_v1.anchors.leftMargin-ring_li_marks_v1.anchors.rightMargin-ring_background_v1.anchors.leftMargin-ring_background_v1.anchors.rightMargin - ring_li_labels_v1.anchors.rightMargin)
                    }
                    return (ring_3.width - ring_li_marks_v1.anchors.leftMargin - ring_li_marks_v1.anchors.rightMargin - ring_background_v1.anchors.leftMargin - ring_li_labels_v1.anchors.rightMargin)*0.6;
                }
                anchors.top: ring_background_v1.top
                anchors.right: ring_li_marks_v1.left
                anchors.rightMargin: 2
                width: getWidth()
                Repeater {
                    model: root_ring.model.count
                    Text {
                        height: stepSize
                        width: parent.width
                        text: root_ring.model.get(index).label
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter                        
                        color: putColor(currentIndex, index)
                        // проброс аттрибутов шрифта с fontProvider
                        font.bold: fontProvider.font.bold
                        font.capitalization: fontProvider.font.capitalization
                        font.family: fontProvider.font.family
                        font.hintingPreference: fontProvider.font.hintingPreference
                        font.italic: fontProvider.font.italic
                        font.letterSpacing: fontProvider.font.letterSpacing
                        font.overline: fontProvider.font.overline
                        font.strikeout: fontProvider.font.strikeout
                        font.styleName: fontProvider.font.styleName
                        font.underline: fontProvider.font.underline
                        font.weight: fontProvider.font.weight
                        font.wordSpacing: fontProvider.font.wordSpacing
                        font.pixelSize: fontProvider.font.pixelSize
                    }
                }
            }
            Column {
                id: ring_li_marks_v1
                anchors.top: ring_background_v1.top
                anchors.right: ring_background_v1.left
                anchors.rightMargin: 2
                width: 4
                Repeater {
                    model: root_ring.model.count
                    Item {
                        width: ring_li_marks_v1.width
                        height: stepSize
                        Rectangle {
                            height: 2;
                            width: parent.width;
                            anchors.centerIn: parent;
                            color: putColor(currentIndex, index)
                        }
                    }
                }
            }
            Rectangle {
                id: ring_background_v1
                function getWidth() {
                    if(fixedSelectorWidth > 0) {
                        return fixedSelectorWidth;
                    }
                    return (parent.width - ring_li_marks_v1.anchors.leftMargin - ring_background_v1.anchors.leftMargin)*0.4;
                }
                anchors.top: parent.top
                anchors.right: parent.right
                width: getWidth()
                height: stepSize * root_ring.model.count
                color: colorBackBackground
                radius: width/2
                border.color: colorBackBorder
                border.width: borderWidth
            }
            Column {
                id: ring_hover
                anchors.top: ring_background_v1.top
                anchors.right: ring_background_v1.right
                Repeater {
                    model: root_ring.model.count
                    Item {
                        width: root_ring.width
                        height: stepSize
                        state: (index === currentIndex) ? "checked" : "unchecked"
                        Rectangle {                            
                            radius: ellipticSelector ? ring_background_v1.width / 2 : 0
                            height: stepSize
                            width: ring_background_v1.width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            border.width: 2
                            color: colorSelectorBackground
                            border.color: colorSelecterBorder
                            visible: (parent.state === "checked") ? true : false
                            Text {
                                text: textSelectorTitle
                                font.bold: true
                                color: colorSelecterBorder
                                font.pixelSize: 8
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea
                        {
                            id: mouseLayout
                            anchors.fill: parent
                            onClicked:{ indexChanged(index); }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: ring_vertical_2
        Item {
            id: ring_4
            height: root_ring.height - ring_label_u.height - ringTypeLoader.anchors.topMargin
            width: root_ring.width
            Rectangle {
                id: ring_background_v2
                function getWidth() {
                    if(fixedSelectorWidth > 0) {
                        return fixedSelectorWidth;
                    }
                    return (parent.width - ring_li_marks_v2.anchors.leftMargin - ring_background_v2.anchors.leftMargin)*0.4;
                }
                anchors.top: parent.top
                anchors.left: parent.left
                width: getWidth()
                height: stepSize * root_ring.model.count
                color: colorBackBackground
                radius: width/2
                border.color: colorBackBorder
                border.width: borderWidth
            }
            Column {
                id: ring_li_marks_v2
                anchors.top: ring_background_v2.top
                anchors.left: ring_background_v2.right
                anchors.leftMargin: 2
                width: 4
                Repeater {
                    model: root_ring.model.count
                    Item{
                        width: ring_li_marks_v2.width
                        height: stepSize
                        Rectangle {
                            height: 2;
                            width: parent.width;
                            anchors.centerIn: parent;
                            color: putColor(currentIndex, index)
                        }
                    }
                }
            }
            Column {
                id: ring_li_labels_v2
                function getWidth() {
                    if(fixedSelectorWidth > 0) {
                        return (ring_4.width-fixedSelectorWidth-ring_li_marks_v2.width-ring_li_marks_v2.anchors.leftMargin-ring_background_v2.anchors.leftMargin-ring_background_v2.anchors.rightMargin)
                    }
                    return (parent.width - ring_li_marks_v2.anchors.leftMargin - ring_background_v2.anchors.leftMargin)*0.6;
                }
                anchors.top: ring_background_v2.top
                anchors.left: ring_li_marks_v2.right
                anchors.leftMargin: 4
                width: getWidth()
                Repeater {
                    model: root_ring.model.count
                    Text {
                        height: stepSize
                        text: root_ring.model.get(index).label
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter                        
                        color: putColor(currentIndex, index)
                        // проброс аттрибутов шрифта с fontProvider
                        font.bold: fontProvider.font.bold
                        font.capitalization: fontProvider.font.capitalization
                        font.family: fontProvider.font.family
                        font.hintingPreference: fontProvider.font.hintingPreference
                        font.italic: fontProvider.font.italic
                        font.letterSpacing: fontProvider.font.letterSpacing
                        font.overline: fontProvider.font.overline
                        font.strikeout: fontProvider.font.strikeout
                        font.styleName: fontProvider.font.styleName
                        font.underline: fontProvider.font.underline
                        font.weight: fontProvider.font.weight
                        font.wordSpacing: fontProvider.font.wordSpacing
                        font.pixelSize: fontProvider.font.pixelSize
                    }
                }
            }
            Column {
                id: ring_hover_v2
                anchors.top: ring_background_v2.top
                anchors.left: parent.left
                Repeater {
                    model: root_ring.model.count
                    Item {
                        width: root_ring.width
                        height: stepSize
                        state: (index == currentIndex) ? "checked" : "unchecked"
                        Rectangle {                            
                            radius: ellipticSelector ? ring_background_v2.width / 2 : 0
                            height: stepSize
                            width: ring_background_v2.width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            border.width: 2
                            color: colorSelectorBackground
                            border.color: colorSelecterBorder
                            visible: (parent.state === "checked") ? true : false
                            Text {
                                text: textSelectorTitle
                                font.bold: true
                                color: colorSelecterBorder
                                font.pixelSize: 8
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea
                        {
                            id: mouseLayout
                            anchors.fill: parent
                            onClicked: indexChanged(index)
                        }
                    }
                }
            }
        }
    }
}
