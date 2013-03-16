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
@synthesize animName;
@synthesize animationImages;
@synthesize imPath;
@synthesize dictPath;

-(id) initWithName:(NSString*)displayName_
            sounds:(NSArray*)possibleSounds_
         animation:(NSString*)animName_
{
    
    if(self = [super init]) {
        [self setDisplayName:displayName_];
        [self setPossibleSounds:possibleSounds_];
        [self setAnimName:animName_];
        
        self.animationImages = [[NSMutableArray alloc] init];
        imPath = nil;
        dictPath = nil;
        
    }
    return self;
}


-(void)dealloc{
    self.displayName = nil;
    [super dealloc];
}

- (void)createAnimation
{
    NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@""];
    
    NSMutableArray *animImages = [[NSMutableArray alloc] init];
    
    if (filePaths)
    {
        for (NSString *imagePath in filePaths)
        {
            NSString *imageName = [imagePath lastPathComponent];
            
            NSRange isAnimImage = [imageName rangeOfString:self.animName];
            
            if (isAnimImage.location != NSNotFound)
            {
                [animImages addObject:[UIImage imageNamed:imageName]];
            }
        }
    }
    self.animationImages = animImages;
    [animImages release];
}




@end
