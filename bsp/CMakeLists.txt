# BSP CMakeLists.txt for S32K358x
# Board Support Package build configuration

cmake_minimum_required(VERSION 3.20)

# BSP Library
# This will be populated once BSP files are added
# Current status: Awaiting BSP integration

# TODO: Add BSP sources when available:
# - startup/startup_s32k358.s
# - startup/system_s32k358.c
# - CMSIS device headers
# - Linker scripts
# - Peripheral drivers

# Placeholder for BSP library
# Uncomment and configure when BSP files are added:

# add_library(s32k3_bsp STATIC
#     startup/startup_s32k358.s
#     startup/system_s32k358.c
#     # Add driver sources here
# )
# 
# target_include_directories(s32k3_bsp PUBLIC
#     ${CMAKE_CURRENT_SOURCE_DIR}/cmsis
#     ${CMAKE_CURRENT_SOURCE_DIR}/startup
#     ${CMAKE_CURRENT_SOURCE_DIR}/drivers
# )
# 
# target_compile_definitions(s32k3_bsp PUBLIC
#     S32K358
#     CPU_S32K358
# )
# 
# # Linker script
# set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/linker/s32k358_flash.ld)
# target_link_options(s32k3_bsp PUBLIC
#     -T${LINKER_SCRIPT}
#     -Wl,-Map=${CMAKE_BINARY_DIR}/s32k3_app.map
# )

message(STATUS "BSP configuration pending - awaiting BSP file integration")
