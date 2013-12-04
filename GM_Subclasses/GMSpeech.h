//
//  GMSpeech.h
//  RB2
//
//  Created by Gary Morris on 2/18/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
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

#import <Foundation/Foundation.h>

typedef enum { AudioCategoryNone, AudioCategoryAmbient, AudioCategoryPlayback } AudioCategories;

@interface GMSpeech : NSObject

// if the same string is sent to speakString again within dropDuplicatesTime,
// then the string will not be spoken (it only checks against one previous),
// default is 20 seconds
@property (nonatomic, assign) NSTimeInterval dropDuplicatesTime;

// audio session category can be set through this property.  The default is
// AudioCategoryNone.  AudioCategoryAmbient corresponds to AVAudioSessionCategoryAmbient.
// AudioCategoryPlayback corresponds to AVAudioSessionCatgoryPlayback.
// (see AVAudioSession for details in setCategory:error:)
@property (nonatomic, assign) AudioCategories audioCategory;

+ (GMSpeech*)speaker;               // returns singleton instance

- (void)speakString:(NSString*)string;      // speaks a string

// completion will be called with finished==YES after the string has been spoken.
// finished will be NO if the string is not spoken, either from an error or
// if it was a duplicate of the last speech (within dropDuplicatesTime)
- (void)speakString:(NSString*)string withCompletion:(void (^)(BOOL finished))completion;

// removes unspoken strings from the queue
- (void)flushQueue;

@end
