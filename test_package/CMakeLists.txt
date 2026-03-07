cmake_minimum_required(VERSION 3.23.0)
project(PackageTest C)

find_package(s32k3x_workspace CONFIG REQUIRED)

add_executable(test_package src/test_package.c)

# Ensure the target exists and link against it
# This validates that CMakeDeps properly generated the target
if(NOT TARGET s32k3x_workspace::s32k3x_workspace)
    message(FATAL_ERROR "Expected CMake target 's32k3x_workspace::s32k3x_workspace' to be defined after find_package(s32k3x_workspace CONFIG REQUIRED)")
endif()

target_link_libraries(test_package PRIVATE s32k3x_workspace::s32k3x_workspace)
