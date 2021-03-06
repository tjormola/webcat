/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include "myclass.h"
#include "DownloadManager.hpp"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QGuiApplication *app = SailfishApp::application(argc, argv);

    QString file;


    // Sometimes I get the feeling I don't know what I do. But it works and the only limitation so far is that '--private' needs to be the first argument
    if (QString(argv[1]) == "--private") {
        // Load private mode here
        app->setApplicationName("harbour-webcat_PRIVATE");
        for(int i=1; i<argc; i++) {
            if (QString(argv[i]) == "about:bookmarks") file = "about:bookmarks";
            else if (!QString(argv[i]).startsWith("/") && !QString(argv[i]).startsWith("http://") && !QString(argv[i]).startsWith("rtsp://")
                     && !QString(argv[i]).startsWith("mms://") && !QString(argv[i]).startsWith("file://") && !QString(argv[i]).startsWith("https://") && !QString(argv[i]).startsWith("www.")) {
                QString pwd("");
                char * PWD;
                PWD = getenv ("PWD");
                pwd.append(PWD);
                file = pwd + "/" + QString(argv[i]);
            }
            else if (QString(argv[i]).startsWith("www.")) file = "http://" + QString(argv[i]);
            else file = QString(argv[i]);
        }
    }
    else {
        app->setApplicationName("harbour-webcat");   // Hopefully no location changes with libsailfishapp affecting config
        for(int i=1; i<argc; i++) {
            if (QString(argv[i]) == "about:bookmarks") file = "about:bookmarks";
            else if (!QString(argv[i]).startsWith("/") && !QString(argv[i]).startsWith("http://") && !QString(argv[i]).startsWith("rtsp://")
                     && !QString(argv[i]).startsWith("mms://") && !QString(argv[i]).startsWith("file://") && !QString(argv[i]).startsWith("https://") && !QString(argv[i]).startsWith("www.")) {
                QString pwd("");
                char * PWD;
                PWD = getenv ("PWD");
                pwd.append(PWD);
                file = pwd + "/" + QString(argv[i]);
            }
            else if (QString(argv[i]).startsWith("www.")) file = "http://" + QString(argv[i]);
            else file = QString(argv[i]);
        }
    }

    //app->setOrganizationName("Webcat");
    app->setApplicationVersion("0.9");
    QQuickView *view = SailfishApp::createView();

    view->setSource(SailfishApp::pathTo("qml/harbour-webcat.qml"));

    QObject *object = view->rootObject();

    //qDebug() << file.isEmpty();
    if (!file.isEmpty()) {
        qDebug() << "Loading url " + file;
        object->setProperty("siteURL", file);
        qDebug() << object->property("siteURL");
    }
    QMetaObject::invokeMethod(object, "loadInitialTab");

    MyClass myClass(view);
    QObject::connect(object, SIGNAL(clearCookies()),
                     &myClass, SLOT(clearCookies()));
    QObject::connect(object, SIGNAL(clearCache()),
                     &myClass, SLOT(clearCache()));
    QObject::connect(object, SIGNAL(openNewWindow(QString)),
                     &myClass, SLOT(openNewWindow(QString)));
    QObject::connect(object, SIGNAL(openPrivateNewWindow(QString)),
                     &myClass, SLOT(openPrivateNewWindow(QString)));
    QObject::connect(object, SIGNAL(openWithvPlayer(QString)),
                     &myClass, SLOT(openWithvPlayer(QString)));

    // Create download manager object
    DownloadManager manager;

    QFile vPlayer("/usr/bin/harbour-videoPlayer");
    if (vPlayer.exists()) {
        object->setProperty("vPlayerExists", true);
    }
    else {
        object->setProperty("vPlayerExists", false);
    }

    view->engine()->rootContext()->setContextProperty("_manager", &manager);

    view->show();

    return app->exec();
}
