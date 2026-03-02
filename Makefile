#******************************************************************************
#
#     File Name: Makefile
#     Project: S32K3X Workspace
#     Description: Makefile for building S32K3xx firmware
#                  Targets S32K358x microcontroller (Cortex-M7)
#     Author: Mohammad Rashiqul Alam
#
#     Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
#
#******************************************************************************

# Project Configuration
PROJECT_NAME = s32k3x_firmware
TARGET_MCU = S32K358

# Toolchain Configuration
TOOLCHAIN_PATH = /home/rashiqul/NXP/gcc-10.2-arm32-eabi/bin
CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
CXX = $(TOOLCHAIN_PATH)/arm-none-eabi-g++
AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
LD = $(TOOLCHAIN_PATH)/arm-none-eabi-ld
OBJCOPY = $(TOOLCHAIN_PATH)/arm-none-eabi-objcopy
OBJDUMP = $(TOOLCHAIN_PATH)/arm-none-eabi-objdump
SIZE = $(TOOLCHAIN_PATH)/arm-none-eabi-size
AR = $(TOOLCHAIN_PATH)/arm-none-eabi-ar
GDB = $(TOOLCHAIN_PATH)/arm-none-eabi-gdb

# Directories
SRC_DIR = src
INC_DIR = include
BSP_DIR = bsp
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Source Files (to be populated)
C_SOURCES = $(wildcard $(SRC_DIR)/*.c) \
            $(wildcard $(BSP_DIR)/**/*.c)

