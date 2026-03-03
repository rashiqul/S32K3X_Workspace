cmake_minimum_required(VERSION 3.23.0)
project(PackageTest C)

find_package(s32k3x_workspace CONFIG REQUIRED)

# Import upstream sources
set(upstream_dir ${PROJECT_BINARY_DIR}/upstream)
file(GLOB upstream_cmake_files RELATIVE ${upstream_dir} ${upstream_dir}/*/src/CMakeLists.txt)
foreach(cmake_file ${upstream_cmake_files})
    get_filename_component(dir ${cmake_file} DIRECTORY)
    add_subdirectory(${upstream_dir}/${dir} ${dir})
endforeach()

# Link the app library with the main library
target_link_libraries(s32k3x_app PRIVATE s32k3x_main)

add_executable(test_package src/test_package.c)
target_link_libraries(test_package PRIVATE s32k3x_app common_lib)
