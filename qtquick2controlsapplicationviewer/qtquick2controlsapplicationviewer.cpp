#include "qtquick2controlsapplicationviewer.h"

#include <QCoreApplication>
#include <QDir>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickView>

class QtQuick2ApplicationViewerPrivate
{
    QString mainQmlFile;
    QQmlEngine engine;
    QQuickWindow *window;

    QtQuick2ApplicationViewerPrivate() : window(0)
    {}

    ~QtQuick2ApplicationViewerPrivate()
    {
        delete window;
    }

    static QString adjustPath(const QString &path);

    friend class QtQuick2ControlsApplicationViewer;
};

QString QtQuick2ApplicationViewerPrivate::adjustPath(const QString &path)
{
#if defined(Q_OS_MAC)
    if (!QDir::isAbsolutePath(path))
        return QStringLiteral("%1/../Resources/%2")
                .arg(QCoreApplication::applicationDirPath(), path);
#elif defined(Q_OS_BLACKBERRY)
    if (!QDir::isAbsolutePath(path))
        return QStringLiteral("app/native/%1").arg(path);
#elif !defined(Q_OS_ANDROID)
    QString pathInInstallDir =
            QStringLiteral("%1/../%2").arg(QCoreApplication::applicationDirPath(), path);
    if (QFileInfo(pathInInstallDir).exists())
        return pathInInstallDir;
    pathInInstallDir =
            QStringLiteral("%1/%2").arg(QCoreApplication::applicationDirPath(), path);
    if (QFileInfo(pathInInstallDir).exists())
        return pathInInstallDir;
#endif
    return path;
}

QtQuick2ControlsApplicationViewer::QtQuick2ControlsApplicationViewer()
    : d(new QtQuick2ApplicationViewerPrivate())
{

}

QtQuick2ControlsApplicationViewer::~QtQuick2ControlsApplicationViewer()
{
    delete d;
}

void QtQuick2ControlsApplicationViewer::setMainQmlFile(const QString &file)
{
    d->mainQmlFile = QtQuick2ApplicationViewerPrivate::adjustPath(file);

    QQmlComponent component(&d->engine);

    QObject::connect(&d->engine, SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

#ifdef Q_OS_ANDROID
    component.loadUrl(QUrl(QStringLiteral("assets:/")+d->mainQmlFile));
#else
    component.loadUrl(QUrl(d->mainQmlFile));
#endif

    if (!component.isReady())
        qWarning("%s", qPrintable(component.errorString()));

    d->window = qobject_cast<QQuickWindow *>(component.create());
    if (!d->window)
        qFatal("Error: Your root item has to be a Window.");

    d->engine.setIncubationController(d->window->incubationController());
}

void QtQuick2ControlsApplicationViewer::addImportPath(const QString &path)
{
    d->engine.addImportPath(QtQuick2ApplicationViewerPrivate::adjustPath(path));
}

void QtQuick2ControlsApplicationViewer::show()
{
    if (d->window)
        d->window->show();
}
