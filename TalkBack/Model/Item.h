//
//  Item.h
//  TalkBack
//
//  Created by Marc Irawan on 13-03-16.
//
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic, retain) NSString *displayName; 
@property(nonatomic, retain) NSArray *possibleSounds;
@property(nonatomic, retain) NSString *animationUrl;
@property(nonatomic, retain) NSMutableArray *animationImages;

@end
