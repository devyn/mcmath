//
//  CConverter.h
//  Cairns_CurrencyProject
//
//  Created by E528 on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CConverter : NSObject {
	double rate;
}

- (CConverter *)initWithCADtoJPYRate:(double)_rate;

- (double)cadToJpy:(double)amount;
- (double)jpyToCad:(double)amount;

@end
