# BSP CMakeLists.txt for S32K358x
# Board Support Package build configuration

cmake_minimum_required(VERSION 3.20)

if(NOT CMAKE_CROSSCOMPILING)
	message(STATUS "Skipping BSP target for host build")
	return()
endif()

set(S32DS_RTD_ROOT "$ENV{S32DS_RTD_ROOT}" CACHE PATH "Path to S32DS PlatformSDK_S32K3 RTD root")
if(NOT S32DS_RTD_ROOT)
	message(FATAL_ERROR
		"S32DS_RTD_ROOT is not set.\n"
		"Set S32DS_RTD_ROOT environment variable or CMake cache entry to your RTD root.\n"
		"Example (env): export S32DS_RTD_ROOT=/path/to/PlatformSDK_S32K3/RTD\n"
		"Example (cmake): cmake -DS32DS_RTD_ROOT=/path/to/PlatformSDK_S32K3/RTD ..."
	)
endif()

set(BASE_NXP_HEADER_DIR "${S32DS_RTD_ROOT}/BaseNXP_TS_T40D34M70I1R0/header")
set(BASE_NXP_INCLUDE_DIR "${S32DS_RTD_ROOT}/BaseNXP_TS_T40D34M70I1R0/include")
set(PLATFORM_INCLUDE_DIR "${S32DS_RTD_ROOT}/Platform_TS_T40D34M70I1R0/include")
set(PLATFORM_STARTUP_INCLUDE_DIR "${S32DS_RTD_ROOT}/Platform_TS_T40D34M70I1R0/startup/include")

set(BSP_REQUIRED_DIRS
	"${BASE_NXP_HEADER_DIR}"
	"${BASE_NXP_INCLUDE_DIR}"
	"${PLATFORM_INCLUDE_DIR}"
	"${PLATFORM_STARTUP_INCLUDE_DIR}"
)

foreach(REQUIRED_DIR IN LISTS BSP_REQUIRED_DIRS)
	if(NOT EXISTS "${REQUIRED_DIR}")
		message(FATAL_ERROR
			"Missing required RTD include directory: ${REQUIRED_DIR}\n"
			"Set S32DS_RTD_ROOT to your S32DS RTD root path."
		)
	endif()
endforeach()

set(S32K3_LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/linker/linker_flash_s32k358.ld")

file(GLOB BSP_STARTUP_SOURCES CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/startup/*.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/startup/*.s"
)

set(BSP_STARTUP_ASM_SOURCES
	"${CMAKE_CURRENT_SOURCE_DIR}/startup/Vector_Table.s"
	"${CMAKE_CURRENT_SOURCE_DIR}/startup/startup_cm7.s"
)

foreach(ASM_SRC IN LISTS BSP_STARTUP_ASM_SOURCES)
	if(EXISTS "${ASM_SRC}")
		set_source_files_properties(${ASM_SRC} PROPERTIES COMPILE_FLAGS "-x assembler-with-cpp")
	endif()
endforeach()

file(GLOB BSP_RTD_SOURCES CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/drivers/rtd/src/*.c"
)

file(GLOB BSP_GENERATED_SOURCES CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/config/generated/src/*.c"
)

file(GLOB BSP_BOARD_SOURCES CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/config/board/*.c"
)

add_library(s32k3_bsp STATIC
	${BSP_STARTUP_SOURCES}
	${BSP_RTD_SOURCES}
	${BSP_GENERATED_SOURCES}
	${BSP_BOARD_SOURCES}
)

target_include_directories(s32k3_bsp PUBLIC
	${CMAKE_CURRENT_SOURCE_DIR}/startup
	${CMAKE_CURRENT_SOURCE_DIR}/drivers/rtd/include
	${CMAKE_CURRENT_SOURCE_DIR}/config/generated/include
	${CMAKE_CURRENT_SOURCE_DIR}/config/board
	${BASE_NXP_HEADER_DIR}
	${BASE_NXP_INCLUDE_DIR}
	${PLATFORM_INCLUDE_DIR}
	${PLATFORM_STARTUP_INCLUDE_DIR}
)

target_compile_definitions(s32k3_bsp PUBLIC
	CPU_S32K358
	S32K358
	GCC
	ENABLE_FPU
	MPU_ENABLE
	D_CACHE_ENABLE
	I_CACHE_ENABLE
	VV_RESULT_ADDRESS=0x204BBF00
)

target_compile_options(s32k3_bsp PRIVATE
	-mcpu=cortex-m7
	-mthumb
	-mlittle-endian
	-mfloat-abi=hard
	-mfpu=fpv5-sp-d16
	-std=c99
	-funsigned-char
	-fomit-frame-pointer
	-fno-short-enums
	-funsigned-bitfields
	-fno-common
	-Wall
	-Wextra
	-Wstrict-prototypes
	-Wsign-compare
	-Wundef
	-Wdouble-promotion
	-Werror=implicit-function-declaration
)

add_library(s32k3_linker_config INTERFACE)

target_link_options(s32k3_linker_config INTERFACE
	-mcpu=cortex-m7
	-mthumb
	-mlittle-endian
	-mfloat-abi=hard
	-mfpu=fpv5-sp-d16
	-specs=nano.specs
	-specs=nosys.specs
	-nostartfiles
	--entry=Reset_Handler
	"SHELL:-T${S32K3_LINKER_SCRIPT}"
	"SHELL:-Wl,-Map=${CMAKE_BINARY_DIR}/bin/s32k3x_firmware.map"
	-Wl,--gc-sections
	-Wl,--print-memory-usage
)

set_target_properties(s32k3_bsp PROPERTIES
	C_STANDARD 99
	C_STANDARD_REQUIRED YES
)

message(STATUS "Configured BSP target s32k3_bsp")
message(STATUS "Using S32DS RTD root: ${S32DS_RTD_ROOT}")
