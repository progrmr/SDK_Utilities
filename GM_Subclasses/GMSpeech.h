//
//  GMSpeech.h
//  RB2
//
//  Created by Gary Morris on 2/18/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSpeech : NSObject

+ (GMSpeech*)speaker;               // returns singleton instance

- (void)speakString:(NSString*)string;      // speaks a string

@end
