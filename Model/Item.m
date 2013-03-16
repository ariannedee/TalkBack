//
//  Item.m
//  TalkBack
//
//  Created by Marc Irawan on 13-03-16.
//
//

#import "Item.h"


@implementation Item

@synthesize displayName;
@synthesize possibleSounds;
@synthesize animationUrl;
@synthesize animationImages;

-(id) initWithName:(NSString*)displayName_
            sounds:(NSArray*)possibleSounds_
         animation:(NSString*)animationUrl_
{
    
    if(self = [super init]) {
        [self setDisplayName:displayName_];
        [self setPossibleSounds:possibleSounds_];
        [self setAnimationUrl:animationUrl_];
        
        self.animationImages = [[NSMutableArray alloc] init];
        //[self createAnimation];
        
    }
    return self;
}


-(void)dealloc{
    self.displayName = nil;
    [super dealloc];
}

- (void)createAnimation
{
    for (int i = 1; i < 3; i++)
    {
        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%i", animationUrl, i]]];
    }
}


@end
