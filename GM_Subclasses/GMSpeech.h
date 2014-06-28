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

@interface GMSpeech : NSObject

// if the same string is sent to speakString again within dropDuplicatesTime,
// then the string will not be spoken (it only checks against one previous),
// default is 20 seconds
@property (nonatomic, assign) NSTimeInterval dropDuplicatesTime;

+ (GMSpeech*)speaker;               // returns singleton instance

- (void)speakString:(NSString*)string;      // speaks a string

// completion will be called with finished==YES after the string has been spoken.
// finished will be NO if the string is not spoken, either from an error or
// if it was a duplicate of the last speech (within dropDuplicatesTime)
- (void)speakString:(NSString*)string withCompletion:(void (^)(BOOL finished))completion;

// pauseFor inserts a pause into the speech queue
- (void)pauseFor:(NSTimeInterval)pauseSeconds;

// removes unspoken strings from the queue, returns YES if something was dequeued
- (BOOL)flushQueue;

@end
