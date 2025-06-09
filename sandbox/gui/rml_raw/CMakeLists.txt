add_executable(rml_raw)

set(BACKENDS_DIR "${AM_ROOT}/thirdparty/RmlUi/Backends")

target_sources(rml_raw PRIVATE "rml_raw.cpp" "${BACKENDS_DIR}/RmlUi_Backend_SDL_GL3.cpp" "${BACKENDS_DIR}/RmlUi_Platform_SDL.cpp" "${BACKENDS_DIR}/RmlUi_Renderer_GL3.cpp")
target_link_libraries(rml_raw PUBLIC am_common_options sdl_all RmlUi::RmlUi)
am_set_common_properties(rml_raw)
