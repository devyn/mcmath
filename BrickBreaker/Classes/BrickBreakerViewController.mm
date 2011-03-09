//
//  BrickBreakerViewController.m
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
//  -- Ideas --
//  - What about making it more difficult the more bricks you manage to hit in a row?
//    - Score multipliers could go nicely with this, too.
//    - It could be made more difficult by making the ball bouncier (faster). I *think* I can do this.
//  - Fancy graphics. Not much to say about this. Just something that looks nicer.
//    - Can't do any awesome special effects with UIKit, really.
//  - More bricks?
//  - Multi-hit bricks?
//  - Randomly-generated level? (with gaps, perhaps, even!)

#import "BrickBreakerViewController.h"

// helpers

std::vector<BBObject *>ud_objs;

BBObject *ud_obj(int type)
{
	BBObject *ret = (BBObject *)malloc(sizeof(BBObject));
	ret->magic = BB_MAGIC;
	ret->type = type;
	ud_objs.push_back(ret);
	return ret;
}

BOOL ud_detect(void *obj)
{
	if (obj == NULL) return FALSE;
	
	BBObject *bbo = (BBObject *)obj;
	
	if (bbo->magic == BB_MAGIC) return TRUE;
	else return FALSE;
}

BBObject *ud_brick(int x, int y)
{
	BBObject *ret = ud_obj(BB_OBJ_BRICK);
	ret->value.brick.x = x;
	ret->value.brick.y = y;
	return ret;
}

void BoxShape(b2Body *body, double left, double top, double width, double height)
{
	b2EdgeShape shape;
	// bottom
	shape.Set(b2Vec2(left,top), b2Vec2(left+width,top));
	b2Fixture *f = body->CreateFixture(&shape, 0);
	f->SetUserData((void *)ud_obj(BB_OBJ_GROUND));
	// top
	shape.Set(b2Vec2(left,top+height), b2Vec2(left+width, top+height));
	body->CreateFixture(&shape, 0);
	// left
	shape.Set(b2Vec2(left,top+height), b2Vec2(left,top));
	body->CreateFixture(&shape, 0);
	// right
	shape.Set(b2Vec2(left+width,top+height), b2Vec2(left+width,top));
	body->CreateFixture(&shape, 0);
	// paddle top-bound
	shape.Set(b2Vec2(left,top+height*0.3), b2Vec2(left+width, top+height*0.3));
	f = body->CreateFixture(&shape, 0);
	b2Filter fd = f->GetFilterData();
	fd.categoryBits = 0x0002;
	f->SetFilterData(fd);
	// paddle bottom-bound
	shape.Set(b2Vec2(left,top+height*0.1), b2Vec2(left+width, top+height*0.1));
	f = body->CreateFixture(&shape, 0);
	fd = f->GetFilterData();
	fd.categoryBits = 0x0002;
	f->SetFilterData(fd);
}

@interface BrickBreakerViewController (Private)

- (void)initializeTimer;
- (void)initializeBricks;
- (void)initializePhysics;
- (void)doMoveMouse:(NSSet *)touches;
- (void)resetBricks;
- (void)gameLogic;
- (void)updateGraphics;

@end


