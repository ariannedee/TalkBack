//
//  TalkBackViewController.m
//  TalkBack
//
//  Created by Arianne Dee on 13-03-15.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TalkBackViewController.h"
#import <OpenEars/LanguageModelGenerator.h>
#import "Item.h"

@implementation TalkBackViewController


@synthesize button;
@synthesize image;
@synthesize openEarsEventsObserver;
@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize slt;


LanguageModelGenerator *lmGenerator;

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
	// OpenEar Language model generator
	lmGenerator = [[LanguageModelGenerator alloc] init];
	NSArray *words1 = [NSArray arrayWithObjects:@"DA", @"DOD", @"DOG", nil];
    NSArray *words2 = [NSArray arrayWithObjects:@"BA", @"BAW", @"BALL", nil];
	NSArray *words3 = [NSArray arrayWithObjects:@"DO", @"DUDE", @"DUCE", @"JUICE", nil];
    NSArray *words4 = [NSArray arrayWithObjects:@"PAH", @"PAHTO", @"PAHCO", @"POPCO", @"POPCONE", @"POPCORN", nil];
    NSArray *words5 = [NSArray arrayWithObjects:@"POOTUH", @"CAHPOOTUH", @"CAHMPYOUTUH", @"COMPUTER", nil];
    
	NSString *name = @"LanguageModelFile";
	NSError *err = [lmGenerator generateLanguageModelFromArray:words1 withFilesNamed:name];
	
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
	
	// OpenEar observer and controller begins
	// we may want to generate a dictionary for each words, and change the dictionary used for each view, 
	// so we only trying to recognize one single word at a time
	[self.openEarsEventsObserver setDelegate:self];
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
	
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

/* methods for OpenEar api */
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
