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

static unsigned nAllocated = 0;

+(id)allocWithZone:(NSZone*)zone
{
    id result = [super allocWithZone:zone];    
    DLog(@"%08x #%04d", result, ++nAllocated);
    return result;
}

-(void)dealloc {
    DLog(@"%08x #%04d", self, nAllocated--);
    [super dealloc];
}

-(id)autorelease
{
    DLog(@"%08x", self);
    return [super autorelease];
}

-(void)release
{
    DLog(@"%08x", self);
    [super release];
}

-(id)retain
{
    DLog(@"%08x", self);
    return [super retain];
}



@end
