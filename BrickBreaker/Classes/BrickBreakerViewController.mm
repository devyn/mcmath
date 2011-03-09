//
//  BrickBreakerViewController.m
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BrickBreakerViewController.h"

// helpers

void BoxShape(b2Body *body, double left, double top, double width, double height) {
	b2EdgeShape shape;
	// bottom
	shape.Set(b2Vec2(left,top), b2Vec2(left+width,top));
	body->CreateFixture(&shape, 0);
	// top
	shape.Set(b2Vec2(left,top+height), b2Vec2(left+width, top+height));
	body->CreateFixture(&shape, 0);
	// left
	shape.Set(b2Vec2(left,top+height), b2Vec2(left,top));
	body->CreateFixture(&shape, 0);
	// right
	shape.Set(b2Vec2(left+width,top+height), b2Vec2(left+width,top));
	body->CreateFixture(&shape, 0);
}

@interface BrickBreakerViewController (Private)

- (void)initializeTimer;
- (void)initializeBricks;
- (void)initializePhysics;
- (void)doMoveMouse:(NSSet *)touches;
- (void)resetBricks;
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
	
	/* set background image */
	self.view.backgroundColor =
		[UIColor colorWithPatternImage:
		 [UIImage imageNamed:@"background.png"]];
	
	/* game initialization */
	[self initializeBricks];
	[self initializePhysics];
	wbreset = YES;
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
	if (isPlaying) [self doMoveMouse:touches];
	else {
		[self startPlaying];
		[self doMoveMouse:touches];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isPlaying) [self doMoveMouse:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isPlaying/* && mouseJoint*/) {
		world->DestroyJoint(mouseJoint);
		mouseJoint = NULL;
	}
}

- (void)startPlaying
{
	if (!isPlaying) {
		if (!lives) {
			lives = 3;
			score = 0;
			[self resetBricks];
		}
		scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
		livesLabel.text = [NSString stringWithFormat:@"%d", lives];
		
		if (wbreset) {
			ball.center = CGPointMake(159, 239);
			wbreset = NO;
			
			float m = 120/BB_FRAME_RATE; // 4 at 30fps.
			ballMovement = CGPointMake(m,m);
			
			if(arc4random() % 100 < 50)
				ballMovement.x = -ballMovement.x;
		}
		
		messageLabel.hidden = YES;
		isPlaying = YES;
		[self initializeTimer];
	}
}

- (void) pauseGame
{
	isPlaying = NO;
	[theTimer invalidate];
	theTimer = nil;
}

- (IBAction)restartGame:(id)sender
{
	messageLabel.hidden = YES;
	[self pauseGame];
	lives = 0;
	wbreset = YES;
	[self startPlaying];
}

- (IBAction)doPauseGame:(id)sender
{
	[self pauseGame];
}

- (void)dealloc {
	[theTimer invalidate]; [theTimer release];
	[scoreLabel release];
	[livesLabel release];
	[messageLabel release];
	[ball release];
	[paddle release];
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			[(bricks[x][y]) release];
		}
	}
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

- (void)initializePhysics
{
	CGSize screenSize = self.view.bounds.size;
	
	// Define gravity.
	b2Vec2 gravity;
	gravity.Set(BB_GRAVITY_X, BB_GRAVITY_Y);
	
	// Should bodies be allowed to sleep?
	bool doSleep = true;
	
	// Create the b2World.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Box in the world so that nothing can escape.
	b2BodyDef boxBodyDef;
	boxBodyDef.position.Set(0, 0);
	
	boxBody = world->CreateBody(&boxBodyDef);
	BoxShape(boxBody, 0, 0,
				      screenSize.width/BB_PTM,
					  screenSize.height/BB_PTM);
	
	// Create the paddle's physical object.
	b2BodyDef paddleBodyDef;
	paddleBodyDef.position.Set(paddle.center.x/BB_PTM,
							   (screenSize.height - paddle.center.y)/BB_PTM);
	paddleBodyDef.fixedRotation = true;
	
	paddleBody = world->CreateBody(&paddleBodyDef);
	b2PolygonShape paddleShape;
	
	paddleShape.SetAsBox(paddle.bounds.size.width/BB_PTM/2,
						 paddle.bounds.size.height/BB_PTM/2);
	
	b2FixtureDef paddleBodyFixtureDef;
	paddleBodyFixtureDef.shape = &paddleShape;
	paddleBodyFixtureDef.density = 3.0f;
	paddleBodyFixtureDef.friction = 0.3f;
	paddleBodyFixtureDef.restitution = 0.5f; // 0 = lead, 1 = super rubber
	paddleBody->CreateFixture(&paddleBodyFixtureDef);
	
	paddleBody->SetType(b2_dynamicBody);
}

- (void)doMoveMouse:(NSSet *)touches
{
	UITouch *touch = [touches anyObject];
	CGPoint l = [touch locationInView:touch.view];
	b2Vec2 tp = b2Vec2(l.x/BB_PTM,
					   (touch.view.bounds.size.height - l.y)/BB_PTM);
	
	if (mouseJoint == NULL) {
		b2MouseJointDef mouseJointDef;
		mouseJointDef.bodyA = boxBody;
		mouseJointDef.bodyB = paddleBody;
		mouseJointDef.target = tp;
		mouseJointDef.collideConnected = true;
		mouseJointDef.maxForce = 1000.0f * paddleBody->GetMass();
		
		mouseJoint = (b2MouseJoint *)world->CreateJoint(&mouseJointDef);
		paddleBody->SetAwake(true);
	} else {
		mouseJoint->SetTarget(tp);
	}

}

- (void)resetBricks
{
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			bricks[x][y].alpha = 1.0;
		}
	}
}

- (void)gameLogic
{
	world->Step(1.0f/BB_FRAME_RATE, 8, 1);
	paddle.center = CGPointMake(paddleBody->GetPosition().x * BB_PTM,
								self.view.bounds.size.height -
								  paddleBody->GetPosition().y * BB_PTM);
	NSLog(@"Physics stepped & updated.");
	
	ball.center = CGPointMake(ball.center.x+ballMovement.x,
							  ball.center.y+ballMovement.y);
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
					bricks[x][y].alpha -= 0.1;
				}
			} else if (bricks[x][y].alpha < 1.0) {
				bricks[x][y].alpha -= 0.1;
			}
		}
	}
	
	if (!there_are_solid_bricks) {
		wbreset = YES;
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
		wbreset = YES;
		[self pauseGame];
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

