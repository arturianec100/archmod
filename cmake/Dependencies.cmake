find_package(SDL2 REQUIRED COMPONENTS SDL2 OPTIONAL_COMPONENTS SDL2main)
find_package(SDL2_ttf REQUIRED COMPONENTS SDL2_ttf)
find_package(SDL2_image REQUIRED COMPONENTS SDL2_image)
find_package(SDL2_mixer REQUIRED COMPONENTS SDL2_mixer)

set(RMLUI_BACKEND SDL_GL3)
add_subdirectory("${AM_ROOT}/thirdparty/RmlUi")
