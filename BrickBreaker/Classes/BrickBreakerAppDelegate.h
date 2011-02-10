//
//  BrickBreakerAppDelegate.h
//  BrickBreaker
//
//  Created by E528 on 2/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrickBreakerViewController;

@interface BrickBreakerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BrickBreakerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BrickBreakerViewController *viewController;

@end

