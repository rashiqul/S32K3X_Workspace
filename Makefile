#******************************************************************************
#
#     File Name: Makefile
#     Project: S32K3X Workspace
#     Description: Unified Makefile for building S32K3xx firmware and x86 tests
#                  - ARM GCC build for S32K358x microcontroller (Cortex-M7)
#                  - Standard GCC build for x86 testing and coverage
#     Author: Mohammad Rashiqul Alam
#
#     Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
#
#******************************************************************************

#==============================================================================
# X86 Build Configuration (for development, testing, and coverage)
#==============================================================================

PACKAGE_NAME ?= s32k3x_workspace
PACKAGE_VERSION ?=
PYTHON_FILES ?= .
MOD_TO_ANALYZE ?= ""
C_FILES ?=
CONAN_CONFIG_VERSION ?= main
CONAN_CONFIG_URL ?= 
CONAN_FLAGS_PARAM := $(CONAN_FLAGS)

# Default for local x86_64 development
TARGET_CPU ?= x86_64

# Auto-detect OS and set appropriate Conan profile
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	DEFAULT_CONAN_BUILD_PROFILE := $(CURDIR)/.conan/profiles/s32k3x_workspace_linux
else ifeq ($(UNAME_S),Darwin)
	DEFAULT_CONAN_BUILD_PROFILE := $(CURDIR)/.conan/profiles/s32k3x_workspace_macos
else
	$(error Unsupported OS: $(UNAME_S))
endif

CONAN_BUILD_PROFILE ?= $(DEFAULT_CONAN_BUILD_PROFILE)

ifeq ($(MAKECMDGOALS),coverage)
COVERAGE ?= 1
endif

ifeq ($(COVERAGE), 1)
TARGET_CPU = x86_64
BUILD_TYPE ?= Debug
CONAN_FLAGS += -o ${PACKAGE_NAME}/*:coverage=True
else
BUILD_TYPE ?= Release
endif

BUILD_DIR ?= build_$(TARGET_CPU)/$(BUILD_TYPE)
CONAN_FLAGS += -pr:b $(CONAN_BUILD_PROFILE)
CONAN_FLAGS += -pr:h $(CONAN_BUILD_PROFILE)
CONAN_FLAGS += --lockfile-partial

ifeq ($(LOCAL_CONAN),1)
export CONAN_HOME=${CURDIR}/.conan2_local/.conan2
endif

ifneq ($(VERBOSE),1)
.SILENT:
endif

#==============================================================================
# ARM Build Configuration (for S32K358x target)
#==============================================================================

# Project Configuration
PROJECT_NAME = s32k3x_firmware
TARGET_MCU = S32K358

# Toolchain Configuration
TOOLCHAIN_PATH = /home/rashiqul/NXP/gcc-10.2-arm32-eabi/bin
ARM_CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
ARM_CXX = $(TOOLCHAIN_PATH)/arm-none-eabi-g++
ARM_AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
ARM_LD = $(TOOLCHAIN_PATH)/arm-none-eabi-ld
ARM_OBJCOPY = $(TOOLCHAIN_PATH)/arm-none-eabi-objcopy
ARM_OBJDUMP = $(TOOLCHAIN_PATH)/arm-none-eabi-objdump
ARM_SIZE = $(TOOLCHAIN_PATH)/arm-none-eabi-size
ARM_AR = $(TOOLCHAIN_PATH)/arm-none-eabi-ar
ARM_GDB = $(TOOLCHAIN_PATH)/arm-none-eabi-gdb

# Directories for ARM build
ARM_SRC_DIR = src
ARM_INC_DIR = include
ARM_BSP_DIR = bsp
ARM_BUILD_DIR = build_s32k
ARM_OBJ_DIR = $(ARM_BUILD_DIR)/obj
ARM_BIN_DIR = $(ARM_BUILD_DIR)/bin

# Source Files for ARM (to be populated)
ARM_C_SOURCES = $(wildcard $(ARM_SRC_DIR)/*.c) \
                $(wildcard $(ARM_BSP_DIR)/**/*.c)

