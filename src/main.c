/******************************************************************************
 *
 * File Name: main.c
 * Project: S32K3X Workspace
 * Description: Main application entry point
 * Author: Mohammad Rashiqul Alam
 *
 * Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
 *
 ******************************************************************************/

#include <stdint.h>

/* Application loop counter for testing */
static volatile uint32_t g_loop_count = 0;

/**
 * @brief Initialize system hardware (placeholder)
 */
void system_init(void)
{
    /* System initialization will be added here */
    /* Clock configuration */
    /* Peripheral initialization */
}

/**
 * @brief Application initialization (placeholder)
 */
void app_init(void)
{
    /* Application-specific initialization */
}

/**
 * @brief Main application task (placeholder)
 */
void app_task(void)
{
    /* Main application logic */
    g_loop_count++;
}

/**
 * @brief Main function - Entry point for the application
 *
 * For S32K358x (ARM Cortex-M7): Runs in infinite loop
 * For x86 testing: Compiled out when UNIT_TEST_BUILD is defined
 *
 * @return Should never return in embedded systems
 */
#ifndef UNIT_TEST_BUILD
int main(void)
{
    /* System initialization */
    system_init();

    /* Initialize peripherals */
    app_init();

#ifdef S32K358
    /* Embedded target - infinite loop */
    while (1) {
        app_task();
    }
#else
    /* Testing on x86 - run once and return for testability */
    app_task();
    return 0;
#endif
}
#endif /* UNIT_TEST_BUILD */
