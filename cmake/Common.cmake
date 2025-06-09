#message("common ${CMAKE_CURRENT_LIST_DIR}")
#set (AM_ROOT ${CMAKE_CURRENT_LIST_DIR})
cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH AM_ROOT)

include("cmake/Dependencies.cmake")
include("cmake/Targets.cmake")
include("cmake/Functions.cmake")
