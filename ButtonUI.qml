import QtQuick 2.1

Rectangle {
    id:rect
    property var btnText: "Text"
    property var btnColor: "RoyalBlue"
    property var btnTextColor: "Cyan"
    property var btnTextFamily: "微软雅黑"

    signal pointerClicked()
    width: 80
    height: 49
    radius: 5
    color: btnColor
    Text {
        id: txt
        width: rect.width
        anchors.centerIn: parent
        text: btnText
        font.family: btnTextFamily
        font.pixelSize: 25
        color: btnTextColor
        horizontalAlignment: Qt.AlignHCenter
    }
    MouseArea{
        anchors.fill: parent

        onClicked:
        {
            anim.start();
            pointerClicked();
        }
    }

    SequentialAnimation{
        id: anim
        NumberAnimation{
            target: rect
            easing.type: Easing.OutSine
            duration: 100
            property: "width"
            to: rect.width + 20
        }
        NumberAnimation{
            target: rect
            easing.type: Easing.OutSine
            duration: 100
            property: "width"
            to: rect.width
        }
    }
}

