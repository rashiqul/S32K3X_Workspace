/******************************************************************************
 *
 * File Name: main.h
 * Project: S32K3X Workspace
 * Description: Main application header file
 * Author: Mohammad Rashiqul Alam
 *
 * Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
 *
 ******************************************************************************/

#ifndef S32K3X_MAIN_H
#define S32K3X_MAIN_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Initialize system hardware
 */
void system_init(void);

/**
 * @brief Application initialization
 */
void app_init(void);

/**
 * @brief Main application task
 */
void app_task(void);

/**
 * @brief Main function entry point
 * @return 0 on success (x86 only), never returns on embedded target
 */
int main(void);

#ifdef __cplusplus
}
#endif

#endif /* S32K3X_MAIN_H */
