//
//  GMObject.m
//  NextSprinter
//
//  Created by Gary Morris on 8/23/11.
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

#import "GMObject.h"
#import "Utilities.h"

@implementation GMObject

#ifdef DEBUG

static unsigned nAllocated = 0;

+(id)allocWithZone:(NSZone*)zone
{
    id result = [super allocWithZone:zone];    
    DLog(@"+++ %08x #%d %@", (uint32_t)result, ++nAllocated, self);
    ((GMObject*)result)->myRetainCount = 1;
    return result;
}

-(void)dealloc {
    DLog(@"--- %08x #%d %@", (uint32_t)self, nAllocated--, self);
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
    DLog(@"    %08x %u %@", (uint32_t)self, --myRetainCount, self);
    [super release];
}

-(id)retain
{
    DLog(@"     %08x %u %@", (uint32_t)self, ++myRetainCount, self);
    return [super retain];
}

#endif

@end
