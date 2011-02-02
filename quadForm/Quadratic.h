//
//  Quadratic.h
//  quadForm
//
//  Created by E528 on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Quadratic : NSObject {
	IBOutlet NSTextField *fieldA;
	IBOutlet NSTextField *fieldB;
	IBOutlet NSTextField *fieldC;
	IBOutlet NSTextField *fieldX1;
	IBOutlet NSTextField *fieldX2;
}

- (IBAction)calculate:(id)sender;

@end
