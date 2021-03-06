import QtQuick 2.0
import Sailfish.Silica 1.0
import "helper/db.js" as DB

Dialog {
    id: settingsPage

    allowedOrientations: Orientation.All

    acceptDestinationAction: PageStackAction.Pop

    property string uAgentTitle : mainWindow.userAgentName
    property string uAgent: mainWindow.userAgent
    property string searchEngineTitle: mainWindow.searchEngineName
    property string searchEngineUri: mainWindow.searchEngine


    // Easy fix only for when http:// or https:// is missing
    function fixUrl(nonFixedUrl) {
        var valid = nonFixedUrl
        if (valid.indexOf(":")<0) {
                return "http://"+valid;
        } else return valid
    }

    function loadDefaults() {
        hp.text = "about:bookmarks";
        minimumFontCombo.currentIndex = 34 - 16;
        defaultFontCombo.currentIndex = 34 - 20;
        defaultFixedFontCombo.currentIndex = 34 - 18;
        loadImagesSwitch.checked = true;
        privateBrowsingSwitch.checked = false;
        dnsPrefetchSwitch.checked = true;
        agentString.text = "Mozilla/5.0 (Maemo; Linux; Jolla; Sailfish; Mobile) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13"
        offlineWebApplicationCacheSwitch.checked = true;
        searchEngine.text = "http://www.google.com/search?q=%s"
        searchEngineCombo.value = "Google"
    }

    function saveSettings() {
        hp.text = fixUrl(hp.text);
        DB.addSetting("homepage", hp.text);
        DB.addSetting("minimumFontSize", minimumFontCombo.value.toString());
        DB.addSetting("defaultFontSize", defaultFontCombo.value.toString());
        DB.addSetting("defaultFixedFontSize", defaultFixedFontCombo.value.toString());
        DB.addSetting("loadImages", loadImagesSwitch.checked.toString());
        DB.addSetting("privateBrowsing", privateBrowsingSwitch.checked.toString());
        DB.addSetting("dnsPrefetch", dnsPrefetchSwitch.checked.toString());
        DB.addSetting("userAgent", agentString.text);
        DB.addSetting("offlineWebApplicationCache", offlineWebApplicationCacheSwitch.checked.toString());
        DB.addSetting("userAgentName", userAgentCombo.value);
        DB.addSetting("searchEngine", searchEngine.text);
        DB.addSetting("searchEngineName", searchEngineCombo.value)
        DB.getSettings();
    }

    // TODO : Maybe it can be made as convenient as AddBookmark !?
    function enterPress() {
        if (hp.focus == true) { hp.text = fixUrl(hp.text);hp.focus = false; }
        else if (searchEngine.focus == true) { searchEngine.text = fixUrl(searchEngine.text); searchEngine.focus = false; }
    }

    function clearCache() {
        remorse.execute(qsTr("Clear cache"), function() { mainWindow.clearCache(); } )
    }

    function clearCookies() {
        remorse.execute(qsTr("Clear Cookies and restart"), function() { mainWindow.clearCookies(); } )
    }

    function clearHistory() {
        remorse.execute(qsTr("Clear History"), function() { DB.clearTable("history"); } )
    }


    onAccepted: saveSettings();

    Keys.onReturnPressed: enterPress();
    Keys.onEnterPressed: enterPress();

    RemorsePopup { id: remorse }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height + head.height

        DialogHeader {
            id: head
            acceptText: qsTr("Save Settings")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Add default bookmarks")
                onClicked: mainWindow.addDefaultBookmarks();
            }
            MenuItem {
                text: qsTr("Clear Cache")
                onClicked: clearCache();
            }
            MenuItem {
                text: qsTr("Clear Cookies")
                onClicked: clearCookies();
            }
            MenuItem {
                text: qsTr("Clear History")
                onClicked: clearHistory();
            }
            MenuItem {
                text: qsTr("Load Defaults")
                onClicked: loadDefaults();
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Goto top")
                onClicked: flick.scrollToTop();
            }
        }

        Column {
            id: col
            width: parent.width
            anchors.top: head.bottom
            spacing: 15

            SectionHeader {
                text: qsTr("Appearance")
            }
            ComboBox {
                id: defaultFontCombo
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Default Font Size")
                currentIndex: 34 - parseInt(mainWindow.defaultFontSize)
                menu: ContextMenu {
                    MenuItem { text: "34"}
                    MenuItem { text: "33"}
                    MenuItem { text: "32"}
                    MenuItem { text: "31"}
                    MenuItem { text: "30"}
                    MenuItem { text: "29"}
                    MenuItem { text: "28"}
                    MenuItem { text: "27"}
                    MenuItem { text: "26"}
                    MenuItem { text: "25"}
                    MenuItem { text: "24"}
                    MenuItem { text: "23"}
                    MenuItem { text: "22"}
                    MenuItem { text: "21"}
                    MenuItem { text: "20"}
                    MenuItem { text: "19"}
                    MenuItem { text: "18"}
                    MenuItem { text: "17"}
                    MenuItem { text: "16"}
                    MenuItem { text: "15"}
                    MenuItem { text: "14"}
                    MenuItem { text: "13"}
                    MenuItem { text: "12"}
                    MenuItem { text: "11"}
                    MenuItem { text: "10"}
                    MenuItem { text: "9" }
                }
            }
            ComboBox {
                id: defaultFixedFontCombo
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Default Fixed Font Size")
                currentIndex: 34 - parseInt(mainWindow.defaultFixedFontSize)
                menu: ContextMenu {
                    MenuItem { text: "34" }
                    MenuItem { text: "33" }
                    MenuItem { text: "32" }
                    MenuItem { text: "31" }
                    MenuItem { text: "30" }
                    MenuItem { text: "29" }
                    MenuItem { text: "28" }
                    MenuItem { text: "27" }
                    MenuItem { text: "26" }
                    MenuItem { text: "25" }
                    MenuItem { text: "24" }
                    MenuItem { text: "23" }
                    MenuItem { text: "22" }
                    MenuItem { text: "21" }
                    MenuItem { text: "20" }
                    MenuItem { text: "19" }
                    MenuItem { text: "18" }
                    MenuItem { text: "17" }
                    MenuItem { text: "16" }
                    MenuItem { text: "15" }
                    MenuItem { text: "14" }
                    MenuItem { text: "13" }
                    MenuItem { text: "12" }
                    MenuItem { text: "11" }
                    MenuItem { text: "10" }
                    MenuItem { text: "9" }
                }
            }
            ComboBox {
                id: minimumFontCombo
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Minimum Font Size")
                currentIndex: 34 - parseInt(mainWindow.minimumFontSize)
                menu: ContextMenu {
                    MenuItem { text: "34" }
                    MenuItem { text: "33" }
                    MenuItem { text: "32" }
                    MenuItem { text: "31" }
                    MenuItem { text: "30" }
                    MenuItem { text: "29" }
                    MenuItem { text: "28" }
                    MenuItem { text: "27" }
                    MenuItem { text: "26" }
                    MenuItem { text: "25" }
                    MenuItem { text: "24" }
                    MenuItem { text: "23" }
                    MenuItem { text: "22" }
                    MenuItem { text: "21" }
                    MenuItem { text: "20" }
                    MenuItem { text: "19" }
                    MenuItem { text: "18" }
                    MenuItem { text: "17" }
                    MenuItem { text: "16" }
                    MenuItem { text: "15" }
                    MenuItem { text: "14" }
                    MenuItem { text: "13" }
                    MenuItem { text: "12" }
                    MenuItem { text: "11" }
                    MenuItem { text: "10" }
                    MenuItem { text: "9" }
                }
            }

            SectionHeader {
                text: qsTr("General")
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 25
                Label {
                    text: qsTr("Homepage: ")
                }
                TextField {
                    id: hp
                    text: mainWindow.homepage  // FIX: on new Window loading siteURL != homepage set in settings so add a new var homepage in mainWindow
                    inputMethodHints: Qt.ImhUrlCharactersOnly
                    onFocusChanged: if (focus == true) selectAll();
                }
            }
            ValueButton {
                anchors.horizontalCenter: parent.horizontalCenter
                id: searchEngineCombo
                label: qsTr("Search Engine:")
                value: searchEngineTitle
                onClicked: pageStack.push(Qt.resolvedUrl("SearchEngineDialog.qml"), {dataContainer: settingsPage});
            }
            Row {
                id: customSearchEngine
                visible: searchEngineCombo.value === qsTr("Custom")
                // TODO: Make a ValueButton out of it and add a List with predefined search engines
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Label {
                    id: searchlbl
                    text: qsTr("Engine Url: ")
                }
                TextField {
                    id: searchEngine
                    text: searchEngineUri
                    inputMethodHints: Qt.ImhUrlCharactersOnly
                    placeholderText: "%s for searchterm"
                    width: hp.width
                    onFocusChanged: if (focus == true) selectAll();
                }
            }
            TextSwitch {
                id: loadImagesSwitch
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Load Images"
                checked: mainWindow.loadImages
            }
            TextSwitch {
                id: privateBrowsingSwitch
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Private Browsing")
                checked: mainWindow.privateBrowsing
            }
            SectionHeader {
                text: "Advanced"
            }
            ValueButton {
                anchors.horizontalCenter: parent.horizontalCenter
                id: userAgentCombo
                label: qsTr("User Agent:")
                value: uAgentTitle
                onClicked: pageStack.push(Qt.resolvedUrl("UserAgentDialog.qml"), {dataContainer: settingsPage});
            }
            TextField {
                id: agentString
                anchors.horizontalCenter: parent.horizontalCenter
                readOnly: true
                width: parent.width - 20
                text: uAgent
            }
            TextSwitch {
                id: dnsPrefetchSwitch
                anchors.horizontalCenter: parent.horizontalCenter
                text: "DNS Prefetch"
                checked: mainWindow.dnsPrefetch
            }
            TextSwitch {
                id: offlineWebApplicationCacheSwitch
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Offline Web Application Cache"
                checked: mainWindow.offlineWebApplicationCache
            }

        }
    }

}
