import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.0
Window {
    id: window1
    visible: true
    width: 640
    height: 480
    title: qsTr("Dictator")
    property var count: 0


    Rectangle{
        id: rectControls
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        TextField{
            id: txtWord
            width: 269
            height: 101
            focus: false
            horizontalAlignment: Qt.AlignHCenter
            text: qsTr("请输入单词")
            anchors.right: parent.right
            anchors.rightMargin: 116
            anchors.top: parent.top
            anchors.topMargin: 7
            anchors.left: parent.left
            anchors.leftMargin: 6
            font.pixelSize: 25
            font.family: "微软雅黑"
            onFocusChanged: {
                if (txtWord.focus && txtWord.text == "请输入单词")
                {
                    txtWord.text = qsTr("");
                    txtWord.textColor = "black";
                    txtAnim.start();
                }
                else if (txtWord.text == "")
                {
                    txtWord.text = qsTr("请输入单词");
                    txtWord.textColor = "gray";
                }
            }
            style:TextFieldStyle{
                textColor: "gray"
                background: Rectangle{
                    radius: 5
                    color: "#F9F9F9"
                    border.color: "#C4CBD1"
                    border.width: 1
                    gradient: Gradient{
                        GradientStop { position: 0.0; color: "#D7D8DC" }
                        GradientStop { position: 0.17; color: "#F9F9F9" }
                    }
                }
            }
        }
        SequentialAnimation{
            id:txtAnim
            NumberAnimation {
                target: txtWord
                property: "scale"
                duration: 100
                to: 1.2
                easing.type: Easing.Linear
            }
            NumberAnimation {
                target: txtWord
                property: "scale"
                duration: 100
                to: 1
                easing.type: Easing.Linear
            }
        }

        TableView{
            id:tvWords
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 161
            anchors.top: parent.top
            anchors.topMargin: 114

            TableViewColumn{
                id: colWord
                role: "word"
                title: "单词"
                elideMode: Text.ElideRight
                horizontalAlignment: Qt.AlignCenter
            }
            TableViewColumn{
                id: colIsRead
                role: "isRead"
                title: "是否阅读"
                elideMode: Text.ElideRight
                horizontalAlignment: Qt.AlignCenter

            }


            model: ListModel{
                id:listWords
            }

            itemDelegate: Text {
                id:delText
                height: 35
                text: styleData.value
                font.family: "微软雅黑"
                font.pixelSize: 35
                horizontalAlignment: Qt.AlignHCenter

            }
            rowDelegate:Rectangle{
                color:styleData.selected ? "#B6EDEC" : (styleData.alternate ? "#925467" : "#6DAB98")
                height: 35
            }

            headerDelegate: Rectangle{
                implicitWidth: 60
                implicitHeight: 40
                border.width: 1
                border.color: "#3E5F8D"
                color: "#47A183"

                Text {
                    text: styleData.value
                    horizontalAlignment: Qt.AlignHCenter
                    anchors.centerIn: parent
                    width: parent.width
                    color:"white"
                    font.family: "微软雅黑"
                    font.pixelSize: 32
                }
            }
        }

        MediaPlayer{
            id:dictator
        }
        function sayWord(lan,word)
        {
            dictator.source = "http://fanyi.baidu.com/gettts?lan="+ lan +"&text="+ word +"&spd=2&source=web";
            dictator.play();
        }

        Timer{
            id:timDictator
            interval: 3000
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                if(count < tvWords.rowCount)
                {
                    var data = listWords.get(count);
                    if(data.isRead == "No")
                    {
                        dictator.source = "http://fanyi.baidu.com/gettts?lan=en&text="+ data.word +"&spd=2&source=web";
                        dictator.play();
                        listWords.setProperty(count,"isRead","Yes")
                        count++;
                    }
                }
                else
                {
                    count = 0;
                    dictator.source = "http://tts.baidu.com/text2audio?lan=en&pid=101&ie=UTF-8&text=Dictating Finished.&spd=2";
                    dictator.play();
                    timDictator.stop();
                }
            }
        }

        ButtonUI{
            id:btnAdd
            x: 531
            width: 106
            height: 101
            radius: 5
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 7
            btnText: "添加单词"
            btnColor: "#C97C2E"
            btnTextColor: "white"
            onPointerClicked:if(txtWord.text != "" && txtWord.text != "请输入单词")listWords.append({"word" : txtWord.text,"isRead" : "No"});
        }

Column {
    id: column1
    x: 4
    y: 114
    width: 632
    height: 366
    spacing: 0

    ButtonUI{
        id:btnStart
        width: 112
        height: 150
        radius: 0
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        btnText: "开始听写"
        btnColor: "#BD5A66"
        btnTextColor: "white"
        onPointerClicked: if (tvWords.rowCount > 0 && !timDictator.running) timDictator.start();
    }

    ButtonUI{
        id:btnDelete
        width: 60
        height: 150
        radius: 0
        anchors.left: parent.left
        anchors.leftMargin: 116
        anchors.right: parent.right
        anchors.rightMargin: 116
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        btnText: "删除单词"
        btnColor: "#5F8D79"
        btnTextColor: "white"
        onPointerClicked: if(tvWords.currentRow > -1)listWords.remove(tvWords.currentRow);
    }

ButtonUI{
            id:btnStop
            width: 112
            height: 150
            radius: 0
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            btnText: "停止听写"
            btnColor: "#414A93"
            btnTextColor: "white"
            onPointerClicked: timDictator.stop();
        }


}

    }

}
