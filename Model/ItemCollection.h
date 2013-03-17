//
//  ItemCollection.h
//  TalkBack
//
//  Created by Marc Irawan on 13-03-16.
//
//

#import <Foundation/Foundation.h>

@class LanguageModelGenerator;

@interface ItemCollection : NSObject

@property(nonatomic, retain) NSMutableArray* itemArray;
@property(nonatomic, retain) LanguageModelGenerator *lmGenerator;

-(id)initWithCategory:(NSString *)collectionName;
-(void)setupLanguageDictionary;

@end
