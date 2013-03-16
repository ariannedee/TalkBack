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

@synthesize itemCollection; 

//-(id)InitWithCategory: (NSstring *)collectionName
//{
//   NSFileManager * fileManager = [[NSFileManager alloc] init];
//    NSString *filePath = [[path objectAtIndex:0] ]
//   if([fileManager fileExistAtPath(@"ALL")])
//   {
//       
//   }
//}
LanguageModelGenerator *lmGenerator;

-(void)SetupLanguageDictionary{
    lmGenerator = [[LanguageModelGenerator alloc] init];
    // words = NSArray from sounds
    for (Item *item in itemCollection)
    {
        NSString *name = @"LanguageModelFile";  // same as item name + postfix
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
        
        // now pass lmPath and dicPath to item's lmPath and dictPath

    }
    
    
}
@end
