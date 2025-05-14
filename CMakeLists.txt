cmake_minimum_required(VERSION 3.25)
project(archmod)

if(EMSCRIPTEN)
    message("Using emscripten!")
else()
    message("Not using emscripten!")
endif()
message("CMAKE_SYSTEM_NAME - ${CMAKE_SYSTEM_NAME}")
message("CMAKE_C_COMPILER_ID - ${CMAKE_C_COMPILER_ID}")
message("CMAKE_CXX_COMPILER_ID - ${CMAKE_CXX_COMPILER_ID}")

#include(common.cmake)

#if(SANDBOX_ENTRY)
  #add_subdirectory("${AM_ROOT}/sandbox/${SANDBOX_ENTRY}")
#else()
#TODO: add subdirectory of engine and editor
#endif()
