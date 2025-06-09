#[[
	Custom find module for SDL_image for Emscripten compilation.

	Input variables:
		SDL2_image_FORMATS

	Output variables:
		SDL2_image_FOUND
		SDL2_image_VERSION

	Resulting targets:
		SDL2_image::SDL2_image
]]

include(FindPackageHandleStandardArgs)
include(FindPackageMessage)

if(NOT TARGET SDL2_image::SDL2_image)
	# If no version was specified, set default
	if(NOT DEFINED SDL2_image_FIND_VERSION)
		set(SDL2_image_FIND_VERSION "2")
	endif()
	if(NOT DEFINED SDL2_image_FORMATS)
		set(SDL2_image_FORMATS "png,jpg,tga")
	endif()

	# Check if requested SDL version is valid
	if((SDL2_image_FIND_VERSION VERSION_LESS "2") OR (SDL2_image_FIND_VERSION VERSION_GREATER_EQUAL "3"))
		message(FATAL_ERROR "The requested SDL2_image version ${SDL2_image_FIND_VERSION} is invalid.")
	endif()

	# Emscripten includes SDL support as part of it's SDK, meaning there's no need to find it
	set(SDL2_image_FOUND TRUE)
	add_library(SDL2_image::SDL2_image INTERFACE IMPORTED)

	# Set found SDL_image version based on latest Emscripten SDK at the time of writing this file
	# Version set based on latest Emscripten SDK at the time of writing this file
	set(SDL2_image_VERSION "2.6.0")

	set(SDL2_image_TARGET_ARGS "--use-port=sdl2_image:formats=${SDL2_image_FORMATS}")

	# Enable compilation and linking against SDL
	target_compile_options(SDL2_image::SDL2_image INTERFACE "${SDL2_image_TARGET_ARGS}")
	target_link_options(SDL2_image::SDL2_image INTERFACE "${SDL2_image_TARGET_ARGS}")

	# Get final compiler and linker flags to print them
	get_target_property(SDL2_image_COMPILE_FLAGS SDL2_image::SDL2_image "INTERFACE_COMPILE_OPTIONS")
	get_target_property(SDL2_image_LINK_FLAGS SDL2_image::SDL2_image "INTERFACE_LINK_OPTIONS")

	find_package_message(
		"SDL2_image"
		"SDL_image ${SDL2_image_VERSION} has been found as part of the Emscripten SDK."
		"[${SDL2_image_COMPILE_FLAGS}][${SDL2_image_LINK_FLAGS}]"
	)

	# Clean scope
	unset(SDL2_image_TARGET_ARGS)
	unset(SDL2_image_COMPILE_FLAGS)
	unset(SDL2_image_LINK_FLAGS)
else()
	# Since the target already exists, we declare it as found
	set(SDL2_image_FOUND TRUE)
	if(NOT DEFINED SDL2_image_VERSION)
		set(SDL2_image_VERSION "UNKNOWN")
	endif()
endif()
