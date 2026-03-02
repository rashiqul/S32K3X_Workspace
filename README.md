# S32K3X Workspace

Embedded firmware development workspace for NXP S32K3xx microcontrollers, primarily targeting the **S32K358x** variant.

## Target Hardware

- **Microcontroller**: S32K358x (Cortex-M7 based)
- **Evaluation Board**: S32K3X8EVB-Q289
- **Board Info**: [NXP S32K3X8EVB-Q289 Product Page](https://www.nxp.com/design/design-center/development-boards-and-designs/S32K3X8EVB-Q289)

## Prerequisites

### Build Environment
- **OS**: Linux (Ubuntu 20.04+ recommended)
- **Compiler**: ARM GCC 10.2 (NXP toolchain)
  - Location: `/home/rashiqul/NXP/gcc-10.2-arm32-eabi/bin`
  - Toolchain: `arm-none-eabi-gcc`
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

### Building the Project

To build all targets for the S32K3xx microcontroller:

```bash
# Build all targets (generates .elf, .hex, .bin)
make build_all_tgt
```

### Build Targets

The Makefile provides the following targets:

- `make build_all_tgt` - Build the complete firmware for S32K3xx targets
- `make clean` - Remove build artifacts
- `make help` - Display available targets

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

The Board Support Package (BSP) will include:
- **Startup Code**: Reset handler, vector table, system initialization
- **Linker Scripts**: Memory layout for S32K358x (Flash/RAM regions)
- **Peripheral Drivers**: GPIO, UART, CAN, ADC, PWM, etc.
- **Clock Configuration**: PLL, clock gating, and system clocks
- **CMSIS**: ARM Cortex Microcontroller Software Interface Standard

> **Note**: BSP components will be integrated incrementally as the project evolves.

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
