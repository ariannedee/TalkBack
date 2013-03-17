//
//  TalkBackViewController.m
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TalkBackViewController.h"
#import "Item.h"
#import "ItemCollection.h"

@implementation TalkBackViewController

@synthesize button;
@synthesize cat_button_1;
@synthesize cat_button_2;
@synthesize cat_button_3;
@synthesize cat_button_4;
@synthesize buttonNext;
@synthesize buttonPrev;
@synthesize image;
@synthesize word;
@synthesize logDisplay;
@synthesize openEarsEventsObserver;
@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize slt;
@synthesize col;
@synthesize curItem;
@synthesize fullUserStats;
@synthesize currentUserStats;
@synthesize listening;
@synthesize stats;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

 /*
  crazy ugly implementation for storing stats to plist
  should refactor to its on model class later.
  flow:
  user_stats.plist -> load to fullUserStats(mutableArray) -> creates currentUserStats(mutableDict) for current stats only
  -> any update would affect only values in currentUserStats -> on level change, move the data to fullUserStats and create new tuple ->
  on program terminates -> move all data back to fullUserStats, then save fullUserStats to plist.
  */

- (NSString *) saveFilePath
{
	NSArray *path =	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//preferably the filename here is @"[username]_stats.plist"
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"user_stats.plist"]; 
	
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	// display categories
	[self.openEarsEventsObserver setDelegate:self];
	
	
	NSString *myPath = [self saveFilePath];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	self.currentUserStats = [[NSMutableDictionary alloc] init];
	
    [self.stats setText:@"WORD \t\t ATTEMPT \t\t SUCCESS \t\t FAIL"];
    
    if (fileExists)
	{		
		self.fullUserStats = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
		// loop through the stat to fill the dictionary with only data that is current
		for (int i = 0; i < [self.fullUserStats count]; i++) {
			// stats[0] = word, [1]=level, [2]=#ofattempt, [3]=#ofsuccess, [4]=consecutiveFail, [5]=isCurrent
			NSArray *stat = [self.fullUserStats objectAtIndex:i];
			if ([[stat objectAtIndex:5] intValue] == 1) {
				NSMutableArray *dicStats = [[NSMutableArray alloc] initWithObjects:[stat objectAtIndex:1], 
									 [stat objectAtIndex:2],
									 [stat objectAtIndex:3],
									 [stat objectAtIndex:4],
									 [NSNumber numberWithInt:i], nil];
				[self.currentUserStats setObject:dicStats forKey:[stat objectAtIndex:0]];
                [[self stats] setText:[NSString stringWithFormat:@"%@\n %@ \t\t\t %@ \t\t\t\t %@ \t\t\t\t %@", self.stats.text, [stat objectAtIndex:0], [stat objectAtIndex:2], [stat objectAtIndex:3], [stat objectAtIndex:4]]];
			}
		}
	}else {
		self.fullUserStats = [[NSMutableArray alloc] init];
	}
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Private functions

// removes item model from the view
- (void)unloadCurrentItemModel
{
	//self.curItem = nil;
	[self.pocketsphinxController stopListening];
}

// populate the view with images/word for the model with given index
// and swap the dictionary for sphinx controller
- (void)loadViewWithItem: (NSInteger)modelIdx
{
	NSInteger size = [[col itemArray] count];
	NSInteger level = 0;
	buttonPrev.hidden = 0;
	buttonNext.hidden = 0;
	if (modelIdx == 0) {
		buttonPrev.hidden = 1;
	}
	if (modelIdx == size - 1) {
		buttonNext.hidden = 1;
	}
	curIdx = modelIdx;
	self.curItem = [[col itemArray] objectAtIndex:curIdx];
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:[curItem imPath] dictionaryAtPath:[curItem dictPath] languageModelIsJSGF:NO];
	
	// getting level from the stored user stats
	if ([self.currentUserStats objectForKey:[self.curItem displayName]] != nil) {
		level = [[[self.currentUserStats objectForKey:[self.curItem displayName]] objectAtIndex:0] intValue];
	}else {
		NSMutableArray *dicStats = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:level],
															[NSNumber numberWithInt:0],
															[NSNumber numberWithInt:0],
															[NSNumber numberWithInt:0],
															[NSNumber numberWithInt:-1], nil];
		[self.currentUserStats setObject:dicStats forKey:[self.curItem displayName]];
	}

	NSString *name = [curItem displayName];
	UIImage *displayImage = [[curItem animationArray] objectAtIndex:0];
	
	self.word.text = name;
	[self.image setImage:displayImage];
	[self.image setAnimationImages:[curItem animationArray]];
	self.image.animationDuration = 2;
	self.image.animationRepeatCount = 1;
}

// removing item models from the array, and clean up generated lmpath and dicpath files
- (void)unloadItemModels
{
	// try plist write out here for now
	// need to move data from currentUserStats(dict) to fullUserStats(array)
	// then write out the array
	NSArray *keys = [self.currentUserStats allKeys];
	for (NSString *key in keys){
		NSArray *dicStats = [self.currentUserStats objectForKey:key];
		NSInteger fullStatIdx = [[dicStats objectAtIndex:4] intValue];
		
		NSMutableArray *aryStats = [[NSMutableArray alloc] initWithObjects: key,
							 [dicStats objectAtIndex:0],
							 [dicStats objectAtIndex:1],
							 [dicStats objectAtIndex:2],
							 [dicStats objectAtIndex:3],
							 [NSNumber numberWithInt:1], nil];
		if (fullStatIdx == -1) {
			// add to array as a new entry
			[self.fullUserStats addObject:aryStats];
		}else {
			// get and update the entry in the array
			[self.fullUserStats replaceObjectAtIndex:fullStatIdx withObject:aryStats];
		}

	}
	[self.fullUserStats writeToFile:[self saveFilePath] atomically:YES];
	[self setCol:nil];
}

