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

#include <stdio.h>
#include <iostream>
#include <thread>
#include <chrono>
#include <signal.h>

#include <bcm2835.h>
#include "PowerBlock.h"
#include "version.h"

static volatile sig_atomic_t doRun = 1;

extern "C" {
void sig_handler(int signo)
{
    if ((signo == SIGINT) | (signo == SIGQUIT) | (signo == SIGABRT) | (signo == SIGTERM))
    {
        std::cout << "[PowerBlock] Releasing input devices." << std::endl;
        doRun = 0;
    }
}
}

void register_signalhandlers()
{
    /* Register signal handlers  */
    if (signal(SIGINT, sig_handler) == SIG_ERR)
    {
        std::cout << std::endl << "[PowerBlock] Cannot catch SIGINT" << std::endl;
    }
    if (signal(SIGQUIT, sig_handler) == SIG_ERR)
    {
        std::cout << std::endl << "[PowerBlock] Cannot catch SIGQUIT" << std::endl;
    }
    if (signal(SIGABRT, sig_handler) == SIG_ERR)
    {
        std::cout << std::endl << "[PowerBlock] Cannot catch SIGABRT" << std::endl;
    }
    if (signal(SIGTERM, sig_handler) == SIG_ERR)
    {
        std::cout << std::endl << "[PowerBlock] Cannot catch SIGTERM" << std::endl;
    }
}

int main(int argc, char** argv)
{
    std::cout << std::endl << "[PowerBlock] Starting driver, version " << VERSION_MAJOR << "." << VERSION_MINOR << "." << VERSION_PATCH << std::endl;

    register_signalhandlers();

    PowerBlock powerBlock = PowerBlock();
    while (doRun)
    {
        powerBlock.update();
        bcm2835_delay(500);
    }

    return 0;
}
