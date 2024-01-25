qt_add_library(StyleLib STATIC)

set_target_properties(StyleLib PROPERTIES AUTOMOC ON)
target_link_libraries(StyleLib PRIVATE Qt6::Quick Qt6::Core)

# set (_QML_IMPORT_PATHS ":/ChatClient")

#put out error: make sure qml_import_path variable is cmakecache.txt
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)
set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY} CACHE STRING "Import paths for Qt Creator's code model" FORCE)

list(APPEND MODULE_QML_FILES Style.qml)

set_source_files_properties(${MODULE_QML_FILES} PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(StyleLib
    URI StyleModule
    VERSION 1.0
    RESOURCE_PREFIX
        /ChatClient
    QML_FILES
        ${MODULE_QML_FILES}
)

