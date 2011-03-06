/*
 *  BrickBreakerConfig.h
 *  BrickBreaker
 *
 *  Created by E528 on 2/17/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef BRICK_BREAKER_CONFIG_H
#define BRICK_BREAKER_CONFIG_H

// Set the frame rate here. 30 = default. 45 seems
// to be good. 60 if you're insane.
#define BB_FRAME_RATE 60

// Brick matrix size.
#define BB_WIDTH 5
#define BB_HEIGHT 4

// Physical world properties.
#define BB_GRAVITY_X 0
#define BB_GRAVITY_Y -9.81 // Earth's gravity.
#define BB_PTM 16 // How many pixels in a metre?

// Various strings.
#define BB_LOSE_STRING @"You just lost The Game."
#define BB_LIFEM_STRING @"AGH, IT BURNS!"
#define BB_WIN_STRING @"Wait, what? You won!?"

#endif