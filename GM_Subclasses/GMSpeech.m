//
//  GMSpeech.m
//  RB2
//
//  Created by Gary Morris on 2/18/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//
//  Modified to work with both OSX and iOS 7.0+
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this file. If not, see <http://www.gnu.org/licenses/>.
//
#import "GMSpeech.h"

// speech synthesis requires MacOSX or iOS >= 7
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (!TARGET_OS_IPHONE)

#if TARGET_OS_IPHONE
#import <AVFoundation/AVFoundation.h>
#define NSSpeechSynthesizerDelegate AVSpeechSynthesizerDelegate
#define NSSpeechSynthesizer         AVSpeechSynthesizer

#else   /* MAC OSX */
// MacOSX allows choosing a voice
#define VOICE @"com.apple.speech.synthesis.voice.Alex"
#endif


// GMSpeechEntry is a object that holds text to be spoken and a completion block
@interface GMSpeechEntry : NSObject
@property (nonatomic, copy)   NSString* string;
@property (nonatomic, strong) void (^completion)(BOOL finished);
@end
@implementation GMSpeechEntry
@end


@interface GMSpeech() <NSSpeechSynthesizerDelegate>

// speechQueue is a FIFO queue of GMSpeechEntry objects waiting to be spoken
@property (atomic, strong)    NSMutableArray*           speechQueue;    // queue waiting to be said

@property (nonatomic, strong) NSSpeechSynthesizer*      speech;         // speech synthesizer
@property (nonatomic, strong) NSString*                 lastSpoken;     // last spoken string
@property (nonatomic, assign) CFAbsoluteTime            lastSpokenTime; // time lastSpoken was spoken
@property (nonatomic, strong) GMSpeechEntry*            currentSpeech;  // currently being spoken

#if TARGET_OS_IPHONE
@property (nonatomic, strong) AVSpeechSynthesisVoice*   voice;          // used with iOS
#endif

@end


@implementation GMSpeech

@synthesize speech = _speech;

+ (GMSpeech*)speaker
{
    static GMSpeech* speaker = nil;
    
    if (speaker == nil) {
        speaker = [[GMSpeech alloc] init];
    }
    return speaker;
}

- (id)init
{
    self = [super init];
    if (self) {
        _speechQueue = [NSMutableArray arrayWithCapacity:8];
        _dropDuplicatesTime = 20;
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
        _voice  = [AVSpeechSynthesisVoice voiceWithLanguage:nil];
        _speech = [[AVSpeechSynthesizer alloc] init];

#else   /* MAC OSX */
        NSString* voice = nil;
        // find the VOICE
        for (NSString* aVoice in [NSSpeechSynthesizer availableVoices]) {
            if ([aVoice isEqualToString:VOICE]) {
                voice = aVoice;
                break;
            }
        }
        _speech = [[NSSpeechSynthesizer alloc] initWithVoice:voice];
#endif  /* TARGET_OS_IPHONE */
        _speech.delegate = self;
    }
    return _speech;
}

#pragma mark -
#pragma mark queues a string for speaking
- (void)speakString:(NSString*)string
{
    [self speakString:string withCompletion:nil];
}

- (void)speakString:(NSString*)string withCompletion:(void (^)(BOOL finished))completion
{
    if (string.length > 0) {
        // add this string to the queue
        GMSpeechEntry* qEntry = [[GMSpeechEntry alloc] init];
        qEntry.string     = string;
        qEntry.completion = completion;

        DLog(@"ENQUEUE: %@", qEntry.string);

        [self.speechQueue addObject:qEntry];

        // speak next string in the queue
        [self speakNext];

    } else {
        // call completion block now
        if (completion) {
            completion(NO); // no because string was 0 length
        }
    }
}

- (void)speakNext
{
    if (self.speechQueue.count && !self.speech.isSpeaking) {
        // dequeue the next speech entry
        GMSpeechEntry* nextEntry = self.speechQueue[0];
        [self.speechQueue removeObjectAtIndex:0];

        // speak it now
        DLog(@"SPEAK: \"%@\"", nextEntry.string);

        // if this is the same as the last speech text, drop it
        const CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
        const CFAbsoluteTime elapsed = now - self.lastSpokenTime;

        if ((elapsed <= self.dropDuplicatesTime) && ([nextEntry.string caseInsensitiveCompare:self.lastSpoken] == NSOrderedSame)) {
            DLog(@"DUPLICATE: spoke it %0.1f secs ago", elapsed);
            // call completion block
            if (nextEntry.completion) {
                nextEntry.completion(NO);   // duplicate, not spoken
            }

            // speak the next entry in the queue
            [self performSelector:@selector(speakNext) withObject:nil afterDelay:0];
            return;
        }

        // save lastSpoken text and lastSpokenTime
        self.lastSpoken     = nextEntry.string;
        self.lastSpokenTime = now;
        self.currentSpeech  = nextEntry;

#if TARGET_OS_IPHONE
        // on iOS we must convert the text to an utterance
        AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:nextEntry.string];
        utterance.voice = self.voice;
        utterance.rate  = 0.25f;      // range 0.0f - 1.0f
        [self.speech speakUtterance:utterance];
        
#else   /* MAC OSX */
        [self.speech startSpeakingString:nextEntry.string];
#endif  /* TARGET_OS_IPHONE */
    }
}

#if TARGET_OS_IPHONE
#pragma mark -
#pragma mark AVSpeechSynthesizerDelegate methods
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    ///DLog(@"");
    if (self.currentSpeech.completion) {
        self.currentSpeech.completion(YES);     // speech finished
    }
    self.currentSpeech = nil;

    // speak next phrase in the queue after a slight pause
    [self performSelector:@selector(speakNext) withObject:nil afterDelay:0.25];
}

#else   /* MAC OSX */
#pragma mark -
#pragma mark NSSpeechSynthesizerDelegate methods
- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
        didFinishSpeaking:(BOOL)finishedSpeaking
{
    if (self.currentSpeech.completion) {
        self.currentSpeech.completion(YES);     // speech finished
    }
    self.currentSpeech = nil;

    // speak next phrase in the queue after a slight pause
    [self performSelector:@selector(speakNext) withObject:nil afterDelay:0.25];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
 didEncounterErrorAtIndex:(NSUInteger)characterIndex
                 ofString:(NSString*)string
                  message:(NSString*)message
{
    if (self.currentSpeech.completion) {
        self.currentSpeech.completion(NO);     // speech failed
    }
    self.currentSpeech = nil;

    DLog(@"ERROR: %@ =================================", message);
}

- (void)speechSynthesizer:(NSSpeechSynthesizer*)speech
  didEncounterSyncMessage:(NSString*)message
{
    DLog(@"SYNC: %@", message);
}
#endif  /* TARGET_OS_IPHONE */

#else 
// no speech synthesis available before iOS 7
@implementation GMSpeech

+ (GMSpeech*)speaker
{
    // this was intentionally left empty
    return nil;
}

- (void)speakString:(NSString*)string
{
    // this was intentionally left empty
}

- (void)speakString:(NSString*)string withCompletion:(void (^)(BOOL finished))completion
{
    // this was intentionally left empty
}

#endif

@end
