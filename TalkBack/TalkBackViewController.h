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

@class ItemCollection;
@class Item;

@interface TalkBackViewController : UIViewController <OpenEarsEventsObserverDelegate> {
	OpenEarsEventsObserver *openEarsEventsObserver;
	PocketsphinxController *pocketsphinxController;
	FliteController *fliteController;
	Slt *slt;
	NSInteger curIdx;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *cat_button_1;
@property (nonatomic, retain) IBOutlet UIButton *cat_button_2;
@property (nonatomic, retain) IBOutlet UIButton *cat_button_3;
@property (nonatomic, retain) IBOutlet UIButton *cat_button_4;
@property (nonatomic, retain) IBOutlet UIButton *buttonNext;
@property (nonatomic, retain) IBOutlet UIButton *buttonPrev;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UIImageView *listening;
@property (nonatomic, retain) IBOutlet UILabel *word;
@property (nonatomic, retain) IBOutlet UILabel *logDisplay;
@property (nonatomic, retain) IBOutlet UITextView *stats;

@property (nonatomic, retain) PocketsphinxController *pocketsphinxController;
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, retain) FliteController *fliteController;
@property (nonatomic, retain) Slt *slt;
@property (nonatomic, retain) ItemCollection *col;
@property (nonatomic, retain) Item *curItem;

//
@property (nonatomic, retain) NSMutableArray *fullUserStats;
@property (nonatomic, retain) NSMutableDictionary *currentUserStats;

- (IBAction)onButtonPushed:(id)sender;
- (IBAction)onCatButtonPushed:(id)sender;
- (IBAction)onButtonNextPushed:(id)sender;
- (IBAction)onButtonPrevPushed:(id)sender;

- (BOOL)isPassedHypothesis:(NSString *)hypothesis;


@end