// Loads item models of specific category
// fetch associated images/animation
// and create the dictionary (lmpath and dicpath) * remember to clean up the files generated
- (void)loadItemModels: (NSInteger)categoryId
{
	switch (categoryId) {
		case 1:
			self.col = [[ItemCollection alloc] initWithCategory: @"All"];
			
			// call to itemcollection for initializing items
			break;
		case 2:
			// call to itemcollection for initializing items
			self.col = [[ItemCollection alloc] initWithCategory: @"TOYS"];

			break;
		case 3:
			// call to itemcollection for initializing items
			self.col = [[ItemCollection alloc] initWithCategory: @"FOOD"];

			break;
		case 4:
			// call to itemcollection for initializing items
			self.col = [[ItemCollection alloc] initWithCategory: @"ANIMALS"];

			break;
		default:
			break;
	}
	if ([[[self col] itemArray] count] > 0)
	{
		[self loadViewWithItem:0];
	}
}

- (void) displayCatButtons
{
	cat_button_1.hidden = 0;
	cat_button_2.hidden = 0;
	cat_button_3.hidden = 0;
	cat_button_4.hidden = 0;
	button.hidden = 1;
	buttonNext.hidden = 1;
	buttonPrev.hidden = 1;
	word.hidden = 1;
	image.hidden = 1;
    [[self stats] setHidden:NO];
}

- (void) hideCatButtons
{
	cat_button_1.hidden = 1;
	cat_button_2.hidden = 1;
	cat_button_3.hidden = 1;
	cat_button_4.hidden = 1;
	button.hidden = 0;
	buttonNext.hidden = 0;
	buttonPrev.hidden = 0;
	word.hidden = 0;
	image.hidden = 0;
    [[self stats] setHidden:YES];
}

#pragma mark - Helper functions

- (BOOL)isPassedHypothesis:(NSString *)hypothesis
{
	NSArray *hypArray = [hypothesis componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @" "]];
//	for (NSString *hyp in hypArray) {
//		if ([[[self curItem] possibleSounds] containsObject:hyp]) {
    if ([hypArray containsObject:[[curItem possibleSounds] objectAtIndex:0]]) {
			return YES;
//		}
	}
	
	return NO;
}

#pragma mark - IBActions


- (IBAction)onCatButtonPushed:(id)sender {
	[self hideCatButtons];
	[self loadItemModels:((UIButton*)sender).tag];
}

- (IBAction)onButtonNextPushed:(id)sender {
	[self unloadCurrentItemModel];
	[self loadViewWithItem:curIdx+1];
}

- (IBAction)onButtonPrevPushed:(id)sender {
	[self unloadCurrentItemModel];
	[self loadViewWithItem:curIdx-1];
}

- (IBAction)onButtonPushed:(id)sender {
	[self unloadCurrentItemModel];
	[self unloadItemModels];
    [self displayCatButtons];
}

#pragma mark - OpenEar methods
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

// ** this is the method that we will work with the most. ** //
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
	self.logDisplay.text = [NSString stringWithFormat:@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID];
	
	NSMutableArray *dicStats = [self.currentUserStats objectForKey:[curItem displayName]];
	[dicStats replaceObjectAtIndex:1 withObject: [NSNumber numberWithInt:[[dicStats objectAtIndex:1] intValue]+1]];
	//recognitionScore.integerValue > -7000
	if(recognitionScore.integerValue > -5000 && [self isPassedHypothesis:hypothesis]){// && [self isPassedHypothesis:hypothesis]){
		
		[dicStats replaceObjectAtIndex:2 withObject: [NSNumber numberWithInt:[[dicStats objectAtIndex:2] intValue]+1]];
		[dicStats replaceObjectAtIndex:3 withObject: [NSNumber numberWithInt:0]];
		NSInteger level = [[dicStats objectAtIndex:2] intValue];
		if (level > 5) { // threshold for moving to new level 
			NSInteger fullStatIdx = [[dicStats objectAtIndex:4] intValue];
			
			NSMutableArray *aryStats = [[NSMutableArray alloc] initWithObjects: [self.curItem displayName],
								 [dicStats objectAtIndex:0],
								 [dicStats objectAtIndex:1],
								 [dicStats objectAtIndex:2],
								 [dicStats objectAtIndex:3],
								 [NSNumber numberWithInt:0], nil];
			if (fullStatIdx == -1) {
				// add to array as a new entry
				[self.fullUserStats addObject:aryStats];
			}else {
				// get and update the entry in the array
				[self.fullUserStats replaceObjectAtIndex:fullStatIdx withObject:aryStats];
			}
			dicStats = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:(level+1)],
								 [NSNumber numberWithInt:0],
								 [NSNumber numberWithInt:0],
								 [NSNumber numberWithInt:0],
								 [NSNumber numberWithInt:-1], nil];
			[self.currentUserStats setObject:dicStats forKey:[self.curItem displayName]];
		}
		[image startAnimating];
	}
    else {

		[dicStats replaceObjectAtIndex:3 withObject: [NSNumber numberWithInt:[[dicStats objectAtIndex:3] intValue]+1]];
		
		[self.fliteController say:[curItem displayName] withVoice:self.slt];
		[image setHighlighted:NO];

	}
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
	[self.fliteController say:[curItem displayName] withVoice:self.slt];
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
    [[self listening] setHidden:NO];
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
    [[self listening] setHighlighted:YES];
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    [[self listening] setHighlighted:NO];
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
    [[self listening] setHidden:YES];
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); 
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

@end
