add_executable(rml_raw)

target_sources(rml_raw PRIVATE "rml_raw.cpp")

am_common_options(rml_raw)
am_use_sdl(rml_raw)
am_use_rml(rml_raw)
