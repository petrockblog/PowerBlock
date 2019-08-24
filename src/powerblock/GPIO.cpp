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

#include "GPIO.h"

#include <iostream>

GPIO::GPIO() {
//  wiringPiSetupGpio();
}

GPIO::~GPIO() {
#ifdef DEBUG
  std::cout << "GPIO: Destructor called." << std::endl;
#endif
}

void GPIO::setDirection(uint16_t pin, Direction_e direction) {
  if (direction == DIRECTION_OUT) {
//      pinMode(pin, OUTPUT);
  } else if (direction == DIRECTION_IN) {
//      pinMode(pin, INPUT);
  }
}

void GPIO::setPullupMode(uint16_t pin, PullupMode_e mode) {
  if (mode == PULLUP_ENABLED) {
//      pullUpDnControl(pin, PUD_UP);
  } else {
//      pullUpDnControl(pin, PUD_OFF);
  }
}

GPIO::Level_e GPIO::read(uint16_t pin) {
//  return (digitalRead((uint8_t) pin) == HIGH) ? LEVEL_HIGH : LEVEL_LOW;
  return LEVEL_LOW;
}

void GPIO::write(uint16_t pin, GPIO::Level_e level) {
//  digitalWrite((uint8_t) pin, level == LEVEL_LOW ? LOW : HIGH);
}
