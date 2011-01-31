//
//  Brain.h
//  Cairns_Calculator
//
//  Created by Devyn Cairns on 1/19/11.
//  Copyright 2011 Devyn Cairns. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Brain : NSObject {
	
	IBOutlet id answerField;
	IBOutlet id numberField1;
	IBOutlet id numberField2;
	
}
-(IBAction) calculateAnswer: (id) sender;
@end
