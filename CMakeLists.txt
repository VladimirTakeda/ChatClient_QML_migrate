cmake_minimum_required(VERSION 3.16)

project(ChatClient_QML VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick WebSockets Widgets)

qt_standard_project_setup()


if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(appChatClient_QML
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}

        src/main.cpp
        src/network/websocketclient.cpp
        src/network/httpclient.cpp
        src/model/data/dialog.cpp
        src/model/data/dialogsmanager.cpp


        src/core/chatclient.cpp

        src/utils/utils.cpp


        src/network/websocketclient.h
        src/network/httpclient.h
        src/model/data/dialog.h
        src/model/data/dialogsmanager.h


        src/core/chatclient.h

        src/utils/utils.h
    )
endif()

qt_add_qml_module(appChatClient_QML
    URI ChatClient_QML
    VERSION 1.0
    RESOURCE_PREFIX
        /ChatClient
    QML_FILES
        Main.qml
        qml/StartWidget.qml
        qml/Registration.qml
        qml/MainWidget.qml
        qml/StyleModule/Style.qml
        qml/MainWidgetInternal/LeftSideBar/LeftToolPanel.qml
        qml/MainWidgetInternal/MidSideBar/MidPanel.qml
        qml/MainWidgetInternal/RightSideBar/ChatHistory.qml
        qml/MainWidgetInternal/MidSideBar/SearchPanel/SearchPanel.qml
        qml/MainWidgetInternal/MidSideBar/StackPanels/ContactsPanel.qml
        qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml
        qml/MainWidgetInternal/MidSideBar/StackPanels/DelegateContactPanel.qml
        qml/MainWidgetInternal/MidSideBar/StackPanels/DelegateSearchPanel.qml
        qml/MainWidgetInternal/RightSideBar/ChatHistoryInternal/TopToolPanel.qml
        qml/MainWidgetInternal/RightSideBar/ChatHistoryInternal/BottomToolPanel.qml
        qml/MainWidgetInternal/RightSideBar/ChatHistoryInternal/ChatDisplayPanel.qml
    RESOURCES
        icons/user_blank.png
        icons/sendMessage.png
        icons/smileButton.png
        icons/paper_clip.svg
        icons/walls2.jpg
        # icons/walls3.jpg
        qml/StyleModule/CMakeLists.txt
    SOURCES
        src/model/contactsmodel.h src/model/contactsmodel.cpp
        src/model/searchmodel.h src/model/searchmodel.cpp
        src/model/chathistorymodel.h src/model/chathistorymodel.cpp
)

add_subdirectory(qml/StyleModule)

# add_subdirectory(qml/MainWidgetInternal/LeftSideBar)
    # qml/MainWidgetInternal/MidSideBar
    # qml/MainWidgetInternal/RightSideBar
    # qml/MainWidgetInternal/MidSideBar/SearchPanel
    # qml/MainWidgetInternal/MidSideBar/StackPanels


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appChatClient_QML PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appChatClient_QML
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appChatClient_QML
    PRIVATE Qt6::Gui Qt6::Quick Qt6::Widgets Qt6::WebSockets StyleLibplugin
)

target_include_directories(appChatClient_QML PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/model
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core
)

include(GNUInstallDirs)
install(TARGETS appChatClient_QML
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
