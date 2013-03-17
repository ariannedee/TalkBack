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
@synthesize animationArray;
@synthesize imPath;
@synthesize dictPath;

-(id) initWithName:(NSString*)displayName_
            sounds:(NSArray*)possibleSounds_
         animation:(NSString*)animName_
{
    self = [super init];
    if(self)
    {
        [self setDisplayName:displayName_];
        [self setPossibleSounds:possibleSounds_];
        [self setAnimName:animName_];
        
        animationArray = [[NSMutableArray alloc] initWithObjects:nil];
        imPath = nil;
        dictPath = nil;
        
		[self createAnimation];
    }
    return self;
}


-(void)dealloc{
	[self setDictPath:nil];
	[self setImPath:nil];
	[self setAnimationArray:nil];
	[self setDisplayName:nil];
	[self setAnimName:nil];
	[self setPossibleSounds:nil];
	
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
    [self setAnimationArray:animImages];
    [animImages release];
}

@end
