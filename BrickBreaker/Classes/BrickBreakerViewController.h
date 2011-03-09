//
//  BrickBreakerViewController.h
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "stdlib.h"
#include "BrickBreakerConfig.h"
#import <Box2D/Box2D.h>
#import "BBContactListener.h"

struct BBObject {
	int magic; // BB_MAGIC
	int type;  // BB_OBJ_*
	union {
		struct {
			int x;
			int y;
		} brick;
	} value;
};

BBObject *ud_obj(int type);
BOOL      ud_detect(void *obj);
BBObject *ud_brick(int x, int y);

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
	int bricksRemaining;
	
	BOOL isPlaying;
	BOOL wbreset;
	NSTimer *theTimer;
	NSTimer *graphicalTimer;
	
	// physical entities
	
	b2World *world;
	b2Body *boxBody;
	b2Body *paddleBody;
	b2Body *ballBody;
	b2Body *brickBodies[BB_WIDTH][BB_HEIGHT];
	b2Fixture *brickFixtures[BB_WIDTH][BB_HEIGHT];
	b2MouseJoint *mouseJoint;
	
	b2Vec2 _iPaddlePos;
	b2Vec2 _iBallPos;
	
	BBContactListener *contactListener;
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

