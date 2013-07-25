//
//  RBSpeech.h
//  RB2
//
//  Created by Gary Morris on 2/18/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBSpeech : NSObject

- (void)speakString:(NSString*)string;      // speak the string

+ (RBSpeech*)speaker;       // returns singleton instance

@end
