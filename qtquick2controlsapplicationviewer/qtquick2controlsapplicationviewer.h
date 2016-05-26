#ifndef QTQUICK2APPLICATIONVIEWER_H
#define QTQUICK2APPLICATIONVIEWER_H

#ifndef QT_NO_WIDGETS
#include <QApplication>
#else
#include <QGuiApplication>
#endif

QT_BEGIN_NAMESPACE

#ifndef QT_NO_WIDGETS
#define Application QApplication
#else
#define Application QGuiApplication
#endif

QT_END_NAMESPACE

class QtQuick2ControlsApplicationViewer
{
public:
    explicit QtQuick2ControlsApplicationViewer();
    virtual ~QtQuick2ControlsApplicationViewer();

    void setMainQmlFile(const QString &file);
    void addImportPath(const QString &path);
    void show();

private:
    class QtQuick2ApplicationViewerPrivate *d;
};

#endif
