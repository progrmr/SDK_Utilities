//
//  GMDatePicker.m
//  Clock
//
//  Created by Gary Morris on 3/22/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "GMDatePicker.h"
#import "UtilitiesUI.h"

@implementation GMDatePicker

-(void)setFrame:(CGRect)newFrame
{
#if 0
	NSLog(@"%s newFrame = %3.0f,%3.0f %3.0f,%3.0f", __PRETTY_FUNCTION__,
		  newFrame.origin.x, newFrame.origin.y,
		  newFrame.size.width, newFrame.size.height);
#endif
	
	newFrame.size = [self sizeThatFits:newFrame.size];	// make it fit
	
	if (self.superview) {
		CGRect parentBounds = self.superview.bounds;
		// place it at the bottom of the screen
		newFrame.origin.y = parentBounds.origin.y + parentBounds.size.height - newFrame.size.height;
	}
	
	[super setFrame:newFrame];
}

-(CGSize)sizeThatFits:(CGSize)size
{
	if (size.width < 400 || isPad()) {
		// portrait orientation (or iPad)
		size.height = 216;
	} else {
		// landscape orientation
		size.height = 162;
	}
	return size;
}


@end
