//
//  CConverter.m
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CConverter.h"


@implementation CConverter

- (CConverter *)initWithCADtoJPYRate:(double)_rate
{
	if (self = [super init]) {
		rate = _rate;
	}
	
	return self;
}

- (double)cadToJpy:(double)amount
{
	return amount*rate;
}

- (double)jpyToCad:(double)amount
{
	return amount/rate;
}

@end