@implementation BrickBreakerViewController
@synthesize scoreLabel;
@synthesize livesLabel;
@synthesize brickValueLabel;
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
	
	/* graphical timer */
	
	float gInterval = 1.0/BB_FRAME_RATE/2;
	graphicalTimer = [NSTimer 
					  scheduledTimerWithTimeInterval:gInterval
					  target:self
					  selector:@selector(updateGraphics)
					  userInfo:nil repeats:YES];
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
	if (isPlaying && mouseJoint) {
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
			wbreset = YES;
		}
		
		if (wbreset) {
			wbreset = NO;
			
			brickChain = 0;
			counter = 0;
			
			ballBody->SetTransform(_iBallPos, 0);
			paddleBody->SetTransform(_iPaddlePos, 0);
			
			ballFixture->SetRestitution(BB_INITIAL_BOUNCINESS);
			brickValue = BB_INITIAL_BRICK_VALUE;
			
			if (arc4random() % 2) ballBody->SetLinearVelocity(b2Vec2(-10.0f,-5.0f));
			else                  ballBody->SetLinearVelocity(b2Vec2( 10.0f,-5.0f));
			
			paddleBody->SetLinearVelocity(b2Vec2(0,0));
			
			ballBody->SetAwake(true);
			paddleBody->SetAwake(true);
			
			if (mouseJoint) {
				world->DestroyJoint(mouseJoint);
				mouseJoint = NULL;
			}
		}
		
		scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
		brickValueLabel.text = [NSString stringWithFormat:@"%05d", brickValue];
		livesLabel.text = [NSString stringWithFormat:@"%d", lives];
		
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
	[graphicalTimer invalidate]; [graphicalTimer release];
	[scoreLabel release];
	[livesLabel release];
	[brickValueLabel release];
	[messageLabel release];
	[ball release];
	[paddle release];
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			[(bricks[x][y]) release];
		}
	}
	std::vector<BBObject *>::iterator pos;
	for (pos=ud_objs.begin(); pos != ud_objs.end(); ++pos) {
		free(*pos);
		ud_objs.erase(pos);
	}
	delete world;
	delete contactListener;
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
			newFrame.origin = CGPointMake(x*32, (y*20) + 50);
			bricks[x][y].frame = newFrame;
			bricks[x][y].alpha = 0.0;
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
	
	contactListener = new BBContactListener();
	
	world->SetContactListener(contactListener);
	
	// Box in the world so that nothing can escape.
	b2BodyDef boxBodyDef;
	boxBodyDef.position.Set(0, 0);
	
	boxBody = world->CreateBody(&boxBodyDef);
	BoxShape(boxBody, 0, 0,
				      screenSize.width/BB_PTM,
					  screenSize.height/BB_PTM);
	
	// Create the paddle's physical object.
	b2BodyDef paddleBodyDef;
	_iPaddlePos = b2Vec2(paddle.center.x/BB_PTM,
						 (screenSize.height - paddle.center.y)/BB_PTM);
	paddleBodyDef.position.Set(_iPaddlePos.x, _iPaddlePos.y);
	paddleBodyDef.fixedRotation = true;
	
	paddleBody = world->CreateBody(&paddleBodyDef);
	b2PolygonShape paddleShape;
	
	paddleShape.SetAsBox(paddle.bounds.size.width/BB_PTM/2,
						 paddle.bounds.size.height/BB_PTM/2);
	
	b2FixtureDef paddleBodyFixtureDef;
	paddleBodyFixtureDef.shape = &paddleShape;
	paddleBodyFixtureDef.density = 5.0f;
	paddleBodyFixtureDef.friction = 0.3f;
	paddleBodyFixtureDef.restitution = 0.2f; // 0 = lead, 1 = super rubber
	b2Fixture *paddleFixture = paddleBody->CreateFixture(&paddleBodyFixtureDef);
	paddleFixture->SetUserData((void *)ud_obj(BB_OBJ_PADDLE));
	
	paddleBody->SetType(b2_dynamicBody);
	
	// Create the ball's physical object.
	b2BodyDef ballBodyDef;
	_iBallPos = b2Vec2(ball.center.x/BB_PTM,
					   (screenSize.height - ball.center.y)/BB_PTM);
	ballBodyDef.position.Set(_iBallPos.x, _iBallPos.y);
	ballBodyDef.fixedRotation = true;
	
	ballBody = world->CreateBody(&ballBodyDef);
	b2CircleShape ballShape;
	
	ballShape.m_radius = ball.bounds.size.height/BB_PTM/2;
	
	b2FixtureDef ballBodyFixtureDef;
	ballBodyFixtureDef.shape = &ballShape;
	ballBodyFixtureDef.density = 5.0f;
	ballBodyFixtureDef.friction = 1.0f;
	ballBodyFixtureDef.restitution = BB_INITIAL_BOUNCINESS;
	ballBodyFixtureDef.filter.maskBits = 0xFFFD; // don't collide with paddle bounds
	ballFixture = ballBody->CreateFixture(&ballBodyFixtureDef);
	ballFixture->SetUserData((void *)ud_obj(BB_OBJ_BALL));
	
	ballBody->SetType(b2_dynamicBody);
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
	bricksRemaining = BB_WIDTH * BB_HEIGHT;
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			// Ensure we can see the bricks!
			bricks[x][y].alpha = 1.0;
			// Only create bodies that don't already exist.
			if (brickBodies[x][y] == NULL) {
				// Initialize the body.
				b2BodyDef brickBodyDef;
				brickBodyDef.position.Set(bricks[x][y].center.x/BB_PTM,
										  (self.view.bounds.size.height - bricks[x][y].center.y)/BB_PTM);
				
				b2Body *brickBody = brickBodies[x][y] = world->CreateBody(&brickBodyDef);
				b2PolygonShape brickShape;
				
				brickShape.SetAsBox(bricks[x][y].bounds.size.width/BB_PTM/2,
									bricks[x][y].bounds.size.height/BB_PTM/2);
				
				brickFixtures[x][y] = brickBody->CreateFixture(&brickShape, 10000.f);
				brickFixtures[x][y]->SetUserData(ud_brick(x, y));
			}
		}
	}
}

