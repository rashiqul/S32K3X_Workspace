# S32K3X Workspace

Embedded firmware development workspace for NXP S32K3xx microcontrollers, primarily targeting the **S32K358x** variant.

## Target Hardware

- **Microcontroller**: S32K358x (Cortex-M7 based)
- **Evaluation Board**: S32K3X8EVB-Q289
- **Board Info**: [NXP S32K3X8EVB-Q289 Product Page](https://www.nxp.com/design/design-center/development-boards-and-designs/S32K3X8EVB-Q289)

## Prerequisites

### Build Environment
- **OS**: Linux (Ubuntu 20.04+ recommended)
- **Python**: 3.10+ with Poetry for dependency management
- **Conan**: 2.x for cross-compilation dependencies
- **CMake**: 3.23+ 
- **Ninja**: Build system
- **Compiler**: ARM GCC 10.x (NXP toolchain)
  - Toolchain: `arm-none-eabi-gcc`
  - Set environment variable: `export NXP_GCC_PATH=/path/to/your/gcc-arm-none-eabi/bin`
  - Example: `export NXP_GCC_PATH=/home/user/NXP/gcc-10.2-arm32-eabi/bin`
- **Make**: GNU Make 4.2+
- **Git**: For version control

### Development Tools (Optional)
- **S32 Design Studio** (Windows) - For debugging and flashing
- **clang-format** - For code formatting
- **OpenOCD** or **SEGGER J-Link** - For target debugging

## Project Structure

```
S32K3x_workspace/
├── src/               # Application source code
├── include/           # Public header files
├── bsp/               # Board Support Package (BSP) files
│   ├── startup/       # Startup code and linker scripts
│   ├── drivers/       # Low-level peripheral drivers
│   └── config/        # MCU configuration files
├── build/             # Build output directory
│   ├── obj/           # Object files
│   └── bin/           # Binary files (.elf, .hex, .bin)
├── docs/              # Documentation
├── scripts/           # Build and utility scripts
├── Makefile           # Main build file
└── README.md          # This file
```

## Quick Start

### Setup

1. Install dependencies:
```bash
make setup
```

2. Set ARM GCC toolchain path:
```bash
export NXP_GCC_PATH=/path/to/your/gcc-arm-none-eabi/bin
```

### Building the Project

To build all targets for the S32K3xx microcontroller:

```bash
# Build firmware for ARM Cortex-M7 target
make build_all_tgt
```

### Build Targets

The Makefile provides the following targets:

**ARM Build Targets (for S32K358x):**
- `make build_all_tgt` - Build firmware for ARM Cortex-M7 target
- `make arm-clean` - Clean ARM build artifacts
- `make arm-info` - Display ARM build configuration

**X86 Build Targets (for development/testing):**
- `make configure` - Configure project with Conan/CMake
- `make build` - Build x86 Debug version
- `make build-release` - Build x86 Release version  
- `make test` - Run unit tests
- `make coverage` - Generate coverage reports

**Utility Targets:**
- `make clean` - Remove build artifacts
- `make clean-all` - Remove all artifacts (pristine state)
- `make help` - Display all available targets

### Build Outputs

Build artifacts are generated in the `build/` directory:
- `*.elf` - Executable and Linkable Format (for debugging)
- `*.hex` - Intel HEX format (for flashing)
- `*.bin` - Binary format (for OTA updates)
- `*.map` - Linker map file (memory layout)

## Development Workflow

### Linux (Build)
1. Make code changes in `src/` or `bsp/`
2. Run `make build_all_tgt` to compile
3. Check build outputs in `build/bin/`

### Windows (Debug & Flash)
1. Copy build artifacts from Linux to Windows (same repo clone)
2. Open project in S32 Design Studio
3. Flash and debug using S32 IDE with S32K3X8EVB-Q289 board

## BSP Integration

The Board Support Package (BSP) files will be integrated using **S32 Design Studio**.

**Recommended Approach**:
1. Create a Hello World project in S32 Design Studio for S32K358
2. Let S32DS auto-generate all BSP files (startup, linker, device headers)
3. Copy the generated BSP files to the `bsp/` directory
4. Update `bsp/CMakeLists.txt` to build the BSP library

For detailed instructions, see: [docs/BSP_INTEGRATION_GUIDE.md](docs/BSP_INTEGRATION_GUIDE.md)

**Required BSP Files**:
- **Startup Code**: Reset handler, vector table (`startup_s32k358.s`, `system_s32k358.c`)
- **Linker Scripts**: Memory layout for S32K358x (`s32k358_flash.ld`)
- **Device Headers**: Peripheral registers (`s32k358.h`, `system_s32k358.h`)
- **Peripheral Drivers**: GPIO, UART, CAN, ADC, PWM, etc. (optional, add as needed)

> **Note**: BSP files are being integrated from S32 Design Studio project generation.

## S32K358x Features

- **Core**: ARM Cortex-M7 @ 160 MHz
- **Flash**: Up to 4 MB
- **SRAM**: Up to 512 KB
- **Peripherals**: CAN-FD, FlexIO, ADC, LPSPI, LPUART, Ethernet, etc.
- **Packages**: LQFP176, LQFP144, MAPBGA289

## Compiler Configuration

The workspace uses the NXP ARM GCC toolchain with the following key flags:
- `-mcpu=cortex-m7` - Target Cortex-M7 core
- `-mthumb` - Use Thumb instruction set
- `-mfloat-abi=hard` - Hardware floating-point
- `-mfpu=fpv5-d16` - FPU configuration for Cortex-M7

## Known Issues & Future Work

- [ ] BSP integration (startup, linker scripts, drivers)
- [ ] Peripheral driver library
- [ ] Example applications (GPIO, UART, CAN, etc.)
- [ ] Unit testing framework
- [ ] CI/CD pipeline integration
- [ ] Windows debugging setup documentation

## Resources

- [S32K3 Reference Manual](https://www.nxp.com/docs/en/reference-manual/S32K3xxRM.pdf)
- [S32K3X8EVB-Q289 User Manual](https://www.nxp.com/docs/en/user-guide/S32K3XXEVB-UG.pdf)
- [ARM GCC Toolchain Documentation](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain)
- [S32 Design Studio](https://www.nxp.com/design/software/development-software/s32-design-studio-ide:S32-DESIGN-STUDIO-IDE)

## License

Copyright © 2026 Mohammad Rashiqul Alam. All rights reserved.

See [LICENSE](LICENSE) for details.

## Author

**Mohammad Rashiqul Alam**

## Contributing

This is a personal development workspace. For questions or issues, contact the repository owner.
