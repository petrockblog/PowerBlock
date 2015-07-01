/*
 * (c) Copyright 2015  Florian Müller (contact@petrockblock.com)
 * https://github.com/petrockblog/PowerBlock
 *
 * Permission to use, copy, modify and distribute the program in both binary and
 * source form, for non-commercial purposes, is hereby granted without fee,
 * providing that this license information and copyright notice appear with
 * all copies and any derived work.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event shall the authors be held liable for any damages
 * arising from the use of this software.
 *
 * This program is freeware for PERSONAL USE only. Commercial users must
 * seek permission of the copyright holders first. Commercial use includes
 * charging money for the program or software derived from the program.
 *
 * The copyright holders request that bug fixes and improvements to the code
 * should be forwarded to them so everyone can benefit from the modifications
 * in future versions.
 */

#ifndef POWERSWITCH_H
#define POWERSWITCH_H

#include <stdint.h>

class PowerSwitch
{
 public:
    typedef enum { STATE_OFF = 0, STATE_ON } PowerState_e;

    typedef enum { SHUTDOWN_TRUE = 0, SHUTDOWN_FALSE } ShutdownSignal_e;

    typedef enum
    {
        SHUTDOWN_ACTIVATED = 0,
        SHUTDOWN_DEACTIVATED
    } ShutdownActivated_e;

    explicit PowerSwitch(ShutdownActivated_e doShutdown);
    ~PowerSwitch();

    void update();

 private:
    ShutdownActivated_e doShutdown;

    const uint16_t PIN_RPI_STATUS = 17;
    const uint16_t PIN_RPI_SHUTDOWN = 18;

    void setPowerSignal(PowerState_e state);
    ShutdownSignal_e getShutdownSignal();
};

#endif
