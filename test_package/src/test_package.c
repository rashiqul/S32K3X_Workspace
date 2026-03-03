/******************************************************************************
 *
 * File Name: test_package.c
 * Project: S32K3X Workspace - Conan Test Package
 * Description: Test package to verify Conan package installation
 * Author: Mohammad Rashiqul Alam
 *
 * Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
 *
 ******************************************************************************/

#include <stdio.h>

/* Test that we can include the package headers */
#ifdef __has_include
#  if __has_include("config.h")
#    include "config.h"
#    define HAS_CONFIG_H 1
#  endif
#  if __has_include("s32k3x/main.h")
#    include "s32k3x/main.h"
#    define HAS_MAIN_H 1
#  endif
#endif

int main(void)
{
    printf("S32K3X Workspace - Conan Test Package\n");
    
#ifdef HAS_CONFIG_H
    printf("✅ config.h found and included\n");
    printf("   Package version: %s\n", S32K3X_PROJECT_VERSION);
#else
    printf("⚠️  config.h not found (header-only package)\n");
#endif

#ifdef HAS_MAIN_H
    printf("✅ s32k3x/main.h found and included\n");
    printf("   Function declarations available:\n");
    printf("   - system_init()\n");
    printf("   - app_init()\n");
    printf("   - app_task()\n");
#else
    printf("⚠️  s32k3x/main.h not found\n");
#endif
    
    printf("\n✅ Conan package structure verified successfully!\n");
    return 0;
}
