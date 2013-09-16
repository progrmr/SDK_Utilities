//
//  GMImage.m
//  ClockU
//
//  Created by Gary Morris on 5/21/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
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

#import "GMImage.h"

///#define DEBUG_REFCOUNT

@implementation GMImage

-(NSString*)description {
	return [NSString stringWithFormat:@"GMImage<%08x>", (uint32_t)self];
}

#ifdef DEBUG_REFCOUNT
-(id)init {
	if (self = [super init]) {
		NSLog(@"%@ init", self);
	}
	return self;
}

-(id)initWithContentsOfFile:(NSString *)path {
	if (self = [super initWithContentsOfFile:path]) {
		NSLog(@"%@ initWithContentsOfFile: %@ %@", self, NSStringFromCGSize(self.size), path);
	}
	return self;
}

-(id)initWithData:(NSData *)data {
	if (self = [super initWithData:data]) {
		NSLog(@"%@ initWithData: %@ %d bytes", self, NSStringFromCGSize(self.size), data.length);
	}
	return self;
}

-(id)initWithCGImage:(CGImageRef)imageRef {
	if (self = [super initWithCGImage:imageRef]) {
		NSLog(@"%@ initWithCGImage: %@", self, NSStringFromCGSize(self.size));
	}
	return self;
}

-(id)autorelease {
	// we add 1 to myRetainCount since it was init to 0 instead of 1, it's offset by 1
	NSLog(@"%@ autorel %2d       (%u)", self, myRetainCount+1, self.retainCount);	
	return [super autorelease];
}

-(void)release {
	NSLog(@"%@ release %2d -> %2d (%u)", self, myRetainCount+1, myRetainCount, self.retainCount);
	myRetainCount--;
	[super release];
}

-(id)retain {
	NSLog(@"%@ retain  %2d -> %2d (%u)", self, myRetainCount+1, myRetainCount+2, self.retainCount);
	myRetainCount++;
	return [super retain];
}

- (void)dealloc {
	NSLog(@"%@ dealloc %2d       (%u)", self, myRetainCount+1, self.retainCount);	
    [super dealloc];
}
#endif

@end
