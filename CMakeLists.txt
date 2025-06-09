cmake_minimum_required(VERSION 3.25)
project(archmod)

if(EMSCRIPTEN)
    message("Using emscripten!")
else()
    message("Not using emscripten!")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
if(EMSCRIPTEN)
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/emscripten")
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/RmlUi/CMake/Modules/Emscripten")
endif()

include("cmake/Common.cmake")

set(SANDBOX_ENTRY "gui/rml_raw")

if(SANDBOX_ENTRY)
  add_subdirectory("${AM_ROOT}/sandbox/${SANDBOX_ENTRY}")
else()
#TODO: add subdirectory of engine and editor
endif()
