//
//  BrickBreakerViewController.m
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BrickBreakerViewController.h"

@interface BrickBreakerViewController (Private)

- (void)initializeTimer;
- (void)initializeBricks;
- (void)gameLogic;

@end


@implementation BrickBreakerViewController
@synthesize scoreLabel;
@synthesize livesLabel;
@synthesize messageLabel;
@synthesize ball;
@synthesize paddle;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self initializeBricks];
	[self startPlaying];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isPlaying) {
		UITouch *touch = [[event allTouches] anyObject];
		touchOffset = paddle.center.x - [touch locationInView:touch.view].x;
	} else {
		[self startPlaying];
	}

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isPlaying) {
		UITouch *touch = [[event allTouches] anyObject];
		
		float distanceMoved =
			([touch locationInView:touch.view].x
			   + touchOffset) - paddle.center.x;
		
		float newX = paddle.center.x + distanceMoved;
		
		if (newX > 30 && newX < 290)
			paddle.center = CGPointMake(newX, paddle.center.y);
		if (newX > 290)
			paddle.center = CGPointMake(290, paddle.center.y);
		if (newX < 30)
			paddle.center = CGPointMake(30, paddle.center.y);
	}
}

- (void)startPlaying
{
	if (!lives) {
		lives = 3;
		score = 0;
	} else {
		scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
		livesLabel.text = [NSString stringWithFormat:@"%d", lives];
		
		ball.center = CGPointMake(159, 239);
		
		float m = 120/BB_FRAME_RATE; // 4 at 30fps.
		ballMovement = CGPointMake(m,m);
		
		if(arc4random() % 100 < 50)
			ballMovement.x = -ballMovement.x;
		messageLabel.hidden = YES;
		isPlaying = YES;
		[self initializeTimer];
	}
}

- (void) pauseGame
{
	[theTimer invalidate];
	theTimer = nil;
}


- (void)dealloc {
	[scoreLabel release];
	[livesLabel release];
	[messageLabel release];
	[ball release];
	[paddle release];
    [super dealloc];
}

@end

@implementation BrickBreakerViewController (Private)

- (void)initializeTimer
{
	if (theTimer == nil) {
		float theInterval = 1.0/BB_FRAME_RATE;
		theTimer = [NSTimer 
					scheduledTimerWithTimeInterval:theInterval
					target:self
					selector:@selector(gameLogic)
					userInfo:nil repeats:YES];
	}
}

- (void)initializeBricks
{
	for (int i=0; i<4; i++)
		brickTypes[i] = [NSString stringWithFormat:@"bricktype%d.png", i+1];
	int count = 0;
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			UIImage *image = [UIImage imageNamed:brickTypes[count++ % 4]];
			bricks[x][y] = [[[UIImageView alloc] initWithImage:image] autorelease];
			CGRect newFrame = bricks[x][y].frame;
			newFrame.origin = CGPointMake(x*64, (y*40) + 50);
			bricks[x][y].frame = newFrame;
			[self.view addSubview:bricks[x][y]];
		}
	}
}

- (void)gameLogic
{
	ball.center = CGPointMake(ball.center.x+ballMovement.x, ball.center.y+ballMovement.y);
	BOOL paddleCollision =
		 ball.center.y >= paddle.center.y - 16 &&
		 ball.center.y <= paddle.center.y + 16 &&
		 ball.center.x >  paddle.center.x - 32 &&
		 ball.center.x <  paddle.center.x + 32;
	
	if (paddleCollision)
		ballMovement.y = -ballMovement.y;
	
	BOOL there_are_solid_bricks = NO;
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			if (bricks[x][y].alpha == 1.0) {
				there_are_solid_bricks = YES;
				if (CGRectIntersectsRect(ball.frame, bricks[x][y].frame))
				{
					score += 10;
					scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
					ballMovement.y = -ballMovement.y;
					ballMovement.x = -ballMovement.x;
					bricks[x][y].alpha -= 0.1;
				} else {
					if (bricks[x][y].alpha > 0)
						bricks[x][y].alpha -= 0.1;
				}
			}
		}
	}
	
	if (!there_are_solid_bricks) {
		[self pauseGame];
		lives = 0;
		messageLabel.text = BB_WIN_STRING;
		messageLabel.hidden = NO;
		return;
	}
	
	if (ball.center.x > 310 || ball.center.x < 16)
		ballMovement.x = -ballMovement.x;
	
	if (ball.center.y < 32)
		ballMovement.y = -ballMovement.y;
	
	if (ball.center.y > 444) {
		[self pauseGame];
		isPlaying = NO;
		lives--;
		livesLabel.text = [NSString stringWithFormat:@"%d", lives];
		
		if (!lives) {
			messageLabel.text = BB_LOSE_STRING;
		} else {
			messageLabel.text = BB_LIFEM_STRING;
		}
		
		messageLabel.hidden = NO;
	}
}

@end

