//
//  TalkBackViewController.h
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkBackViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIImageView *image;

- (IBAction)onButtonPushed:(id)sender;

@end
