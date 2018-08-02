/*
 * (c) Copyright 2015  Florian Müller (contact@petrockblock.com)
 * https://github.com/petrockblog/ControlBlockService
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

#include <stdlib.h>
#include <plog/Log.h>
#include "PowerSwitch.h"
#include "GPIO.h"

const char* PowerSwitch::SHUTDOWNSCRIPT = "/etc/powerblockswitchoff.sh";

PowerSwitch::PowerSwitch(ShutdownActivated_e doShutdown) :
        doShutdown(SHUTDOWN_ACTIVATED)
{
    if (doShutdown == SHUTDOWN_ACTIVATED)
    {
        // RPI_STATUS signal
        GPIO::getInstance().setDirection(PIN_RPI_STATUS, GPIO::DIRECTION_OUT);

        // RPI_SHUTDOWN signal
        GPIO::getInstance().setDirection(PIN_RPI_SHUTDOWN, GPIO::DIRECTION_IN);
        GPIO::getInstance().setPullupMode(PIN_RPI_SHUTDOWN, GPIO::PULLDOWN_ENABLED);

        setPowerSignal(PowerSwitch::STATE_ON);
    }
}

void PowerSwitch::update()
{
    static bool isShutdownInitiated = false;

    if ((doShutdown == SHUTDOWN_ACTIVATED) && (getShutdownSignal() == SHUTDOWN_TRUE) && (!isShutdownInitiated))
    {
        LOG_INFO << "Shutdown signal observed. Executing shutdownscript " << SHUTDOWNSCRIPT << " and initiating shutdown.";
        system(SHUTDOWNSCRIPT);
        isShutdownInitiated = true;
    }
}

void PowerSwitch::setPowerSignal(PowerState_e state)
{
    if (state == STATE_OFF)
    {
        LOG_INFO << "Setting RPi status signal to LOW";
        GPIO::getInstance().write(PIN_RPI_STATUS, GPIO::LEVEL_LOW);
    }
    else
    {
        LOG_INFO << "Setting RPi status signal to HIGH";
        GPIO::getInstance().write(PIN_RPI_STATUS, GPIO::LEVEL_HIGH);
    }
}

PowerSwitch::ShutdownSignal_e PowerSwitch::getShutdownSignal()
{
    ShutdownSignal_e signal;
    if (GPIO::getInstance().read(PIN_RPI_SHUTDOWN) == GPIO::LEVEL_LOW)
    {
        signal = SHUTDOWN_FALSE;
    }
    else
    {
        signal = SHUTDOWN_TRUE;
    }
    return signal;
}
