#[[
	Custom find module for SDL_mixer for Emscripten compilation.

	Input variables:
    none

	Output variables:
		SDL2_mixer_FOUND
		SDL2_mixer_VERSION

	Resulting targets:
		SDL2_mixer::SDL2_mixer
]]

include(FindPackageHandleStandardArgs)
include(FindPackageMessage)

if(NOT TARGET SDL2_mixer::SDL2_mixer)
	# If no version was specified, set default
	if(NOT DEFINED SDL2_mixer_FIND_VERSION)
		set(SDL2_mixer_FIND_VERSION "2")
	endif()

	# Check if requested SDL version is valid
	if((SDL2_mixer_FIND_VERSION VERSION_LESS "2") OR (SDL2_mixer_FIND_VERSION VERSION_GREATER_EQUAL "3"))
		message(FATAL_ERROR "The requested SDL2_mixer version ${SDL2_mixer_FIND_VERSION} is invalid.")
	endif()

	# Emscripten includes SDL support as part of it's SDK, meaning there's no need to find it
	set(SDL2_mixer_FOUND TRUE)
	add_library(SDL2_mixer::SDL2_mixer INTERFACE IMPORTED)

	# Set found SDL_image version based on latest Emscripten SDK at the time of writing this file
	# Version set based on latest Emscripten SDK at the time of writing this file
	set(SDL2_mixer_VERSION "2.8.0")

	set(SDL2_mixer_TARGET_ARGS "--use-port=sdl2_mixer")

	# Enable compilation and linking against SDL
	target_compile_options(SDL2_mixer::SDL2_mixer INTERFACE "${SDL2_mixer_TARGET_ARGS}")
	target_link_options(SDL2_mixer::SDL2_mixer INTERFACE "${SDL2_mixer_TARGET_ARGS}")

	# Get final compiler and linker flags to print them
	get_target_property(SDL2_mixer_COMPILE_FLAGS SDL2_mixer::SDL2_mixer "INTERFACE_COMPILE_OPTIONS")
	get_target_property(SDL2_mixer_LINK_FLAGS SDL2_mixer::SDL2_mixer "INTERFACE_LINK_OPTIONS")

	find_package_message(
		"SDL2_mixer"
		"SDL_mixer ${SDL2_mixer_VERSION} has been found as part of the Emscripten SDK."
		"[${SDL2_mixer_COMPILE_FLAGS}][${SDL2_mixer_LINK_FLAGS}]"
	)

	# Clean scope
	unset(SDL2_mixer_TARGET_ARGS)
	unset(SDL2_mixer_COMPILE_FLAGS)
	unset(SDL2_mixer_LINK_FLAGS)
else()
	# Since the target already exists, we declare it as found
	set(SDL2_mixer_FOUND TRUE)
	if(NOT DEFINED SDL2_mixer_VERSION)
		set(SDL2_mixer_VERSION "UNKNOWN")
	endif()
endif()
