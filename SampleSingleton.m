//
//  SampleSingleton.m
//
//  Based on Fred McCann's blog "Using the Singleton Pattern in Objective-C"
//  http://www.duckrowing.com/2010/05/21/using-the-singleton-pattern-in-objective-c/
//
//  Created by Gary Morris on 6/9/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import "SampleSingleton.h"


@implementation SampleSingleton

static SampleSingleton* sharedInstance = nil;

#pragma mark Singleton methods
//-----------------------------------------------------------------------
// sharedInstance - returns the instance of this Singleton class
//-----------------------------------------------------------------------
+(SampleSingleton*)shared
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            // alloc invokes allocWithZone which sets sharedInstance
            [[self alloc] init];    
        }
    }
    return sharedInstance;
}

+(id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone*)zone
{
    return self;
}

-(id)retain
{
    return self;
}

-(void)release
{
    // do nothing
}

-(id)autorelease
{
    return self;
}

-(NSUInteger)retainCount
{
    return NSUIntegerMax;
}

#pragma mark Initialization code
-(id)init
{
    @synchronized(self) {
        [super init];
        //-----------------------------------------------
        // initialization code goes here
        //-----------------------------------------------
        return self;
    }
}




@end
