//
//  MyDocument.h
//  simpleTextEditor
//
//  Created by E528 on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
	IBOutlet NSTextView *textView;
	NSAttributedString *string;
}

@property(copy) NSAttributedString *string;

@end
