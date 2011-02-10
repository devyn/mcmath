//
//  BrickBreakerViewController.h
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrickBreakerViewController : UIViewController {
	UILabel *scoreLabel;
	UIImageView *ball;
	int score;
	
	CGPoint ballMovement;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *ball;

- (void)initializeTimer;
- (void)animateBall:(NSTimer *)theTimer;

@end

