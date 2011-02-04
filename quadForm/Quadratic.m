//
//  Quadratic.m
//  quadForm
//
//  Created by E528 on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quadratic.h"
#import <math.h>

@implementation Quadratic

- (IBAction)calculate:(id)sender
{
	double a, b, c, answerX1, answerX2;
	
	/* get input */
	
	a = [fieldA doubleValue];
	b = [fieldB doubleValue];
	c = [fieldC doubleValue];
	
	/* quadratic formula calculation */
	
	double s = sqrt(pow(b, 2) - 4*a*c); // common value between X1, X2
	
	answerX1 = (-b + s) / (2*a);
	answerX2 = (-b - s) / (2*a);
	
	/* debug information */
	
	NSLog(@"-- quadratic calc req --");
	NSLog(@"a = %f, b = %f, c = %f", a, b, c);
	NSLog(@"s = %f", s);
	NSLog(@"answerX1 = %f", answerX1);
	NSLog(@"answerX2 = %f", answerX2);
	
	/* push answers back */
	
	[fieldX1 setDoubleValue:answerX1];
	[fieldX2 setDoubleValue:answerX2];
}

@end
