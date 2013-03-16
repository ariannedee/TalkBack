//
//  TalkBackAppDelegate.h
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkBackViewController;

@interface TalkBackAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TalkBackViewController *viewController;

@end