- (void)gameLogic
{
	// Step the physics simulation forward.
	world->Step(1.0f/BB_FRAME_RATE, 8, 1);
	
	// Update positions of things.
	paddle.center = CGPointMake(paddleBody->GetPosition().x * BB_PTM,
								self.view.bounds.size.height -
								  paddleBody->GetPosition().y * BB_PTM);
	
	ball.center = CGPointMake(ballBody->GetPosition().x * BB_PTM,
							  self.view.bounds.size.height -
							    ballBody->GetPosition().y * BB_PTM);
	
	// Subtract 3 points for every 5 seconds passed.
	if (++counter / BB_FRAME_RATE / 5 > 1) {
		counter -= BB_FRAME_RATE*5;
		score -= 3;
		scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
	}
	
	// Iterate through the contacts.
	std::vector<b2Body  *>toDestroy;
	std::vector<BBContact>::iterator pos;
	for (pos = contactListener->contacts.begin();
		 pos != contactListener->contacts.end(); ++pos) {
		
		BBContact contact = *pos;
		
		// Hooray for Box2D UserData hacking! :-/
		
		void *uda, *udb;
		uda = contact.fixtureA->GetUserData();
		udb = contact.fixtureB->GetUserData();
		
		if (ud_detect(uda) && ud_detect(udb)) {
			BBObject *bba = (BBObject *)uda;
			BBObject *bbb = (BBObject *)udb;
			BBObject *brickHit = NULL;
			// Are we brick + ball?
			if (bba->type == BB_OBJ_BRICK && bbb->type == BB_OBJ_BALL) brickHit = bba;
			if (bbb->type == BB_OBJ_BRICK && bba->type == BB_OBJ_BALL) brickHit = bbb;
			// Yeah, we are.
			if (brickHit != NULL) {
				int x = brickHit->value.brick.x;
				int y = brickHit->value.brick.y;
				
				// Pretty fading.
				bricks[x][y].alpha -= 0.05;
				
				// Score is usually good.
				score += brickValue;
				
				// OH MY FSM, SCORE CHAINS!
				brickValue += BB_BONUS_CHAIN1 + BB_BONUS_CHAIN2*brickChain;
				++brickChain;
				
				// Count bricks that still need to be slaughtered.
				bricksRemaining -= 1;
				
				// Let's make it a little harder, shall we?
				if (ballFixture->GetRestitution() < 0.5f)
					ballFixture->SetRestitution(ballFixture->GetRestitution()*1.2f);
				
				// Update score / brick value labels. Or we could just not tell the user. Meh.
				scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
				brickValueLabel.text = [NSString stringWithFormat:@"%05d", brickValue];
				
				// Good. Now send our dead bricks to the meat shop.
				if (std::find(toDestroy.begin(), toDestroy.end(), brickBodies[x][y]) == toDestroy.end()) {
					toDestroy.push_back(brickBodies[x][y]);
					brickBodies[x][y] = NULL;
				}
			}
			
			// Are we ball + ground?
			if ((bba->type == BB_OBJ_BALL && bbb->type == BB_OBJ_GROUND)
			||  (bbb->type == BB_OBJ_BALL && bba->type == BB_OBJ_GROUND)) {
				wbreset = YES;
				[self pauseGame];
				lives--;
				livesLabel.text = [NSString stringWithFormat:@"%d", lives];
				
				// In other words, you suck.
				if (!lives) {
					messageLabel.text = BB_LOSE_STRING;
				} else {
					messageLabel.text = BB_LIFEM_STRING;
				}
				
				messageLabel.hidden = NO;
			}
			
			// We need to stop our CHAIN2 if the ball hits the paddle. Can't make it too easy.
			if ((bba->type == BB_OBJ_PADDLE && bbb->type == BB_OBJ_BALL)
			||  (bbb->type == BB_OBJ_PADDLE && bba->type == BB_OBJ_BALL)) {
				brickChain = 0;
			}
		}
		
		if (bricksRemaining < 1) {
			// Wait, how!?
			wbreset = YES;
			[self pauseGame];
			lives = 0;
			if (score == 1337) {
				// Oh, you probably hacked it. Don't do that... mm'kay?
				messageLabel.text = BB_1337_STRING;
			} else {
				// Or you really are awesome.
				messageLabel.text = BB_WIN_STRING;
			}
			messageLabel.hidden = NO;
		}
	}
	
	std::vector<b2Body  *>::iterator pos2;
	for (pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
		world->DestroyBody(*pos2);
	}
}

- (void)updateGraphics
{
	// This does our fading for us. Separate timer so pausing the game doesn't make the fading effect pause.
	// (I didn't like that. xD)
	for (int y=0; y < BB_HEIGHT; y++) {
		for (int x=0; x < BB_WIDTH; x++) {
			if (bricks[x][y].alpha < 1.0 && bricks[x][y].alpha > 0.0) {
				bricks[x][y].alpha -= 0.05;
			}
		}
	}
}

@end

