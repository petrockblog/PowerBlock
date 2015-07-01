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

#ifndef POWERBLOCKCONFIGURATION_H
#define POWERBLOCKCONFIGURATION_H

#include <json/json.h>

class PowerBlockConfiguration
{
 public:
    enum ShutdownType_e
    {
        SHUTDOWN_DEACTIVATED = 0,
        SHUTDOWN_ACTIVATED
    };

    PowerBlockConfiguration();
    ~PowerBlockConfiguration();

    void initialize();
    ShutdownType_e getShutdownActivation() const;

 private:
    ShutdownType_e doShutdown;
};

#endif
