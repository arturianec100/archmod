#[[
	Custom find module for SDL_ttf for Emscripten compilation.

	Input variables:
    none

	Output variables:
		SDL2_ttf_FOUND
		SDL2_ttf_VERSION

	Resulting targets:
		SDL2_ttf::SDL2_ttf
]]

include(FindPackageHandleStandardArgs)
include(FindPackageMessage)

if(NOT TARGET SDL2_ttf::SDL2_ttf)
	# If no version was specified, set default
	if(NOT DEFINED SDL2_ttf_FIND_VERSION)
		set(SDL2_ttf_FIND_VERSION "2")
	endif()

	# Check if requested SDL version is valid
	if((SDL2_ttf_FIND_VERSION VERSION_LESS "2") OR (SDL2_ttf_FIND_VERSION VERSION_GREATER_EQUAL "3"))
		message(FATAL_ERROR "The requested SDL2_ttf version ${SDL2_ttf_FIND_VERSION} is invalid.")
	endif()

	# Emscripten includes SDL support as part of it's SDK, meaning there's no need to find it
	set(SDL2_ttf_FOUND TRUE)
	add_library(SDL2_ttf::SDL2_ttf INTERFACE IMPORTED)

	# Set found SDL_image version based on latest Emscripten SDK at the time of writing this file
	# Version set based on latest Emscripten SDK at the time of writing this file
	set(SDL2_ttf_VERSION "2.20.2")

	set(SDL2_ttf_TARGET_ARGS "--use-port=sdl2_ttf")

	# Enable compilation and linking against SDL
	target_compile_options(SDL2_ttf::SDL2_ttf INTERFACE "${SDL2_ttf_TARGET_ARGS}")
	target_link_options(SDL2_ttf::SDL2_ttf INTERFACE "${SDL2_ttf_TARGET_ARGS}")

	# Get final compiler and linker flags to print them
	get_target_property(SDL2_ttf_COMPILE_FLAGS SDL2_ttf::SDL2_ttf "INTERFACE_COMPILE_OPTIONS")
	get_target_property(SDL2_ttf_LINK_FLAGS SDL2_ttf::SDL2_ttf "INTERFACE_LINK_OPTIONS")

	find_package_message(
		"SDL2_ttf"
		"SDL_ttf ${SDL2_ttf_VERSION} has been found as part of the Emscripten SDK."
		"[${SDL2_ttf_COMPILE_FLAGS}][${SDL2_ttf_LINK_FLAGS}]"
	)

	# Clean scope
	unset(SDL2_ttf_TARGET_ARGS)
	unset(SDL2_ttf_COMPILE_FLAGS)
	unset(SDL2_ttf_LINK_FLAGS)
else()
	# Since the target already exists, we declare it as found
	set(SDL2_ttf_FOUND TRUE)
	if(NOT DEFINED SDL2_ttf_VERSION)
		set(SDL2_ttf_VERSION "UNKNOWN")
	endif()
endif()