ASM_SOURCES = $(wildcard $(BSP_DIR)/startup/*.s)

# Include Directories
INCLUDES = -I$(INC_DIR) \
           -I$(BSP_DIR) \
           -I$(BSP_DIR)/config \
           -I$(BSP_DIR)/drivers

# CPU and FPU Configuration for S32K358x (Cortex-M7)
CPU = -mcpu=cortex-m7
FPU = -mfpu=fpv5-d16
FLOAT_ABI = -mfloat-abi=hard

# Compile Flags
CFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
CFLAGS += -std=gnu11
CFLAGS += -Wall -Wextra -Werror
CFLAGS += -fdata-sections -ffunction-sections
CFLAGS += -fno-common -fno-builtin
CFLAGS += -g3 -O0  # Debug build (change to -Os or -O2 for release)
CFLAGS += $(INCLUDES)
CFLAGS += -D$(TARGET_MCU)

# C++ Flags
CXXFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
CXXFLAGS += -std=c++17
CXXFLAGS += -Wall -Wextra -Werror
CXXFLAGS += -fdata-sections -ffunction-sections
CXXFLAGS += -fno-exceptions -fno-rtti
CXXFLAGS += -g3 -O0
CXXFLAGS += $(INCLUDES)
CXXFLAGS += -D$(TARGET_MCU)

# Assembly Flags
ASFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
ASFLAGS += -g3

# Linker Flags (linker script to be added)
LDFLAGS = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)
LDFLAGS += -specs=nano.specs -specs=nosys.specs
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,--print-memory-usage
# LDFLAGS += -T$(BSP_DIR)/linker/S32K358_flash.ld  # Uncomment when linker script is available

# Object Files
OBJECTS = $(addprefix $(OBJ_DIR)/, $(notdir $(C_SOURCES:.c=.o)))
OBJECTS += $(addprefix $(OBJ_DIR)/, $(notdir $(ASM_SOURCES:.s=.o)))

# Output Files
ELF_FILE = $(BIN_DIR)/$(PROJECT_NAME).elf
HEX_FILE = $(BIN_DIR)/$(PROJECT_NAME).hex
BIN_FILE = $(BIN_DIR)/$(PROJECT_NAME).bin
MAP_FILE = $(BIN_DIR)/$(PROJECT_NAME).map

# VPATH for source file search
VPATH = $(SRC_DIR):$(BSP_DIR)

# Default Target
.PHONY: all
all: help

# Help Target
.PHONY: help
help:
	@echo "=========================================="
	@echo "  S32K3X Workspace Build System"
	@echo "=========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  build_all_tgt    - Build firmware for S32K3xx targets"
	@echo "  clean            - Remove build artifacts"
	@echo "  distclean        - Remove all generated files"
	@echo "  info             - Display build configuration"
	@echo "  help             - Display this help message"
	@echo ""
	@echo "Project: $(PROJECT_NAME)"
	@echo "Target MCU: $(TARGET_MCU)"
	@echo "Toolchain: $(TOOLCHAIN_PATH)"
	@echo ""

# Build All Targets
.PHONY: build_all_tgt
build_all_tgt: $(BIN_DIR) $(OBJ_DIR)
	@echo "=========================================="
	@echo "  Building S32K3XX Firmware"
	@echo "=========================================="
	@echo ""
	@echo "NOTE: This is a skeleton build. BSP and application sources need to be added."
	@echo ""
	@echo "Build configuration:"
	@echo "  - Target MCU: $(TARGET_MCU)"
	@echo "  - Compiler: $(CC)"
	@echo "  - Build directory: $(BUILD_DIR)"
	@echo ""
	@echo "To complete the build, the following components are needed:"
	@echo "  1. Startup code (reset handler, vector table)"
	@echo "  2. Linker script (memory layout for S32K358x)"
	@echo "  3. System initialization code"
	@echo "  4. Application source files"
	@echo ""
	@echo "Skeleton build structure created successfully!"
	@echo "Build directories: $(OBJ_DIR), $(BIN_DIR)"
	@echo ""

# Create Directories
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

# Compile C Sources
$(OBJ_DIR)/%.o: %.c
	@echo "Compiling: $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Compile C++ Sources
$(OBJ_DIR)/%.o: %.cpp
	@echo "Compiling: $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile Assembly Sources
$(OBJ_DIR)/%.o: %.s
	@echo "Assembling: $<"
	@$(AS) $(ASFLAGS) -c $< -o $@

# Link
$(ELF_FILE): $(OBJECTS)
	@echo "Linking: $(ELF_FILE)"
	@$(CC) $(LDFLAGS) -Wl,-Map=$(MAP_FILE) $(OBJECTS) -o $@
	@$(SIZE) $(ELF_FILE)

# Generate HEX
$(HEX_FILE): $(ELF_FILE)
	@echo "Creating HEX: $(HEX_FILE)"
	@$(OBJCOPY) -O ihex $(ELF_FILE) $(HEX_FILE)

# Generate BIN
$(BIN_FILE): $(ELF_FILE)
	@echo "Creating BIN: $(BIN_FILE)"
	@$(OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)

# Clean Build Artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete."

# Clean Everything
.PHONY: distclean
distclean: clean
	@echo "Removing all generated files..."
	@rm -rf $(BUILD_DIR)
	@echo "Distclean complete."

# Display Build Info
.PHONY: info
info:
	@echo "=========================================="
	@echo "  Build Configuration"
	@echo "=========================================="
	@echo "Project Name:    $(PROJECT_NAME)"
	@echo "Target MCU:      $(TARGET_MCU)"
	@echo "Toolchain Path:  $(TOOLCHAIN_PATH)"
	@echo ""
	@echo "Compiler:        $(CC)"
	@echo "C++ Compiler:    $(CXX)"
	@echo "Linker:          $(LD)"
	@echo "Objcopy:         $(OBJCOPY)"
	@echo "Size:            $(SIZE)"
	@echo ""
	@echo "CPU:             $(CPU)"
	@echo "FPU:             $(FPU)"
	@echo "Float ABI:       $(FLOAT_ABI)"
	@echo ""
	@echo "Source Dir:      $(SRC_DIR)"
	@echo "Include Dir:     $(INC_DIR)"
	@echo "BSP Dir:         $(BSP_DIR)"
	@echo "Build Dir:       $(BUILD_DIR)"
	@echo ""
	@echo "C Sources:       $(words $(C_SOURCES)) files"
	@echo "ASM Sources:     $(words $(ASM_SOURCES)) files"
	@echo ""

# Phony Targets
.PHONY: all clean distclean info help build_all_tgt