ARM_ASM_SOURCES = $(wildcard $(ARM_BSP_DIR)/startup/*.s)

# Include Directories for ARM
ARM_INCLUDES = -I$(ARM_INC_DIR) \
               -I$(ARM_BSP_DIR) \
               -I$(ARM_BSP_DIR)/config \
               -I$(ARM_BSP_DIR)/drivers

# CPU and FPU Configuration for S32K358x (Cortex-M7)
CPU = -mcpu=cortex-m7
FPU = -mfpu=fpv5-d16
FLOAT_ABI = -mfloat-abi=hard

# ARM Compile Flags
ARM_CFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
ARM_CFLAGS += -std=gnu11
ARM_CFLAGS += -Wall -Wextra -Werror
ARM_CFLAGS += -fdata-sections -ffunction-sections
ARM_CFLAGS += -fno-common -fno-builtin
ARM_CFLAGS += -g3 -O0  # Debug build
ARM_CFLAGS += $(ARM_INCLUDES)
ARM_CFLAGS += -D$(TARGET_MCU)

# ARM C++ Flags
ARM_CXXFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
ARM_CXXFLAGS += -std=c++17
ARM_CXXFLAGS += -Wall -Wextra -Werror
ARM_CXXFLAGS += -fdata-sections -ffunction-sections
ARM_CXXFLAGS += -fno-exceptions -fno-rtti
ARM_CXXFLAGS += -g3 -O0
ARM_CXXFLAGS += $(ARM_INCLUDES)
ARM_CXXFLAGS += -D$(TARGET_MCU)

# ARM Assembly Flags
ARM_ASFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
ARM_ASFLAGS += -g3

# ARM Linker Flags
ARM_LDFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
ARM_LDFLAGS += -specs=nano.specs -specs=nosys.specs
ARM_LDFLAGS += -Wl,--gc-sections
ARM_LDFLAGS += -Wl,--print-memory-usage

# ARM Object Files
ARM_OBJECTS = $(addprefix $(ARM_OBJ_DIR)/, $(notdir $(ARM_C_SOURCES:.c=.o)))
ARM_OBJECTS += $(addprefix $(ARM_OBJ_DIR)/, $(notdir $(ARM_ASM_SOURCES:.s=.o)))

# ARM Output Files
ARM_ELF_FILE = $(ARM_BIN_DIR)/$(PROJECT_NAME).elf
ARM_HEX_FILE = $(ARM_BIN_DIR)/$(PROJECT_NAME).hex
ARM_BIN_FILE = $(ARM_BIN_DIR)/$(PROJECT_NAME).bin
ARM_MAP_FILE = $(ARM_BIN_DIR)/$(PROJECT_NAME).map

#==============================================================================
# Phony Targets
#==============================================================================

.PHONY: default help
default: help

#==============================================================================
# Help Target
#==============================================================================

help:
	@echo "=========================================="
	@echo "  S32K3X Workspace Build System"
	@echo "=========================================="
	@echo ""
	@echo "X86 Build Targets (for development/testing):"
	@echo "  configure         - Configure project with Conan/CMake"
	@echo "  pre-configure     - Install Poetry dependencies"
	@echo "  conan-install     - Install Conan dependencies"
	@echo "  build             - Build x86 Debug version"
	@echo "  build-debug       - Build x86 Debug version"
	@echo "  build-release     - Build x86 Release version"
	@echo "  test              - Run unit tests"
	@echo "  coverage          - Generate coverage reports"
	@echo "  coverage-cbd      - Generate C/C++ coverage report"
	@echo ""
	@echo "ARM Build Targets (for S32K358x):"
	@echo "  build_all_tgt     - Build firmware for ARM Cortex-M7"
	@echo "  arm-clean         - Clean ARM build artifacts"
	@echo "  arm-info          - Display ARM build configuration"
	@echo ""
	@echo "Quality Targets:"
	@echo "  lint              - Run linting checks"
	@echo "  clang-format      - Format C/C++ code"
	@echo "  format            - Format Python code"
	@echo ""
	@echo "Utility Targets:"
	@echo "  clean             - Remove build artifacts"
	@echo "  clean-all         - Remove all artifacts (pristine state)"
	@echo "  list-targets      - List all CMake targets"
	@echo "  help              - Display this help message"
	@echo ""
	@echo "Project: $(PACKAGE_NAME)"
	@echo "Target MCU (ARM): $(TARGET_MCU)"
	@echo "Toolchain (ARM): $(TOOLCHAIN_PATH)"
	@echo ""

#==============================================================================
# X86 Build Targets
#==============================================================================

.PHONY: list-targets
list-targets:
	@if [ -f ${BUILD_DIR}/Makefile ]; then \
		echo "Available build targets:"; \
		poetry run cmake --build ${BUILD_DIR} --target help; \
	else \
		echo "Build directory not found. Run 'make configure' first."; \
	fi

.PHONY: all
all: configure build-release test lint

.PHONY: lint check
lint check:
	poetry check -v
	poetry run black --check $(PYTHON_FILES) --exclude "build_x86_64|build_s32k|.conan2_local"
	poetry run ruff $(PYTHON_FILES) --exclude "build_x86_64,build_s32k,.conan2_local"

.PHONY: setup
setup:
	@echo "🔧 Running development environment setup..."
	@if [ -f ./scripts/setup-dev-environment.sh ]; then \
		./scripts/setup-dev-environment.sh; \
	else \
		echo "Setup script not found. Installing dependencies..."; \
		$(MAKE) pre-configure; \
	fi

.PHONY: pre-configure
pre-configure:
	poetry install --no-root

.PHONY: conan-install
conan-install:
	poetry run conan install . --build=missing -s build_type=$(BUILD_TYPE) $(CONAN_FLAGS)
	CONAN_BUILD=0 CONAN_RUN_TESTS=0 poetry run conan build . --build=missing -s build_type=$(BUILD_TYPE) $(CONAN_FLAGS)

.PHONY: configure
configure: conanfile.py pre-configure conan-install

.PHONY: build-debug
build-debug:
	BUILD_TYPE=Debug $(MAKE) configure
	. build_$(TARGET_CPU)/Debug/generators/conanbuild.sh && poetry run cmake --build build_$(TARGET_CPU)/Debug -t all

.PHONY: build-release
build-release:
	BUILD_TYPE=Release $(MAKE) configure
	. build_$(TARGET_CPU)/Release/generators/conanbuild.sh && poetry run cmake --build build_$(TARGET_CPU)/Release -t all

.PHONY: build
build: build-debug

.PHONY: test
test: configure
	. ${BUILD_DIR}/generators/conanbuild.sh && poetry run cmake --build ${BUILD_DIR} -t test

.PHONY: package
package:
	poetry install --no-root
	poetry run conan create . --build=missing -s build_type=$(BUILD_TYPE) $(CONAN_FLAGS)

.PHONY: coverage
coverage: clean pre-configure
	@echo "========================================================"
	@echo "          Full Coverage Analysis"
	@echo "========================================================"
	@echo ""
	@echo "Building and testing Debug profile with coverage..."
	@echo "--------------------------------------------------------"
	COVERAGE=1 $(MAKE) build-debug
	COVERAGE=1 BUILD_TYPE=Debug $(MAKE) test
	COVERAGE=1 BUILD_TYPE=Debug $(MAKE) coverage-nosanitize coverage-cbd
	@echo ""
	@echo "Building and testing Release profile with coverage..."
	@echo "--------------------------------------------------------"
	COVERAGE=1 $(MAKE) build-release
	COVERAGE=1 BUILD_TYPE=Release $(MAKE) test
	COVERAGE=1 BUILD_TYPE=Release $(MAKE) coverage-nosanitize coverage-cbd
	@echo ""
	@echo "========================================================"
	@echo "          Coverage Reports Generated"
	@echo "========================================================"
	@echo "Debug HTML Report:   build_$(TARGET_CPU)/Debug/coverage/coverage_report.html"
	@echo "Release HTML Report: build_$(TARGET_CPU)/Release/coverage/coverage_report.html"
	@echo "========================================================"

.PHONY: coverage-nosanitize
coverage-nosanitize:
	find . -name "*.gcda" | xargs rm -f
	CONAN_RUN_ENABLE_SANITIZER=0 \
	poetry run conan build . --build=missing -s build_type=$(BUILD_TYPE) $(CONAN_FLAGS)

.PHONY: coverage-sanitize
coverage-sanitize:
	find . -name "*.gcda" | xargs rm -f
	CONAN_RUN_ENABLE_SANITIZER=1 \
	poetry run conan build . --build=missing -s build_type=$(BUILD_TYPE) $(CONAN_FLAGS)

.PHONY: coverage-cbd
coverage-cbd:
	mkdir -p ${BUILD_DIR}/coverage
	@echo ""
	@echo "C/C++ Code Coverage ($(BUILD_TYPE))"
	@echo "----------------------------------------"
	@(poetry run gcovr -r. -s \
	--exclude 'test/.*' \
	--exclude '.conan2_local/.*' \
	--html-details --html-title "S32K3X Code Coverage Report ($(BUILD_TYPE))" \
	--cobertura ${BUILD_DIR}/coverage/cobertura.xml --cobertura-pretty \
	--sonarqube ${BUILD_DIR}/coverage/sonarqube.xml \
	-o ${BUILD_DIR}/coverage/coverage_report.html 2>/dev/null | grep -E '^(lines|functions|branches):' || echo "No C/C++ coverage data found")

.PHONY: clang-format
clang-format:
	@echo "Formatting C/C++ files with clang-format..."
	@find src include test -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) 2>/dev/null | while read file; do \
		echo "  Formatting: $$file"; \
		clang-format -i "$$file"; \
	done
	@echo "✅ All C/C++ files formatted"

.PHONY: format
format:
	poetry run black $(PYTHON_FILES)
	poetry run ruff --fix $(PYTHON_FILES)

#==============================================================================
# ARM Build Targets
#==============================================================================

.PHONY: build_all_tgt
build_all_tgt: pre-configure $(ARM_BIN_DIR) $(ARM_OBJ_DIR)
	@echo "=========================================="
	@echo "  Building S32K3XX Firmware"
	@echo "=========================================="
	@echo ""
	@echo "Installing ARM dependencies with Conan..."
	@poetry run conan install . \
		--build=missing \
		-pr:h .conan/profiles/s32k3x_arm_cortex_m7 \
		-pr:b $(CONAN_BUILD_PROFILE) \
		-s build_type=Release \
		-of $(ARM_BUILD_DIR)
	@echo ""
	@echo "Configuring ARM build with CMake..."
	@CONAN_GEN_DIR=$$(find $(ARM_BUILD_DIR) -name "conan_toolchain.cmake" -exec dirname {} \; | head -1); \
	test -n "$$CONAN_GEN_DIR" || { echo "Error: conan_toolchain.cmake not found"; exit 1; }; \
	. $$CONAN_GEN_DIR/conanbuild.sh && \
	poetry run cmake -S . -B $(ARM_BUILD_DIR) \
		-DCMAKE_TOOLCHAIN_FILE=$$CONAN_GEN_DIR/conan_toolchain.cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
		-G Ninja
	@echo ""
	@echo "Building firmware..."
	@CONAN_GEN_DIR=$$(find $(ARM_BUILD_DIR) -name "conan_toolchain.cmake" -exec dirname {} \; | head -1); \
	test -n "$$CONAN_GEN_DIR" || { echo "Error: conan_toolchain.cmake not found"; exit 1; }; \
	. $$CONAN_GEN_DIR/conanbuild.sh && \
	poetry run cmake --build $(ARM_BUILD_DIR) --config Release
	@echo ""
	@echo "=========================================="
	@echo "  Firmware Build Complete!"
	@echo "=========================================="
	@echo "Target MCU:      $(TARGET_MCU)"
	@echo "Compiler:        $(ARM_CC)"
	@echo "Build directory: $(ARM_BUILD_DIR)"
	@echo "Conan Profile:   s32k3x_arm_cortex_m7"
	@echo "Build artifacts: $(ARM_BIN_DIR)"
	@echo ""

$(ARM_BIN_DIR):
	@mkdir -p $(ARM_BIN_DIR)

$(ARM_OBJ_DIR):
	@mkdir -p $(ARM_OBJ_DIR)

.PHONY: arm-clean
arm-clean:
	@echo "Cleaning ARM build artifacts..."
	@rm -rf $(ARM_BUILD_DIR)
	@echo "ARM clean complete."

.PHONY: arm-info
arm-info:
	@echo "=========================================="
	@echo "  ARM Build Configuration"
	@echo "=========================================="
	@echo "Project Name:    $(PROJECT_NAME)"
	@echo "Target MCU:      $(TARGET_MCU)"
	@echo "Toolchain Path:  $(TOOLCHAIN_PATH)"
	@echo ""
	@echo "Compiler:        $(ARM_CC)"
	@echo "C++ Compiler:    $(ARM_CXX)"
	@echo "Linker:          $(ARM_LD)"
	@echo "Objcopy:         $(ARM_OBJCOPY)"
	@echo "Size:            $(ARM_SIZE)"
	@echo ""
	@echo "CPU:             $(CPU)"
	@echo "FPU:             $(FPU)"
	@echo "Float ABI:       $(FLOAT_ABI)"
	@echo ""
	@echo "Source Dir:      $(ARM_SRC_DIR)"
	@echo "Include Dir:     $(ARM_INC_DIR)"
	@echo "BSP Dir:         $(ARM_BSP_DIR)"
	@echo "Build Dir:       $(ARM_BUILD_DIR)"
	@echo ""
	@echo "C Sources:       $(words $(ARM_C_SOURCES)) files"
	@echo "ASM Sources:     $(words $(ARM_ASM_SOURCES)) files"
	@echo ""

#==============================================================================
# Clean Targets
#==============================================================================

.PHONY: clean clean-all
clean:
	rm -rf build build_x86_64 build_s32k
	find . -type d -name "build*" -not -name "build_s32k" | xargs rm -rf
	rm -rf .benchmark .coverage .venv .*_cache site
	find . -type d -name __pycache__ | xargs rm -rf

clean-all: clean
	@echo "🧹 Deep cleaning project - removing all caches and dependencies..."
	@echo "Removing local Conan data..."
	rm -rf .conan2_local poetry.lock
	@echo "Removing project .venv..."
	rm -rf .venv
	@echo "Clearing Poetry cache..."
	poetry cache clear --all pypi -n 2>/dev/null || true
	@echo "Removing Conan cache..."
	rm -rf ~/.conan2 ~/.conan
	@echo "✅ Project reset to pristine state"

.DEFAULT:
	. ${BUILD_DIR}/generators/conanbuild.sh && poetry run cmake --build ${BUILD_DIR} --target $@
