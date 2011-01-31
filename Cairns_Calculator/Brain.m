//
//  Brain.m
//  Cairns_Calculator
//
//  Created by E528 on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"


@implementation Brain

- (IBAction)calculateAnswer:(id)sender
{
	float num1, num2, answer;
	num1 = [numberField1 floatValue];
	num2 = [numberField2 floatValue];
	answer = num1 + num2;
	
	[answerField setFloatValue:answer];
}

@end
