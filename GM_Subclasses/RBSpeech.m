//
//  RBSpeech.m
//  RB2
//
//  Created by Gary Morris on 2/18/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//
//  Modified to work with both OSX and iOS 7.0+
//
#import "RBSpeech.h"

// speech synthesis required MacOSX or iOS >= 7
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (!TARGET_OS_IPHONE)

#if TARGET_OS_IPHONE
#import <AVFoundation/AVFoundation.h>
#define NSSpeechSynthesizerDelegate AVSpeechSynthesizerDelegate
#define NSSpeechSynthesizer         AVSpeechSynthesizer

#else
// MacOSX 
#define VOICE @"com.apple.speech.synthesis.voice.Alex"
#endif

@interface RBSpeech() <NSSpeechSynthesizerDelegate>

@property (atomic, strong)    NSMutableArray*           speechQueue;    // things waiting to be said
@property (nonatomic, strong) NSSpeechSynthesizer*      speech;         // speech synthesizer

#if TARGET_OS_IPHONE
@property (nonatomic, strong) AVSpeechSynthesisVoice*   voice;
#endif

@end


@implementation RBSpeech

@synthesize speech = _speech;

+ (RBSpeech*)speaker
{
    static RBSpeech* speaker = nil;
    
    if (speaker == nil) {
        speaker = [[RBSpeech alloc] init];
    }
    return speaker;
}

- (id)init
{
    self = [super init];
    if (self) {
        _speechQueue = [NSMutableArray arrayWithCapacity:4];

    }
    return self;
}

#pragma mark -
#pragma mark custom getter
- (NSSpeechSynthesizer*)speech
{
    if (_speech == nil) {
#if TARGET_OS_IPHONE
        // get a voice for the default language
        _voice = [AVSpeechSynthesisVoice voiceWithLanguage:nil];

        _speech = [[AVSpeechSynthesizer alloc] init];
#else
        NSString* voice = nil;

        for (NSString* aVoice in [NSSpeechSynthesizer availableVoices]) {
            if ([aVoice isEqualToString:RB_VOICE]) {
                voice = aVoice;
                break;
            }
        }
        _speech = [[NSSpeechSynthesizer alloc] initWithVoice:voice];
#endif
        _speech.delegate = self;
    }
    return _speech;
}

#pragma mark -
#pragma mark speaking
- (void)speakString:(NSString*)string
{
    // add this string to the queue
    [self.speechQueue addObject:string];

    // speak next string in the queue
    [self speakNext];
}

- (void)speakNext
{
    if (self.speechQueue.count && !self.speech.isSpeaking) {
        // speak the queued text
        NSString* nextSpeech = [self.speechQueue objectAtIndex:0];
        [self.speechQueue removeObjectAtIndex:0];

        // speak it now
#if TARGET_OS_IPHONE
        AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:nextSpeech];
        utterance.voice = self.voice;
        utterance.rate  = 0.25f;      // range 0.0f - 1.0f

        [self.speech speakUtterance:utterance];
#else
        [self.speech startSpeakingString:nextSpeech];
#endif
    }
}

#if TARGET_OS_IPHONE
#pragma mark -
#pragma mark AVSpeechSynthesizerDelegate methods
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
  didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    DLog(@"");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    DLog(@"");
    // speak next phrase in the queue after a slight pause
    [self performSelector:@selector(speakNext) withObject:nil afterDelay:0.25];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
willSpeakRangeOfSpeechString:(NSRange)characterRange
                utterance:(AVSpeechUtterance *)utterance
{
    DLog(@"");
}

#else
#pragma mark -
#pragma mark NSSpeechSynthesizerDelegate methods
- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
        didFinishSpeaking:(BOOL)finishedSpeaking
{
    DLog(@"");
    // speak next phrase in the queue after a slight pause
    [self performSelector:@selector(speakNext) withObject:nil afterDelay:0.25];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
 didEncounterErrorAtIndex:(NSUInteger)characterIndex
                 ofString:(NSString*)string
                  message:(NSString*)message
{
    DLog(@"ERROR: %@", message);
}

- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
  didEncounterSyncMessage:(NSString*)message
{
    DLog(@"SYNC: %@", message);
}

- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
            willSpeakWord:(NSRange)characterRange
                 ofString:(NSString*)string
{
    NSString* word = [string substringWithRange:characterRange];

    DLog(@"%@", word);
}
#endif

#else 
// no speech synthesis available
@implementation RBSpeech

+ (RBSpeech*)speaker
{
    // this was intentionally left empty
    return nil;
}

- (void)speakString:(NSString*)string
{
    // this was intentionally left empty
}
#endif

@end
