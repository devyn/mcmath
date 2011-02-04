//
//  Quadratic.m
//  quadForm
//
//  Created by E528 on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quadratic.h"

@implementation Quadratic

- (IBAction)calculate:(id)sender
{
	double a, b, c, answerX1, answerX2;
	
	a = [fieldA doubleValue];
	b = [fieldB doubleValue];
	c = [fieldC doubleValue];
	
	/* placeholder code */
	answerX1 = a+b+c;
	answerX2 = answerX1;
	
	[fieldX1 setDoubleValue:answerX1];
	[fieldX2 setDoubleValue:answerX2];
}

@end
