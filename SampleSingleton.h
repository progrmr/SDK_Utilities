//
//  SampleSingleton.h
//  NextSprinter
//
//  Created by Gary Morris on 6/9/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SampleSingleton : NSObject {
    
}

//-----------------------------------------------------------------------
// sharedInstance - returns the instance of this Singleton class
//-----------------------------------------------------------------------
+(SampleSingleton*)shared;

@end
