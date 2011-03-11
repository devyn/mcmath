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
#define BB_WIDTH 10
#define BB_HEIGHT 6

// Initial properties.
#define BB_INITIAL_BRICK_VALUE 10
#define BB_INITIAL_BOUNCINESS 0.2f

// Brick value bonuses.
#define BB_BONUS_CHAIN1 5
#define BB_BONUS_CHAIN2 20

// Physical world properties.
#define BB_GRAVITY_X 0
#define BB_GRAVITY_Y -9.81 // Earth's gravity.
#define BB_PTM 16 // How many pixels in a metre?

// Various strings.
#define BB_LOSE_STRING1      @"LOL nub. You lost The Game."
#define BB_LOSE_STRING2      @"(Touch to try again, though!)"

#define BB_LIFEM_STRING1     @"がんばってください！"
#define BB_LIFEM_STRING2     @"(Keep trying!)"

#define BB_WIN_STRING1       @"Well, great!"
#define BB_WIN_STRING2       @"(Now try to get 10,000 score.)"

#define BB_WIN_10000_STRING1 @"NO! You must get 20,000 score."
#define BB_WIN_10000_STRING2 @""

#define BB_WIN_20000_STRING1 @"I could do that in my sleep."
#define BB_WIN_20000_STRING2 @"Try for 30,000."

#define BB_WIN_30000_STRING1 @"とても簡単だ！ Easy!"
#define BB_WIN_30000_STRING2 @"(You need to get 40,000!)"

#define BB_WIN_40000_STRING1 @"御目出度うございます！ Really, gratz."
#define BB_WIN_40000_STRING2 @"(If you get 50,000, I'll go insane.)"

#define BB_WIN_50000_STRING1 @"43 72 61 70 2e 20"
#define BB_WIN_50000_STRING2 @"57 68 61 74 20 74 68 65 20 68 65 6c 6c 2c 20 6d 61 6e 3f"

// I very much doubt this will happen to anyone, but in case it does, best be prepared.
#define BB_1337_STRING1      @"g0 d13, n00b."
#define BB_1337_STRING2      @"j00r |/|0t w3|_C0|\\/|e |-|3r3 4nY|\\/|0aR!"

// Object types.
#define BB_MAGIC      0x1337F00D
#define BB_OBJ_BALL   0x1
#define BB_OBJ_PADDLE 0x2
#define BB_OBJ_BRICK  0x3
#define BB_OBJ_GROUND 0x4

// Debugging. (Really, this means cheats. xD)
//#define BB_AUTOWIN 50000

#endif