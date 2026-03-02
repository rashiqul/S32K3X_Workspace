cmake_minimum_required(VERSION 3.23)
project(S32K3xWorkspace)
enable_testing()
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Options
option(ENABLE_WARNINGS_SETTINGS "Allow target_set_warnings to add flags and defines." ON)
option(ENABLE_LTO "Enable link time optimization" ON)
option(COVERAGE "Generate coverage data" OFF)

# Set version if not provided
if(NOT DEFINED CONAN_PACKAGE_VERSION)
    set(CONAN_PACKAGE_VERSION "0.1.0")
endif()

# Generate config.h from config.h.in
configure_file(
    ${CMAKE_SOURCE_DIR}/include/config.h.in
    ${CMAKE_BINARY_DIR}/config.h
    @ONLY
)

# Add cmake modules directory
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

if(COVERAGE)
    include(CodeCoverage)
    append_coverage_compiler_flags()
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -O0")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
endif()
message(STATUS "COVERAGE=${COVERAGE}")

# Find GTest from Conan (for x86 testing)
if(CMAKE_BUILD_TYPE MATCHES "Debug|Release")
    find_package(GTest CONFIG REQUIRED)
endif()

# Simplified cmake configuration for local development
include(GNUInstallDirs)

add_subdirectory(src)

if(NOT CMAKE_CROSSCOMPILING)
    add_subdirectory(test)
endif()

# Install include directories
install(DIRECTORY include/ DESTINATION include
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.in" EXCLUDE
)

install(DIRECTORY docs/ DESTINATION docs)
