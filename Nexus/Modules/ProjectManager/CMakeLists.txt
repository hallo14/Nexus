
qt_add_qml_module(ProjectManager
    URI Modules.ProjectManager
    VERSION 1.0
    SOURCES
        githubcontroller.cpp
        githubcontroller.h
    QML_FILES
        ProjectManager.qml
        QML_FILES TopBar.qml
        QML_FILES RepoView.qml
        QML_FILES Popups/LoginPopup.qml
        QML_FILES RepoInfoView/CommandList.qml
        QML_FILES RepoInfoView.qml
        QML_FILES Common/NexusButton.qml
        QML_FILES Popups/CommandDialog.qml
        QML_FILES Popups/CommandContextMenu.qml
        QML_FILES Common/NexusRectangle.qml
        QML_FILES Common/NexusText.qml
)

find_package(Qt6 REQUIRED COMPONENTS Gui Network QuickEffects)
target_link_libraries(ProjectManager PRIVATE Qt6::Gui Qt6::Network)
