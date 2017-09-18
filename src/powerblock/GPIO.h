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

#ifndef GPIO_H_
#define GPIO_H_

#include "stdint.h"

class GPIO
{
public:
    typedef enum
    {
        LEVEL_LOW = 0, LEVEL_HIGH, LEVEL_UNAVAILABLE
    } Level_e;

    typedef enum
    {
        DIRECTION_IN = 0, DIRECTION_OUT
    } Direction_e;

    typedef enum
    {
        PULLUP_ENABLED = 0, PULLDOWN_ENABLED, PULLUPDOWN_DISABLED
    } PullupMode_e;

    virtual ~GPIO();

    static GPIO& getInstance()
    {
        static GPIO instance = GPIO();
        return instance;
    }

    void setDirection(uint16_t pin, Direction_e direction);
    void setPullupMode(uint16_t pin, PullupMode_e mode);
    Level_e read(uint16_t pin);
    void write(uint16_t pin, Level_e level);

private:
    static bool isBCM2835Initialized;

    GPIO();
};

#endif
