//
//  BrickBreakerViewController.m
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BrickBreakerViewController.h"

@interface BrickBreakerViewController (Private)

- (void)handlePaddleCollision;

@end


@implementation BrickBreakerViewController
@synthesize scoreLabel;
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
	[self initializeTimer];
	
	float m = 120/BB_FRAME_RATE; // 4 at 30fps.
	ballMovement = CGPointMake(m,m);
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

- (void)initializeTimer
{
	float theInterval = 1.0/BB_FRAME_RATE;
	[NSTimer scheduledTimerWithTimeInterval:theInterval target:self
								   selector:@selector(animateBall:)
								   userInfo:nil repeats:YES];
}

- (void)animateBall:(NSTimer *)theTimer
{
	ball.center = CGPointMake(ball.center.x+ballMovement.x, ball.center.y+ballMovement.y);
	
	[self handlePaddleCollision];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	touchOffset = paddle.center.x - [touch locationInView:touch.view].x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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

- (void)dealloc {
	[scoreLabel release];
	[ball release];
	[paddle release];
    [super dealloc];
}

@end

@implementation BrickBreakerViewController (Private)



- (void)handlePaddleCollision {
	BOOL paddleCollision =
	ball.center.y >= paddle.center.y - 16 &&
	ball.center.y <= paddle.center.y + 16 &&
	ball.center.x >  paddle.center.x - 32 &&
	ball.center.x <  paddle.center.x + 32;
	
	//NSLog(@"paddle collision? %d", (int)paddleCollision);
	
	if (paddleCollision)
	{
		ballMovement.y = -ballMovement.y; // reverses the direction
		if (ball.center.y >= paddle.center.y - 16
			&& ballMovement.y < 0)
		{
			ball.center = CGPointMake(ball.center.x, paddle.center.y - 16);
		}
		else if (ball.center.y <= paddle.center.y + 16
				 && ballMovement.y > 0)
		{
			ball.center = CGPointMake(ball.center.x, paddle.center.y + 16);
		}
		else if (ball.center.x >= paddle.center.x - 32
				 && ballMovement.x < 0)
		{
			ball.center = CGPointMake(ball.center.x - 32, paddle.center.y);
		}
		else if (ball.center.x <= paddle.center.x + 32
				 && ballMovement.x > 0)
		{
			ball.center = CGPointMake(ball.center.x + 32, paddle.center.y);
		}
	}
	
	if (ball.center.x > 300 || ball.center.x < 20)
		ballMovement.x = -ballMovement.x;
	
	if (ball.center.y > 440 || ball.center.y < 40)
		ballMovement.y = -ballMovement.y;
}

@end

