/*
* Name: Taylor Caldwell
* Project Name: QtMetronome
*/

import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtMultimedia 5.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

//Splishy Splashy Screen
ApplicationWindow
{
    id: splash
    height: 600
    width: 700
    title: "Qt Metronome"

    Rectangle
    {
        id: root
        anchors.fill: parent

        Image
        {
            id: background
            source: "qrc://pics/Splash.jpg"
            anchors.fill: parent
        }

        Button
        {
            id: startButton
            text: "Start!"
            anchors.centerIn: background
            anchors.bottomMargin: 50
            height: 50
            width: 100

            onClicked:
            {
                splash.hide()
                introSong.stop()
                windowMain.show()
            }

            style: ButtonStyle
            {
            label: Text
            {
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "AR ESSENCE"
            font.pointSize: 18
            color: "#730e0e"
            text: control.text
        }
    }
}

Button
{
    id: aboutButton
    height:50
    width:100
    anchors.top: startButton.bottom
    anchors.horizontalCenter: startButton.horizontalCenter
    anchors.topMargin: 20
    text: "About"

    onClicked:
    {
        aboutWindow.show()
    }

    style: ButtonStyle
    {
    label: Text
    {
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: "AR ESSENCE"
    font.pointSize: 18
    color: "#730e0e"
    text: control.text
}
}
}

Text
{
    id: titleText
    font.family: "AR DECODE"
    text:"Qt Metronome"
    font.pointSize: 80
    color: "#e8d32e"
    anchors.horizontalCenter: root.horizontalCenter

}

Text
{
    id:musicLabel
    text: "    Music"
    font.family: "AR ESSENCE"
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 15
    color: "#ecf150"
}

Button
{
    id: musicToggle
    height: 25
    width: 30
    text: "On"
    style: ButtonStyle
    {
        label: Text
        {
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "AR ESSENCE"
            font.pointSize: 12
            color: "#730e0e"
            text: control.text
        }
    }
    onClicked:
    {
        if(musicToggle.text == "On")
        {
            musicToggle.text = "Off"
            introSong.pause()
        }
        else if(musicToggle.text == "Off")
        {
            musicToggle.text = "On"
            introSong.play()
        }
    }
}

Audio
{
    id: introSong
    source:"qrc://sounds/MountainKing.mp3"
    autoPlay: true
    autoLoad: true
}
}

ApplicationWindow
{
    id: aboutWindow
    title: "About Qt Metronome"
    visible:false
    height: 450
    width: 700

    Rectangle
    {
        id:aboutRect
        anchors.fill: parent
        border.color: "black"
        Image
        {
            id: aboutPageBackground
            source: "qrc://pics/PaperBackground.jpg"
            anchors.fill: parent
        }

        Image
        {
            id: tempos
            fillMode: Image.PreserveAspectCrop
            source: "qrc://pics/tempos.jpg"
            width: 250
            height:275
            anchors.top:line3.bottom
            anchors.horizontalCenter: line3.horizontalCenter
            anchors.topMargin: 30
        }

        Text{id: line1; anchors.top: aboutRect.top; anchors.horizontalCenter: aboutRect.horizontalCenter; anchors.topMargin: 50;
            text: "Welcome to the Qt Metronome! This is a tool that will help"; font.family: "Palatino Linotype"; font.bold: true; color: "white"; font.pointSize: 16; }
        Text{id: line2; anchors.top: line1.bottom; anchors.horizontalCenter:line1.Center; font.family: "Palatino Linotype";
            text: "                      you increase your skill with any instrument. By practicing"; color: "white"; font.pointSize: 14; font.bold: true;}
        Text{id: line3; anchors.top: line2.bottom; anchors.horizontalCenter: line2.Center; font.family: "Palatino Linotype";
            text: "                      with a tempo you can learn how to play accurately and fast!"; color: "white"; font.pointSize: 14; font.bold: true;}

    }
}


// VARIABLES
property int count: 1
property double millis: 0
property double lastMillis: 0
property int i: 1
property double taps: 0
property double lastTap: 0
property color shapeColor: "green"

// SETTINGS
property string timeSign //time signature string
property int timeSignCount //number of clicks per beat
property int timeSignIndex //index of the time signature OptionSelector
property int accentSound //index of the accent OptionSelector
property int clickSound //index of the click OptionSelector
property int bpm: 1 //beats per minute
property int accentOn //state of the switchAccent
property int flashOn //animation on/off
property double accentVolume //volume of the accent sound
property double clickVolume //volume of the click sound

// DATABASE
property var db: null

function openDB()
{
    if(db !== null) return;

    db = LocalStorage.openDatabaseSync("Quicktronome", "0.1", "Quicktronome settings", 100000); //DNC

    try
    {
        db.transaction(function(tx)
        {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
            var table  = tx.executeSql("SELECT * FROM settings");
            // seed the table with default values
            if (table.rows.length === 0) {
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["timeSign", "4/4"]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["timeSignCount", 4]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["timeSignIndex", 2]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["accentSound", 0]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["clickSound", 0]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["bpm", 120]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["accentOn", 1]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["flashOn", 1]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["width", 70]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["heigth", 60]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["accentVolume", 1]);
                tx.executeSql('INSERT INTO settings VALUES(?, ?)', ["clickVolume", 0.8]);
                console.log('Settings table added');
            };
        });
    } catch (err)
    {
        console.log("Error creating table in database: " + err);
    };
}


