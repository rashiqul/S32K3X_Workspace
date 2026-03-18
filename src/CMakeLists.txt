# Common library for all source files
add_library(common_lib INTERFACE)
target_include_directories(common_lib INTERFACE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_BINARY_DIR}
)

link_libraries(common_lib)

if(CMAKE_CROSSCOMPILING)
    add_executable(s32k3x_firmware main.c)
    target_include_directories(s32k3x_firmware PUBLIC
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_SOURCE_DIR}/include/s32k3x
    )
    target_compile_options(s32k3x_firmware PRIVATE
        -mcpu=cortex-m7
        -mthumb
        -mlittle-endian
        -mfloat-abi=hard
        -mfpu=fpv5-sp-d16
    )
    target_link_libraries(s32k3x_firmware PRIVATE s32k3_bsp)
    set_target_properties(s32k3x_firmware PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )

    if(NOT CMAKE_OBJCOPY)
        find_program(CMAKE_OBJCOPY arm-none-eabi-objcopy)
    endif()

    if(CMAKE_OBJCOPY)
        add_custom_command(TARGET s32k3x_firmware POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -O ihex
                $<TARGET_FILE:s32k3x_firmware>
                ${CMAKE_BINARY_DIR}/bin/s32k3x_firmware.hex
            COMMAND ${CMAKE_OBJCOPY} -O binary
                $<TARGET_FILE:s32k3x_firmware>
                ${CMAKE_BINARY_DIR}/bin/s32k3x_firmware.bin
            COMMENT "Generating HEX and BIN artifacts"
        )
    else()
        message(WARNING "objcopy not found; HEX/BIN artifacts will not be generated")
    endif()
else()
    # Build application functions as a library (without main) for testing
    add_library(s32k3x_app OBJECT main.c)
    target_include_directories(s32k3x_app PUBLIC
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_SOURCE_DIR}/include/s32k3x
    )
    target_compile_definitions(s32k3x_app PRIVATE UNIT_TEST_BUILD)

    # Build full main application for host-side development workflows
    add_library(s32k3x_main main.c)
    target_include_directories(s32k3x_main PUBLIC
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_SOURCE_DIR}/include/s32k3x
    )
endif()

