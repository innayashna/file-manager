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
            UI.qml
        RESOURCES
            icons/navigation/arrow-small-left.png
            icons/navigation/arrow-small-right.png
            icons/file/default-file.png
            icons/file/folder.png
            icons/file/pdf.png
            icons/file/picture.png
            icons/file/txt.png
            icons/file/video.png
            icons/file/music.png
)

target_link_libraries(file_manager PRIVATE
        Qt6::Core
        Qt6::Widgets
        Qt6::Gui
        Qt6::Quick
)
