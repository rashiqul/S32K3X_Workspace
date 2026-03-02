# Common library for all source files
add_library(common_lib INTERFACE)
target_include_directories(common_lib INTERFACE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_BINARY_DIR}
)

link_libraries(common_lib)

# Build application functions as a library (without main) for testing
add_library(s32k3x_app OBJECT main.c)
target_include_directories(s32k3x_app PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/s32k3x
)
target_compile_definitions(s32k3x_app PRIVATE UNIT_TEST_BUILD)

#Build full main application for embedded target
add_library(s32k3x_main main.c)
target_include_directories(s32k3x_main PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/s32k3x
)

