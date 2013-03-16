//
//  TalkBackViewController.m
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TalkBackViewController.h"
#import "Item.h"

@implementation TalkBackViewController

@synthesize button;
@synthesize buttonNext;
@synthesize buttonPrev;
@synthesize image;
@synthesize openEarsEventsObserver;
@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize slt;

NSArray *itemModelArray;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// OpenEar Language model generator
        //lmGenerator = [[LanguageModelGenerator alloc] init];
		itemModelArray = [[NSArray alloc] init];
		[self.openEarsEventsObserver setDelegate:self];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	// display categories
	
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
	[self.pocketsphinxController stopListening];
}

// populate the view with images/word for the model with given index
// and swap the dictionary for sphinx controller
- (void)loadViewWithItem: (NSInteger)modelIdx
{

	NSString* lmPath = @""; // path from model
	NSString* dictPath = @""; // path from model
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dictPath languageModelIsJSGF:NO];
}

// removing item models from the array, and clean up generated lmpath and dicpath files
- (void)unloadItemModels
{
	
}

// Loads item models of specific category
// fetch associated images/animation
// and create the dictionary (lmpath and dicpath) * remember to clean up the files generated
- (void)loadItemModels
{
	/* sample data sounds from text?
	 NSArray *words1 = [NSArray arrayWithObjects:@"BALLS",@"B",@"ALL",@"BA",@"BU",@"BO", nil];
	 */
	
	 //NSArray *paths = createDictionary(words1);
	
}

#pragma mark - IBActions

// moving to next itemmodel
- (IBAction)onButtonNextPushed:(id)sender {
	[image setImage:[UIImage imageNamed:@"swirl.jpg"]];
}

- (IBAction)onButtonPrevPushed:(id)sender {
	[image setImage:[UIImage imageNamed:@"swirl.jpg"]];
}

- (IBAction)onButtonPushed:(id)sender {
    
    if ([button isSelected]) {
        [button setSelected:NO];
        [image setHighlighted:NO];
    }
    else
    {
        [button setSelected:YES];
        [image setHighlighted:YES];
    }
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
	if(recognitionScore.intValue > -600 && recognitionScore.intValue < -10 && [hypothesis isEqualToString:@"BALLS"]){
		[image setHighlighted:YES];
	}
    else {
		[self.fliteController say:@"BALLS" withVoice:self.slt];
		[image setHighlighted:NO];

	}
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
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
