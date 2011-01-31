//
//  Brain.h
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "CConverter.h"


@interface Brain : NSObject {
	CConverter *converter;
	IBOutlet NSTextField *cadField;
	IBOutlet NSTextField *jpyField;
}

- (void)awakeFromNib;

- (IBAction)cadToJpy:(id)sender;
- (IBAction)jpyToCad:(id)sender;

@end
