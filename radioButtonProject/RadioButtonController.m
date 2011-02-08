//
//  RadioButtonController.m
//  radioButtonProject
//
//  Created by E528 on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioButtonController.h"


@implementation RadioButtonController

-(IBAction)findSelectedButton:(id)sender
{
	NSLog(@"button selected: %d", [[sender selectedCell] tag]);
}

@end
