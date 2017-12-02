import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id:mainwin
    property string wincolor: "black"
    property string gaugeglow: "white"
    visible: true
    width: 1920
    height: 810
    onAfterRendering: Work.start();
    color: mainwin.wincolor

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#a8a8a8"

        Rectangle{
            id: rpmrect
            color: "transparent"
            height: 550
            width: 550
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            RectangularGlow {
                id: reffect
                anchors.fill: rpm
                glowRadius: 0
                spread: 0
                cornerRadius: 500
                color: mainwin.gaugeglow
            }

            Rectangle{
                id:rpmblurr
                height: rpm.height -32
                width: rpm.width -32
                anchors.centerIn: rpm
                anchors.horizontalCenterOffset: 5
                anchors.verticalCenterOffset: 1
                color: mainwin.wincolor
                radius: 360
                opacity: .05
                FastBlur{
                    anchors.fill: parent
                    source: rpm
                    radius: 64
                }
            }

            Image {
                id: rpmneedle
                property double angle: -36
                source: "qrc:/gauges/needle.png"
                anchors.verticalCenterOffset: 128.75
                anchors.horizontalCenterOffset: 4
                anchors.centerIn: rpm
                transform: Rotation { origin.x: 5; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: rpmneedle.angle;
                    Behavior on angle { SpringAnimation { spring: 5; damping: 0.4 ; modulus: 360 }}} //324
                smooth: true

                DropShadow {
                    anchors.fill: rpmneedle
                    horizontalOffset: 25
                    verticalOffset: -3
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: rpmneedle
                    spread: 0
                }
            }

            Image{
                id: fuelpneedle
                property int angle: 90
                source: "qrc:/gauges/fueltempneedle.png"
                anchors.verticalCenterOffset: 80
                anchors.horizontalCenterOffset: 5
                anchors.centerIn: rpm
                transform: Rotation { origin.x: 5; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: fuelpneedle.angle;
                    Behavior on angle { SpringAnimation { spring: 5; damping: 0.4 ; modulus: 360 }}}
            }

            Image{
                id: tempneedle
                property int angle: 270
                source: "qrc:/gauges/fueltempneedle.png"
                anchors.verticalCenterOffset: 80
                anchors.horizontalCenterOffset: 5
                anchors.centerIn: rpm
                transform: Rotation { origin.x: 5; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: tempneedle.angle;
                    Behavior on angle { SpringAnimation { spring: 5; damping: 0.4 ; modulus: 360 }}}
            }
            Image{
                id: rpm
                source: "qrc:/gauges/RPMGauge.png"
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Text {
                    id: txtgear
                    text: ""
                    font.pointSize: 70
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 5
                    color: "#0059ff"
                }
            }
        }

        Rectangle{
            id: mphrect
            color: "transparent"
            anchors.right: background.right
            anchors.bottom: background.bottom
            anchors.bottomMargin: 10
            anchors.rightMargin: 25
            height: 550
            width: 550

            RectangularGlow {
                id: meffect
                anchors.fill: mphrect
                glowRadius: 0
                spread: 0
                cornerRadius: 360
                color: mainwin.gaugeglow
            }

            Rectangle{
                id:mphblurr
                height: mph.height -34
                width: mph.width -34
                anchors.centerIn: mph
                anchors.horizontalCenterOffset: 12
                anchors.verticalCenterOffset: 10
                color: mainwin.wincolor
                radius: 360
                opacity: .05
                FastBlur{
                    anchors.fill: parent
                    source: mph
                    radius: 64
                }
            }

            Image {
                id: mphneedle
                property double angle: 36
                anchors.verticalCenterOffset: 137.75
                anchors.horizontalCenterOffset: 13
                source: "qrc:/gauges/needle.png"
                anchors.centerIn: mph
                transform: Rotation { origin.x: 5; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: mphneedle.angle;
                    Behavior on angle { SpringAnimation { spring: 5; damping: 0.4 ; modulus: 360 }}}
                smooth: true

                DropShadow {
                    anchors.fill: mphneedle
                    horizontalOffset: -25
                    verticalOffset: -3
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: mphneedle
                    spread: 0
                }
            }

            Image{
                id: mph
                source: "qrc:/gauges/MPHGauge.png"
                anchors.centerIn: mphrect

                Text{
                    id: liveMPH
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 10
                    font.pointSize: 70
                    color: "#0059ff"
                    text: "0"
                    font.family: "Calibri"
                }

                Image{
                    visible: false
                    id: checkengine
                    source: "qrc:/gauges/checkengine.png"
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 110
                    anchors.horizontalCenterOffset: 8
                    Text{
                        id: troubleCode
                        font.pointSize: 5
                        font.bold: true
                        color: "gold"
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 2
                    }
                }

                Image {
                    id: skull
                    source: "qrc:/gauges/skull.png"
                    anchors.centerIn: parent
                    height: 300
                    width: 300
                    opacity: 0
                    anchors.verticalCenterOffset: 10
                    anchors.horizontalCenterOffset: 10
                    ColorOverlay{
                        anchors.fill: parent
                        source: parent
                        color: "transparent"
                    }
                }
            }
        }
    }

    Connections{
        target: Work
        onObdRPM: {rpmneedle.angle = rpm * 0.036 - 36;
            skull.opacity = ((rpm * .1) -450) * .01;
            liveMPH.opacity = 1 - (skull.opacity)
        }

        onObdMPH: {liveMPH.text = (speed - .9).toFixed(0);
            mphneedle.angle = (((speed - .9) * -1.8) + 36).toFixed(0)
        }

        onObdFuelStatus: {fuelpneedle.angle = ((fuel - 3) * 1.6) + 100}
        onObdCoolantTemp: {tempneedle.angle = ((coolantTemp * -1) * .57) + 80;
        }
        onObdTroubleCode: {troubleCode.text = troublecode;
            checkengine.visible = true
        }
        onGear: txtgear.text = gear
    }
}
