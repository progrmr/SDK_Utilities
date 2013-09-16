//
//  GMDatePicker.m
//  Clock
//
//  Created by Gary Morris on 3/22/10.
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

#import "GMDatePicker.h"
#import "UtilitiesUI.h"

@implementation GMDatePicker

-(void)setFrame:(CGRect)newFrame
{
	CGSize newSize = [self sizeThatFits:newFrame.size];	// make it fit

    if (newSize.height != newFrame.size.height) {
        newFrame.size = newSize;
        
        if (self.superview) {
            CGRect parentBounds = self.superview.bounds;
            // place it at the bottom of the screen
            newFrame.origin.y = parentBounds.origin.y + parentBounds.size.height - newFrame.size.height;
        }        
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
