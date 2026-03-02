add_executable(test_main test_main.cpp $<TARGET_OBJECTS:s32k3x_app>)
target_include_directories(test_main PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/s32k3x
)
target_link_libraries(test_main 
    PRIVATE GTest::gtest GTest::gtest_main
)

# Simplified CMake configuration
include(GoogleTest)
gtest_discover_tests(test_main)
