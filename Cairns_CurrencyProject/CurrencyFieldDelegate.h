//
//  CurrencyFieldDelegate.h
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "Brain.h"

@interface CurrencyFieldDelegate : NSObject {
	IBOutlet Brain *controller;
}

- (void)controlTextDidChange:(NSNotification *)obj;

@end
