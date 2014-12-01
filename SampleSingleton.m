//
//  SampleSingleton.m
//
//  Based on Fred McCann's blog "Using the Singleton Pattern in Objective-C"
//  http://www.duckrowing.com/2010/05/21/using-the-singleton-pattern-in-objective-c/
//
//  Created by Gary Morris on 6/9/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//
// This file is part of SDK_Utilities.repo
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

-(oneway void)release
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
