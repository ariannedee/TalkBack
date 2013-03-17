//
//  ItemCollection.m
//  TalkBack
//
//  Created by Marc Irawan on 13-03-16.
//
//

#import "ItemCollection.h"
#import "Item.h"
#import <OpenEars/LanguageModelGenerator.h>

@implementation ItemCollection

@synthesize itemArray;
@synthesize lmGenerator;

-(id)initWithCategory:(NSString *)collectionName
{
    self = [super init];
    if(self) {
        self.itemArray = [[NSMutableArray alloc] init];

        NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"data" inDirectory:@""];
        NSInputStream *stream;
        NSString *fileRoot;
        if (filePaths)
        {
            for (NSString *dataPath in filePaths)
            {
                NSString *fileName = [dataPath lastPathComponent];
                
                NSRange isCorrectFile = [dataPath rangeOfString: collectionName];
                if(isCorrectFile.location != NSNotFound)
                {
                    stream = [[NSInputStream alloc] initWithFileAtPath: fileName];
                    fileRoot = dataPath;
                    break;
                }
            }
        }
        
        //Read data
        NSString *fileContent = [NSString stringWithContentsOfFile: fileRoot encoding:NSUTF8StringEncoding error:nil];
        //seperate by new Line
        NSArray * lineByLineString = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //then breakdown further
        for(NSString *str in lineByLineString){
            
            NSArray *wrdArray = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @","]];
            NSString *firstWord = [wrdArray objectAtIndex:0];
            Item *newItem = [[Item alloc] initWithName:firstWord
                                                sounds:wrdArray
                                             animation:firstWord];
            [self.itemArray addObject:newItem];
			[newItem release];
        }
    }
    [self setupLanguageDictionary];
    return self;
}

-(void)setupLanguageDictionary
{
    lmGenerator = [[LanguageModelGenerator alloc] init];
    // words = NSArray from sounds
    for (Item *item in itemArray)
    {
        NSString *name = [NSString stringWithFormat:@"%@%@", [item displayName], @"_sounddict"];  // same as item name + postfix
        NSError *err = [lmGenerator generateLanguageModelFromArray:item.possibleSounds withFilesNamed:name];
        NSDictionary *languageGeneratorResults = nil;
        NSString *lmPath = nil;
        NSString *dicPath = nil;
        
        if([err code] == noErr) {
            languageGeneratorResults = [err userInfo];
            lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
            dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
        } else {
            NSLog(@"Error: %@",[err localizedDescription]);
        }
		[item setImPath:lmPath];
		[item setDictPath:dicPath];
        
        // now pass lmPath and dicPath to item's lmPath and dictPath

    }
}

- (void)dealloc
{
	[self setItemArray:nil];
	[self setLmGenerator:nil];
	
	[super dealloc];
}
@end
