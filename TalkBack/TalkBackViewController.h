//
//  TalkBackViewController.h
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import <OpenEars/PocketsphinxController.h>

@interface TalkBackViewController : UIViewController <OpenEarsEventsObserverDelegate> {
	OpenEarsEventsObserver *openEarsEventsObserver;
	PocketsphinxController *pocketsphinxController;
	FliteController *fliteController;
	Slt *slt;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *buttonNext;
@property (nonatomic, retain) IBOutlet UIButton *buttonPrev;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) PocketsphinxController *pocketsphinxController;
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, retain) FliteController *fliteController;
@property (nonatomic, retain) Slt *slt;

@property (nonatomic, retain) NSArray *itemModelArray;

- (IBAction)onButtonPushed:(id)sender;
- (IBAction)onButtonNextPushed:(id)sender;
- (IBAction)onButtonPrevPushed:(id)sender;

@end
