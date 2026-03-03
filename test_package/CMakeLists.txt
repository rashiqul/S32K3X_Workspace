cmake_minimum_required(VERSION 3.23.0)
project(PackageTest C)

find_package(s32k3x_workspace CONFIG REQUIRED)

add_executable(test_package src/test_package.c)

# For header-only package, just link against the interface target if it exists
# Otherwise just verify we can include the headers
if(TARGET s32k3x_workspace::s32k3x_workspace)
    target_link_libraries(test_package PRIVATE s32k3x_workspace::s32k3x_workspace)
endif()
