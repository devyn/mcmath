//
//  MyDocument.m
//  simpleTextEditor
//
//  Created by E528 on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument
@synthesize string;

- (id)init
{
    self = [super init];
    if (self) {
    
        if (string == nil) {
			string = [[NSAttributedString alloc] initWithString:@""];
		}
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    if ([self string] != nil) {
		[[textView textStorage] setAttributedString:[self string]];
	}
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData *data;
	
	[self setString:[textView textStorage]];
	
	NSMutableDictionary *dict = [NSDictionary
								 dictionaryWithObject:NSRTFTextDocumentType
								 forKey:NSDocumentTypeDocumentAttribute];
	
	[textView breakUndoCoalescing];
	
	data = [[self string]
			dataFromRange:NSMakeRange(0, [[self string] length])
			documentAttributes:dict
			error:outError];
	
	return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
	NSAttributedString *fileContents = [[NSAttributedString alloc]
										initWithData:data options:NULL
										documentAttributes:NULL
										error:outError];
	if (fileContents) {
		readSuccess = YES;
		[self setString:fileContents];
		[fileContents release];
	}
	
	return readSuccess;
}

- (void)textDidChange:(NSNotification *)notification
{
	[self setString:[textView textStorage]];
}



@end
