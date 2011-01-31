//
//  Brain.m
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"


@implementation Brain

- (void)awakeFromNib
{
	converter = [[CConverter alloc] initWithCADtoJPYRate:82.6353077];
}

- (IBAction)cadToJpy:(id)sender
{
	[jpyField setDoubleValue:[converter cadToJpy:[cadField doubleValue]]];
}

- (IBAction)jpyToCad:(id)sender
{
	[cadField setDoubleValue:[converter jpyToCad:[jpyField doubleValue]]];
}

@end