function saveSetting(key, value)
{
    openDB();
    db.transaction( function(tx)
    {
        tx.executeSql('INSERT OR REPLACE INTO settings VALUES(?, ?)', [key, value]);
    });
}

function getSetting(key)
{
    openDB();
    var res = "";
    db.transaction(function(tx)
    {
        var rs = tx.executeSql('SELECT value FROM settings WHERE key=?;', [key]);
        res = rs.rows.item(0).value;
    });
    return res;
}

// on startup
Component.onCompleted:
{
    timeSign = getSetting("timeSign")
    timeSignCount = getSetting("timeSignCount")
    timeSignIndex = getSetting("timeSignIndex")
    accentSound = getSetting("accentSound")
    clickSound = getSetting("clickSound")
    bpm = getSetting("bpm")
    accentOn = getSetting("accentOn")
    flashOn = getSetting("flashOn")
    width = getSetting("width")
    height = getSetting("height")
    accentVolume = getSetting("accentVolume")
    clickVolume = getSetting("clickVolume")

}

// on closed
Component.onDestruction:
{
    saveSetting("timeSign", timeSign)
    saveSetting("timeSignCount", timeSignCount)
    saveSetting("timeSignIndex", timeSignIndex)
    saveSetting("accentSound", accentSound)
    saveSetting("clickSound", clickSound)
    saveSetting("bpm", bpm)
    saveSetting("accentOn", accentOn)
    saveSetting("flashOn", flashOn)
    saveSetting("width", width)
    saveSetting("height", height)
    saveSetting("accentVolume", accentVolume)
    saveSetting("clickVolume", clickVolume)
}



// FUNCTIONS
function playClick(sound)
{
    switch (sound)
    {
    case 0:
        woodBlock.play()
        break;
    case 1:
        smallWood.play()
        break;
    case 2:
        highTing.play()
        break;
    case 3:
        lightBeep.play() //classics 0-3
        break;
    case 4:
        bongo.play()
        break;
    case 5:
        smallTom.play()
        break;
    case 6:
        lightCowbell.play()
        break;
    case 7:
        electricTom.play() //drums 4-7
        break;
    case 8:
        safariBongo.play()
        break;
    case 9:
        lowBongo.play()
        break;
    case 10:
        tambo.play()
        break;
    case 11:
        cowbellClassic.play() //exotic 8-11
        break;
    case 12:
        laserKick.play()
        break;
    case 13:
        laserCan.play()
        break;
    case 14:
        evilFrog.play()
        break;
    case 15:
        alienBeep.play() //ET sounds 12-15
        break;
    }
}

