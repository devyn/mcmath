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
	UIImageView *ball;
	UIImageView *paddle;
	
	int score;
	
	CGPoint ballMovement;
	float touchOffset;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *ball;
@property (nonatomic, retain) IBOutlet UIImageView *paddle;

- (void)initializeTimer;
- (void)animateBall:(NSTimer *)theTimer;

@end
