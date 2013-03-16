//
//  TalkBackViewController.h
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>

@interface TalkBackViewController : UIViewController <OpenEarsEventsObserverDelegate> {
	OpenEarsEventsObserver *openEarsEventsObserver;
	PocketsphinxController *pocketsphinxController;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property(nonatomic, retain) PocketsphinxController *pocketsphinxController;
@property(nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;

- (IBAction)onButtonPushed:(id)sender;

@end
