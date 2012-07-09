//
//  GMObject.m
//  NextSprinter
//
//  Created by Gary Morris on 8/23/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import "GMObject.h"
#import "Utilities.h"

@implementation GMObject

#ifdef DEBUG

static unsigned nAllocated = 0;

+(id)allocWithZone:(NSZone*)zone
{
    id result = [super allocWithZone:zone];    
    DLog(@"%08x #%d %@", (uint32_t)result, ++nAllocated, self);
    ((GMObject*)result)->myRetainCount = 1;
    return result;
}

-(void)dealloc {
    DLog(@"%08x #%d %@", (uint32_t)self, nAllocated--, self);
    [super dealloc];
}

-(id)autorelease
{
    // doesn't change retain count, just queues a future retain operation
    DLog(@"%08x %u %@", (uint32_t)self, myRetainCount, self);
    return [super autorelease];
}

-(oneway void)release
{
    DLog(@"%08x %u %@", (uint32_t)self, --myRetainCount, self);
    [super release];
}

-(id)retain
{
    DLog(@"%08x %u %@", (uint32_t)self, ++myRetainCount, self);
    return [super retain];
}

#endif

@end
