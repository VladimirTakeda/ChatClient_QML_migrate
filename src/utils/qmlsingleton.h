#pragma once

#include <QJSEngine>
#include <QObject>

/// Helper for QML_SINGLETON types whose only instance is created in main().
/// Such types take dependencies in their constructors, so the QML engine cannot construct them itself.
/// Instead each of them keeps a static pointer to its instance and its static create() returns it through this helper.
/// The object is marked as C++-owned, otherwise the engine would delete it on shutdown (double delete).
/// NOTE: if such a type is default-constructible, the engine ignores create() and builds its own instance with `new`,
/// so these types must not have a default constructor (that is why the models take a mandatory `parent`).
template <typename T>
T *ExposeExistingInstance(T *instance)
{
    Q_ASSERT_X(instance, "ExposeExistingInstance", "construct the object in main() before the QML engine loads");
    QJSEngine::setObjectOwnership(instance, QJSEngine::CppOwnership);
    return instance;
}
