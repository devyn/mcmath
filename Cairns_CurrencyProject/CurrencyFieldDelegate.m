//
//  CurrencyFieldDelegate.m
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrencyFieldDelegate.h"


@implementation CurrencyFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
	switch ([[obj object] tag]) {
		case 32000:
			[controller cadToJpy:[obj object]];
			break;
		case 32001:
			[controller jpyToCad:[obj object]];
			break;
	}
}

@end
