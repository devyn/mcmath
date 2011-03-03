//
//  BrickBreakerViewController.h
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BrickBreakerConfig.h"

@interface BrickBreakerViewController : UIViewController {
	UILabel *scoreLabel;
	UILabel *livesLabel;
	UILabel *messageLabel;
	UIImageView *ball;
	UIImageView *paddle;
	UIImageView *bricks[BB_WIDTH][BB_HEIGHT];
	NSString *brickTypes[4];
	
	int score;
	int lives;
	
	CGPoint ballMovement;
	float touchOffset;
	
	BOOL isPlaying;
	BOOL wbreset;
	NSTimer *theTimer;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *livesLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UIImageView *ball;
@property (nonatomic, retain) IBOutlet UIImageView *paddle;

- (void)startPlaying;
- (void)pauseGame;

- (IBAction)restartGame:(id)sender;
- (IBAction)doPauseGame:(id)sender;

@end

