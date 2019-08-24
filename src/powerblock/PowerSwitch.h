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

#include "OutputPort.h"
#include "InputPort.h"


/**
 * This class implements the functionality of a physical power switch.
 */
class PowerSwitch
{
public:
    /**
     * Power state indicator values
     */
    enum PowerState_e
    {
        STATE_OFF = 0,  //!< Off state
        STATE_ON        //!< On state
    };

    /**
     * Signal levels of the shutdown signal
     */
    enum ShutdownSignal_e
    {
        SHUTDOWN_TRUE = 0,  //!< Logical high/true
        SHUTDOWN_FALSE      //!< Logical low/false
    };

    /**
     * Status indicators of the shutdown activation
     */
    enum ShutdownActivated_e
    {
        SHUTDOWN_ACTIVATED = 0, SHUTDOWN_DEACTIVATED
    };

    /**
     * Constructor
     * @param doShutdown Indicates whether the power switch should update its state (=true) or not (=false)
     */
    explicit PowerSwitch(ShutdownActivated_e doShutdown, uint16_t statusPin, uint16_t shutdownPin);

    /**
     * Destructor
     */
    ~PowerSwitch() = default;

    /**
     * Read the signal level of the power switch and udpate internal state
     */
    bool update();

private:
    static const char* SHUTDOWNSCRIPT;

    uint16_t statusPin_;     //!< BCM pin number of the status signal pin
    uint16_t shutdownPin_;   //!< BCM pin number of the shutdown signal pin
    bool shutdownInitiated_;
    ShutdownActivated_e doShutdown_;  //!< State of the shutdown activation
    std::shared_ptr<OutputPort> statusPin_port_;
    std::shared_ptr<InputPort> shutdownPin_port_;

    /**
     * Sets the given level of the shutdown signal
     * @param state The target state of signal level
     */
    void setPowerSignal(PowerState_e state);

    /**
     * Gets the level of the shutdown signal
     * @return
     *  - SHUTDOWN_FALSE, if the signal level is logical low,
     *  - SHUTDOWN_TRUE, otherwise.
     */
    ShutdownSignal_e getShutdownSignal();
};

#endif