function playAccent(sound)
{
    switch (sound)
    {
    case 0:
        accentSine.play()
        break;
    case 1:
        accentPluck.play()
        break;
    case 2:
        accentBass.play()
        break;
    }
}

function italian(tempo)
{
    if (tempo < 40) return "Larghissimo"
    else if (tempo >= 40 && tempo < 60) return "Largo"
    else if (tempo >= 60 && tempo < 66) return "Larghetto"
    else if (tempo >= 66 && tempo < 76) return "Adagio"
    else if (tempo >= 76 && tempo < 108) return "Adante"
    else if (tempo >= 108 && tempo < 120) return "Modernato"
    else if (tempo >= 120 && tempo < 168) return "Allegro"
    else if (tempo >= 168 && tempo < 208) return "Presto"
    else if (tempo >= 208) return "Prestissimo"
}

ApplicationWindow
{
    id: windowMain
    title: "QtMetronome"
    minimumWidth: 600
    minimumHeight: 400
    maximumHeight: 400
    maximumWidth: 600
    width: 600
    height: 400
    visible:false

    //classic
    SoundEffect
    {
        id: woodBlock
        source: "qrc:/Sounds/WoodBlock.wav"
        volume: clickVolume
    }

    SoundEffect
    {
        id: smallWood
        source: "qrc:/Sounds/SmallWoodKnock.wav"
        volume: accentVolume
    }

    SoundEffect
    {
        id: highTing
        source: "qrc:/Sounds/HighTing.wav"
        volume: clickVolume
    }

    SoundEffect
    {
        id: lightBeep
        source: "qrc:/Sounds/LightBeep.wav"
        volume: accentVolume
    }
    //classic sounds done

    //drums
    SoundEffect
    {
        id: bongo
        source: "qrc:/Sounds/Bongo.wav"
        volume: clickVolume
    }

    SoundEffect
    {
        id: smallTom
        source: "qrc:/Sounds/SmallTom.wav"
        volume: accentVolume
    }

    SoundEffect
    {
        id: lightCowbell
        source: "qrc:/Sounds/LightCowbell.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id:electricTom
        source: "qrc:/Sounds/ElectricTom.wav"
        volume:accentVolume
    }

    //drums done

    //Exotic
    SoundEffect
    {
        id: safariBongo
        source: "qrc:/Sounds/SafariBongo.wav"
        volume:accentVolume
    }

    SoundEffect
    {
        id: lowBongo
        source: "qrc:/Sounds/LowBongo.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id: tambo
        source: "qrc:/Sounds/Tambo.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id: cowbellClassic
        source: "qrc:/Sounds/ClassicCowbell.wav"
        volume:accentVolume
    }
    //exotics done

    //Extraterrestrial sounds
    SoundEffect
    {
        id: laserKick
        source: "qrc:/Sounds/LaserKick.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id: laserCan
        source: "qrc:/Sounds/LaserCan.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id: evilFrog
        source: "qrc:/Sounds/Evil Frog.wav"
        volume:accentVolume
    }
    SoundEffect
    {
        id: alienBeep
        source: "qrc:/Sounds/AlienBeep.wav"
        volume:accentVolume
    }
    //E.T. sounds done

    //decides when to play sound effects
    //really the entire program resides here
    Timer
    {
        id: timer
        interval: 60000/bpm
        running: false
        repeat: true
        triggeredOnStart: true

        onTriggered:
        {
            shapeColor = "red"
            playClick(clickSound)

            if (flashOn) flash.start()
            else shape.color = shapeColor
        }
    }

    Rectangle
    {
        id:bigWrapper
        color: "#64a5e2"
        border.color: "black"
        gradient: Gradient
        {
            GradientStop
            {
                position: 0.00;
                color: "#64a5e2";
            }
            GradientStop
            {
                position: 1.00;
                color: "#ffffff";
            }
        }
        anchors.fill: parent

        Button
        {
            id: buttonStart
            width: 400
            action: actionStart
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Component.onCompleted:
            {
                height *= 1.2
            }

            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "AR CENA"
                    font.pointSize: 15
                    color: "#1032ad"
                    text: control.text
                }
            }

        }

        //starts the metronome.
        Action
        {
            id: actionStart
            text: "Start"
            shortcut: "space"
            tooltip: "Start/stop the metronome\nShortcut: Space"

            onTriggered:
            {
                bpm = slider.value
                if (timer.running)
                {
                    text = "Start"
                    timer.stop()
                    count = 1
                }
                else
                {
                    text = "Stop"
                    timer.start()
                }
            }
        }

        //handles the slider to change bpm
        Slider
        {
            id: slider
            width: parent.width
            minimumValue: 30
            maximumValue: 300
            value: bpm
            anchors.bottom: buttonStart.top
            anchors.bottomMargin: 10
            onValueChanged: splash.bpm = value
        }

        Button
        {
            id: increaseSpeed
            text: "-"
            width: bpmDisplaybox.width/2 -5
            anchors.top:bpmDisplaybox.bottom
            anchors.topMargin: 5
            anchors.left: bpmDisplaybox.left

            onClicked:
            {
                slider.value--
            }

            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "AR CENA"
                    font.pointSize: 17
                    color: "#1032ad"
                    text: control.text
                }
            }
        }

        Button
        {
            id: decreaseSpeed
            text: "+"
            width: bpmDisplaybox.width/2
            anchors.left: increaseSpeed.right
            anchors.leftMargin: 5
            anchors.top: bpmDisplaybox.bottom
            anchors.topMargin:  5
            onClicked:
            {
                slider.value++
            }

            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "AR CENA"
                    font.pointSize: 17
                    color: "#1032ad"
                    text: control.text
                }
            }
        }

        Label
        {
            id: tips
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Tips n' Tricks"
            font.family: "AR CENA"
            font.bold: true
            font.underline: true
            font.pointSize: 13
        }

        Label
        {
            id: settings
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tips.bottom
            font.family: "AR CENA"
            font.pointSize: 12
            text: " -Your last used settings are automatically saved once you end the program."
        }

        Label
        {
            id: shorty
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: settings.bottom
            font.family: "AR CENA"
            font.pointSize: 12
            text: " -You can use the space bar to quickly start and stop the metronome."
        }

        Label
        {
            id: startSlow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: shorty.bottom
            font.family: "AR CENA"
            font.pointSize: 12
            text: " -Use the Tap Tempo button to set your own custom pace by clicking."
        }

        Label
        {
            id:drumLoop
            font.family: "AR CENA"
            font.pointSize: 12
            anchors.right: startDrumLoop.left
            anchors.verticalCenter: startDrumLoop.verticalCenter
            anchors.rightMargin: 5
            text: "5 minute Drum loop at 120bpm --->"
        }

        Audio
        {
            id: drumsloop
            source:"qrc://sounds/DrumLoop.mp3"
            autoPlay: false
            autoLoad: true
        }

        Button
        {
            id:startDrumLoop
            text: "Start Drums"
            x: 420
            y: 275

            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "AR CENA"
                    font.pointSize: 15
                    color: "#1032ad"
                    text: control.text
                }
            }

            onClicked:
            {
                //start the loop audio file
                if(startDrumLoop.text == "Start Drums")
                {
                    drumsloop.play()
                    startDrumLoop.text = "Stop Drums"
                }
                else
                {
                    drumsloop.stop()
                    startDrumLoop.text = "Start Drums"
                }
            }
        }

        Rectangle
        {
            id: shape
            color: "#303030"
            width: 20
            height: 20
            radius: 10
            border.color: shapeColor
            border.width: 1

            anchors.left: bpmDisplaybox.right
            anchors.leftMargin: 7
            anchors.top:bpmDisplaybox.top

            SequentialAnimation on color
            {
                id: flash
                running: false

                ColorAnimation { from: "#303030"; to: shapeColor; duration: 0 }
                ColorAnimation { from: shapeColor; to: "#303030"; duration: 60000/bpm*0.6 }

            }
        }

        Label
        {
            id: labelTempo
            width: bpmDisplaybox.width
            anchors.topMargin: 15
            anchors.top:increaseSpeed.bottom
            anchors.left: increaseSpeed.left
            text: "Tempo: " + slider.value.toFixed() + " BPM (" + italian(slider.value.toFixed()) + ")"
            font.family: "AR CENA"
            font.pointSize: 15
        }

        Rectangle
        {
            id: bpmDisplaybox
            height: 80
            width: 150
            color: "#999595"
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10

            gradient: Gradient
            {
                GradientStop
                {
                    position: 0.00;
                    color: "#d5cbcb";
                }
                GradientStop
                {
                    position: 1.00;
                    color: "#ffffff";
                }
            }
            border.color: "black"
            border.width: 2

            Text
            {
                text: slider.value.toFixed()
                font.family: "AR CENA"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 50
                anchors.fill: parent
            }
        }

        Action
        {
            id: actionMinus
            text: "+"
            shortcut: "q"
            tooltip: "Tempo + 1\nShortcut: Q"

            onTriggered: slider.value++
        }

        Action
        {
            id: actionPlus
            text: "-"
            shortcut: "w"
            tooltip: "Tempo - 1\nShortcut: W"

            onTriggered: slider.value--
        }
        Button
        {
            id: buttonTap
            width: bpmDisplaybox.width
            action: actionTap
            anchors.bottom:bpmDisplaybox.top
            anchors.bottomMargin: 5
            anchors.left: bpmDisplaybox.left


            style: ButtonStyle
            {
                label: Text
                {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "AR CENA"
                    font.pointSize: 15
                    color: "#1032ad"
                    text: control.text
                }
            }
        }

        //handles the logic for Tap feature
        Action
        {
            id: actionTap
            text: "Tap Tempo"
            shortcut: "t"
            tooltip: "Tap tempo\nShortcut: T"

            onTriggered:
            {

                //calculates average tap tempo
                var date = new Date()

                if (lastTap != 0)
                {
                    millis = date.getTime() - lastTap
                    lastTap = date.getTime()

                    // if the difference between taps is greater than 1/5, reset
                    if (lastMillis != 0 && Math.abs(lastMillis-millis) > lastMillis/5)
                    {
                        i = 1
                        taps = lastTap = millis = lastMillis = 0
                        return
                    }

                    lastMillis = millis

                    taps += (60000/millis)

                    // set tempo to the average of the taps
                    slider.value = (taps/i > 300) ? 300 : taps/i
                    i++
                }
                else
                {
                    lastTap = date.getTime()
                }
            }
        }

        GroupBox
        {
            title: "Classic Sounds"
            id: classics
            height: 100
            width:90
            anchors.leftMargin: 20
            anchors.left: shape.right
            anchors.top: shape.top

            Column
            {
                //anchors.fill: parent
                spacing: 5

                ExclusiveGroup { id: gClick }

                RadioButton
                {
                    text: "Wood Block"
                    exclusiveGroup: gClick
                    checked: (clickSound == 0) ? true : false

                    onCheckedChanged: if (checked) clickSound = 0
                }

                RadioButton
                {
                    text: "Small Knock"
                    exclusiveGroup: gClick
                    checked: (clickSound == 1) ? true : false

                    onCheckedChanged: if (checked) clickSound = 1
                }

                RadioButton
                {
                    text: "High Ting"
                    exclusiveGroup: gClick
                    checked: (clickSound == 2) ? true : false

                    onCheckedChanged: if (checked) clickSound = 2
                }
                RadioButton
                {
                    text: "Light Beep"
                    exclusiveGroup: gClick
                    checked: (clickSound == 3) ? true : false

                    onCheckedChanged: if (checked) clickSound = 3
                }

            }

            GroupBox
            {
                title: "Drum Sounds"
                id: drums
                height: 100
                width:90
                x: 90
                y: -15

                Column
                {
                    //anchors.fill: parent
                    spacing: 5

                    ExclusiveGroup { id: dG}

                    RadioButton
                    {
                        text: "Bongo"
                        exclusiveGroup: dG
                        checked: (clickSound == 4) ? true : false

                        onCheckedChanged: if (checked) clickSound = 4
                    }

                    RadioButton
                    {
                        text: "Small Tom"
                        exclusiveGroup: dG
                        checked: (clickSound == 5) ? true : false

                        onCheckedChanged: if (checked) clickSound = 5
                    }

                    RadioButton
                    {
                        text: "Light Cowbell"
                        exclusiveGroup: dG
                        checked: (clickSound == 6) ? true : false

                        onCheckedChanged: if (checked) clickSound = 6
                    }
                    RadioButton
                    {
                        text: "Electric Tom"
                        exclusiveGroup: dG
                        checked: (clickSound == 7) ? true : false

                        onCheckedChanged: if (checked) clickSound = 7
                    }

                }
                GroupBox
                {
                    title: "Exotic Sounds"
                    id: exotic
                    height: 100
                    width:90
                    x: 90
                    y: -15

                    Column
                    {
                        spacing: 5

                        ExclusiveGroup { id: eG}

                        RadioButton
                        {
                            text: "Safari Bongo"
                            exclusiveGroup: eG
                            checked: (clickSound == 8) ? true : false

                            onCheckedChanged: if (checked) clickSound = 8
                        }

                        RadioButton
                        {
                            text: "Low Bongo"
                            exclusiveGroup: eG
                            checked: (clickSound == 9) ? true : false

                            onCheckedChanged: if (checked) clickSound = 9
                        }

                        RadioButton
                        {
                            text: "Tambourine"
                            exclusiveGroup: eG
                            checked: (clickSound == 10) ? true : false

                            onCheckedChanged: if (checked) clickSound = 10
                        }
                        RadioButton
                        {
                            text: "Full Cowbell"
                            exclusiveGroup: eG
                            checked: (clickSound == 11) ? true : false

                            onCheckedChanged: if (checked) clickSound = 11
                        }

                    }

                }

                GroupBox
                {
                    title: "Alien Sounds"
                    id: alien
                    height: 100
                    width:90
                    x: 187
                    y: -15

                    Column
                    {
                        spacing: 5

                        ExclusiveGroup { id: aG}

                        RadioButton
                        {
                            text: "Laser Kick"
                            exclusiveGroup: aG
                            checked: (clickSound == 12) ? true : false

                            onCheckedChanged: if (checked) clickSound = 12
                        }

                        RadioButton
                        {
                            text: "Laser Can"
                            exclusiveGroup: aG
                            checked: (clickSound == 13) ? true : false

                            onCheckedChanged: if (checked) clickSound = 13
                        }

                        RadioButton
                        {
                            text: "Evil Frog"
                            exclusiveGroup: aG
                            checked: (clickSound == 14) ? true : false

                            onCheckedChanged: if (checked) clickSound = 14
                        }
                        RadioButton
                        {
                            text: "Alien Beep"
                            exclusiveGroup: aG
                            checked: (clickSound == 15) ? true : false

                            onCheckedChanged: if (checked) clickSound = 15
                        }

                    }

                }

            }
        }
    }
}
}
