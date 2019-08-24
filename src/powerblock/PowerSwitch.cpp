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
#include <iostream>
#include <stdint.h>
#include <plog/Log.h>

#include "PowerSwitch.h"
#include "GPIO.h"

const char *PowerSwitch::SHUTDOWNSCRIPT = "/etc/powerblockswitchoff.sh &";

PowerSwitch::PowerSwitch(ShutdownActivated_e doShutdown, uint16_t _statusPin, uint16_t _shutdownPin) :
    doShutdown_(SHUTDOWN_ACTIVATED),
    statusPin_(17),
    shutdownPin_(18),
    shutdownInitiated_(false) {
  statusPin_ = _statusPin;
  shutdownPin_ = _shutdownPin;

  if (doShutdown == SHUTDOWN_ACTIVATED) {
    statusPin_port_ = std::make_shared<OutputPort>(statusPin_);
    shutdownPin_port_ = std::make_shared<InputPort>(shutdownPin_);

//    // RPI_STATUS signal
//    GPIO::getInstance().setDirection(statusPin_, GPIO::DIRECTION_OUT);
//
//    // RPI_SHUTDOWN signal
//    GPIO::getInstance().setDirection(shutdownPin_, GPIO::DIRECTION_IN);
//    GPIO::getInstance().setPullupMode(shutdownPin_, GPIO::PULLDOWN_ENABLED);

    setPowerSignal(PowerSwitch::STATE_ON);
  }
}

bool PowerSwitch::update() {
  if ((doShutdown_ == SHUTDOWN_ACTIVATED) && (getShutdownSignal() == SHUTDOWN_TRUE) && (!shutdownInitiated_)) {
    LOG_INFO << "Shutdown signal observed. Executing shutdownscript " << SHUTDOWNSCRIPT << " and initiating shutdown.";
    system(SHUTDOWNSCRIPT);
    shutdownInitiated_ = true;
  }
  return shutdownInitiated_;
}

void PowerSwitch::setPowerSignal(PowerState_e state) {
  if (state == STATE_OFF) {
    LOG_INFO << "Setting RPi status signal to LOW";
//    GPIO::getInstance().write(statusPin_, GPIO::LEVEL_LOW);
    statusPin_port_->Write(false);
  } else {
    LOG_INFO << "Setting RPi status signal to HIGH";
//    GPIO::getInstance().write(statusPin_, GPIO::LEVEL_HIGH);
    statusPin_port_->Write(true);
  }
}

PowerSwitch::ShutdownSignal_e PowerSwitch::getShutdownSignal() {
  ShutdownSignal_e signal;
//  if (GPIO::getInstance().read(shutdownPin_) == GPIO::LEVEL_LOW) {
  if (!shutdownPin_port_->Read()) {
    signal = SHUTDOWN_FALSE;
  } else {
    signal = SHUTDOWN_TRUE;
  }
  return signal;
}
