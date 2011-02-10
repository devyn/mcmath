//
//  BrickBreakerViewController.m
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BrickBreakerViewController.h"

@implementation BrickBreakerViewController
@synthesize scoreLabel;
@synthesize ball;


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
	ballMovement.x = 4;
	ballMovement.y = 4;
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
	float theInterval = 1.0/30.0;
	[NSTimer scheduledTimerWithTimeInterval:theInterval target:self
								   selector:@selector(animateBall:)
								   userInfo:nil repeats:YES];
}

- (void)animateBall:(NSTimer *)theTimer
{
	ball.center = CGPointMake(ball.center.x+ballMovement.x, ball.center.y+ballMovement.y);
	
	if (ball.center.x > 300 || ball.center.x < 20)
		ballMovement.x = -ballMovement.x;
	
	if (ball.center.y > 440 || ball.center.y < 40)
		ballMovement.y = -ballMovement.y;
}

- (void)dealloc {
	[scoreLabel release];
	[ball release];
    [super dealloc];
}

@end
