
qt_add_qml_module(ProjectManager
    URI Modules.ProjectManager
    VERSION 1.0
    SOURCES
    githubcontroller.cpp
    githubcontroller.h
    QML_FILES
        ProjectManager.qml
)

find_package(Qt6 REQUIRED COMPONENTS Gui Network)
target_link_libraries(ProjectManager PRIVATE Qt6::Gui Qt6::Network)
