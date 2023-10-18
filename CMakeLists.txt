cmake_minimum_required(VERSION 3.26)
project(file_manager)

set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 COMPONENTS Core Widgets Gui Quick REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(Qt6_DIR "/opt/homebrew/opt/qt/lib/cmake/Qt6")


add_executable(file_manager main.cpp
        FileManager.cpp
        File.h
        File.cpp)

qt_add_qml_module(file_manager
        URI fileManager
        QML_FILES
            UI/FileManagerApp.qml
            UI/components/ColumnHeaders.qml
            UI/components/FileList.qml
            UI/components/Toolbar.qml
            UI/components/AttributeMenu.qml
            UI/components/SortMenu.qml
            UI/components/FileActionsMenu.qml
            UI/components/FileMenuDialogs.qml
        RESOURCES
            UI/components/icons/navigation/arrow-small-left.png
            UI/components/icons/navigation/arrow-small-right.png
            UI/components/icons/file/default-file.png
            UI/components/icons/file/folder.png
            UI/components/icons/file/pdf.png
            UI/components/icons/file/picture.png
            UI/components/icons/file/txt.png
            UI/components/icons/file/video.png
            UI/components/icons/file/music.png
)

target_link_libraries(file_manager PRIVATE
        Qt6::Core
        Qt6::Widgets
        Qt6::Gui
        Qt6::Quick
)
