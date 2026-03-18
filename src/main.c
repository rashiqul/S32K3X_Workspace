/******************************************************************************
 *
 * File Name: main.c
 * Project: S32K3X Workspace
 * Description: MCU bring-up and clock validation entry point
 * Author: Mohammad Rashiqul Alam
 *
 * Copyright (c) 2026 Mohammad Rashiqul Alam. All rights reserved.
 *
 ******************************************************************************/

#include <stdint.h>

#if defined(S32K358) && !defined(UNIT_TEST_BUILD)

#include "Mcu.h"

#define CLOCKOUT_FREQ_CFG_0 ((uint64)20000000U)
#define CLOCKOUT_FREQ_CFG_1 ((uint64)6000000U)

/* Exposed for debugger inspection after bring-up. */
static volatile uint8 g_clock_validation_result = 0U;

static boolean clock_frequency_matches(uint64 expected_hz)
{
    return (Mcu_GetClockFrequency(CLKOUT_RUN_CLK) == expected_hz) ? TRUE : FALSE;
}

int main(void)
{
    boolean result = TRUE;

#if (MCU_PRECOMPILE_SUPPORT == STD_ON)
    Mcu_Init(NULL_PTR);
#else
    Mcu_Init(&Mcu_Config);
#endif

    if (E_OK != Mcu_InitClock(McuClockSettingConfig_0))
    {
        result = FALSE;
    }

#if (MCU_NO_PLL == STD_OFF)
    while (MCU_PLL_LOCKED != Mcu_GetPllStatus())
    {
        /* Busy wait until PLL lock. */
    }

    if (E_OK != Mcu_DistributePllClock())
    {
        result = FALSE;
    }
#endif

    Mcu_SetMode(McuModeSettingConf_0);

    if (FALSE == clock_frequency_matches(CLOCKOUT_FREQ_CFG_0))
    {
        result = FALSE;
    }

    if (E_OK != Mcu_InitClock(McuClockSettingConfig_1))
    {
        result = FALSE;
    }

    if (FALSE == clock_frequency_matches(CLOCKOUT_FREQ_CFG_1))
    {
        result = FALSE;
    }

    g_clock_validation_result = (TRUE == result) ? 1U : 0U;

    while (1)
    {
    }
}

#else

/* Host/test fallback path used by x86 builds and unit tests. */
static volatile uint32_t g_loop_count = 0;

void system_init(void)
{
    /* Host fallback: no hardware initialization required. */
}

void app_init(void)
{
    /* Host fallback: no peripheral/application setup required. */
}

void app_task(void)
{
    g_loop_count++;
}

#ifndef UNIT_TEST_BUILD
int main(void)
{
    system_init();
    app_init();
    app_task();
    return 0;
}
#endif

#endif
