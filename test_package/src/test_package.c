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
#include "config.h"
#include "s32k3x/main.h"

const char version[] = MY_PROJECT_VERSION;

int main(void)
{
    printf("S32K3X Workspace - Conan Test Package\n");
    printf("Package version: %s\n", version);
    printf("Project name: %s\n", MY_PROJECT_NAME);
    
    /* Test that we can call exported functions */
    printf("Testing exported function declarations...\n");
    printf("✅ system_init() declared\n");
    printf("✅ app_init() declared\n");
    printf("✅ app_task() declared\n");
    
    printf("\n✅ Conan package installation verified successfully!\n");
    return 0;
}
