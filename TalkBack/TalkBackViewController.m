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
@synthesize openEarsEventsObserver;
@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize slt;
@synthesize col;
@synthesize curItem;

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

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	// display categories
	[self.openEarsEventsObserver setDelegate:self];
    
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
}

#pragma mark - Helper functions

- (BOOL)isPassedHypothesis:(NSString *)hypothesis
{
	NSArray *hypArray = [hypothesis componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @" "]];
	for (NSString *hyp in hypArray) {
		if ([[[self curItem] possibleSounds] containsObject:hyp]) {
			return YES;
		}
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
	if(recognitionScore.intValue > -7000 && recognitionScore.intValue < -400 && [self isPassedHypothesis:hypothesis]){
		
		[image startAnimating];
	}
    else {
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
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
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
